# dotfiles
Dotfiles for my linux box! If you stumble upon this repo, feel free to take and use these as you please!

This was created to work on my Ubuntu 15.04 install. Please open an issue or a pull request with installation help for Arch users or other distros

## Included configs/Dependencies
Config files for the following applications in this repo:
  * [i3-gaps](https://github.com/Airblader/i3) - Window Manager
    - Not in Ubuntu repos (at least not an up-to-date version)
    - Dunst for notifications (included with i3)
  * [Lemonbar](https://github.com/krypt-n/bar) - Status bar
    - Not in Ubuntu repos
    - This is a fork that supports fontconfig (ie fontawesome)
    - Requires [Fontawesome](https://github.com/FortAwesome/Font-Awesome) fonts for icons
    - Uses [conky](https://github.com/brndnmtthws/conky) for system stats
  * [compton](https://github.com/chjj/compton) - Compositing Manager (for transparency and such)
  * [rofi](https://github.com/DaveDavenport/rofi) - Application Launcher
  * (g)vim - Text editor
    - Uses [Vundle](https://github.com/VundleVim/Vundle.vim) for plugin management
  * [zsh](http://www.zsh.org/) - shell
    - [Oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
  * [powerline](https://github.com/powerline/powerline) - statusline (for zsh)
    - [powerline-gitstatus](https://github.com/jaspernbrouwer/powerline-gitstatus) - Git segment for Powerline
  

        sudo apt-get install zsh compton vim-gtk conky powerline
        pip install powerline-gitstatus

Installation for each package can be found in the standard Ubuntu repositories or their respective git repos (links are included).
In order to actually use the config files, you'll have to create symlinks to your clone of this repo. 

## Installation
This repo was intended to be cloned into your home folder (many file paths are hard coded)
  ```
  cd ~
  git clone https://github.com/alexmcnurlin/dotfiles.git .dotfiles
  ```

### Setup

The following commands will (should) move each config file into .dotfiles/back and create a symlink to the config file in this repo.
***Note***: I haven't actually run these commands to test them. If they don't work,
please make a pull request with a fix or open an issue!

        # Create backup directory
        mkdir ~/.dotfiles/back/

        # i3 config files
        mv -r ~/.i3/ ~/.dotfiles/back/
        mv -r ~/.config/dunst/dunstrc ~/.dotfiles/back/
        ln -s ~/.dotfiles/i3/ ~/.i3/
        ln -s ~/.dotfiles/dunst/dunstrc ~/.i3/

        # Compton config
        mv ~/.compton.conf ~/.dotfiles/back/
        ln -s ~/.dotfiles/.compton.conf ~/.compton.conf
        
        # Zsh
        mv ~/.zshrc ~/.dotfiles/back/
        ln -s ~/.dotfiles/shell/.zshrc ~/.zshrc

        # Dunst (i3 notification daemon)
        mv -r ~/.config/dunst/ ~/.dotfiles/back/
        ln -s ~/.dotfiles/dunst/ ~/.config/dunst/

        # Vim
        mv ~/.vimrc ~/.vimrc.local ~/.vimrc.bundles.local ~/.dotfiles/back/
        ln -s ~/.dotfiles/vim/.vimrc
        ln -s ~/.dotfiles/vim/.vimrc.local
        ln -s ~/.dotfiles/vim/.vimrc.bundles.local
        # You'll need to run :PluginInstall in vim to download and install plugins

If you are trying to install this onto your local setup, let me know what can be done to make this easier. 


## Customization
  Color settings for i3, Lemonbar, and Dunst are all 

TODO: 
  * Add links and install commands for the different packages. 
  * Create a simple setup than a mess of symlinks
