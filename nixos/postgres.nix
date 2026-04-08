{pkgs, ...}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
    ensureUsers = [
      {
        name = "maix";
        ensureClauses.superuser = true;
      }
    ];
  };
}
