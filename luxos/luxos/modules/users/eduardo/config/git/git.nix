{ ... }:

{
  programs.git = {
    enable = true;
    config = {
      user.name = "Eduardo Função";
      user.email = "eduardofuncao@hotmail.com";
      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = true;
    };
  };
}
