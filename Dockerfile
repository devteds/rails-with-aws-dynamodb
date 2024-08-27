# syntax = docker/dockerfile:1

# Stage 1: Builder (base image that can be used for local deve or to run unit tests on CI)
FROM ruby:3.3.4 AS builder
RUN mkdir /app
WORKDIR /app
RUN apt-get update -qq && \
    apt-get -y install build-essential
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install

# Stage 2: develop (for local development setup)
FROM builder AS develop
RUN apt-get update && \
    apt-get install -y less
WORKDIR /workspace
CMD [ "bundle", "exec", "rails", "s", "-b", "0.0.0.0" ]

# Stage 3: prod-build (intermediate stage that builds prod artifacts)
FROM builder AS prod-build
COPY . /app
# RUN rails assets:precompile
RUN bundle config set --local without 'development test' && \
    bundle config set --local path /rubygems
RUN bundle install

# Stage 4: prod (image that will be deployed all of the environments - qa, staging, prod etc.)
FROM ruby:3.3.4-slim AS prod
RUN mkdir /app
WORKDIR /app
COPY --from=prod-build /app /app
COPY --from=prod-build /rubygems /rubygems
RUN bundle config set --local without 'development test' && \
    bundle config set --local path /rubygems
ENV RAILS_ENV="production"
ENV SECRET_KEY_BASE="this_is_demo-not_important"
CMD [ "bundle", "exec", "rails", "s", "-b", "0.0.0.0" ]
