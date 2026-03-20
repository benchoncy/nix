check:
	nix flake check

update:
	nix flake update shared nixpkgs

update-shared:
	nix flake update shared

update-nixpkgs:
	nix flake update nixpkgs

darwin-rebuild:
	sudo darwin-rebuild switch --flake .#<work-host-name>

home-manager:
	home-manager switch --flake .#<work-host-name>-home
