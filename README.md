# Data Tools for WCDP

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
