with import <nixpkgs> {};
mkShell {
  buildInputs = [
	(python3.withPackages (ps: with ps; [
	pydicom
	python38Packages.matplotlib
	numpy
	python38Packages.pillow
	pandas
	python38Packages.opencv4
	]))
    nano
    emacs
    git
  ];
}
