# dotfiles
Dotfiles for my linux box! If you stumble upon this repo, feel free to take and use these as you please!

## Installation
If you are trying to install this onto your local setup, let me know what can be done to make this easier. 

`git clone https://github.com/alexmcnurlin/dotfiles`

Config files for the following applications in this repo:
  * i3        - Window manager
  * compton   - Compositing Manager
  * rofi      - Launcher
  * gvim      - Text editor
  * zsh       - shell
  * powerline - statusline (for zsh)
  
Installation for each package can be found in the standard Ubuntu repositories 
or their respective git repos. Some programs (like zsh) must be configured before 
being useful. Unfortunately, right now, most of the config files will need to 
be symlinked from their default location to the git repo in order to work.  
Likewise, you will have to delete the contents of the files/directories that 
are already there. Please back up those files somehow before deleting them.

        rm -rf ~/.i3/
        ln -s ~/.dotfiles/i3/ ~/.i3/

        rm ~/.compton.conf
        ln -s ~/.dotfiles/.compton.conf ~/.compton.conf
        
        rm ~/.zshrc
        ln -s ~/.dotfiles/shell/.zshrc ~/.zshrc

        rm -rf ~/.config/dunst/
        ln -s ~/.dotfiles/dunst/ ~/.config/dunst/

        rm ~/.vimrc ~/.vimrc.local ~/.vimrc.bundles.local
        ln -s ~/.dotfiles/vim/.vimrc
        ln -s ~/.dotfiles/vim/.vimrc.local
        ln -s ~/.dotfiles/vim/.vimrc.bundles.local

I don't have powerline set up in a way that's easy to configure :( I'll work on that in a later commit.

TODO: 
  * Add links and install commands for the different packages. 
  * Create a simple setup instead of a mess of symlinks
