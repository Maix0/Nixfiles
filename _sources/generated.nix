# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  proton-ge = {
    pname = "proton-ge";
    version = "GE-Proton7-29";
    src = fetchurl {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton7-29/GE-Proton7-29.tar.gz";
      sha256 = "sha256-bmi3l8FXpoIdBAp8HisXJ1awNxNFzK+XiVwhBN/jOUY=";
    };
  };
}