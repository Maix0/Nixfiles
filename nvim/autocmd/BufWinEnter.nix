{
  inputs,
  lib,
  ...
}: let
  moduleName = "bufWinEnter";
in {
  flake.modules.nixvim.${moduleName} = {
    pkgs,
    config,
    lib,
    ...
  }: {
    autoCmd = [
      {
        event = "BufWinEnter";
        pattern = "*";
        command = "call matchadd('BreakspaceChar', ' ')";
      }
      {
        event = "BufWinEnter";
        pattern = "*";
        command = "highlight BreakspaceChar ctermbg=red guibg=#f92672";
      }
    ];
  };
}
