{
  inputs,
  lib,
  ...
}: {
  flake.lib = {
    containsModule = name: attr: (builtins.hasAttr name attr);
    optionalModule = name: attr:
      lib.optionals
      (inputs.self.lib.containsModule name attr)
      [attr.${name}];
  };
}
