web: bundle exec puma -C config/puma.rb
worker: env NEW_RELIC_APP_NAME=$NEW_RELIC_APP_NAME-worker DB_POOL=$SIDEKIQ_DB_POOL bundle exec sidekiq -e $RAILS_ENV -q high -q medium -q default
load: env NEW_RELIC_APP_NAME=$NEW_RELIC_APP_NAME-load SIDEKIQ_CONCURRENCY=$LOAD_SIDEKIQ_CONCURRENCY DB_POOL=$LOAD_DB_POOL bundle exec sidekiq -e $RAILS_ENV -q load