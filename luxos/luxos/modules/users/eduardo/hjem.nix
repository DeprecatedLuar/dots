{ inputs, ... }:

{
  flake-file.inputs.hjem = {
    url = "github:feel-co/hjem";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [ inputs.hjem.nixosModules.default ];

  hjem.users.eduardo = {
    user = "eduardo";
    directory = "/home/eduardo";
    files = {
      ".config/kitty/kitty.conf".source = ./config/kitty/kitty.conf;
      ".config/tmux/tmux.conf".source = ./config/tmux/tmux.conf;
      ".config/noctalia-shell/config.json".source = ./config/noctalia/noctalia.json;
      ".config/niri/config.kdl".source = ./config/niri/config.kdl;
      ".config/nvim/init.lua".source = ./config/nvim/init.lua;
      ".config/nvim/lua/plugins.lua".source = ./config/nvim/lua/plugins.lua;
      ".config/nvim/lua/todo.lua".source = ./config/nvim/lua/todo.lua;
      ".config/nvim/lua/git_config.lua".source = ./config/nvim/lua/git_config.lua;
      ".config/nvim/lua/treesitter.lua".source = ./config/nvim/lua/treesitter.lua;
      ".config/nvim/lua/debugconfig.lua".source = ./config/nvim/lua/debugconfig.lua;
      ".config/nvim/lua/oil_config.lua".source = ./config/nvim/lua/oil_config.lua;
      ".config/nvim/lua/lsp.lua".source = ./config/nvim/lua/lsp.lua;
      ".config/nvim/lua/image.lua".source = ./config/nvim/lua/image.lua;
      ".config/nvim/syntax/advpl.vim".source = ./config/nvim/syntax/advpl.vim;
      ".config/nvim/nvim-pack-lock.json".source = ./config/nvim/nvim-pack-lock.json;
    };
  };
}
