sudo apt-get install g++
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install build-essential bison openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev
wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.5.tar.gz
tar xvfz ruby-2.1.5.tar.gz
cd ruby-2.1.5
./configure
make
sudo make install
