require( "src/pchgroups" )

workspace "pchgroupz"


	kind "ConsoleApp"
	--kind "StaticLib"
	architecture "x64"
    configurations {"debug", "release"}
    language "C++"
    cppdialect "C++latest"
    system "windows"
    staticruntime "On"
    systemversion "latest"
	pdbfile "$(SharedPdb)"
	project "urmom"
	project "*"

	pchgroup("SharedPCH",
			 "prj1",
			 "prj2")

workspace "*"
