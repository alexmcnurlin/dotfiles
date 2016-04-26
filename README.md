# dotfiles
Dotfiles for my linux box! If you stumble upon this repo, feel free to take and use these as you please!

## Included configs
Config files for the following applications in this repo:
  * [i3-gaps](https://github.com/Airblader/i3)   - Window Manager
    - Dunst for notifications (included with i3)
  * [Lemonbar](https://github.com/krypt-n/bar)   - Status bar
    - This is a fork that supports fontconfig (ie fontawesome)
    - Requires [Fontawesome](https://github.com/FortAwesome/Font-Awesome) for icons
  * [compton](https://github.com/chjj/compton)   - Compositing Manager (for transparency and such)
  * [rofi](https://github.com/DaveDavenport/rofi)      - Application Launcher
  * gvim      - Text editor
  * [zsh](http://www.zsh.org/)       - shell
    - [Oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
  * [powerline](https://github.com/powerline/powerline) - statusline (for zsh)
  
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

        cd ~/
        mkdir ~/.dotfiles/back/

        mv -r ~/.i3/ ~/.dotfiles/back/
        mv -r ~/.config/dunst/dunstrc ~/.dotfiles/back/
        ln -s ~/.dotfiles/i3/ ~/.i3/
        ln -s ~/.dotfiles/dunst/dunstrc ~/.i3/

        mv ~/.compton.conf ~/.dotfiles/back/
        ln -s ~/.dotfiles/.compton.conf ~/.compton.conf
        
        mv ~/.zshrc ~/.dotfiles/back/
        ln -s ~/.dotfiles/shell/.zshrc ~/.zshrc

        mv -r ~/.config/dunst/ ~/.dotfiles/back/
        ln -s ~/.dotfiles/dunst/ ~/.config/dunst/

        mv ~/.vimrc ~/.vimrc.local ~/.vimrc.bundles.local ~/.dotfiles/back/
        ln -s ~/.dotfiles/vim/.vimrc
        ln -s ~/.dotfiles/vim/.vimrc.local
        ln -s ~/.dotfiles/vim/.vimrc.bundles.local
        # You'll need to run :PluginInstall in vim to download and install plugins

If you are trying to install this onto your local setup, let me know what can be done to make this easier. 


TODO: 
  * Add links and install commands for the different packages. 
  * Create a simple setup than a mess of symlinks
