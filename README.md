# Data Tools for WCDP

## Data Analysis of WCDP

To do geospacial analysis of voter data, the first step is to retrieve geo-IPs for voters. The
data in VoteBuilder doesn't come with latitude/longitude pairs, but we can fetch most geo-IPs from
open Census data apis.

First, given a List export from VoteBuilder called `input.csv` run:

```
ruby lib/geoip/geoip_csv.rb input.csv geoips.csv
```

This will produce a CSV with a VANID, latitude, and longitude for _most_ voters (some mailing addresses are newer than the
available census data). The resulting file will look like:

```
VANID,latitude,longitude
6271,35.957436,-86.72896
12155,35.9647,-86.82905
12179,35.779125,-86.888855
```

Next, you can join these IPs with the source data, and index into Elasticsearch with:

```
ruby lib/elasticsearch/indexer.rb input.csv geoips.csv
```

This creates a new `people` index with the mapping found at `lib/elasticsearch/people_mapping.json`

From there, it's a simple matter of building visualizations.

## Validating VoteBuilder Phone Numbers

### Usage

##### Setup

1. run `cp bin/keys.sh.example bin/keys.sh`
1. modify the contents of `keys.sh` to use your keys. It is excluded by the gitignore, and will not be checked in.
1. run `bundle install` to get your ruby gems

##### Running
You can run 

```
bin/wcdp validate
```

to try out validating phone numbers (TODO, actually validate phone numbers :P )

You can also run:

```
source bin/keys.sh
source bin/functions.sh
test_connection
# OR
hit_api GET /apiKeyProfiles
```

to try out various API endpoints. This lines up with the API syntax at https://developers.ngpvan.com/


## Munging ActBlue CSVs to import to NationBuilder

The first CSV I was asked to import to NationBuilder had a single column for "Name", like:

```
Donor Name,Donor Addr1,Donor City,Donor State,Donor ZIP,Donor Country,Donor Email,Donor Phone
```

NationBuilder expects names to be split into `first`, `middle`, and `last`.

`bin/act_blue_to_nation_builder.rb` is an attempt to read, parse, and "clean" such a CSV. You may need to tweak it for your
specific CSV, as it makes assumptions about what columns are available and in which order.
