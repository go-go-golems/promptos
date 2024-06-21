Get details about an item. Specify the item by its name, ID, or sharing link.

If you have multiple items with the same name, or if you’re concerned about
API rate limits, specify the item by its ID or limit the scope of the search
with the '--vault' flag.

Learn more about IDs and caching:
https://developer.1password.com/docs/cli/reference

To retrieve the contents of a specific field, use 'op read' instead.

When using service accounts, you must specify a vault with the '--vault' flag
or through piped input.

SPECIFY ITEMS ON STANDARD INPUT

'op item get' treats each line of information on standard input (stdin) as an
object specifier.

You can also input a list or array of JSON objects, and the command will get an
item for any object that has an ID key. This is useful for passing information
from one command to another.

Usage:  op item get [{ <itemName> | <itemID> | <shareLink> | - }] [flags]

Examples:
Get details for all items with a specified tag:

	op item list --tags documentation --format json | op item get -

Get a CSV list of the username, and password for all logins in a vault:

	op item list --categories Login --vault Staging --format json | op item get - --fields label=username,label=password

Get a JSON object of an item's username and password fields:

	op item get Netflix --fields label=username,label=password --format json

Get a list of fields by type:

	op item get Netflix --fields type=concealed

Get an item's one-time password:

	op item get Google --otp

Retrieve a shareable link for the item referenced by ID:

	op item get kiramv6tpjijkuci7fig4lndta --vault "Ops Secrets" --share-link

Flags:
      --fields strings    Return data from specific fields. Use 'label=' to get the field by name or 'type=' to filter fields by type. Specify multiple
                          in a comma-separated list.
  -h, --help              help for get
      --include-archive   Include items in the Archive. Can also be set using OP_INCLUDE_ARCHIVE environment variable.
      --otp               Output the primary one-time password for this item.
      --reveal            Don't conceal the private SSH key when using human-readable output.
      --share-link        Get a shareable link for the item.
      --vault string      Look for the item in this vault.

To list the global flags available on every command, run  'op --help'.
