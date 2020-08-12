#!/usr/bin/env bash
#
# Copyright (c) 2020 Seagate Technology LLC and/or its Affiliates
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# For any questions about this software or licensing,
# please email opensource@seagate.com or cortx-questions@seagate.com.

set -e -o pipefail
set -x
export PS4='+ [${BASH_SOURCE[0]##*/}:${LINENO}${FUNCNAME[0]:+:${FUNCNAME[0]}}] '

# NOTE: cortx-hare have to be installed: either RPM or devinstall

usermod --append --groups hare ${USER}
mkdir -p /var/motr
echo "options lnet networks=tcp(eth1) config_on_load=1" > /etc/modprobe.d/lnet.conf
for i in {0..9}; do
    dd if=/dev/zero of=/var/motr/disk${i}.img bs=1M seek=9999 count=1
    losetup /dev/loop${i} /var/motr/disk${i}.img
done
# XXX-FIXME: to discuss
hctl bootstrap --mkfs /opt/seagate/cortx/hare/share/cfgen/examples/singlenode.yaml