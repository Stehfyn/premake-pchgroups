require ('vstudio')

premake.api.register {

    name = "usermacros",

    scope = "config",

    kind = "list:table",

    tokens = true
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