#!/bin/bash

eggs="lazy-ssax ssax sxml-match sxml-templates sxml-tools sxml-transforms syntax-case"

# install chicken
if [ ! `which chicken-setup` ]; then
	bash $DTHOME/install/$OS/install_chicken.sh
fi

# install eggs for parsing XML
echo "Installing eggs ..."
chicken-setup -d $eggs && \
rm -rf *.egg
echo "done."
