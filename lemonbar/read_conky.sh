#! /usr/bin/env bash

conky -c ~/.dotfiles/lemonbar/conkyrc | while read line; do
	echo $line > ~/.dotfiles/lemonbar/conky_output
done
