web: bundle exec rails server -p $PORT
worker: rake myrake:bg
worker: QUEUE=* bundle exec rake environment resque:work
