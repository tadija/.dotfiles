# .dotfiles

**From vanilla to personalized macOS in less then 30 minutes**

> If this can help you too, then great, feel free to customize it and use for your own needs.

Install and run Xcode then start Terminal app and follow instructions:

## Step 1 [get ready]

- Clone this repo into your home directory

	``` sh
	$ git clone https://github.com/tadija/.dotfiles.git ~/.dotfiles
	```

- Run this [setup script](system/setup.sh) which will make your new [.shell_file](.shell_file)

	``` sh
	$ . ~/.dotfiles/system/setup.sh
	```
	
- Play some music while doing all of this? (optional)

	``` sh
	$ my-radio
	```

- Configure [AE theme](themes/AE.terminal) for Terminal? (optional)

	``` sh
	$ df-terminal AE
	```
	
	*after this step run `rm ~/.zcompdump` and restart Terminal in order to fix the error:*
	`compinit:482: bad math expression: operand expected at end of string`

## Step 2 [set]

- Configure and save [your config file](custom/config.sh)

	``` sh
	$ df-edit config
	```

- Reload shell

	``` sh
	$ df-reload
	```

- Configure global git user (optional)

	``` sh
	$ git-user my --global
	```

## Step 3 [go]

- Install / Update / Upgrade [Homebrew](http://brew.sh)

	``` sh
	$ df-homebrew
	```

- Install all the things from [your config file](custom/config.sh)

	``` sh
	$ df-install
	```
	
- Reload shell

	``` sh
	$ df-reload
	```

---

`done for fun`
