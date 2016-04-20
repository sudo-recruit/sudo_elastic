include_recipe "consul::default"

consul_definition 'elastic_search_sudo' do
  type 'service'
  parameters(tags: %w{elastic_search}, address: '127.0.0.1', port: 9200)
  notifies :reload, 'consul_service[consul]', :delayed
end

consul_definition 'elastic_alive' do
  type 'check'
  parameters(name:'elastic_alive',http: 'http://localhost:9200', interval: '10s',timeout: "1s")
  notifies :reload, 'consul_service[consul]', :delayed
end

include_recipe "sudo_consul_service::required_reboot"
