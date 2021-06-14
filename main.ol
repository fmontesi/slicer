#!/usr/bin/env jolie

from string-utils import StringUtils
from console import Console
from runtime import Runtime
from file import File

from .jolie-slicer import Slicer

service Launcher {
	  embed Runtime as runtime
	  embed File as file
    embed StringUtils as S
    embed Console as C
    embed Slicer as Slicer

    define usage {
        println@C( "Usage: slicer <program_file> -c <config_file> -o <output_directory>" )()
    }
    
    main {
        scope( usage ) {
            install( default => usage )
            i = 0
            while(i < #args ) {
                if( args[i] == "--config" || args[i] == "-c" ) {
                    request.config = args[++i]
                } else if ( args[i] == "--output" || args[i] == "-o" ) {
                    request.outputDirectory = args[++i]
                } else {
                    startsWith@S( args[i] { prefix = "-" } )( isAnOption )
                    if( isAnOption ) {
                        throw( UnrecognizedOption, "Unrecognized option " + args[i] )
                    } else {
                        request.program = args[i]
                    }
                }
                ++i
            }
            if( !is_defined(request.config) && !is_defined(request.program) ) {
                throw( MissingArgument, "An argument is missing" )
            }
        }
        getRealServiceDirectory@file()( home )
		    getFileSeparator@file()( sep )
        println@C( home )()

		    // loadEmbeddedService@runtime( {
			  //     filepath = home + sep + "jolie-slicer.ol"
        //     // type = "Java"
			  //     service = "Slicer"
			  //     // params -> config
		    // } )()
        // slice@Slicer( request )()
    }
}