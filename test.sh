#!/bin/sh

# Wait for database to be ready
until pg_isready --host="$TEST_DB_HOST"; do sleep 1; done

# Migrate the database
bundle exec rake db:migrate

# Run tests
bundle exec rake
