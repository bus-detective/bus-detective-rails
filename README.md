![Codeship Build Status](https://www.codeship.io/projects/e510f2b0-afb9-0132-3257-0e5ba92aabbb/status)
[![Code Climate](https://codeclimate.com/github/bus-detective/bus-detective/badges/gpa.svg)](https://codeclimate.com/github/bus-detective/bus-detective)

# Bus Detective

* Ruby: 2.2.0 - Rails: 4.2.0
* PostgreSQL
* Redis

### Setup

#### Copy example files
    cp .env.example .env
    cp config/database.yml.example config/database.yml

#### Fetch stop data

Import data for all existing agencies:

    rake metro:import_existing

Import data for a new agency:

    rake metro:import["http://url_to_gtfs_file.zip"]

Import data directly from the heroku app:

    ./bin/data

Updating data on Heroku

    heroku run:detached --size Performance -a busdetective rake metro:import_existing

### Run

    rails s

### Test

    rake

This project rocks and uses MIT-LICENSE.


## Hosting

* Hosting - Heroku under Gaslight account
* DNS - DNSimple under Gaslight account
* Monitoring - Skylight (see accounts doc for credentials)
** Uses environment variables SKYLIGHT_APPLICATION and SKYLIGHT_AUTHENTICATION on Heroku


