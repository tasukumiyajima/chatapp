FROM ruby:2.5.3

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get update && \
    apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/* && \
    apt-get update -qq && apt-get install -y build-essential libpq-dev && \
    apt-get update && apt-get install -y curl apt-transport-https wget && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - 

RUN apt-get install -y nodejs npm && npm install n -g && n 10.17.0
RUN yarn add node-sass
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app
