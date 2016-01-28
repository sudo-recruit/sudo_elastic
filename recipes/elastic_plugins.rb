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
  group 'root'
  user 'root'
end

directory '/usr/share/elasticsearch/plugins/ik' do
  group 'root'
  user 'root'
end

file "/usr/share/elasticsearch/plugins/ik/elasticsearch-analysis-ik-#{ik_version}.zip" do
  content lazy {IO.read("#{home_path}/elasticsearch-analysis-ik/target/releases/elasticsearch-analysis-ik-#{ik_version}.zip")}
  action :create
  group 'root'
  user 'root'
end

bash 'unzip ik' do
  cwd "/usr/share/elasticsearch/plugins/ik"
  code "unzip elasticsearch-analysis-ik-#{ik_version}.zip"
  group 'root'
  user 'root'
end

from_path="#{home_path}/elasticsearch-analysis-ik/config/ik/"
to_path='/etc/elasticsearch/ik/'

directory '/etc/elasticsearch/ik' do
  group 'root'
  user 'root'
end

directory '/etc/elasticsearch/ik/custom' do
  group 'root'
  user 'root'
end

#stupid way to copy file
files=['IKAnalyzer.cfg.xml','main.dic','quantifier.dic','suffix.dic','preposition.dic','stopword.dic','surname.dic',
       'custom/ext_stopword.dic','custom/single_word.dic','custom/single_word_low_freq.dic',
       'custom/mydict.dic','custom/single_word_full.dic','custom/sougou.dic']

files.each do|f|
  file "#{to_path}#{f}" do
    content lazy {IO.read("#{from_path}#{f}")}
    action :create
    group 'root'
    user 'root'
  end
end
