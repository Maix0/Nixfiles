{
  inputs,
  lib,
  ...
}: {
  # To add a nixos system config:
  # flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "<name>";
  config.flake.lib.mkNixos = system: name: {
    ${name} = inputs.nixpkgs.lib.nixosSystem {
      modules =
        [
          inputs.self.modules.nixos."lib-system"
          inputs.self.modules.nixos."host-${name}"
          {
            nixpkgs = {
              config.allowUnfree = true;
              hostPlatform = lib.mkDefault system;
            };
            networking.hostName = lib.mkDefault "${name}";
          }
        ]
        ++ (
          lib.optionals
          (builtins.hasAttr "host-${name}-hw" inputs.self.modules.nixos)
          [inputs.self.modules.nixos."host-${name}-hw"]
        );
    };
  };
}
