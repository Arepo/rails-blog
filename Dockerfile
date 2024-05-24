FROM ruby:3.0.7

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get update && apt-get install -y nodejs

WORKDIR /app

COPY Gemfile* ./
RUN bundle install
COPY . .

RUN RAILS_ENV=production bundle exec rake assets:precompile

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
