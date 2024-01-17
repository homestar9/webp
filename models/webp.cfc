/**
 * WebP Encoder/Decoder
 * Google Documentation: https://developers.google.com/speed/webp/docs/
 */
component 
    singleton
    hint="I am the webp encoder/decoder"
{

    property name="settings" inject="coldbox:modulesettings:webp";

    function init() {
        return this;
    }

    /**
     * Encode
     * Compresses an image using the WebP format. Input format can be either PNG, JPEG, TIFF, WebP or raw Y'CbCr samples. 
     * Note: Animated PNG and WebP files are not supported.
     * https://developers.google.com/speed/webp/docs/cwebp
     *
     * @source (string) Full path to the source file to convert
     * @destination (string) Full path to the output file
     * 
     * Compression/Quality
     * @lossless (boolean) Encode the image without any loss
     * @nearLossless (int 0-100) Specify the level of near-lossless image preprocessing
     * @quality (int 0-100) Specify the compression factor. 
     * @losslessCompressionMode (int (0-9)) Switch on lossless compression mode with the specified level
     * @alphaQuality (int(0-100)) Specify the compression factor for alpha compression
     * @preset (string) Specify the compression preset (default, photo, picture, drawing, icon, text)
     * @compressionMethod (int(0-6)) Specify the compression method to use
     * 
     * Cropping
     * @cropX (int) Crop the source X-position
     * @cropY (int) Crop the source Y-position
     * @cropWidth (int) Crop the source width
     * @cropHeight (int) Crop the source height 
     * 
     * Resizing
     * @resizeWidth (int) Resize the source to the specified width
     * @resizeHeight (int) Resize the source to the specified height
     * 
     * Performance
     * @multiThreaded (boolean) Use multi-threading for encoding, if possible
     * @lowMemory (boolean) Reduce memory usage (not recommended)
     * 
     * Lossy Options
     * @size specify a target size (in bytes) to try and reach for the compressed output
     * @psnr (float) Specify a target PSNR (in dB) to try and reach for the compressed output
     * @pass (int 1-10) Set a maximum number of passes to use during the dichotomy used by options -size and -psnr
     * @autoFilter (boolean) Turns auto-filter on. This algorithm will spend additional time optimizing the filtering strength to reach a well-balanced quality.
     * @jpegLike (boolean) hange the internal parameter mapping to better match the expected size of JPEG compression
     * 
     * Advanced
     * @filterStrength (int 0-100) Specify the strength of the deblocking filter,
     * @filterSharpness (int 0-7) Specify the sharpness of the deblocking filter 
     * @filterStrong (boolean) Use strong filtering
     * @filterWeak (boolean) disable strong filtering

     * @exact (boolean) Preserve RGB values in transparent area.
     * @metadata (string) metadata to copy from the input to the output if present. Valid values: all, none, exif, icc, xmp.
     * @noAlpha (boolean)Discard any transparency information
     * @verbose (boolean) return verbose output
     * @timeout (int) Timeout in seconds for cfexecute to finish
     */
    string function encode( 
        required string source, 
        required string destination, 
        boolean lossless=false,
        numeric nearLossless,
        numeric quality = 80,
        numeric losslessCompressionMode,
        numeric alphaQuality,
        string preset,
        numeric compressionMethod,
        
        // Croppping
        numeric cropX,
        numeric cropY,
        numeric cropWidth,
        numeric cropHeight,

        // Resizing
        numeric resizeWidth=0,
        numeric resizeHeight=0,

        // Performance
        boolean multiThreaded=true,
        boolean lowMemory=false,

        // Lossy Options
        numeric size,
        numeric psnr,
        numeric pass,
        boolean autoFilter=false,
        boolean jpegLike=false,

        // Advanced
        numeric filterStrength, // 0-100
        numeric filterSharpness, // 0-7
        boolean filterStrong=false,
        boolean filterWeak=false,

        // additional options
        boolean exact=false,
        string metadata, // all, none, exif, icc, xmp
        boolean noAlpha=false,
        string sourceHint, // photo, picture, graph, 

        // Logging
        boolean verbose=false,

        // Timeout
        numeric timeout=10 // 10 seconds
    ) {

        var result = "";
        var cmd =  [];

        if ( !fileExists( source ) ) {
            throw( "Source file does not exist" );
        }

        if ( !directoryExists( getDirectoryFromPath( destination ) ) ) {
            throw( "Destination directory does not exist" );
        }

        /*
            Preset
            Specify a set of pre-defined parameters to suit a particular type of source material. Possible values are: default, photo, picture, drawing, icon, text.
        */
        if ( arguments.keyExists( "preset" ) ) {
            cmd.append( "-preset #arguments.preset#" );
        }

        /*
            Lossless
            Encode the image without any loss.
        */
        if ( arguments.lossless ) {
            
            cmd.append( "-lossless -q 100" );
            
            if ( arguments.keyExists( "losslessCompressionMode" ) ) {
                cmd.append( "-z #arguments.losslessCompressionMode#" );
            }

            /*
                exact
                Preserve RGB values in transparent area. 
            */
            if ( arguments.exact ) {
                cmd.append( "-exact" );
            }
        
        /*
            NearLossless
            Specify the level of near-lossless image preprocessing. This option adjusts pixel values to help compressibility, but has minimal impact on the visual quality. It triggers lossless compression mode automatically. The range is 0 (maximum preprocessing) to 100 (no preprocessing, the default). The typical value is around 60. Note that lossy with -q 100 can at times yield better results.
        */
        } else if ( arguments.keyExists( "nearLossless" ) ) {
            cmd.append( "-near_lossless #arguments.nearLossless#" );
        
        // Lossy
        } else {
            
            cmd.append( "-q#(arguments.jpegLike ? ' jpeg_like' : '' )# #arguments.quality#" );

            // Lossy Options
            if( arguments.keyExists( "psnr" ) ) {
                cmd.append( "-psnr #arguments.psnr#" );
            }

            if( arguments.keyExists( "pass" ) ) {
                cmd.append( "-pass #arguments.pass#" );
            }

            if( arguments.autoFilter ) {
                cmd.append( "-af" );
            }

            // Advanced
            if( arguments.keyExists( "filterStrength" ) ) {
                cmd.append( "-f #arguments.filterStrength#" );
            }

            if( arguments.keyExists( "filterSharpness" ) ) {
                cmd.append( "-sharpness #arguments.filterSharpness#" );
            }

            if( arguments.filterStrong ) {
                cmd.append( "-strong" );
            }

            if( arguments.filterWeak ) {
                cmd.append( "-nostrong" );
            }

        }

        /*
            CompressionMethod
            Specify the compression method to use. This parameter controls the trade off between encoding speed and the compressed file size and quality. Possible values range from 0 to 6. Default value is 4. When higher values are used, the encoder will spend more time inspecting additional encoding possibilities and decide on the quality gain. Lower value can result in faster processing time at the expense of larger file size and lower compression quality.
        */
        if ( arguments.keyExists( "compressionMethod" ) ) {
            cmd.append( "-m #arguments.compressionMethod#" );
        }

        /*
            alphaQuality
            Specify the compression factor for alpha compression between 0 and 100. Lossless compression of alpha is achieved using a value of 100, while the lower values result in a lossy compression. The default is 100.
        */
        if ( arguments.keyExists( "alphaQuality" ) ) {
            cmd.append( "-alpha_q #arguments.alphaQuality#" );
        }

        // Cropping
        if ( 
            arguments.keyExists( "cropX" ) && 
            arguments.keyExists( "cropY" ) && 
            arguments.keyExists( "cropWidth" ) && 
            arguments.keyExists( "cropHeight" ) 
        ) {
            cmd.append( "-crop #arguments.cropX# #arguments.cropY# #arguments.cropWidth# #arguments.cropHeight#" );
        }

        // Resizing (if either width or height is set. 0=preserves aspect ratio)
        if( arguments.resizeWidth || arguments.resizeHeight ) {
            cmd.append( "-resize #arguments.resizeWidth# #arguments.resizeHeight#" );
        }

        if ( arguments.multiThreaded ) {
            cmd.append( "-mt" );
        }

        if ( arguments.lowMemory ) {
            cmd.append( "-low_memory" );
        }

        // metadata
        if ( arguments.keyExists( "metadata" ) ) {
            cmd.append( "-metadata #arguments.metadata#" );
        }
        
        if ( arguments.noAlpha ) {
            cmd.append( "-noalpha" );
        }

        if ( arguments.keyExists( "sourceHint" ) ) {
            cmd.append( "-hint #arguments.sourceHint#" );
        }

        // Logging
        if ( arguments.verbose ) {
            cmd.append( "-v" );
        }

        cmd.append( "#source# -o #destination#" );

        return execute(
            name = settings.binPath & "cwebp.exe",
            cmd = cmd,
            timeout = arguments.timeout
        );

    }

    /**
     * Decode
     * Decompress a WebP file to an image file
     * decompresses WebP files into PNG, PAM, PPM or PGM images. Note: Animated WebP files are not supported.
     * Why google didn't add JPG is beyond me.
     * https://developers.google.com/speed/webp/docs/dwebp
     * 
     * @source
     * @destination
     * @cropX
     * @cropY
     * @cropWidth
     * @cropHeight
     * @resizeWidth
     * @resizeHeight
     * @flipImage
     * @multiThreaded
     * @verbose
     * @timeout
     */
    string function decode(
        required string source,
        required string destination,

        // Croppping
        numeric cropX,
        numeric cropY,
        numeric cropWidth,
        numeric cropHeight,

        // Resizing
        numeric resizeWidth=0,
        numeric resizeHeight=0,

        // Other Options
        boolean flipImage=false, // cannot be named 'flip' for some reason

        // Performance
        boolean multiThreaded=true,

        // Logging
        boolean verbose=false,

        // timeout
        numeric timeout=10 // 10 seconds
    ) {

        var result = "";
        var cmd =  [];

        if ( !fileExists( source ) ) {
            throw( "Source file does not exist" );
        }

        if ( !directoryExists( getDirectoryFromPath( destination ) ) ) {
            throw( "Destination directory does not exist" );
        }

        // Attept to infer what the output format should be
        var fileExtension = getFileExtension( getFileFromPath( destination ) );

        switch( fileExtension ) {
            case "png":
                // no need to add flag as this is the default
                break;
            case "pam":
                cmd.append( "-pam" );
                break;
            case "ppm":
                cmd.append( "-ppm" );
                break;
            case "pgm":
                cmd.append( "-pgm" );
                break;
            case "tiff":
                cmd.append( "-tiff" );
                break;
            case "yuv":
                cmd.append( "-yuv" );
                break;
            default:
                throw( "unknown or unsupported outputformat #fileExtension#" );

        }

        // Cropping
        if ( 
            arguments.keyExists( "cropX" ) && 
            arguments.keyExists( "cropY" ) && 
            arguments.keyExists( "cropWidth" ) && 
            arguments.keyExists( "cropHeight" ) 
        ) {
            cmd.append( "-crop #arguments.cropX# #arguments.cropY# #arguments.cropWidth# #arguments.cropHeight#" );
        }

        // Resizing (if either width or height is set. 0=preserves aspect ratio)
        if( arguments.resizeWidth || arguments.resizeHeight ) {
            cmd.append( "-resize #arguments.resizeWidth# #arguments.resizeHeight#" );
        }

        if ( arguments.flipImage ) {
            cmd.append( "-flip" );
        }

        if ( arguments.verbose ) {
            cmd.append( "-v" );
        }

        cmd.append( "#source# -o #destination#" );

        return execute(
            name = settings.binPath & "dwebp.exe",
            cmd = cmd,
            timeout = arguments.timeout
        );
    }



    /**
     * Execute
     * Performs the cfexecute command and returns the result
     */
    private function execute(
        required string name,
        required array cmd,
        numeric timeout
    ) {
        var result = "";

        cfexecute(
            name = settings.cmdPath,
            arguments = "/c "& arguments.name & " " & arguments.cmd.toList( " " ) & " 2>&1",
            variable = "result",
            timeout = arguments.timeout
        );

        return result;
    }

    /**
     * GetFileExtension
     * Returns the fileName extension
     */
    private string function getFileExtension( filename ) {

		if ( find( ".", arguments.fileName ) ) {
			return listLast( arguments.fileName, "." );
		}

		return "";

    }



}