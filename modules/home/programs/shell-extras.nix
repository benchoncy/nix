{ pkgs, ... }: {
  home.file.".zsh/zsh-autosuggestions" = {
    source = "${pkgs.zsh-autosuggestions}/share/zsh/plugins/zsh-autosuggestions";
    recursive = true;
  };
}
