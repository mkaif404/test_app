# Use the official Ruby image with the specified version
FROM ruby:3.3.4

# Install required packages
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    yarn \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
# Set the working directory
WORKDIR /usr/src/app

# Copy Gemfile and Gemfile.lock
COPY Gemfile /usr/src/app/Gemfile
COPY Gemfile.lock /usr/src/app/Gemfile.lock

# Install gems
RUN bundle install 

# Copy the rest of the application code
COPY . /usr/src/app

# Precompile assets
RUN bundle exec rake assets:precompile

# Set environment variables if necessary (for example, Rails environment)
ENV RAILS_ENV=production
ENV RACK_ENV=production

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["rails", "server", "-b", "0.0.0.0"]