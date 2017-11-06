web: bundle exec rails server -p $PORT
worker: QUEUE=* bundle exec rake environment resque:work
worker: bundle exec rake environment resque:scheduler