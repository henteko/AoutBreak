FROM ubuntu:12.10
MAINTAINER henteko

RUN apt-get update
RUN apt-get install -y curl git build-essential ruby1.9.3 libsqlite3-dev
RUN apt-get install -y libpq-dev nodejs libv8-dev
RUN gem install rubygems-update --no-ri --no-rdoc
RUN update_rubygems
RUN gem install bundler sinatra --no-ri --no-rdoc

ADD rails_sample /opt/railsapp

WORKDIR /opt/railsapp
RUN bundle install
