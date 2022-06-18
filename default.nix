{
  blackbox-src ? null,
  desktop-file-utils,
  lib,
  stdenv,
  cmake,
  fetchFromGitLab,
  gettext,
  gtk4,
  json-glib,
  libadwaita,
  librsvg,
  libsForQt5,
  marble,
  meson,
  ninja,
  pcre,
  pkg-config,
  qt5,
  python3,
  vala,
  #vte,
  vte-gtk4,
  wrapGAppsHook4,
}: stdenv.mkDerivation {
  pname = "blackbox";
  version = "main";
  src = if blackbox-src != null then blackbox-src else fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "raggesilver";
    repo = "blackbox";
    rev = "3c61b8fb2f55f93c0757081b39b3c6c0c22bc965";
    sha256 = "sha256-iVdwGW897vsqG/DXgewm5udnzlWFWF07T8f3lA45bVA=";
  };
  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';
  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    qt5.wrapQtAppsHook
    vala
    wrapGAppsHook4
  ];
  buildInputs = [
    cmake
    gettext
    gtk4
    libadwaita
    librsvg
    json-glib
    marble
    pcre
    vte-gtk4
  ];
  meta = {
    description = ''A beautiful and simple GTK 4 terminal.'';
    homepage = "https://gitlab.gnome.org/raggesilver/blackbox";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
