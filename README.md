# Data Tools for WCDP

### Usage

##### Setup

1. run `cp bin/keys.sh.example bin/keys.sh`
1. modify the contents of `keys.sh` to use your keys. It is excluded by the gitignore, and will not be checked in.

##### Running
You can run 

```
bin/validate_phone_numbers.sh
```

to try out validating phone numbers (TODO, actually validate phone numbers :P )

You can also run:

```
source bin/functions.sh
test_connection
# OR
hit_api GET /apiKeyProfiles
```

to try out various API endpoints.
