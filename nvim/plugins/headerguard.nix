{
  inputs,
  lib,
  ...
}: let
  moduleName = "headerguard";
in {
  flake.modules.nixvim.${moduleName} = {
    pkgs,
    config,
    ...
  }:
    with lib; {
      options.plugins.${moduleName} = {
        enable = mkEnableOption "Enable headerguard";
        useCppComment = mkEnableOption "Use c++-style comments instead of c-style";
      };

      config = let
        cfg = config.plugins.${moduleName};
      in
        mkIf cfg.enable {
          extraPlugins = [
            (
              pkgs.vimUtils.buildVimPlugin rec {
                pname = "vim-headerguard";
                src = pkgs.fetchFromGitHub {
                  owner = "drmikehenry";
                  repo = pname;
                  hash = "sha256-asziFy3Dag8bV7Ptw5G46JQVzyrkJiQkaNqdjz72jwY=";
                  rev = version;
                };
                version = "8987a70ad416414ce5c570842c392111abd10555";
              }
            )
          ];

          globals.headerguard_use_cpp_comments = cfg.useCppComment;
        };
    };
}
