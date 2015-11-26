include_recipe "apt"
include_recipe "java::default"
include_recipe "elasticsearch::default"

package 'curl'
package 'git'
package 'vim'

# include_recipe "sudo_elastic::elastic_plugins"

# network.hos
elasticsearch_configure 'elasticsearch' do
  configuration ({
                   'cluster.name' => 'escluster',
                   'node.name' => 'node01',
                   'network.host' => node['sudo_elastic']['elastic_search']['network_host']
  })
end

bash 'start elastic search' do
  code 'sudo service elasticsearch restart'
end
