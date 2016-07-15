include_recipe 'poise-monit'

template "/etc/monit/conf.d/elasticsearch" do
  source "monit_elasticsearch.erb"
end