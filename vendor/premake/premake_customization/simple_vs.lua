require('vstudio')

premake.api.register {

    name = "pchsourcedir",

    scope = "project",

    kind = "path",

    tokens = true
}

local function hello(prj)
	print("hello")
end

premake.override(premake.vstudio.vc2010, "project", function(base, prj)
	local calls = base(prj)
	table.insertafter(calls, premake.vstudio.vc2010.xmlDeclaration, hello)
	return calls
end)