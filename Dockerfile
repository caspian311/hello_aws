FROM phusion/baseimage:0.9.18

ENV RUBY_VERSION 2.3.0
RUN apt-get update && apt-get --quiet --yes install \
  build-essential \
  libssl-dev \
  zlib1g-dev \
  git \
  libreadline-dev

RUN cd /usr/local/src &&\
    git clone https://github.com/sstephenson/ruby-build.git &&\
    cd ruby-build &&\
    ./install.sh

RUN ruby-build $RUBY_VERSION /usr/local
RUN gem update --system
RUN gem install bundler --no-ri --no-rdoc

RUN mkdir -p /application
RUN mkdir -p /var/log/applications

WORKDIR /application
ADD Gemfile.lock /application/
ADD Gemfile /application/
RUN bundle install --without development test

ADD . /application
EXPOSE 4444
CMD ./run.sh | tee /var/log/applications/hello_aws.log
