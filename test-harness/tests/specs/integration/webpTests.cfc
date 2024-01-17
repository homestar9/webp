/**
* The base model test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="coldbox.system.testing.BaseTestCase" {
    
    
    variables._inputPath = expandPath( "../../resources/" );
    variables._outputPath = expandPath( "../../resources/output/" );
    variables._cleanOutput = true;

    /*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		
		// setup the model
		super.setup();

        model = getInstance( "webp@webp" );

	}

	function afterAll(){
		super.afterAll();

        if ( variables._cleanOutput ) {

            // delete everything in the output folder
            directoryList( 
                path = variables._outputPath,
                type = "file"
            ).each( function( item ) {
                fileDelete( item );
            } );
        }

	}

	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( "WebP Model", function(){
			
            it( "can be created", function(){
                expect( model ).toBeComponent();
            });

            it( "can create a webp image from a jpg source", function(){
                
                var outputFilename = createUuid() & ".webp";
                
                var result = model.encode(
                    source = expandPath( "../../resources/golden.jpg" ),
                    destination = variables._outputPath & outputFilename,
                    verbose = true
                );

                var resultArray = listToArray(result, chr(10) );

                //debug( resultArray );

                expect( fileExists( variables._outputPath & outputFilename ) ).toBeTrue();
                expect( resultArray[1] ).toContain( "time to read" );
                expect( resultArray[2] ).toContain( "saving file" );

            });

            it( "can create a lossless webp image from a PNG source", function(){
                
                var outputFilename = createUuid() & ".webp";
                
                var result = model.encode(
                    source = expandPath( "../../resources/dog.png" ),
                    destination = variables._outputPath & outputFilename,
                    lossless = true,
                    verbose = true
                );

                var resultArray = listToArray(result, chr(10) );

                //debug( resultArray );

                expect( fileExists( variables._outputPath & outputFilename ) ).toBeTrue();
                expect( resultArray[1] ).toContain( "time to read" );
                expect( resultArray[2] ).toContain( "saving file" );

            });

            it( "can convert a webp image to png", function(){
                
                var outputFilename = createUuid() & ".png";
                
                var result = model.decode(
                    source = expandPath( "../../resources/golden.webp" ),
                    destination = variables._outputPath & outputFilename,
                    verbose = true
                );

                var resultArray = listToArray(result, chr(10) );

                //debug( resultArray );

                expect( fileExists( variables._outputPath & outputFilename ) ).toBeTrue();
                expect( resultArray[1] ).toContain( "time to decode" );
                expect( resultArray[2] ).toContain( "decoded" );
                expect( resultArray[3] ).toContain( "saved file" );

            });
        
        });

	}

}
