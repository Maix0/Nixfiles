{
  inputs,
  lib,
  ...
}: {
  # To add a standalone home-manager output:
  # flake.homeConfigurations = inputs.self.lib.mkHomeManager "x86_64-linux" "<name>";
  config.flake.lib.mkHomeManager = system: name: {
    "hc-${name}" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = [
        inputs.self.modules.homeManager."hm-${name}"
        {nixpkgs.config.allowUnfree = true;}
      ];
    };
  };
}
