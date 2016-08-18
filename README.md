![Codeship Build Status](https://www.codeship.io/projects/e510f2b0-afb9-0132-3257-0e5ba92aabbb/status)
[![Code Climate](https://codeclimate.com/github/bus-detective/bus-detective/badges/gpa.svg)](https://codeclimate.com/github/bus-detective/bus-detective)

# Bus Detective

* Ruby: 2.2.0 - Rails: 4.2.0
* PostgreSQL
* Redis

### Setup

#### Copy example files

    cp .env.example .env

#### Fetch stop data

Import data for all existing agencies:

    rake metro:import_existing

Import data for a new agency:

    rake metro:import["http://url_to_gtfs_file.zip"]

Import data directly from the heroku app:

    ./bin/data

Updating data on Heroku

    heroku run:detached --size Performance -a busdetective rake metro:import_existing

#### Load Testing

    rake load_test[127.0.0.1:3000]

### Run

    rails s

### Test

    rake

## Hosting

* Hosting - Heroku under Gaslight account
* DNS - DNSimple under Gaslight account
* Monitoring - Skylight (see accounts doc for credentials)
** Uses environment variables SKYLIGHT_APPLICATION and SKYLIGHT_AUTHENTICATION on Heroku

## License
This project rocks and uses (MIT-LICENSE).

## Contributing
GitHub's guide for [Contributing to Open Source](https://guides.github.com/activities/contributing-to-open-source/)
offer's the best advice.

#### tl;dr
1. [Fork it](https://help.github.com/articles/fork-a-repo/)!
1. Create your feature branch: `git checkout -b cool-new-feature`
1. Commit your changes: `git commit -am 'Added a cool feature'`
1. Push to the branch: `git push origin cool-new-feature`
1. [Create new Pull Request](https://help.github.com/articles/creating-a-pull-request/).
