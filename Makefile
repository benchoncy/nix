check:
	nix flake check

update:
	nix flake update --flake .

nixos-rebuild:
	sudo nixos-rebuild switch --flake .#nixos-bstuart

darwin-rebuild:
	sudo darwin-rebuild switch --impure --flake "path:$(CURDIR)#bstuart-mbp-m1pro"

home-manager:
	home-manager switch --flake .

home-manager-personal:
	home-manager switch --flake .#nixos-bstuart-home

home-manager-work:
	home-manager switch --impure --flake "path:$(CURDIR)#bstuart-mbp-m1pro-home"
