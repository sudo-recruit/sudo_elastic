name "sudo_elastic"
version "0.1.3"
maintainer "ocowchun"
maintainer_email "ben.yeh@sudo.com.tw"
license  "MIT"
supports "ubuntu"
description "install elastic and [elasticsearch-analysis-ik]"
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))

depends "java"
depends "apt", "~> 2.9.2"
depends "elasticsearch", "~> 2.2.0"
