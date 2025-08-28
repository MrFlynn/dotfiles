let
  swift-flake-rev = "c26f560b73ca34b32aa7b6462a9973a13e3b2da9";

in
self: super: {
  keylock = super.stdenv.mkDerivation {
    pname = "keylock";
    version = "0.1";

    src = super.fetchFromGitHub {
      owner = "kfv";
      repo = "keylock";
      rev = "d808c1651d65c3159a8902481e8c75c8aa5c807f";
      sha256 = "0f3dcj7h8k22mcf4q85mmwp41pcsi6p614jfvczz1gkj4zdclj01";
    };

    buildInputs = with super; [
      gnumake
      (
        builtins.getFlake "git+https://github.com/timothyklim/swift-flake?rev=${swift-flake-rev}"
      ).packages.${super.system}.default
    ];

    installPhase = ''
      make install PREFIX=$out
    '';

    meta = {
      description = "macOS utility to lock input devices for easy cleaning.";
      homepage = "https://github.com/kfv/keylock";
    };
  };

  vimPlugins = super.vimPlugins // {
    space-vim-dark = super.vimUtils.buildVimPlugin {
      name = "space-vim-dark";

      src = super.fetchFromGitHub {
        owner = "liuchengxu";
        repo = "space-vim-dark";
        rev = "0ab698bd2a3959e3bed7691ac55ba4d8abefd143";
        sha256 = "0h1adjk9hnknhmgzw1vdfa1gslpx7an8p0ghd0qknnirlygcz9qr";
      };
    };
  };
}

