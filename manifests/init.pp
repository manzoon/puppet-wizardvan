#   Copyright 2015 John Kinsella
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
# = Class: wizardvan
#
# Installs and configures the Sensu metrics relay WizardVan
#
# == Parameters
#
# [*wv_dest*]
#   String. Location to download wizardvan to from github
#   Default: /usr/local/lib/sensu-metrics-relay
#
# [*wv_repo*]
#   String. WizardVan Github repository url
#   Default: https://github.com/grepory/wizardvan.git
#
# [*graphite_relay*]
#   Boolean. Specifies if data should be relayed to a graphite server
#   Default: true
#
# [*graphite_host*]
#   String. Graphite server hostname or IP address
#   Default: localhost
#
# [*graphite_port*]
#   Integer. Port on graphite host to connect to
#   Default: 2003
#
# [*graphite_max_queue_size*]
#   Integer. Maximum queue size for sending to graphite
#   Default: 16384
#
# [*tsdb_relay*]
#   Boolean. Specifies if data should be relayed to an openTSDB server
#   Default: false
#
# [*tsdb_host*]
#   String. OpenTSDB server hostname or IP address
#   Default: localhost
#
# [*tsdb_port*]
#   Integer. Port on OpenTSDB host to connect to
#   Default: 4424
#
class wizardvan (
  $graphite_relay          = true,
  $graphite_host           = 'localhost',
  $graphite_port           = 2003,
  $graphite_max_queue_size = 16384,
  $tsdb_relay              = false,
  $tsdb_host               = 'localhost',
  $tsdb_port               = 4424,
  $wv_dest                 = '/usr/local/lib/sensu-metrics-relay',
  $wv_repo                 = 'https://github.com/grepory/wizardvan.git'
) {
  validate_bool($graphite_relay, $tsdb_relay)
  if !is_integer($graphite_port) { fail('graphite_port must be an integer') }
  if !is_integer($graphite_max_queue_size) { fail('graphite_max_queue_size must be an integer') }
  if !is_integer($tsdb_port) { fail('tsdb_port must be an integer') }

  vcsrepo { $wv_dest:
    ensure    => present,
    provider  => git,
    source    => $wv_repo,
    require   => [File['/etc/sensu/conf.d/config_relay.json'],Package['git']],
    notify    => Exec['copywizardvanfiles'];
  }

  exec {
    # We don't have to restart sensu after this, as the sensu
    # module will do so after fixing ownership and permissions.
    'copywizardvanfiles':
      command     => "cp -R ${wv_dest}/lib/sensu/extensions/* /etc/sensu/extensions",
      refreshonly => true,
      path        => '/bin',
  }
  if $::bios_version == 'VirtualBox' {
    $config_relay_template = "/tmp/vagrant-puppet/modules-f2a3e880375508488722eafa8258d2eb/wizardvan/templates/config.json.erb"
  } else {
    $config_relay_template = 'puppet:///modules/wizardvan/config.json.erb'
  }

  file { '/etc/sensu/conf.d/config_relay.json':
    content => template($config_relay_template),
    require => Class['sensu'];
  }
}
