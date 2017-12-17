web: bundle exec rails server -p $PORT
worker: bundle exec rake myrake:bg
worker: QUEUE=* bundle exec rake environment resque:work
