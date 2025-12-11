inputs: self: super: {
  keylock = super.stdenv.mkDerivation {
    pname = "keylock";
    version = "0.1";

    src = inputs.keylock-src;

    buildInputs = with super; [
      cacert
      swift
      swiftpm
    ];

    installPhase = ''
      swift build -c release
      mkdir -p "$out/bin"
      cp -f .build/release/keylock "$out/bin/keylock"
    '';

    meta = {
      description = "macOS utility to lock input devices for easy cleaning.";
      homepage = "https://github.com/kfv/keylock";
    };
  };

  vimPlugins = super.vimPlugins // {
    space-vim-dark = super.vimUtils.buildVimPlugin {
      name = "space-vim-dark";

      src = inputs.space-vim-dark-src;
    };
  };
}
