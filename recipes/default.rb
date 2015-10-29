include_recipe "apt"
include_recipe "java::default"
include_recipe "elasticsearch::default"

package 'curl'
package 'git'
package 'vim'

include_recipe "sudo_elastic::elastic_plugins"

bash 'start elastic search' do
  code 'sudo service elasticsearch restart'
end
