#!/bin/sh

#  GIN COIN Masternode docker template
#  Copyright © 2019 cryon.io
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as published
#  by the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#  Contact: cryi@tutanota.com

GIT_INFO=$(curl -sL "https://api.github.com/repos/GIN-coin/gincoin-core/releases/latest")                                       
URL=$(printf "%s\n" "$GIT_INFO" | jq .assets[].browser_download_url -r | grep binaries | grep linux | grep 64bit)                         

curl -L "$URL" -o ./gincoin.tar.gz

tar -xzvf ./gincoin.tar.gz
cp -f ./gincoin-binaries/gincoind .
cp -f ./gincoin-binaries/gincoin-cli .
rm -rf ./gincoin-binaries
rm -f ./gincoin.tar.gz