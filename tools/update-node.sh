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

PATH_TO_SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname "$PATH_TO_SCRIPT")

get_latest_github_release() {
    GIT_INFO=$(curl -sL "https://api.github.com/repos/$1/releases/latest")
    get_json_value "$GIT_INFO" "tag_name"                                           
    RESULT=$JSON_VALUE                             
} 

get_json_value() {
    JSON_VALUE=$(printf "%s\n" "$1" | jq ".[\"$2\"]" -r)
}

container=$(docker-compose -f "$BASEDIR/../docker-compose.yml" ps -q mn)
if [ -z "$container" ]; then 
    # masternode is not running
    exit 1
fi
current_ver=$(sh "$BASEDIR/node-info.sh")
get_latest_github_release "GIN-coin/gincoin-core"
# shellcheck disable=SC1003
ver=$(echo "$RESULT" | sed 's\v\\')
if echo "$current_ver" | grep -q "VERSION: $ver"; then
    exit 0
else
    docker-compose -f "$BASEDIR/../docker-compose.yml" build --no-cache && docker-compose -f "$BASEDIR/../docker-compose.yml" up -d --force-recreate
    sleep 10
    current_ver=$(sh "$BASEDIR/node-info.sh")
    if echo "$current_ver" | grep -q "VERSION: $ver" "$BASEDIR/../data/node.info"; then
        exit 0
    else 
        # failed to update masternode
        exit 2
    fi
fi