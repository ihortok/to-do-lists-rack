FROM ruby:3.4.5-slim

ENV RACK_ENV=production

WORKDIR /app

RUN apt-get update && apt-get install -y build-essential libsqlite3-dev

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

COPY . .

EXPOSE 9292

RUN bundle exec rake db:setup
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "--port", "9292"]
