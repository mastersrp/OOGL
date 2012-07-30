solution "OOGL"
	configurations { "Debug", "Release" }

	configuration "Debug"
		defines { "DEBUG" }
		flags { "Symbols", "FloatFast", "EnableSSE2" }
		targetsuffix( "-d" )
	configuration "Release"
		defines { "NDEBUG" }
		flags { "OptimizeSpeed", "FloatFast", "EnableSSE2" }

	if( _ACTION == nil ) then
		location( "build/" )
	else
		location( "build/" .. _ACTION )
	end

	libjpeg = os.matchfiles( "src/GL/Util/libjpeg/*.c" )
	libpng = os.matchfiles( "src/GL/Util/libpng/*.c" )
	zlib = os.matchfiles( "src/GL/Util/zlib/*.c" )

	newoption {
		trigger			= "without-meshloader",
		description	= "Do NOT build the mesh loader"
	}

	newoption {
		trigger			= "without-imageloader",
		description	= "Do NOT build the image loader"
	}

	newoption {
		trigger			= "build",
		value				= "TYPE",
		description	= "Which type of library to output",
		allowed 		= {
				{ "shared", "Shared/Dynamic Linked" },
				{ "static", "Static linked" }
		}
	}

	if( _OPTIONS['build'] == nil ) then _OPTIONS['build'] = shared end

	configuration "without-meshloader"
		defines { "OOGL_NO_MESHLOADER" }

	configuration "without-imageloader"
		defines { "OOGL_NO_IMAGELOADER" }

	project "png"
		kind "StaticLib"
		language "C"
		includedirs { "include", "src" }
		targetdir( "bin/" )
		files { "src/GL/Util/libpng/*.c" }
	
	project "jpeg"
		kind "StaticLib"
		language "C"
		includedirs { "include", "src" }
		targetdir( "bin/" )
		files { "src/GL/Util/libjpeg/*.c" }
	
	project "zlib"
		kind "StaticLib"
		language "C"
		includedirs { "include", "src" }
		targetdir( "bin/" )
		files { "src/GL/Util/zlib/*.c" }

	project "OOGL"
		if( _OPTIONS['build'] == "shared" ) then
			kind "SharedLib"
		else
			kind "StaticLib"
		end
		language "C++"
		includedirs { "include", "src/GL/Util/libjpeg","src/GL/Util/libpng","src/GL/Util/zlib/", "src" }
		targetdir ( "bin/" )
		buildoptions { "-std=c++0x" } -- Enable C++0x for OOGL, but not for the C libraries
		files { "src/**.cpp" }
		defines { "ExtraWarnings", "FatalWarnings" }
		links { "zlib", "jpeg", "png" }
