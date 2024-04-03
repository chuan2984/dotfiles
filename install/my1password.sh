#!/bin/bash
op signin --account my.1password.com # to sign in
op plugin init gh # to enable sign in with gh
source ~/.config/op/plugins.sh # to create an alias for gh with op
