require ('vstudio')

premake.extensions.pchgroups = true


premake.api.register {

    name = "usermacros",

    scope = "config",

    kind = "list:table",

    tokens = true
}

premake.api.register {

    name = "importprops",

    scope = "config",

    kind = "list:path",

    tokens = true
}

premake.api.register {

	name = "pdbfile",

	scope = "config",

	kind = "path",

	tokens = true
}

premake.api.register {

	name = "custombuildstepbefore",

	scope = "config",

	kind  = "string",

	tokens = true
}
