# Online Venture Challenge

## Production

This app lives at `app.onlineventurechallenge.com` for students, `admin.onlineventurechallenge.com` for admins (instructors), and `ops.onlineventurechallenge.com` for ops (super users). It is hosted on heroku as `venture-challenge`.

Deploy using `git push heroku master`.

Run migrations: `heroku run rake db:migrate`.

## Production setup

- Create a secret key and set it as `SECRET_KEY_BASE`
- Create a LinkedIn application for oauth and set the `LINKEDIN_KEY`, and `LINKEDIN_SECRET` environment variables.
- Create a Shopify application for oauth and set the `SHOPIFY_KEY`, and `SHOPIFY_SECRET` environment variables.
- Choose an ops password for http basic auth and set the `OPS_PASSWORD` environment variable.
- Create a CDN pointing to the app for asset hosting, and set the `ASSET_HOST` environment variable.

## Background tasks

There are two key background tasks that should be run intermittently in production (using Heroku scheduler, or another cron-type scheduler) to keep this app synchronized with the outside world.

### Synchronize Teams

`rake synchronize:teams`

This tasks a) synchronizes shop orders from Shopify, b) ensures shopify webhooks are still in place, and c) completes any tasks that have been satisfied but not marked as completed. This task is idempotent, so it can run as often as necessary to make sure data is up-to-date. Note that we *also* run this synchronization for a given shop whenever we receive a webhook from Shopify for that shop. Scheduling this task acts as an ensurance that this synchronization will get run even if the (less reliable) webhooks fail to fire.

### Synchronize Charges

- `rake synchronize:charges`

 Shopify application charges have a lengthy activation life-cycle; see http://docs.shopify.com/api/applicationcharge . When a team launches their shop, we ensure the charge is accepted and valid, and then create an unactivated `Charge` in our database. The actual activation of the charge is done in the background so the user doesn't have to wait for it, and this also makes the process more reliable to network failures. This task tries to activate on un-activated application charges with Shopify.

## Development

This app uses subdomains (`app`, `admin`, and `ops`) to differentiate user types. This makes omniauth less upset about having multiple types of users, and provides a nice separation of the app into namespaces. The caveat is that you need to use a subdomain in development.

You can use lvh.me to enable subdomains in development: `admin.lvh.me:3000`, `app.lvh.me:3000`, and `ops.lvh.me:3000`

## Ops Tools

Testing the many roles/scenarios in this app, together with using oauth, is not easy using traditional means. We have a number of ops tools to aid with doing this, from withing the Ops section of the app. There you can:

- Assume the identity of any student or instructor and view the app as if you were them.
- Create a dummy instructor for testing.
- Create a seeded competition in mid-game for an instructor with realistic data.
- Create a new student without a team in a competition.

You can also bypass LinkedIn authentication and log in or create new accounts manually by visiting `/auth/developer`.

## Development setup

### Quick Notes

- Use create a `.env` file to make setting environment variables easier.
- Create a LinkedIn application for oauth and set the `LINKEDIN_KEY`, and `LINKEDIN_SECRET` environment variables.
- Create a Shopify application for oauth and set the `SHOPIFY_KEY`, and `SHOPIFY_SECRET` environment variables.
- Choose an ops password for http basic auth and set the `OPS_PASSWORD` environment variable.
- Setup your database with `rake db:create:all && rake db:setup`
- Ensure the tests pass with `rake test:all`

### Testing

Run all the tests using: `rake test:all`

### Extended MacOS 10.14.6 Install Notes

```
# Install homebrew from
# https://brew.sh

brew update

# Let brew to do build dependencies and XCode setup
# but we're going to RVM for version pinning
brew install ruby && brew uninstall ruby

# install rvm
# https://rvm.io/rvm/install


PKG_CONFIG_PATH=/usr/local/openssl-1.0/lib/pkgconfig rvm reinstall 2.5.7 --with-openssl-dir=/usr/local/openssl-1.0/


cd ~/Documents/GitHub/venture_challenge_app
rvm install
rvm use

# the nokogiri gem at version 1.6.3.1 fails to build on MacOS 10.15.1
# Install the libiconv dependency and manually build the gem
gem install nokogiri -v1.6.3.1 -- --use-system-libraries=true --with-xml2-include="$(xcrun --show-sdk-path)"/usr/include/libxml2

# we need the pg headers for the gem later (postgresql@11.4 headers worked)
brew install postgresql

# now we should be good to
bundle install

# Rails 4.x Doesn't work with PostgreSQL >10
# so don't bother running the brew'd binary (11.4 at writing)
# Instead, grab Postgress.app.  Scroll down to find
# "Postgres.app with PostgreSQL 9.5, 9.6, 10 and 11"
# https://postgresapp.com/downloads.html

# Create a new PostgreSQL 9.6 server
# Create and popupate config/database.yml

# Download Postico for database interaction
# https://eggerapps.at/postico/
```

