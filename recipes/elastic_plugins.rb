include_recipe "elasticsearch::default"

package 'maven'
home_path=node['sudo_elastic']['home_path']
ik_version=node['sudo_elastic']['ik']['version']

ik_revision="v#{ik_version}"
ik_revision='master' if ik_version=='master'

git "#{home_path}/elasticsearch-analysis-ik" do
  repository 'https://github.com/medcl/elasticsearch-analysis-ik'
  revision "#{ik_revision}"
end

bash 'mvn compile' do
  cwd "#{home_path}/elasticsearch-analysis-ik"
  code 'mvn compile'
end

bash 'mvn package' do
  cwd "#{home_path}/elasticsearch-analysis-ik"
  code 'mvn package'
end

#

directory '/usr/share/elasticsearch/plugins' do
  group 'elasticsearch'
  user 'elasticsearch'
end

directory '/usr/share/elasticsearch/plugins/ik' do
  group 'elasticsearch'
  user 'elasticsearch'
end

file "/usr/share/elasticsearch/plugins/ik/elasticsearch-analysis-ik-#{ik_version}.zip" do
  content lazy {IO.read("#{home_path}/elasticsearch-analysis-ik/target/releases/elasticsearch-analysis-ik-#{ik_version}.zip")}
  action :create
  group 'elasticsearch'
  user 'elasticsearch'
end

bash 'unzip ik' do
  cwd "/usr/share/elasticsearch/plugins/ik"
  code "unzip elasticsearch-analysis-ik-#{ik_version}.zip"
  group 'elasticsearch'
  user 'elasticsearch'
end

from_path="#{home_path}/elasticsearch-analysis-ik/config/ik/"
to_path='/etc/elasticsearch/ik/'

directory '/etc/elasticsearch/ik' do
  group 'elasticsearch'
  user 'elasticsearch'
end

directory '/etc/elasticsearch/ik/custom' do
  group 'elasticsearch'
  user 'elasticsearch'
end

#stupid way to copy file
files=['IKAnalyzer.cfg.xml','main.dic','quantifier.dic','suffix.dic','preposition.dic','stopword.dic','surname.dic',
       'custom/ext_stopword.dic','custom/single_word.dic','custom/single_word_low_freq.dic',
       'custom/mydict.dic','custom/single_word_full.dic','custom/sougou.dic']

files.each do|f|
  file "#{to_path}#{f}" do
    content lazy {IO.read("#{from_path}#{f}")}
    action :create
    group 'elasticsearch'
    user 'elasticsearch'
  end
end

directory '/etc/elasticsearch/analysis' do
  group 'elasticsearch'
  user 'elasticsearch'
end

template "/etc/elasticsearch/analysis/synonym.txt" do
  source "synonym.txt"
end

elasticsearch_configure 'elasticsearch' do
  configuration ({
                   'cluster.name' => node['sudo_elastic']['elastic_search']['cluster']['name'],
                   'node.name' => node['sudo_elastic']['elastic_search']['node']['name'],
                   'network.host' => node['sudo_elastic']['elastic_search']['network_host'],
                   'index.analysis.filter.sudo_synonym.type'=>'synonym',
                   'index.analysis.filter.sudo_synonym.synonyms_path'=>'"analysis/synonym.txt"',
                   'index.analysis.analyzer.sudo_analyzer.type'=>'custom',
                   'index.analysis.analyzer.sudo_analyzer.char_filter'=>'html_strip',
                   'index.analysis.analyzer.sudo_analyzer.tokenizer'=>'ik_smart',
                   'index.analysis.analyzer.sudo_analyzer.filter'=>'[lowercase, sudo_synonym]'
  })
end