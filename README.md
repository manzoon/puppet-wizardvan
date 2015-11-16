# Puppet-Wizardvan

Installs and manages the Sensu metrics relay "Wizardvan" (AKA [sensu-metrics-relay](https://github.com/opower/sensu-metrics-relay)) 

## Installation

    $ puppet module install jlk/puppet-wizardvan

## Prerequisites

- Running Sensu server

### Dependencies

- [puppetlabs/stdlib](https://github.com/puppetlabs/puppetlabs-stdlib)
- [puppetlabs-vcsrepo](https://github.com/puppetlabs/puppetlabs-vcsrepo)
- [sensu-puppet](https://github.com/sensu/sensu-puppet) 

See `metadata.json` for details.

## Basic example

    node 'sensu-server.foo.com' {
      class { 'wizardvan':;}
      ...
    }

## Parameters:

###`wv_dest`

String. Location to download wizardvan to from github

Default: /usr/local/lib/sensu-metrics-relay

###`graphite_relay`

Boolean. Specifies if data should be relayed to a graphite server

Default: true

###`graphite_host`

String. Graphite server hostname or IP address

Default: localhost

###`graphite_port`

Integer. Port on graphite host to connect to

Default: 2003

###`graphite_max_queue_size`

Integer. Maximum queue size for sending to graphite

Default: 16384

###`tsdb_relay`

Boolean. Specifies if data should be relayed to an openTSDB server

Default: false

###`tsdb_host`

String. OpenTSDB server hostname or IP address

Default: localhost

###`tsdb_port`

Integer. Port on OpenTSDB host to connect to

Default: 4424

## License

   Copyright 2015 John Kinsella

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

   See LICENSE file for more details.
