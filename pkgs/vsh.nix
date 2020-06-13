{ writeShellScriptBin, vagrant }:
writeShellScriptBin "vsh" ''
set -- ''${1:-default}

if [ ! -f '.ssh-config' ]; then
    ${vagrant}/bin/vagrant ssh-config > .ssh-config
fi

if ! grep -s "Host ''${1}$" .ssh-config >/dev/null; then
    ${vagrant}/bin/vagrant ssh-config "''${1}" >> .ssh-config
fi

ssh -F .ssh-config "$@"
''
