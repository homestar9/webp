/**
 * Webp Module
 * Utility module for working with webp images
 * Google's precompiled binaries are used for this module can be found here:
 * https://developers.google.com/speed/webp/docs/precompiled
 * 
 */
component {

	// Module Properties
	this.title             = "webp";
	this.author            = "Angry Sam Productions, Inc.";
	this.webURL            = "https://www.angrysam.com";
	this.description       = "This module provides utilities for working with webp images.";
	this.modelNamespace    = "webp";
	this.cfmapping         = "webp";
	// Module Dependencies That Must Be Loaded First, use internal names or aliases
	this.dependencies      = [];
	// Helpers
	this.applicationHelper = [];

	/**
	 * Module Config
     * todo: add support for other platforms
	 */
	function configure(){
		// Module Settings
		settings = { 
            cmdPath : getCmdPath(),
            binPath : modulePath & "/bin/#getBinPath()#/" 
        };
	}

    private function getBinPath(){
        if ( 
            server.os.name CONTAINS "Windows" && 
            server.os.arch CONTAINS "64"
        ) {
            return "win-x64-1.3.2";
        }

        throw( "unsupported OS: #server.os.name#" );
    }

    private function getCmdPath(){
        if ( server.os.name CONTAINS "Windows" ) {
            return "c:\windows\system32\cmd.exe";
        }

        throw( "unsupported OS: #server.os.name#" );
    }

	/**
	 * Fired when the module is registered and activated.
	 */
	function onLoad(){}

}
