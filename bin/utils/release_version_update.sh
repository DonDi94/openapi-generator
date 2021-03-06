#!/bin/bash
#
# usage: ./bin/utils/release_version_update.sh 3.0.1-SNAPSHOT 3.0.1
#
# Copyright 2018 OpenAPI-Generator Contributors (https://openapi-generator.tech)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if [[ "$1" != "" ]]; then
    FROM="$1"
else
    echo "Missing argument. Usage e.g.: ./bin/utils/release_version_update.sh 3.0.1-SNAPSHOT 3.0.1"
    exit 1;
fi

if [[ "$2" != "" ]]; then
    TO="$2"
else
    echo "Missing argument. Usage e.g.: ./bin/utils/release_version_update.sh 3.0.1-SNAPSHOT 3.0.1"
    exit 1;
fi

echo "Release preparation: replacing $FROM with $TO in different files"

# This script assumes the files defined here have a version surrounded by angle brackets within an xml node.
# For example, >4.0.0< becomes >4.0.1-SNAPSHOT<.
# Verify the sed command below against a file before adding here.
declare -a files=("modules/openapi-generator-cli/pom.xml"
                  "modules/openapi-generator-gradle-plugin/pom.xml"
                  "modules/openapi-generator-core/pom.xml"
                  "modules/openapi-generator-maven-plugin/pom.xml"
                  "modules/openapi-generator-online/pom.xml"
                  "modules/openapi-generator/pom.xml"
                  "samples/meta-codegen/lib/pom.xml"
                  "pom.xml")

sedi () {
  # Cross-platform version of sed -i that works both on Mac and Linux
  sed --version >/dev/null 2>&1 && sed -i -e "$@" || sed -i "" "$@"
}

for filename in "${files[@]}"; do
  # e.g. sed -i '' "s/3.0.1-SNAPSHOT/3.0.1/g" CI/pom.xml.bash
  #echo "Running command: sed -i '' "s/$FROM/$TO/g" $filename"
  if sedi "s/>$FROM</>$TO</g" $filename; then
    echo "Updated $filename successfully!"
  else
    echo "ERROR: Failed to update $filename with the following command"
    echo "sed -i '' \"s/$FROM/$TO/g\" $filename"
  fi
done
