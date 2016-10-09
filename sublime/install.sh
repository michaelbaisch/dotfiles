# symlink settings
sublime_dir=~/Library/Application\ Support/Sublime\ Text\ 3/Packages
mv "$sublime_dir/User" "$sublime_dir/User.backup"
ln -s "$ZSH/sublime/User" "$sublime_dir"