#!/bin/bash

sudo -v

yay -Syu --noconfirm
flatpak update -y

pkill -RTMIN+4 waybar