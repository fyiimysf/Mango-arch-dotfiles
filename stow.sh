echo "Stowing all dotfiles from $DOTFILES_DIR..."

	cd stow
for dir in */; do
    package="${dir%/}"  # Remove trailing slash
    if [[ -d "$package" ]]; then
        #if [ ! "$package" = "setup.sh" ]&[ ! "$package" = "README.md" ]&[ ! "$package" = ".gitattributes" ]&[ ! "$package" = ".gitignore" ]&[ ! "$package" = "LICENSE" ]&[ ! "$package" = ".git" ]; then
         echo "Stowing $package..."
         stow -Rv -t '../../' "$package"
	#fi
    fi
done
	cd ..
