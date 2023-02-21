# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  proton-ge = {
    pname = "proton-ge";
    version = "GE-Proton7-49";
    src = fetchurl {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton7-49/GE-Proton7-49.tar.gz";
      sha256 = "sha256-T+7R+zFMd0yQ0v7/WGym2kzMMulUmATS/LCEQS8whiw=";
    };
  };
  warcraftlogs = {
    pname = "warcraftlogs";
    version = "6.0.1";
    src = fetchurl {
      url = "https://github.com/RPGLogs/Uploaders-warcraftlogs/releases/download/v6.0.1/Warcraft-Logs-Uploader-6.0.1.AppImage";
      sha256 = "sha256-FmPqXyAo3zRO1UppxYe8YG7MG+Uli+TVr9y8IeGAoVQ=";
    };
  };
}
