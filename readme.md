# webp

![WebP Logo](https://github.com/homestar9/webp/blob/master/webp-logo.webp?raw=true)

WebP is a Coldbox module that provides a simple API for converting images into WebP format. It can also be used to convert WebP images into other formats. It uses the precompiled binaries provided by [Google](https://developers.google.com/speed/webp/docs/precompiled).

## Why WebP?

WebP is a modern image format offering superior lossless and lossy compression for images on the web.  Google encourages the use of modern image formats, like WebP, as part of their [Core Web Vitals](https://web.dev/vitals/) initiative.  WebP images are typically 25-35% smaller than their JPEG or PNG counterparts, resulting in faster page load times and reduced bandwidth usage.  [WebP is compatible](https://caniuse.com/webp) with all major modern browers.

## WebP Support in ColdFusion

- [Lucee's Image Extension](https://github.com/lucee/extension-image) supports WebP as of version 2.0.
- Adobe ColdFusion does not support WebP.  There is an [open ticket](https://tracker.adobe.com/#/view/CF-4220291) for this feature. Please vote for it!

## Requirements

- Lucee 5+
- Adobe ColdFusion 2018+
- Coldbox 6+
- Windows (for now)
- `<cfexecute>` enabled

## Installation

Within Commandbox type:

```
box install webp
```

The module configuration will detect your operating system and point to the appropriate binaries. If you need to override the default configuration, you can do so in your `Coldbox.cfc` file:

```
webp = {
    cmdPath : "c:\windows\system32\cmd.exe", // path to cmd.exe
    binPath : "c:\custom-binaries\" // path to your custom binaries
}
```

## Usage

Use Wirebox to inject `webp` into your handler or service:

```
property name="webp" inject="webp@webp";
```

To encode an image into webp format:

```
webp.encode( 
    source = "path/to/image.jpg", 
    destination = "path/to/image.webp" 
);

```

To decode a webp image into another format:

```
webp.decode( 
    source = "path/to/image.webp", 
    destination = "path/to/image.png" 
);
```

Google currently supports the following [output formats](https://developers.google.com/speed/webp/docs/dwebp): PNG, TIFF, BMP, PPM, PGM, PBM, and PNM.  I have no idea why they don't support JPG.  If you need to convert a webp image to JPG, first, decode the image as a PNG and then use you can use the [`cfimage`](https://cfdocs.org/cfimage) tag or [`imageWrite()`](https://cfdocs.org/imagewrite) function.

### Encode Arguments

The following arguments are available when encoding an image:
| Argument | Type | Default | Description |
|----------------|--------------|--------------|--------------|
| @source | String | | Full path to the source file to convert |
| @destination |  String | | Full path to the output file |
| @lossless | Boolean | false | Encode the image without any loss |
| @nearLossless | Int (0-100) | | Specify the level of near-lossless image preprocessing |
| @quality | Int (0-100) | 80 | Specify the compression factor. |
| @losslessCompressionMode | int (0-9) | | Switch on lossless compression mode with the specified level |
| @alphaQuality | int(0-100) | 100 | Specify the compression factor for alpha compression |
| @preset | string | | Specify the compression preset (default, photo, picture, drawing, icon, text) |
| @compressionMethod | int(0-6) | 4 | Specify the compression method to use |
| @cropX | int | | Crop the source X-position |
| @cropY | int | | Crop the source Y-position |
| @cropWidth | int | | Crop the source width |
| @cropHeight | int | | Crop the source height |
| @resizeWidth | int | | Resize the source to the specified width |
| @resizeHeight | int | | Resize the source to the specified height |
| @multiThreaded | boolean | true | Use multi-threading for encoding, if possible
| @lowMemory | boolean | false | Reduce memory usage (not recommended)
| @size | int | | Target size (in bytes) for the output file
| @psnr | float | | Target PSNR (in dB. typically: 42) for the output file
| @pass | int (1-10) | 1 | Number of entropy-analysis passes (in [1..10])
| @autoFilter | boolean | false | Turns auto-filter on. This algorithm will spend additional time optimizing the filtering strength to reach a well-balanced quality |
| @jpegLike | boolean | false | Enables JPEG-like image preprocessing. This preprocessing step tries to map visually lossless areas to the lossless compressed domain if possible |
| @filterStrength | int (0-100) |  | Filter strength (between 0 (off) and 100) for the pre-processing step. The larger the value, the stronger the filtering |
| @filterSharpness | int (0-7) |  | Filter sharpness (between 0 (off) and 7) |
| @filterStrong | boolean | false | Use strong filter  |
| @filterWeak | boolean | false | disable strong filter |
| @exact | boolean | false | Preserve RGB values in transparent area |
| @metadata | string | none | metadata to copy from the input to the output if present. Valid values: all, none, exif, icc, xmp |
| @noAlpha | boolean | false | Discard any transparency information |
| @sourceHint | string | | Hint for image type (photo, picture, graph) |
| @verbose | boolean | false | return verbose output |
| @timeout | int | 10 | Timeout in seconds for cfexecute to finish |

See [Google's documentation](https://developers.google.com/speed/webp/docs/cwebp) for more details on encoding Webp images.

### Decode Arguments

The following arguments are available when decoding an image:

| Argument | Type | Default | Description |
|----------------|--------------|--------------|--------------|
| @source | String | | Full path to the source file to convert |
| @destination |  String | | Full path to the output file |
| @cropX | int | | Crop the source X-position |
| @cropY | int | | Crop the source Y-position |
| @cropWidth | int | | Crop the source width |
| @cropHeight | int | | Crop the source height  |
| @resizeWidth | int | | Resize the source to the specified width |
| @resizeHeight | int | | Resize the source to the specified height |
| flipImage | boolean | false | Flip the image vertically |
| @multiThreaded | boolean | true | Use multi-threading for encoding, if possible |
| @verbose | boolean | false | return verbose output |
| @timeout | int | 10 | Timeout in seconds for cfexecute to finish |

See [Google's Documentation](https://developers.google.com/speed/webp/docs/dwebp) for more details when decoding Webp images.


## Known Issues

This module currently only works on Windows operating systems.  If you have a Mac or Linux machine and would like to contribute, please feel free to submit a PR.

## Future Development Roadmap

- Support Mac
- Support Linux
- Create more encode/decode tests using lossless/lossy advanced options
