with import <nixpkgs> {};
mkShell.override { stdenv = llvmPackages_16.stdenv; } {
    buildInputs = [
        erlang
        shellcheck
    ];
    shellHook = ''
        . .shellhook
    '';
}
