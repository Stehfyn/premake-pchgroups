require ('vstudio')

premake.api.register {

    name = "importprops",

    scope = "config",

    kind = "list:path",

    tokens = true
}

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
