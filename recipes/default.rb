include_recipe "apt"
include_recipe "java::default"
include_recipe "elasticsearch::default"

package 'curl'
package 'git'
package 'vim'
package 'zip'

# set elastic search config
elasticsearch_configure 'elasticsearch' do
  configuration ({
                   'cluster.name' => node['sudo_elastic']['elastic_search']['cluster']['name'],
                   'node.name' => node['sudo_elastic']['elastic_search']['node']['name'],
                   'network.host' => node['sudo_elastic']['elastic_search']['network_host']
  })
end

bash 'start elastic search' do
  code 'sudo service elasticsearch restart'
end

