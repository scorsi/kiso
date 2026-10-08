# What a consuming flake imports (`imports = [ inputs.kiso.flakeModules.default ];`): kiso's options
# (`kiso.*`) and features (`flake.modules.<class>.<name>`), next to its own. The features are closed
# over kiso's inputs (`kisoInputs`), which the consumer makes follow its own to keep one version of
# each.
kisoInputs: {
  imports = [
    kisoInputs.flake-parts.flakeModules.modules
    (kisoInputs.import-tree ./modules)
  ];
  _module.args = { inherit kisoInputs; };
}
