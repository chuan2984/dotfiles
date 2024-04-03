#!/bin/bash
cd ~/github/work/
op signin --account fieldwire.1password.com # to sign in
op plugin init gh # to enable sign in with gh
source ~/.config/op/plugins.sh # to create an alias for gh with op
