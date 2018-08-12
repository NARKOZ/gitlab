FROM ruby:2.5

WORKDIR /app

COPY . ./
RUN bundle config mirror.https://rubygems.org https://nexus.cloud.haefemeier.eu/repository/gem-group \
    && bundle install

CMD ["bin/console"]
