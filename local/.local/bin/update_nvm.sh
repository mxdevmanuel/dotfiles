#!/usr/bin/env bash
function _update_nvm(){
        local releasedata=$(curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/nvm-sh/nvm/releases/latest)
        local releasename=$(echo -n $releasedata | jq ".name" )

         if [[ -d $HOME/.nvm ]]
         then
                [ `alias | grep nvm | wc -l` != 0 ] && unalias nvm

                [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
                
                nvm_version=$(nvm --version)
                nvm_latest=$(echo $releasename | sed 's/[^0-9.]*//g')

                if [[ "$nvm_version" == "$nvm_latest" ]]
                then
                        echo "NVM is up to date"
                        exit 0
                fi
         fi

         curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${releasename}/install.sh" | bash
}

_update_nvm
