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
    system = "x86_64-linux";
    overlays = [inputs.self.overlays.default];
    pkgs = import inputs.nixpkgs {inherit overlays system;};
  in {
    overlays = {
      blackbox = final: prev: {
        # Requires libadwaita 1.2, but nixpkgs doesn't have this yet.
        libadwaita = prev.libadwaita.overrideAttrs (old: rec {
          version = "1.2.beta";
          src = prev.fetchFromGitLab {
            domain = "gitlab.gnome.org";
            owner = "GNOME";
            repo = "libadwaita";
            rev = version;
            hash = "sha256-QBblkeNAgfHi5YQxaV9ceqNDyDIGu8d6pvLcT6apm6o=";
          };
        });
      };
      default = inputs.self.overlays.blackbox;
    };

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

    formatter.${system} = pkgs.alejandra;
  };
}
