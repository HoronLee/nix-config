{ pkgs }:
pkgs.writeShellApplication {
  name = "magpie-install";
  runtimeInputs =
    with pkgs;
    [
      curl
      jq
      coreutils
      gnugrep
      gnused
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      desktop-file-utils
      xdg-utils
    ];
  text = ''
    if (( $# != 0 )); then
      echo "Usage: magpie-install" >&2
      exit 2
    fi

    binary="$HOME/.local/bin/magpie"
    curl_args=(-fsSL --max-time 30)
    if [[ -n "''${MAGPIE_PROXY:-}" ]]; then
      curl_args+=(--proxy "$MAGPIE_PROXY")
    fi

    latest=$(curl "''${curl_args[@]}" https://usemagpie.ai/api/latest | jq -er '.version')
    if [[ ! "$latest" =~ ^[0-9]+([.][0-9]+){2}$ ]]; then
      echo "Invalid Magpie release version: $latest" >&2
      exit 1
    fi

    # macOS 的命令链接指向可更新的原生应用，Nix store 中的副本需要替换。
    if [[ -x "$binary" && -w "$binary" && "$(readlink -f -- "$binary")" != /nix/store/* ]]; then
      if ! version_output=$("$binary" --version); then
        echo "Cannot read the installed Magpie version; on NixOS check that nix-ld is active." >&2
        exit 1
      fi
      if [[ ! "$version_output" =~ [0-9]+([.][0-9]+){2} ]]; then
        echo "Invalid installed Magpie version: $version_output" >&2
        exit 1
      fi
      current="''${BASH_REMATCH[0]}"
      if printf '%s\n%s\n' "$latest" "$current" | sort -V -C; then
        printf 'Magpie %s is current; keeping %s.\n' "$current" "$binary"
        exit 0
      fi
    fi

    tmpdir=$(mktemp -d)
    trap 'rm -rf -- "$tmpdir"' EXIT
    curl "''${curl_args[@]}" -o "$tmpdir/install.sh" https://usemagpie.ai/install.sh
    export MAGPIE_BIN_DIR="$HOME/.local/bin"
    ${pkgs.runtimeShell} "$tmpdir/install.sh" --gui
  '';
}
