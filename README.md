# Bus Detective

Ruby: 2.2.0 - Rails: 4.2.0

### Setup

#### fetch stop data

Import data for all existing agencies:

    rake metro:import

Import data for a new agency:

    rake metro:import["http://url_to_gtfs_file.zip"]

or if your have access to the heroku app

    ./bin/data

### Run

    rails s

### Test

    rake

This project rocks and uses MIT-LICENSE.
