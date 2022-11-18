with import <nixpkgs> {};
mkShell {
    buildInputs = [
        erlang
        shellcheck
    ];
    shellHook = ''
        . .shellhook
    '';
}
