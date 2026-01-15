# .dotfiles

**from vanilla system to infinity and beyond in no time**

- macOS: install and run Xcode, then start Terminal app and follow instructions below
- Linux / WSL: change shell to zsh -> `chsh -s $(which zsh)`, then follow instructions below

> feel free to fork and customize for yourself

## Step 1 [ready]

- Clone this repo into your home directory

	``` sh
	cd && git clone https://github.com/tadija/.dotfiles.git
	```

- Run [the setup script](system/setup.sh) to make [the shell file](.shell) and setup `dot_files` defined in [the config file](custom/config.sh)

	``` sh
	. ~/.dotfiles/system/setup.sh deploy
	```
	> replace `deploy` with `destroy` to uninstall
	
- Play some music while doing all of this? (optional)

	``` sh
	my-radio
	```

## Step 2 [set]

- Configure and save [the config file](custom/config.sh)

	``` sh
	df-edit config
	```

- Reload shell

	``` sh
	df-reload
	```

- Configure global git user (optional)

	``` sh
	df-git my --global
	```

## Step 3 [go]

- Configure and save [the install file](custom/install.sh)

	``` sh
	df-edit install
	```

- Install all the things

	``` sh
	df-install
	```
	
- Reload shell

	``` sh
	df-reload
	```

boom! that's it!

---

`done for fun`

