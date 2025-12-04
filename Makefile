check:
	nix flake check

nixos-rebuild:
	sudo nixos-rebuild switch --flake .

darwin-rebuild:
	sudo darwin-rebuild switch --flake .

home-manager:
	home-manager switch --flake .
