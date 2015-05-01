# Bus Detective

Ruby: 2.2.0 - Rails: 4.2.0

### Setup

#### Fetch stop data

Import data for all existing agencies:

    rake metro:import_existing

Import data for a new agency:

    rake metro:import["http://url_to_gtfs_file.zip"]

Import data direcrly from the heroku app:

    ./bin/data

### Run

    rails s

### Test

    rake

This project rocks and uses MIT-LICENSE.
