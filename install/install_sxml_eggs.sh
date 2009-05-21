#!/bin/bash

eggs="lazy-ssax ssax sxml-match sxml-templates sxml-transforms syntax-case"

# install chicken
if [ ! `which chicken-setup` ]; then
	bash $DTHOME/install/$OS/install_chicken.sh
fi

# install eggs for parsing XML
echo "Installing eggs ..."
chicken-setup -d $eggs
mkdir -p eggs
mv *.egg eggs/
chown -R $USER eggs
echo "done."
