NIXOS_HOST ?= nixos-bstuart
HOME_HOST ?= nixos-bstuart-home

check:
	nix flake check

update:
	nix flake update --flake .

nixos-rebuild:
	sudo nixos-rebuild switch --flake .#$(NIXOS_HOST)

home-manager:
	home-manager switch --flake .#$(HOME_HOST)
