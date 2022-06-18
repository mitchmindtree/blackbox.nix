{
  description = ''
    A nix flake for Paulo Queiroz' beautiful GTK 4 Terminal.
  '';

  inputs = {
    blackbox-src = {
      url = "git+https://gitlab.gnome.org/raggesilver/blackbox?ref=main";
      flake = false;
    };
    marble-src = {
      url = "git+https://gitlab.gnome.org/raggesilver/marble?ref=wip/gtk4";
      flake = false;
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # A fork of `nixos-unstable` with a patch for `vte` enabling gtk4 support.
    # Should remove this in favour of `nixpkgs` once gtk4 lands upstream.
    # See diff here:
    # https://github.com/NixOS/nixpkgs/compare/nixos-unstable...mitchmindtree:vte-master-gtk4?expand=1
    nixpkgs-vte-gtk4.url = "github:/mitchmindtree/nixpkgs/vte-master-gtk4";
  };

  outputs = inputs: let
    out = system: let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in {
      packages.${system} = rec {
        marble = pkgs.callPackage ./marble.nix {
          inherit (inputs) marble-src;
        };
        blackbox = pkgs.callPackage ./default.nix {
          inherit (inputs) blackbox-src;
          inherit marble;
          vte-gtk4 = inputs.nixpkgs-vte-gtk4.legacyPackages.${system}.vte;
        };
        default = blackbox;
      };
    };
  in
    out "x86_64-linux";
}
