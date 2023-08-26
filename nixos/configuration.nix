# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  nixpkgs.config = {
    permittedInsecurePackages = [
      "electron-13.6.9"
      "nodejs-14.21.3"
      "openssl-1.1.1u"
      "openssl-1.1.1v"
    ];
  };
}
// {
  nixpkgs.config.permittedInsecurePackages = [
    "electron-13.6.9"
    "nodejs-14.21.3"
    "openssl-1.1.1u"
    "openssl-1.1.1v"
  ];
}
