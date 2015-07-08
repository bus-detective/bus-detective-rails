FROM ruby:2.2.2-slim

MAINTAINER Jim Anders <janders223@gmail.com>

ENV REFRESHED_AT 2015-07-01

RUN apt-get update -qq && apt-get install -y build-essential

# for postgres
RUN apt-get install -y libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# for capybara-webkit
RUN apt-get install -y libqt4-webkit libqt4-dev xvfb

# for a JS runtime
RUN apt-get install -y nodejs

ENV APP /webApps/app

COPY Gemfile* $APP/

WORKDIR $APP

RUN bundle install -j4

COPY . $APP
