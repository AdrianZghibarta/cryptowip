if  [ -n "${ZSH_VERSION:-}"  ]; then
echo  'export PATH="./bin:$PATH"'  >> ~/.zshrc
echo  'export RBENV_ROOT=/usr/local/var/rbenv'  >> ~/.zshrc
echo  'eval "$(rbenv init - --no-rehash)"'  >> ~/.zshrc
echo  'export COCOAPODS_DISABLE_DETERMINISTIC_UUIDS=1'  >> ~/.zshrc
else
echo  'export PATH="./bin:$PATH"'  >> ~/.bash_profile
echo  'export RBENV_ROOT=/usr/local/var/rbenv'  >> ~/.bash_profile
echo  'eval "$(rbenv init - --no-rehash)"'  >> ~/.bash_profile
echo  'export COCOAPODS_DISABLE_DETERMINISTIC_UUIDS=1'  >> ~/.bash_profile
fi

eval  "$(rbenv init - --no-rehash)"
echo  'export PATH="./bin:$PATH"'
