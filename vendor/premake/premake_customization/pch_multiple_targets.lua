require('vstudio')

--Default: 1 pch targeting 1 or more projects
--Multi:   2 or more pchs targeting 1 or more projects each

premake.api.register {

	name = "pchtar",

	scope = "",

	kind = "string",

	allowed = {
		"Default",
		"Multi"
	}
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