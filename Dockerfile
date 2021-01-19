FROM ruby:2.6.6

RUN apt-get update -qq && apt-get install -y postgresql-client
WORKDIR /app

COPY rails_app/Gemfile /app/Gemfile
COPY rails_app/Gemfile.lock /app/Gemfile.lock

RUN gem install bundler && bundle install --jobs 20 --retry 5

ENV DB_HOST db

COPY rails_app/. /app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Start the main process.
CMD ["rails", "s", "-b", "0.0.0.0"]
