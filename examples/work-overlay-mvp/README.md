# Work Overlay MVP

This is a generic example of the minimum private work overlay expected by the main flake.

Suggested layout:

- `modules/home/default.nix`
- `home-files/work/.aws/config`
- `home-files/work/.config/shell/tools/work-ticket.sh`

Customize these placeholders before using it:

- `<work-email>`
- `<work-git-host>`
- the AWS profiles in `home-files/work/.aws/config`
- any ticketing CLI commands in `work-ticket.sh`

The host machine should set:

- `my.work.enable = true`
- `my.work.repoPath = "/absolute/path/to/your/private/work/repo"`
