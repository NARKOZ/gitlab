FROM ruby:2.5

WORKDIR /app

COPY . ./
RUN bundle install

CMD ["bin/console"]
