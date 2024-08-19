#!/bin/bash
#
# Copyright © 2016-2024 The Thingsboard Authors
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

for i in "$@"
do
case $i in
    --fromVersion=*)
    FROM_VERSION="${i#*=}"
    shift
    ;;
    *)
            # unknown option
    ;;
esac
done

if [[ -z "${FROM_VERSION// }" ]]; then
    echo "--fromVersion parameter is invalid or unspecified!"
    echo "Usage: upgrade.sh --fromVersion={VERSION}"
    exit 1
else
    fromVersion="${FROM_VERSION// }"
fi

CONF_FOLDER=/usr/share/tb-mqtt-transport/conf
configfile=tb-mqtt-transport.conf
jarfile=/usr/share/tb-mqtt-transport/bin/tb-mqtt-transport.jar
installDir=/usr/share/tb-mqtt-transport/data

source "${CONF_FOLDER}/${configfile}"

run_user=thingsboard

su -s /bin/sh -c "java -cp ${jarfile} $JAVA_OPTS -Dloader.main=org.thingsboard.server.ThingsboardInstallApplication \
                    -Dinstall.data_dir=${installDir} \
                    -Dspring.jpa.hibernate.ddl-auto=none \
                    -Dinstall.upgrade=true \
                    -Dinstall.upgrade.from_version=${fromVersion} \
                    -Dlogging.config=/usr/share/tb-mqtt-transport/bin/install/logback.xml \
                    org.springframework.boot.loader.PropertiesLauncher" "$run_user"

if [ $? -ne 0 ]; then
    echo "ThingsBoard upgrade failed!"
else
    echo "ThingsBoard upgraded successfully!"
fi

exit $?
