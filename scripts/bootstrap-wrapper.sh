#!/bin/sh

set -u

shared_repo_url=${SHARED_REPO_URL:-https://github.com/benchoncy/nix.git}
if [ "$#" -eq 0 ]; then
    if [ -z "${HOME:-}" ]; then
        printf '%s\n' 'error: HOME is not set; provide a destination argument' >&2
        exit 2
    fi
    destination=$HOME/.nix-config
else
    destination=$1
fi

if [ "$#" -gt 1 ]; then
    printf '%s\n' "error: expected at most one destination argument" >&2
    exit 2
fi

if [ -z "$destination" ]; then
    printf '%s\n' 'error: HOME is not set; provide a destination argument' >&2
    exit 2
fi

if ! command -v git >/dev/null 2>&1; then
    printf '%s\n' 'error: git is required but was not found' >&2
    exit 1
fi

is_empty_directory() {
    for entry in "$1"/* "$1"/.[!.]* "$1"/..?*; do
        if [ -e "$entry" ] || [ -L "$entry" ]; then
            return 1
        fi
    done
    return 0
}

created_destination=0
temporary_directory=
completed=0

cleanup() {
    if [ -n "$temporary_directory" ]; then
        rm -rf "$temporary_directory"
    fi
    if [ "$created_destination" -eq 1 ] && [ "$completed" -eq 0 ]; then
        rm -rf "$destination"
    fi
}

trap cleanup 0 1 2 3 15

if [ -e "$destination" ] || [ -L "$destination" ]; then
    if [ ! -d "$destination" ]; then
        printf '%s\n' "error: destination is not a directory: $destination" >&2
        exit 1
    fi
    if ! is_empty_directory "$destination"; then
        printf '%s\n' "error: destination is not empty: $destination" >&2
        exit 1
    fi
else
    if ! mkdir -p "$destination"; then
        printf '%s\n' "error: could not create destination: $destination" >&2
        exit 1
    fi
    created_destination=1
fi

temporary_directory=$(mktemp -d "${TMPDIR:-/tmp}/bootstrap-wrapper.XXXXXX") || {
    printf '%s\n' 'error: could not create a temporary directory' >&2
    exit 1
}

printf '%s\n' "Cloning shared configuration..."
if ! git clone "$shared_repo_url" "$temporary_directory/shared"; then
    printf '%s\n' 'error: could not clone the shared repository' >&2
    exit 1
fi

if ! cp -R "$temporary_directory/shared/examples/work-overlay-mvp/." "$destination/"; then
    printf '%s\n' 'error: could not copy the work overlay example' >&2
    exit 1
fi

if ! git -C "$destination" init >/dev/null 2>&1; then
    printf '%s\n' 'error: could not initialize the destination git repository' >&2
    exit 1
fi

printf '%s\n' 'Adding shared repository as a submodule...'
if ! git -C "$destination" submodule add "$shared_repo_url" shared >/dev/null 2>&1; then
    printf '%s\n' 'error: could not add shared as a git submodule' >&2
    exit 1
fi

if ! git -C "$destination" add .; then
    printf '%s\n' 'error: could not stage the generated wrapper' >&2
    exit 1
fi

completed=1
printf '\n%s\n' "Wrapper created at $destination"
printf '%s\n' "Next steps:"
printf '%s\n' "  cd $destination"
printf '%s\n' '  review the staged example and commit the initial wrapper'
