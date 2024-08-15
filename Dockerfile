FROM ruby:3.3.4-bullseye AS base

RUN apt-get update -qq && apt-get install -y build-essential apt-utils libpq-dev nodejs

WORKDIR /app

RUN gem install bundler

COPY Gemfile* ./

RUN bundle install

ADD . /app

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
