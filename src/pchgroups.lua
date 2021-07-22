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

function isPath(str)
	if str and #str > 0 then
		for i = 1, #str do
			if str[i] == '/' or str[i] == '\\' then
				return true 
			end
		end
	end
	return false
end

function pchgroup(prjgroup, ...)

	slndir = path.translate(_MAIN_SCRIPT_DIR)
	keydir = "$(Configuration)-$(Platform)\\"

	pchprjname   = "sharedpch"
	pchfilename  = "stdafx.h"
	pchsrcdir    = (slndir.. "\\src\\sharedpch\\") --%{prj.name}\\")
	pchtargetdir = (slndir.. "\\build\\bin\\$(ProjectName)\\" .. keydir)
	pchobjdir    = (slndir.. "\\build\\obj\\$(ProjectName)\\" .. keydir)

	arg={...}
	--arg[2]
	--arg[3]
	--arg[4]
	--arg[5]
	--arg[6]

	
	if #arg > 2 and not isPath(arg[1]) then
		pchprjname = arg[1]
	end

	if #arg > 3 and isPath(arg[2]) then
		pchsrcdir = (slndir .. "\\" .. path.translate(arg[2]))
	end

	if #arg > 4 and isPath(arg[3]) then
		pchobjdir = (slndir .. "\\" .. path.translate(arg[3]))
	end

	project (pchprjname)
		kind      "StaticLib"
		location  (pchsrcdir)
		targetdir (pchtargetdir)
		objdir    (pchobjdir)

		files
		{
			(pchsrcdir .. "/**.h"),
			(pchsrcdir .. "/**.hpp"),
			(pchsrcdir .. "/**.cpp")
		}

		pchheader (pchfilename)
		pchsource ("$(SharedPch)")
	project "*"

	prjgroup = {}

	for i = 1, #arg do
		local val = arg[#arg + 1 - i]

		if not isPath(val) and val ~= pchprjname then
			prjgroup[i] = val
		
		else
			break
		end
	end

	--reserve adding the pchprj to do so explicitly as follows:
	table.insert(prjgroup, pchprjname)

	for i = 1, #prjgroup do
		print(prjgroup[i])
	end

	--apply compat props to projects down a list
	--do so by creating a list of projects and then add the pchname to the list


	for i = 1, #prjgroup do
		project (prjgroup[i])
			---[[
			usermacros
			{
				SharedPch=(pchtargetdir),
				SharedPdb=(pchobjdir),
				SharedIdb=(pchsrcdir)
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

	ok, err = os.touchfile(pchsrcdir .. pchfilename)

	print(ok, err)
end
