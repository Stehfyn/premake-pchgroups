if premake.extensions == nil or premake.extensions.pchgroups == nil then
	include ("_preload.lua")
end

premake.extensions.pchgroups = {

	custombuildbeforestep = "ClCompile"
}

premake.override(premake.vstudio.vc2010, "userMacros", function(base, cfg)

	local _macros = cfg.usermacros

	--define the elements for the user-defined macros

    if _macros and #_macros > 0 then

    	premake.push('<PropertyGroup Label="UserMacros">')

    	for index, data in ipairs(_macros) do

    		for key, value in pairs(data) do

        		premake.w('<%s>%s</%s>',key,value,key)

        	end

    	end

    	premake.pop('</PropertyGroup>')

    --include new elements along with msbuild macros

    	premake.push('<ItemGroup>')

    	for index, data in ipairs(_macros) do

    		for key, value in pairs(data) do

        		premake.push('<BuildMacro Include="%s">', key)

        		premake.w('<Value>$(%s)</Value>', key)

        		premake.pop('</BuildMacro>')

        	end

    	end

    	premake.pop('</ItemGroup>')

    end

end)

premake.override(premake.vstudio.vc2010, "propertySheets", function(base, cfg)

	premake.push('<ImportGroup Label="PropertySheets" %s>', premake.vstudio.vc2010.condition(cfg))

    premake.w('<Import Project="$(UserRootDir)\\Microsoft.Cpp.$(Platform).user.props" Condition="exists(\'$(UserRootDir)\\Microsoft.Cpp.$(Platform).user.props\')" Label="LocalAppDataPlatform"/>')

    if cfg.importprops and #cfg.importprops > 0 then

        for i = 1, #cfg.importprops do

            local prop = premake.project.getrelative(cfg.project, cfg.importprops[i])

        premake.w('<Import Project="%s"/>', prop);

        end

    end

    premake.pop('</ImportGroup>')

end)

premake.override(premake.vstudio.vc2010, "programDatabaseFileName", function(base, cfg)

	if cfg.pdbfile and #cfg.pdbfile >0 then

		premake.vstudio.vc2010.element("ProgramDatabaseFileName", nil, cfg.pdbfile)

	end

end)

premake.override(premake.vstudio.vc2010.elements, "clCompile", function(base, cfg)

	local calls = base(cfg)

	if cfg.kind ~= premake.STATICLIB and #cfg.pdbfile > 0 then

		table.insert(calls, premake.vstudio.vc2010.programDatabaseFileName)

	end

	return calls

end)

function pchgroup(...)
	--default src dir: wks.location\src\
	--default int dir: wks.location\build\obj\plat_config
	local arg={...}
	local n = 0

	local pchname = "sharedpch"
	local pchfilename = "stdafx"

	local ms_pchsrcdir = "$(SolutionDir)\\src\\$(ProjectName)\\"
	local ms_pchtargetdir = "$(SolutionDir)\\build\\bin\\$(ProjectName)\\$(Configuration)-$(PlatformShortName)\\"
	local ms_pchobjdir = "$(SolutionDir)\\build\\obj\\$(ProjectName)\\$(Configuration)-$(PlatformShortName)\\"


	if #arg > 2 then

		n = 2

		pchname = arg[1]

	end

	if #arg > 3 then

		n = 3

		pchsrcdir = arg[2]

	end

	if #arg > 4 then

		n = 4

		pchobjdir = arg[3]

	end

	--create staticlib
	project (pchname)
		kind "StaticLib"
		location (ms_pchsrcdir)
		targetdir(ms_pchtargetdir)
		objdir(ms_pchobjdir)

		files
		{
			(ms_pchsrcdir .. "/**.h"),
			(ms_pchsrcdir .. "/**.hpp"),
			(ms_pchsrcdir .. "/**.cpp")
		}

		pchheader (pchfilename .. ".h")
		pchsource ("$(SharedPch)")

	prjlist = {}
	index = 1

	for i = n, #arg do
		prjlist[index] = arg[i]
		index = index + 1
	end

	table.insert(prjlist, pchname)

	for i = 1, #prjlist do
		print(prjlist[i])
	end

	--apply compat props to projects down a list
	--do so by creating a list of projects and then add the pchname to the list


	for i = 1, #prjlist do
		project (prjlist[i])
			---[[
			usermacros
			{
				SharedPch=(ms_pchtargetdir),
				SharedPdb=(ms_pchobjdir),
				SharedIdb=(ms_pchsrcdir)
			}
			--]]

		project "*"
		--usermacros
		--pdbfile
		--custombuilstep

			--command
			--output
		--custombuildbeforestep
		--project (v)
		--project (arg[i])



	end
end
