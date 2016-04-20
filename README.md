#sudo_elastic Cookbook
This cookbook inculdes recipes to install elastic and [elasticsearch-analysis-ik](https://github.com/medcl/elasticsearch-analysis-ik)

##sudo_elastic::default
install elasticsearch and [kopf](https://github.com/lmenezes/elasticsearch-kopf)

* `['sudo_elastic']['elastic_search']['cluster']['name']` - elasticsearch cluster name(default:`my_escluster`)
* `['sudo_elastic']['elastic_search']['node']['name']` - elasticsearch node name(default:`node1`)
* `['sudo_elastic']['elastic_search']['network_host']` - elasticsearch network_host(default:`0.0.0.0`)

##sudo_elastic::elastic_plugins
install [elasticsearch-analysis-ik](https://github.com/medcl/elasticsearch-analysis-ik)

##sudo_elastic::consul
install [consul](https://www.consul.io/)

* `['consul']['config']['node_name']` - consul node name(default:`my_elastic_search`)
* `['consul']['config']['start_join']` - consul agent to join (i.e. `%w{172.20.20.11}`)

##todo
* write test

MIT
