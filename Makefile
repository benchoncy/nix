check:
	nix flake check

update:
	nix flake update --flake .

nixos-rebuild:
	sudo nixos-rebuild switch --flake .

darwin-rebuild:
	sudo darwin-rebuild switch --flake .

home-manager:
	home-manager switch --flake .
