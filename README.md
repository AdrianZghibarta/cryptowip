# Setup

## Homebrew

Make sure `homebrew` package manager is installed

```
ruby -e` `"$(curl -fsSL  [https://raw.githubusercontent.com/Homebrew/install/master/install)](https://raw.githubusercontent.com/Homebrew/install/master/install))"
```

## Ruby environment

To assure that each dev machine has the same Ruby version and all Ruby related code will run ok let's use `rbenv`
To install it, run:

```
brew update
brew install rbenv ruby-build
```

## Install project dependencies

Clone the project, `cd` into the new cloned project. To make sure that the shell is updated run (only once to make sure ruby environment setup is finished):
```
./configure_shell_profile.sh
source ~/.bash_profile #'source ~/.zshrc' if you're using zsh
```

Install ruby dependencies

```
rbenv install
rbenv rehash
gem update --system
gem install bundler
bundle install
bundle exec pod install
xed . # to open the XCode workspace
```


