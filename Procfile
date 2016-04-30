web: bundle exec rackup config.ru -p $PORT
worker: bundle exec sidekiq -c $SIDEKIQ_CONCURRENCY -r ./worker.rb

