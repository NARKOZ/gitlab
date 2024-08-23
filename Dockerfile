FROM ruby:3.1

WORKDIR /app

COPY . ./
RUN bundle install

CMD ["bin/console"]
