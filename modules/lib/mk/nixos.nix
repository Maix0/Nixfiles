{
  inputs,
  lib,
  ...
}: {
  # To add a nixos system config:
  # flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "<name>";
  config.flake.lib.mkNixos = system: name: {
    ${name} = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        inputs.self.modules.nixos.${name}
        {
          nixpkgs.hostPlatform = lib.mkDefault system;
          networking.hostName = lib.mkDefault "${name}";
        }
      ];
    };
  };
}
