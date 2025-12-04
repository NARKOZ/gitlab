# CLI

> [!IMPORTANT]
> You need to set [environment variables](./configuration#environment-variables) before using CLI.

## Commands

Send gitlab methods as commands, and parameters as arguments to `gitlab` command
line utility

```sh
gitlab users
```

```sh
gitlab user
```

```sh
gitlab user 2
```

## Filter

You can filter output by supplying `--only` or `--except` flags

```sh
gitlab user --only=id,email,name
```

```sh
gitlab users --except=id,email,name
```

> [!WARNING]
> Before executing destructive commands you will be prompted to confirm them.

## Additional commands

`help` lists all available actions

`shell` runs shell to perform commands

`info` gives information about environment

`-v` or `--version` shows gem version

## Shell

You can perform commands in interactive `gitlab` shell by running `gitlab shell`

```sh
gitlab shell

# list available commands
gitlab> help

# list groups
gitlab> groups

# protect a branch
gitlab> protect_branch 1 master

# quit shell
gitlab> exit
```

You can hit <kbd>tab</kbd> for command completion.
