# Use the official Ruby image with the specified version
FROM ruby:3.3.4

# Set environment variables
ENV RAILS_ENV production
ENV RACK_ENV production

# Install necessary packages
RUN apt-get update -qq && apt-get install -y nodejs yarn postgresql-client

# Set working directory
WORKDIR /app

# Install Bundler
RUN gem install bundler

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install 

# Copy the rest of the application code
COPY . .

# Precompile assets
RUN bundle exec rake assets:precompile

# Clean up after bundle install
RUN rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Expose port 3000 to the outside world
EXPOSE 3000

# Start the application
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
