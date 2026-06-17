{
  description = "Weston example/demo Wayland clients";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ]; # weston is Linux-only
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f (
            import nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
            }
          )
        );
    in
    {
      overlays.default = import ./overlay.nix;

      packages = forAllSystems (pkgs: {
        default = pkgs.weston-demos;
        weston-demos = pkgs.weston-demos;
      });

      apps = forAllSystems (
        pkgs:
        builtins.listToAttrs (
          map (n: {
            name = n;
            value = {
              type = "app";
              program = "${pkgs.weston-demos}/bin/${n}";
            };
          }) pkgs.weston-demos.clientNames
        )
      );
    };
}
