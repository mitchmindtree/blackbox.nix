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
    vte-src = {
      url = "git+https://gitlab.gnome.org/gnome/vte?ref=master";
      flake = false;
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs: let
    out = system: let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in {
      packages.${system} = rec {
        vte-gtk4 = pkgs.callPackage ./vte-gtk4.nix {
          inherit (inputs) vte-src;
        };
        marble = pkgs.callPackage ./marble.nix {
          inherit (inputs) marble-src;
        };
        blackbox = pkgs.callPackage ./default.nix {
          inherit (inputs) blackbox-src;
          inherit marble vte-gtk4;
        };
        default = blackbox;
      };
    };
  in
    out "x86_64-linux";
}
