package 'maven'
home_path=node['sudo_elastic']['home_path']

git "#{home_path}/elasticsearch-analysis-ik" do
  repository 'https://github.com/medcl/elasticsearch-analysis-ik'
  revision 'v1.4.1'
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

directory '/usr/local/elasticsearch/plugins' do
  group 'elasticsearch'
  user 'elasticsearch'
end

directory '/usr/local/elasticsearch/plugins/ik' do
  group 'elasticsearch'
  user 'elasticsearch'
end

file '/usr/local/elasticsearch/plugins/ik/elasticsearch-analysis-ik-1.4.1-jar-with-dependencies.jar' do
  content lazy {IO.read("#{home_path}/elasticsearch-analysis-ik/target/releases/elasticsearch-analysis-ik-1.4.1-jar-with-dependencies.jar")}
  action :create
  group 'elasticsearch'
  user 'elasticsearch'
end

from_path="#{home_path}/elasticsearch-analysis-ik/config/ik/"
to_path='/usr/local/etc/elasticsearch/ik/'

directory '/usr/local/etc/elasticsearch/ik' do
  group 'elasticsearch'
  user 'elasticsearch'
end

directory '/usr/local/etc/elasticsearch/ik/custom' do
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
