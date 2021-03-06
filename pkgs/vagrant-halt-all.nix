{ writeShellScriptBin }:
writeShellScriptBin "vagrant-halt-all" ''

boxes=$(vagrant global-status | sed -n -e '3,/^ $/p' | grep running)

regular=$(echo "''${boxes}" | grep -v devops | cut -d' ' -f1 | xargs)
devops=$(echo "''${boxes}" | grep devops | cut -d' ' -f1)

vagrant halt ''${regular}
vagrant halt ''${devops}
''
