{
  callPackage,
  sources,
  naersk,
}: rec {
  simulationcraft = callPackage ./simulationcraft.nix {simulationcraft-src = sources.simulationcraft;};
  hbw = callPackage ./hbw {};
  kabalist_cli = callPackage ./kabalist.nix {
    inherit naersk;
    kabalist-src = sources.kabalist;
  };
  frg = callPackage ./frg.nix {};
  lemminx-bin = callPackage ./lemminx-bin.nix {};
  bonnie = callPackage ./bonnie {};
  perseus-cli = callPackage ./perseus {inherit bonnie;};
}
