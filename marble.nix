{
  marble-src ? null,
  lib,
  stdenv,
  desktop-file-utils,
  fetchFromGitLab,
  gobject-introspection,
  gtk3,
  gtk4,
  meson,
  ninja,
  pkg-config,
  vala
}:
stdenv.mkDerivation {
  pname = "marble";
  version = "master";
  src = if marble-src != null then marble-src else fetchFromGitLab {
    domain = "gitlab.com";
    owner = "raggesilver";
    repo = "marble";
    rev = "6dcc6fefa35f0151b0549c01bd774750fe6bdef8";
    sha256 = "sha256-0VJ9nyjWOOdLBm3ufleS/xcAS5YsSedJ2NtBjyM3uaY=";
  };
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];
  buildInputs = [
    desktop-file-utils
    gobject-introspection
    gtk3
    gtk4
  ];
  meta = {
    description = ''Paulo Queiroz's personal GTK 4 library.'';
    homepage = "https://gitlab.com/raggesilver/marble";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
