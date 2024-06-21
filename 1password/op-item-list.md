List items.

Returns a list of all items the account has read access to by default. Use flags to filter results.
Excludes items in the Archive by default.

Categories are:

    API Credential    Bank Account              Credit Card
    Database          Document                  Driver License
    Email Account     Identity                  Login
    Membership        Outdoor License           Passport
    Password          Reward Program            Secure Note
    Server            Social Security Number    Software License
    SSH Key           Wireless Router

Usage:  op item list [flags]

Aliases:
  list, ls

Examples:
Get details for all items with a specified tag:

  op item list --tags documentation --format=json | op item get -

Get a CSV list of the username, and password for all logins in a vault:

  op item list --categories Login --vault Staging --format=json | op item get - --fields username,password
	
Selecting a tag '<tag>' will also return items with tags sub-nested to '<tag>'. For example: '<tag/subtag>'.

Flags:
      --categories categories   Only list items in these categories (comma-separated).
      --favorite                Only list favorite items
  -h, --help                    help for list
      --include-archive         Include items in the Archive. Can also be set using OP_INCLUDE_ARCHIVE environment variable.
      --long                    Output a more detailed item list.
      --tags tags               Only list items with these tags (comma-separated).
      --vault vault             Only list items in this vault.

To list the global flags available on every command, run  'op --help'.
