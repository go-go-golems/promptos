Permanently delete an item. 

Use the '--archive' option to move it to the Archive instead.

An item may be specified by its name, ID, or sharing link.

SPECIFY ITEMS ON STANDARD INPUT

The command treats each line of information on standard input (stdin) as
an object specifier. Run 'op help' to learn more about how to specify
objects.

The input can also be a list or array of JSON objects. The command will
get an item for any object that has an ID. This is useful for
passing information from one 'op' command to another.

Usage:  op item delete [{ <itemName> | <itemID> | <shareLink> | - }] [flags]

Aliases:
  delete, remove, rm

Examples:
Permanently delete an item:

    op item delete "Defunct Login"    

Move an item to the Archive:

    op item delete "Defunct Login" --archive

Flags:
      --archive        Move the item to the Archive.
  -h, --help           help for delete
      --vault string   Look for the item in this vault.

To list the global flags available on every command, run  'op --help'.
