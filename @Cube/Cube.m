classdef Cube
    % Cube A class for hyperspectal datacubes.
    %   Includes methods for reading data from files and cube manipulations
    %   while keeping track of the metadata, including full history of operations.
    % TODO: History tracking should probably be implemented as a better
    % data structure (possibly value class)

    % !!! This must be updated each time the class definition changes !!!
    % The constant properties are not saved to files, so comparing this to
    % the private Version property should reveal version changes from
    % object creation.
    properties (Constant, Hidden)
        ClassVersion = '0.5.6-dev' % Current version of the class source
    end
    
    properties (SetAccess = 'private')
        Data            = zeros(0,0,0) % The raw datacube
        Files           = {} % Full path(s) of the file(s) the cube corresponds to (if any)
        Quantity        = '' % Physical quantity of data
        WavelengthUnit  = '' % Physical unit of the wavelengths
        Wavelength      = [] % Center wavelengths for each band
        FWHM            = [] % FWHM's for each band
        History         = {{'Object created'}} % Operation history for this cube
        Version         = Cube.ClassVersion % Class version at the time of object creation
    end
    
    % Always recalculated from the data so they are in sync
    properties (Dependent, SetAccess = 'private')
        Type   % Type of data (double, float etc.)
        Min    % Minimum value in the cube
        Max    % Maximum value in the cube
        Size   % Size of the data matrix ([Height, Width, Bands])
        Area   % Pixel count of the image
        Bands  % The vector 1:nBands (for ease of use)
        Width  % Width of the image
        Height % Height of the image
        nBands % Number of bands
    end
    
    methods
        
        %% Constructor %%
    
        function cube = Cube(varargin)
            %CUBE Construct a Cube from given data
            % Usage:
            %  Cube(filename, quantity) reads data from the given file with
            %  the given quantity (default quantity 'Unknown')
            %  
            %  Cube(..., 'br', data) additionally attempts to calibrate the
            %  data using the given black reference, which may be a
            %  filename or existing Cube.
            %
            %  Cube(..., 'wr', data) attempts to calculate reflectance from
            %  raw or radiance data using the given white reference.
            %
            % FIXME: Enviread errors should be caught and handled to have
            %        more meaningful error messages and behaviour.
            
        if nargin > 0  % Calling without parameters explicitly does nothing.
        
            % Parse the input parameters using the customized inputParser
            CA = CubeArgs();
            CA.parse(varargin{:})
            
            data = CA.Results.data;
            qty  = CA.Results.quantity;
            ft   = CA.Results.filetype;
            br   = CA.Results.br;
            wr   = CA.Results.wr;
            wl   = CA.Results.wl;
            wlu  = CA.Results.wlunit;
            fwhm = CA.Results.fwhm;
            hst  = CA.Results.history;
            
            if CA.isCube(data)
                % If given an existing Cube object, copy and update any
                % given properties.
                cube = data;
                if ~ismember('quantity', CA.UsingDefaults)
                    cube.Quantity = qty;
                end
                if ~ismember('wl', CA.UsingDefaults)
                    cube.Wavelength = wl;
                    cube.WavelengthUnit = 'Unknown';
                end
                if ~ismember('wlunit', CA.UsingDefaults)
                    cube.WavelengthUnit = wlu;
                end
                if ~ismember('fwhm', CA.UsingDefaults)
                    cube.FWHM = fwhm;
                end
            elseif CA.isFile(data)
                % If we are given a file, pick a reader based on filetype
                switch lower(ft)
                    case 'envi'
                        % Try to find a corresponding ENVI header and read the
                        % data
                        hdrfile = findhdr(data);
                        
                        fprintf('Reading ENVI data from %s\n', data);
                        [cube.Data, info] = enviread(data, hdrfile);
                        fprintf('ENVI data read.\n');
                        
                        % Assign the relevant metadata to the object
                        cube.Files    = data;
                        cube.Quantity = qty;
                        cube.History  = {{'Data read from ENVI file',@Cube,data,qty}};
                        cube          = cube.parseENVI(info);
                    case 'image'
                        % Assume the filename is an image file
                        % and attempt to read it using imread.
                        [cube.Data, ~, ~] = imread(data);
                        
                        % Fill the metadata using the given parameters.
                        % We don't attempt to read geotiff data etc. for now.
                        cube.Files           = data;
                        cube.Quantity        = qty;
                        cube.Wavelength      = wl;
                        cube.WavelengthUnit  = wlu;
                        cube.FWHM            = fwhm;
                        cube.History  = {{'Data read from image file', @Cube, CA.Results}};
                    otherwise
                        error('File type %s cannot currently be read',ft);
                end
            elseif isnumeric(data)
                % If we are given a matrix, assign it as data and assign
                % metadata from the given parameters
                cube.Data = data;
                if ismember('quantity', CA.UsingDefaults)
                    warning('Cube:DefaultQuantity', 'Quantity not given, setting to %s.', qty);
                end
                cube.Quantity = qty;
                
                % Construct default values if none were given
                if ismember('wl', CA.UsingDefaults)
                    warning('Cube:DefaultWavelength', 'Wavelengths not given, using layer numbering.');
                    wl = 1:size(data,3);
                end
                
                if ismember('wlunit', CA.UsingDefaults)
                    if ismember('wl', CA.UsingDefaults)
                        warning('Cube:DefaultWavelengthUnit', 'Wavelength unit not given, setting to "Band index".');
                        wlu = 'Band index';
                    else
                        warning('Cube:UnknownWavelengthUnit', 'Wavelength unit not given, setting to "Unknown".');
                        wlu = 'Unknown';
                    end
                end
                
                if ismember('fwhm', CA.UsingDefaults)
                    warning('Cube:DefaultFWHM', 'FWHM values not given, setting to zero.');
                    fwhm = zeros(1, size(data, 3));
                end
                
                cube.Wavelength = wl;
                cube.WavelengthUnit = wlu;
                cube.FWHM = fwhm;

                cube.History = hst;
                % Append the given history with a note and the given
                % parameters.
                % Note that the data matrix is saved here as well, which
                % can result in large memory use.
                cube.History = {{'Cube constructed from matrix data',@Cube,CA.Results}};
            else
                error('Unknown data supplied, parameters were\n%s',evalc('CA.Results'));
            end
            
            % If a black reference was given, try to calibrate
            if ~isempty(br)
                % If given a filename, attempt to read it as raw data.
                if CA.isFile(br)
                    br = Cube(br, 'Raw');
                end
                
                % at this point, br should be a valid Cube
                cube = cube.calibrate(br);
            end
            
            % If a white reference was given, attempt to calculate
            % reflectance from the data
            if ~isempty(wr)
                
                % If a filename was given, we try to read it
                if CA.isFile(wr)
                    % If a black reference was also given, assume the white
                    % reference to be raw data in need of calibration.
                    % Otherwise, it should be Radiance and we don't need to
                    % recalibrate
                    if ~isempty(br)
                        wr = Cube(wr, 'Raw', 'br', br);
                    else 
                        wr = Cube(wr, 'Radiance');
                    end
                end
                
                % At this point, wr should be a valid Cube
                cube = cube.toReflectance(wr);
            end
        end
        end
        

        %% Getters and Setters %%
        
        function value = get.Type(obj)
            value = class(obj.Data);
        end
        
        function value = get.Min(obj)
            value = min(obj.Data(:));
        end
        
        function value = get.Max(obj)
            value = max(obj.Data(:));
        end
        
        % Size, Area and Bands correspond to those given by size(obj.Data),
        % but Size is padded to include singleton dimensions.
        function value = get.Size(obj)
            switch ndims(obj.Data)
                case 3
                    value = size(obj.Data);
                case 2
                    value = [size(obj.Data),1];
                otherwise
                    error('Data dimensions otherworldly (%s). Check sanity.', mat2str(size(obj.Data)));
            end
        end
        
        % Width and height of the image. Note the order vs. Size.
        function value = get.Width(obj)
            value = obj.Size(2);
        end
        
        function value = get.Height(obj)
            value = obj.Size(1);
        end
        
        function value = get.Area(obj)
            value = obj.Width*obj.Height;
        end
        
        function value = get.nBands(obj)
            value = obj.Size(3);
        end
        
        function value = get.Bands(obj)
            value = 1:obj.nBands;
        end
        
        % Enforce that Wavelength and FWHM correspond to Data in size.
        % TODO: Does not prevent mismatches if we forget to set either
        %       when changing the data.
        % FIXME: Is there a way to avoid referencing dependent properties
        %        here?
        function obj = set.Wavelength(obj,value)
            assert(isequal(size(value),[1,obj.nBands]), ...
                   'Cube:IncorrectWavelength', ...
                   'Given wavelengths do not match the data!');
            obj.Wavelength = value;
        end
        
        function obj = set.FWHM(obj,value)
            assert(isequal(size(value),[1,obj.nBands]), ...
                   'Cube:IncorrectFWHM', ...
                   'Given FWHMs do not match the data!');
            obj.FWHM = value;
        end
        
        % Enforce that file list and history are always appended.
        function obj = set.Files(obj,value)
            obj.Files = [obj.Files; value];
        end
        
        function obj = set.History(obj,value)
            obj.History = [obj.History; value];
        end
        
        % Enforce the type of Data to numeric and warn if precision
        % changes.
        % FIXME: Is there a way to avoid referencing dependent properties
        %        here?
        function obj = set.Data(obj,value)
            assert(isnumeric(value),'Attempted to assign non-numeric data!');
            if ~strcmp(class(value),obj.Type) && ~isempty(obj.Data)
                warning('Data type changes from %s to %s',obj.Type,class(value));
            end
            obj.Data = value;
        end
        
        % Data quantity must be a non-empty char array
        function obj = set.Quantity(obj,value)
            assert(~isempty(value), 'Attempted to assign empty quantity!');
            assert(ischar(value), 'Quantity must be a non-empty char array');
            obj.Quantity = value;
        end
        
        %% Visualization %%    
        
        % See show.m
        [obj,h] = show(obj)
        
        % See cubehist.m
        [obj,counts,bin_edges,h] = cubehist(obj, flag, showPlot, bin_edges)
        
        % See plot.m
        [obj,h] = plot(obj,h)
        
        % See im.m
        [obj,h] = im(obj,b,hlx,hly)
        
        % See rgb.m
        [obj,im] = rgb(obj,b)
        
        %% Rearrangement %%
        
        function obj = flipHoriz(obj)
            %FLIPX Flip the image upside-down
            obj.Data = flip(obj.Data,2);
            obj.History = {{'Flipped horizontally',@flipHoriz}};
        end
        
        function obj = flipVert(obj)
            %FLIPY Flip the image left-to-right
            obj.Data = flip(obj.Data,1);
            obj.History = {{'Flipped vertically',@flipVert}};
        end
        
        function obj = byCols(obj)
            %BYCOLS Concatenates the spatial pixel columns
            % Concatenates the spatial dimensions columnwise, returning
            % an Area x 1 x Bands cube
            obj.Data    = reshape(obj.Data,[obj.Area,1,obj.nBands]);
            obj.History = {{'Spatial columns concatenated',@byCols}};
        end
            
        function obj = unCols(obj, W, H)
            %UNCOLS Reshape columnwise listed spectra into the given shape
            % Given shape = [Width Height], attempts to restructure the
            % (W*H) x 1 x Bands Cube data into an Width x Height x Bands cube.
            
            assert(obj.Height == obj.Area, 'Data must be columnwise ordered spectra!');
            
            obj = obj.unmask(true(H, W));
            % History will be added by unmask
        end
            
        %% Slicing %%
    
        function obj = crop(obj,tl,br)
            %CROP Spatial crop
            % crop([tlx, tly],[brx, bry]) crops the cube spatially to a 
            %     rectangle defined by top left corner [tlx, tly] and
            %     bottom right corner [brx, bty].
            %             
            % TODO: Validate input more thoroughly
            assert(obj.inIm(tl(1),tl(2)) && obj.inIm(br(1),br(2)),'Corners must be integer coordinates inside the image plane.');
            obj.Data = obj.Data(tl(2):br(2),tl(1):br(1),:);
            obj.History = {{'Cropped spatially',@crop,tl,br}};
        end
        
        function obj = bands(obj,b)
            %BANDS Bandwise crop
            % bands(b) returns a cube with only the given bands 
            %          b must be a vector of indices in Bands or a logical
            %          array.
            % TODO: Validate input
            obj.Data       = obj.Data(:,:,b);
            obj.Wavelength = obj.Wavelength(b);
            obj.FWHM       = obj.FWHM(b);
            obj.History    = {{'Select bands retained',@bands,b}};
        end
        
        function obj = mask(obj,maskim)
            %MASK Select spatial points using a mask image
            % mask(maskim) returns a Cube containing the pixels determined
            % by the logical matrix maskim in columnwise order. 
            % The matrix maskim must have the same spatial dimensions as the
            % Cube.
            
            assert(islogical(maskim), 'The mask must be a logical matrix.');
            assert(isequal(size(maskim), [obj.Height,obj.Width]),...
                'The mask must have the same dimensions as the Cube (%d), was %d',...
                [obj.Height, obj.Width],size(maskim));
            
            % Count the number of spatial pixels after masking
            N = sum(maskim(:));
            
            % Replicate the mask bandwise for easy indexing
            cubeMask = repmat(maskim,1,1,obj.nBands);
            
            % Index the data using the mask and reshape into columnwise
            % gathered spectral vectors.
            obj.Data    = reshape(obj.Data(cubeMask),N,1,obj.nBands);
            obj.History = {{'Spatial mask applied',@mask, maskim}};
        end
        
        function obj = unmask(obj,maskim)
            %UNMASK Spatially reshape columnwise ordered spectra
            % unmask(maskim) attempts to reorganize the Cube data into
            % a Cube with the spatial dimensions of the mask image, with
            % the nonempty pixels in the mask containing the data and the
            % rest initialized to zero (inverse of mask() for the preserved
            % points).
            % The matrix maskim must be a logical matrix with the amount of
            % nonempty elements equal to the number of pixels in the Cube.
            
            assert(islogical(maskim), 'The mask must be a logical matrix.');
            
            % Calculate the number of spatial pixels and check for sanity
            N = sum(maskim(:));
            
            assert(N == obj.Area,...
                'The number of nonempty pixels in the mask (%d) does not equal the number of existing pixels (%d)',...
                N,obj.Area);
            
            % Replicate the mask for each band for easy indexing
            cubeMask = repmat(maskim,1,1,obj.nBands);
            
            % Initialize the new data with zero and assign the values to
            % the mask positions
            tmp           = zeros(size(cubeMask), obj.Type);
            tmp(cubeMask) = obj.Data(:);
            obj.Data      = tmp;
            obj.History   = {{'Reshaped using a mask image', @unmask, maskim}};
        end
        
        function obj = px(obj,x,y)
            %PX Select pixels from the cube
            % Usage: px(x,y)
            %        px([x,y]) 
            % with x, y column vectors of pixel coordinates.
            % Returns the cube containing the points (x,y) in the original
            % cube. Note that this is the opposite order to MATLAB default
            % indexing.
            if nargin < 3
                assert(size(x,2)==2,'Expected coordinate matrix [x,y].');
                y = x(:,2);
                x = x(:,1);
            end
            assert(obj.inIm(x,y),'Coordinates must be integers between (1,1) and (%d,%d)',obj.Width,obj.Height);
            
            % Reshape using byCols so that the rows match spatial linear
            % indexing. History is appended here first so that arguments of
            % px are sound for the cube before byCols.
            % Note the order of indexing.
            obj.History = {{'Selected pixels retained',@px,x,y}};
            idx = sub2ind(obj.Size(1:2),y,x);
            obj.Data = obj.byCols.Data(idx,1,:);
        end
        
        function obj = take(obj,n)
            %TAKE Take the first n pixel spectra (in column order)
            % Usage: take(N), where n = 1,...,Area returns a cube
            % containing the first n pixels in a single column.
            % If n > Area, returns all the pixels.
            assert(isnatural(n), 'N must be a natural number');
            
            if n > obj.Area
                n = obj.Area;
            end
            
            obj.History = {{'Taking n first pixels', @take, n}};
            obj = obj.byCols.px(ones(1,n)',(1:n)');
        end
        
        function [obj, pxy] = sample(obj,n,subdivs)
            %SAMPLE Sample the cube spatially using sudoku-like LHS
            % [obj, pxy] = sample(n,subdivs) returns n sample spatial 
            % pixels from the cube that are evenly distributed in a 
            % subdivs^2 grid spanning the image. If subdivs is not given, 
            % assumes 1 (LHS sampling). The second output contains a matrix
            % of the x and y coordinates sampled.
            if nargin < 3
                subdivs = 1;
            end
            % TODO: History is appended first here, then in px. 
            %       Possibly confusing.
            obj.History = {{'Sampled using sudoku sampling',@sample,n,subdivs}};
            pxy = sudoku_2d(n,subdivs,[obj.Width,obj.Height]);
            obj = obj.px(pxy);
        end
        
        %% Operations %%

        function obj = toReflectance(obj,wr)
            %TOREFLECTANCE Calculate reflectance from radiance 
            % toReflectance(wr) divides the data values by the values in
            % the given white reference. Both need to be Cube objects
            % containing radiance data.
            % If wr has fewer lines (smaller height than the data), use the
            % column averages of each band for the calculation (similar to
            % g_refl.m)
            %
            % TODO: Reduce code duplication with calibrate()
            % TODO: Implement a mechanism to check whether Cubes are
            %       calibrated using the same black reference.
                 
            % Sanity checks
            assert(strcmp(obj.Quantity, 'Radiance'), 'Data has to be calibrated radiance data to be converted, was %s', obj.Quantity);
            assert(strcmp(wr.Quantity, 'Radiance'), 'White reference has to be calibrated radiance data, was %s', wr.Quantity);
            assert(obj.Width == wr.Width, 'White reference has width %d, expected %d)', wr.Width, obj.Width);
            assert(obj.nBands == wr.nBands, 'White reference has %d bands, expected %d', wr.nBands, obj.nBands);
            
            if wr.Height == obj.Height
                % For matching sizes, just calculate
                obj.Data = double(obj.Data) ./ double(wr.Data);
            else
                % For differing heights, calibrate using the column means
                % (for single-line camera references)
                wr = wr.colMean;
                
                % TODO: Should line replication be a Cube method (that
                % leaves behind history?)
                obj.Data = double(obj.Data) ./ repmat(double(wr.Data), obj.Height, 1);
            end
            
            obj.Quantity = 'Reflectance';
            obj.Files    = wr.Files(:);
            obj.History  = {{'Calculated reflectance using white reference', @toReflectance, wr.History}};
        end
        
        function obj = calibrate(obj, br)
            %CALIBRATE Calibrates the data by substracting dark current
            % calibrate(br) substracts the given black reference from the
            % data. br must be a Cube object containing raw data.
            % The width and band number of the reference must match the data.
            % If br has fewer lines (smaller height than the data), use the
            % column averages of each band for calibration (similar to
            % g_refl.m)
            % TODO: Reduce code duplication with toReflectance()
            
            % Disallow re-calibration
            assert(strcmp(obj.Quantity, 'Raw'), 'Data must be uncalibrated values, was %s', obj.Quantity);
            
            % Some sanity checks
            % TODO: Should we check that the wavelengths match
            %       (difficult with float values)?
            assert(strcmp(br.Quantity, 'Raw'), 'Black reference should contain raw data, was %s', br.Quantity);
            assert(br.Width == obj.Width, 'Black reference has width %d, expected %d', br.Width, obj.Width);
            assert(br.nBands == obj.nBands, 'Black reference has %d bands, expected %d', br.nBands, obj.nBands);
            
            % FIXME: History should probably contain a mention of the type
            % change?
            if br.Height == obj.Height
                % For matching sizes, just calculate
                obj.Data = double(obj.Data) - double(br.Data);
            else
                % For differing heights, calibrate using the column means
                % (for single-line camera references)
                br = br.colMean;
                
                % TODO: Should line replication be a Cube method (that
                % leaves behind history?)
                obj.Data = double(obj.Data) - repmat(double(br.Data), obj.Height, 1);
            end
            
            % TODO: Can this be something else than radiance?
            obj.Quantity = 'Radiance';
            
            % Add the files used for forming br explicitly
            obj.Files    = br.Files(:);
            
            % Only include the history of the reference file in the
            % metadata instead of the actual parameter.
            % TODO: Is this practical / good enough for reproducability?
            obj.History  = {{'Calibrated to radiance using black reference',@calibrate, br.History}};
        end
        
        function obj = map(obj,f,history,qty,wlunit,wls,fwhm)
            %MAP Applies the given function on the cube data
            % map(f,history,qty,wlunit,wls,fwhm) applies the function f on 
            % the data and returns a cube with the resulting data. The user
            % must supply an explanatory history string to be included in
            % the result history.
            % The user must supply a new quantity, wavelengths, fwhms and
            % wavelength unit that correspond to the new data. Note that
            % a validity check on the supplied values is done AFTER
            % computing f, and if errors occur, the resulting data will be
            % lost.
            
            % Do some validity checks beforehand (not enough to guarantee
            % success, since the result of f and the supplied values might 
            % conflict)
            assert(isa(f,'function_handle'),...
                'Expected a valid function handle');
            assert(CubeArgs.isValidQuantity(qty),...
                'Quantity specification must be a non-empty char array');
            assert(ischar(wlunit),...
                'Wavelength unit specification must be a char array');
            assert(ischar(history),...
                'Explanatory history entry must be a string');
            
            % Hope for the best and let setters fail on any inconsistancies.
            obj.Data       = f(obj.Data);
            obj.Quantity   = qty;
            obj.Wavelength = wls;
            obj.FWHM       = fwhm;
            obj.WavelengthUnit = wlunit;
            obj.History    = {{'Applied a function on the data',...
                @map, f, history, qty, wls, fwhm, wlunit}};
        end
        
        function obj = mapSpectra(obj,f,history,qty,wlunit,wls,fwhm)
            %MAPSPECTRA Apply a function on a list of the spectra
            % mapSpectra(f,history,qty,wlunit,wls,fwhm) applies the function
            % f on the data, reordered as a columnwise matrix of the pixel 
            % spectra. The result returned by the function will be reshaped
            % to the original image dimensions. The user must supply an 
            % explanatory history string to be included in the result history.
            % The user must supply a new quantity, wavelengths, fwhms and
            % wavelength unit that correspond to the new data. Note that
            % a validity check on the supplied values is done AFTER
            % computing f, and if errors occur, the resulting data will be
            % lost. Note that f must preserve the area of the image.
            
            % The data will have a singleton width dimension after byCols,
            % so we must deal with it by wrapping the given function.
            g = @(x) permute(shiftdim(f(squeeze(x)), -1), [2 1 3]);
            
            obj = obj.byCols.map(g,history,qty,wlunit,wls,fwhm).unCols(obj.Width, obj.Height);
        end
        
        function obj = mapBands(obj, f, history, qty)
            %MAPBANDS Apply a function on each band of the data
            % mapBands(f,history,qty) applies f on each band (image) and
            % returns a Cube with the resulting data. User must supply a
            % history string to be included in the result history, and the
            % quantity specification for the new data.
            % Changes in wavelength and fwhm values are not supported,
            % though the spatial dimensions of the data may change.
            
            assert(isa(f,'function_handle'),...
                'Expected a valid function handle');
            assert(CubeArgs.isValidQuantity(qty),...
                'Quantity specification must be a non-empty char array');
            
            for b = obj.Bands
                tmp(:,:,b) = f(obj.Data(:,:,b));
            end
            
            obj.Data     = tmp;
            obj.Quantity = qty;
            obj.History  = {{'Applied function on each band',...
                f, history, qty}};
        end
        
        %% Reductions %%
        
        function obj = mean(obj, flag1, flag2)
            %MEAN Returns the spatial mean spectra.
            % mean('omitnan'), mean('omitinf') or mean('omitinf','omitnan')
            % may be used to omit NaN, Inf or both values.
            
            if nargin < 2
                % Just calculate the mean
                obj.Data    = mean(obj.byCols.Data,1);
                obj.History = {{'Reduced to spatial mean',@mean}};
            elseif nargin < 3
                if strcmp(flag1, 'omitinf')
                    % Convert inf to nan, and use the flag in mean
                    obj.Data(isinf(obj.Data)) = nan;
                    obj.Data = mean(obj.byCols.Data,1,'omitnan');
                elseif strcmp(flag1, 'omitnan')
                    % For NaN, mean() has us covered
                    obj.Data    = mean(obj.byCols.Data,1, flag1);
                else
                    error('Flag not recognized.\nPass "omitinf", "omitnan" or both to omit respective values from the mean.');
                end
                obj.History = {{'Reduced to spatial mean',@mean, flag1}};
            elseif nargin == 3 && ...
                   ((strcmp(flag1,'omitinf') && strcmp(flag2, 'omitnan')) ||...
                    (strcmp(flag2,'omitinf') && strcmp(flag1, 'omitnan')))
                obj.Data = obj.byCols.Data;
                obj.Data = mean(obj.Data(obj.Data < inf),1,'omitnan');
                obj.History = {{'Reduced to spatial mean',@mean, flag1,flag2}};
            else
                error('Flags not recognized.\nPass "omitinf", "omitnan" or both to omit respective values from the mean.');
            end
        end
        
        function obj = colMean(obj)
            %COLMEAN Returns the spatial mean spectra for each column.
            obj.Data    = mean(obj.Data,1);
            obj.History = {{'Reduced to spatially columnwise means',@colMean}};
        end
        
        function obj = median(obj)
            %MEDIAN Returns the spatial median spectra.
            obj.Data    = median(obj.byCols.Data,1);
            obj.History = {{'Reduced to spatial median',@median}};
        end
        
        function obj = writeENVI(obj, filename)
            %WRITEENVI Save cube data to an ENVI format file
            % Cube.writeENVI(filename) saves the Cube data and applicable
            % metadata to the given ENVI data and header files. 'filename' 
            % should be the desired filename without the extension.
            % Currently does not save the object history.
            % NOTE: Will overwrite existing files.
            
            % Generate ENVI header info
            info = enviinfo(obj.Data);
            info.description = ['{', strjoin(obj.Files, ' '), '}'];
            info.wavelength_units = obj.WavelengthUnit;
            info.wavelength = ['{', num2str(obj.Wavelength, '%f, '), '}'];
            info.fwhm = ['{', num2str(obj.FWHM, '%f, '), '}'];
            
            hdrfile = [filename, '.hdr'];
            datafile = [filename, '.dat'];
            enviwrite(obj.Data, info, datafile, hdrfile);
        end

    end
        
    
    %% Private methods %%
    
    methods (Access = 'private')
        % See parseENVI.m
        obj = parseENVI(obj, S)
        
        function bool = inIm(obj,x,y)
            %INIM Check whether a pixel coordinate is valid.
            % Valid coordinates are integers between 1 and width/height of 
            % the image plane.
            % Requires ../Utils/isnatural.m and ../Utils/inRect.m
            
            % Check if we are given integers and their sizes match
            if ~isequal(size(x),size(y)) || ~isnatural(x) || ~isnatural(y)
                bool = false;
            else
                maxP = obj.Size([1,2]);
                bool = all(inRect([y, x],[1,1],maxP));
            end
        end
        
        function filename = generateFileName(obj,name)
            %GENERATEFILENAME Generate a filename based on Cube history
            % filename = generateFileName(name)
            % Returns a filename (without path or extension) using the format
            %  name-WidthxHeightxnBands-Quantity
            % If name is not given, uses the original filename without
            % extension or path parts.
            
            if nargin < 2
                [~, name, ~] = fileparts(obj.Files{1});
            end
            
            size = sprintf('%dx%dx%d',obj.Width,obj.Height,obj.nBands);
            nameparts  = {name, size, obj.Quantity};
            filename = strjoin(nameparts,'-');
        end
    end
    
    methods (Static)
        
        function saveToFile(obj, filename, overwrite)
            %SAVETOFILE Save cube(s) to a file
            % Cube.saveToFile(cube, filename) saves the given cube or cube
            % array, and possibly generates a filename.
            % If the filename is a directory, 
            % If the given filename does not have
            % an extension, appends '.cb'.
            % Unless the optional parameter overwrite is given and true, 
            % throws an error if the file already exists.
            if nargin < 3
                overwrite = false;
            end
            
            % Sanity checks
            assert(isa(obj,'Cube'), 'First parameter invalid, expected a valid Cube object or array.');
            assert(ischar(filename) && ~isempty(filename), 'Second parameter was invalid, expected a filename (non-empty string)');
            assert(islogical(overwrite), 'Overwrite parameter must be a logical value.');
            
            % Append '.cb' when no file extension was given
            [dir, fname, ext] = fileparts(filename);
            if strcmp(ext,'')
                fname = [fname,'.cb'];
            else
                fname = [fname,ext];
            end
            savefile = fullfile(dir,fname);
            
            % Check whether we are overwriting and act appropriately
            assert( ~exist(savefile,'file') || overwrite, ...
                'File already exists. If you want to overwrite, give true as the third parameter.');
            
            % Save the file and print some nice output
            CUBEDATA = obj;
            n = length(CUBEDATA);
            fprintf('Saving %d Cube(s) to %s\n', n, savefile);
            
            % For files over 2GB in size, only version 7.3 of the MAT
            % format is available. If it is not specified, save fails but
            % only with a warning. Since we can't know the file size
            % beforehand, default to version 7.3 always.
            save(savefile,'CUBEDATA','-mat','-v7.3');
            fprintf('Saved. File contents:\n');
            whos('-file', savefile);
        end
        
        function obj = loadFromFile(filename)
            %LOADFROMFILE Load saved cube(s)
            % C = loadFromFile(filename) attempts to read the filename,
            % which be a valid MAT file containing the variable CUBEDATA.
            % Display some output when starting and finishing loading
            fprintf('Loading Cube data from %s\n', filename);
            S = load(filename,'-mat','CUBEDATA');
            fprintf('Loaded %d Cube(s).\n',length(S.CUBEDATA));
            obj = S.CUBEDATA;
        end
        
        function obj = loadobj(s)
            %LOADOBJ Check the version of the saved class before loading
            % In case the saved version does not match the current version
            % in the class definition, throw an error and show the versions
            % if possible.
            if ~isequal(s.Version, Cube.ClassVersion)
                if ischar(s.Version) && ischar(Cube.ClassVersion)
                    warning('Saved object has version %s, while current class version is %s. Proceed with caution.',...
                        s.Version, Cube.ClassVersion);
                else
                    warning('The saved object has different version than the current class. Proceed with caution.');
                end
            end
            obj = loadobj(s);
        end
    end
end
