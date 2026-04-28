FROM ruby:3.0-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile
COPY Gemfile Gemfile.lock* ./

# Install gems
RUN bundle install

# Copy project files
COPY . .

# Default command
CMD ["bash"]
