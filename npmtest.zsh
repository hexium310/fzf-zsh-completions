#!/usr/bin/env zsh

() {
    pushd tests/_support/npm

    local package=${npm_directory-$(dirname -- $(npm root))}/package.json
    if [[ ! -f $package ]]; then
        return
    fi

    cat < <(node -e '
        process.stdout.write(
            Object.keys(
                JSON.parse(
                    require("fs").readFileSync(process.stdin.fd, "utf-8")
                ).scripts
            ).join("\0")
        )' < $package)
}
