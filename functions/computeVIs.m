function B = computeVIs(hcube, visName, option)

arguments
    hcube (1,1) hypercube {mustBeDataCube(hcube)}
    visName (1, 1) string {mustBeNonempty}
    option.BlockSize (1,:) {mustBeNumeric, mustBeNonNan, mustBeNonempty,...
        mustBeFinite, mustBePositive, mustBeInteger, mustBeReal, ...
        validateBlockSize(option.BlockSize, hcube)} = [size(hcube.DataCube, 1),...
        size(hcube.DataCube, 2)]
end

% For compiler tests
if isdeployed
    rootDir = ctfroot;
else
    rootDir = matlabroot;
end
% Register resources/hyperspectral.
matlab.internal.msgcat.setAdditionalResourceLocation(rootDir);
wavelengths = hcube.Wavelength;

% Convert wavelength unit to nanometer (default) if original wavelength
% unit is present in metadata. Otherwise, always assuming wavelength unit
% to be in nanometer
if isfield(hcube.Metadata, 'WavelengthUnits')
    wavelengths = hyper.internal.wavelengthUnitConversion(wavelengths,...
        hcube.Metadata.WavelengthUnits);
end

%wavelengths= validateWavelength(wavelengths);
hcube = hcube.DataCube;

% Find NIR band in hyperspectral data at wavelength 800 nanometers
[~, NIRIdx] = min(abs(wavelengths - 800));

% Find R band in hyperspectral data at wavelength 670 nanometers
[~, RIdx] = min(abs(wavelengths - 670));

% Find RE band in hyperspectral data at wavelength 725 nanometers
[~, REIdx] = min(abs(wavelengths - 725));

% Find G band in hyperspectral data at wavelength 550 nanometers
[~, GIdx] = min(abs(wavelengths - 550));

sizeChk = [size(hcube, 1), size(hcube, 2)];



if isequal(option.BlockSize, sizeChk)
    switch visName
        case "ndvi"
            B = computeNdvi(hcube, NIRIdx, RIdx);
        case "evi2"
            B = computeEvi2(hcube, NIRIdx, RIdx);
        case "cire"
            B = computeCire(hcube, NIRIdx, REIdx);
        case "gndvi"
            B = computeGndvi(hcube, NIRIdx, GIdx);
        case "grvi"
            B = computeGrvi(hcube, NIRIdx, GIdx);
        case "psri"
            B = computePsri(hcube, NIRIdx, RIdx, GIdx);
        case "ren"
            B = computeRen(hcube, NIRIdx, REIdx);
        case "savi"
            B = computeSavi(hcube, NIRIdx, RIdx);
    end

else
    [~, ~, channels] = size(hcube);
    
    bSize = [option.BlockSize channels];
    
    % Compute VI using NIR and R bands
    bim = blockedImage(hcube);
    
    out = null;

    switch visName
        case "ndvi"
            out = apply(bim, @(bs)computeNdvi(bs.Data, NIRIdx, RIdx), 'BlockSize', bSize);
        case "evi2"
            out = apply(bim, @(bs)computeEvi2(bs.Data, NIRIdx, RIdx), 'BlockSize', bSize);
        case "cire"
            out = apply(bim, @(bs)computeCire(bs.Data, NIRIdx, REIdx), 'BlockSize', bSize);
        case "gndvi"
            out = apply(bim, @(bs)computeGndvi(bs.Data, NIRIdx, GIdx), 'BlockSize', bSize);
        case "grvi"
            out = apply(bim, @(bs)computeGrvi(bs.Data, NIRIdx, GIdx), 'BlockSize', bSize);
        case "psri"
            out = apply(bim, @(bs)computePsri(bs.Data, NIRIdx, RIdx, GIdx), 'BlockSize', bSize);
        case "ren"
            out = apply(bim, @(bs)computeRen(bs.Data, NIRIdx, REIdx), 'BlockSize', bSize);
        case "savi"
            out = apply(bim, @(bs)computeSavi(bs.Data, NIRIdx, RIdx), 'BlockSize', bSize);
    end

    B = gather(out);
    
end

end

function out = computeCire(X, NIRIdx, REIdx)
if isinteger(X)
    X = single(X);
end

NIR = X(:,:,NIRIdx);
RE = X(:,:,REIdx);

out = (NIR./(RE+eps))-1;
end

function out = computeNdvi(X, NIRIdx, RIdx)
if isinteger(X)
    X = single(X);
end

NIR = X(:,:,NIRIdx);
R = X(:,:,RIdx);

out = (NIR-R)./(NIR+R+eps);
end

function out = computeEvi2(X, NIRIdx, RIdx)
if isinteger(X)
    X = single(X);
end

NIR = X(:,:,NIRIdx);
R = X(:,:,RIdx);

out = 2.5*(NIR-R)./(NIR+2.4*R+1+eps);
end

function out = computeGndvi(X, NIRIdx, GIdx)
if isinteger(X)
    X = single(X);
end

NIR = X(:,:,NIRIdx);
G = X(:,:,GIdx);

out = (NIR-G)./(NIR+G+eps);
end

function out = computeGrvi(X, NIRIdx, GIdx)
if isinteger(X)
    X = single(X);
end

% R = X(:,:,RIdx);
NIR = X(:,:,NIRIdx);
G = X(:,:,GIdx);

% out = (G-R)./(G+R+eps);
out = NIR./(G+eps);
end


function out = computePsri(X, NIRIdx ,RIdx, GIdx)
if isinteger(X)
    X = single(X);
end

NIR = X(:,:,NIRIdx);
R = X(:,:,RIdx);
G = X(:,:,GIdx);

out = (R-G)./(NIR + eps);
end

function out = computeRen(X, NIRIdx ,REIdx)
if isinteger(X)
    X = single(X);
end

NIR = X(:,:,NIRIdx);
RE = X(:,:,REIdx);

out = (NIR-RE)./(NIR + RE + eps);
end

function out = computeSavi(X, NIRIdx ,RIdx)
if isinteger(X)
    X = single(X);
end

NIR = X(:,:,NIRIdx);
R = X(:,:,RIdx);

% L is the soil-brightness correction.
l = 0.5;

out = ((NIR-R)./(NIR + R + l + eps))*(1+l);
end

function mustBeDataCube(hcube)
mustBeNumeric(hcube.DataCube);
mustBeNonempty(hcube.DataCube);
if ndims(hcube.DataCube) ~= 3
    error(message('hyperspectral:vi:incorrectNumdims'));
end
end

function wavelength = validateWavelength(wavelength)
% Range of NIR is 700-1400nm
[NIR, R, GREEN, RE]= hyper.internal.hasWavelength(wavelength, {'nir','red','green','re'});
if ~any(NIR)
    error(message('hyperspectral:hypercube:mustHaveNIRChannelWavelength'));
end
% Range of Red is 610-700nm
if ~any(R)
    error(message('hyperspectral:hypercube:mustHaveRedChannelWavelength'));
end
if ~any(GREEN)
    error(message('hyperspectral:hypercube:mustHaveGreenChannelWavelength'));
end

if ~any(RE)
    error(message('hyperspectral:hypercube:mustHaveWavelength'));
end

end

function validateBlockSize(blockSize, datacube)
% Condition check for BlockSize
[rows, cols, ~] = size(datacube.DataCube);

if ~(numel(blockSize) == 2)
    error(message('hyperspectral:vi:validateSize'));
end

if (blockSize(1) > rows) || (blockSize(2) > cols)
    error(message('hyperspectral:vi:validateBS'));
end
end