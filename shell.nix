let
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  buildInputs = [
    pkgs.nano
    pkgs.tree
    pkgs.findutils
    pkgs.rsync
    pkgs.imagemagick
    pkgs.detox
  ];
}
