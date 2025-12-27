inputs: final: prev: {
  keylock = prev.stdenv.mkDerivation {
    pname = "keylock";
    version = "0.1";

    src = inputs.keylock-src;

    buildInputs = with prev; [
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

  vimPlugins = prev.vimPlugins // {
    space-vim-dark = prev.vimUtils.buildVimPlugin {
      name = "space-vim-dark";

      src = inputs.space-vim-dark-src;
    };
  };

  nix = prev.nix.overrideAttrs (old: {
    doCheck = false;
    doInstallCheck = false;
  });
}