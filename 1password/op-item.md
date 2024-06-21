Create a new item.

Get a list of all item categories:

	op item template list

Use assignment statements or an item category JSON template to save details in
built-in or custom fields.

Learn more about creating items:
https://developer.1password.com/docs/cli/create-item/

Learn more about item fields and fieldTypes:
https://developer.1password.com/docs/cli/item-fields/


GENERATE A PASSWORD

Use the '--generate-password' option to set a random password for a Login
or Password item. The default is 32-characters, and includes upper and
lowercase letters, numbers, and symbols ('!@.-_*').

You can specify the password length (between 1 and 64 characters) and the
character types to use:

	--generate-password='letters,digits,symbols,32'


SET ADDITIONAL FIELDS WITH ASSIGNMENT STATEMENTS

You can use assignment statements as command arguments to set built-in and
custom fields.

	[<section>.]<field>[[<fieldType>]]=<value>

Command arguments get logged in your command history, and
can be visible to other processes on your machine. If you’re assigning
sensitive values, use a JSON template instead.

For example, to create a text field named "host" within a section named
"Database Credentials", with the value set to 33.166.240.221:

	DatabaseCredentials.host[text]=33.166.240.221

The section name is optional unless multiple sections contain fields with
the same name.

Use a backslash to escape periods, equal signs, or backslashes in section
or field names. Don’t use backslashes to escape the value.

You can omit spaces in the section or field name, or refer to the field by
its JSON short name ('name' or 'n').


CREATE AN ITEM USING A JSON TEMPLATE

Use an item JSON template to assign sensitive values to an item. If you
combine a template with assignment statements, assignment statements
take precedence.

1. Save the appropriate item category template to a file:

	op item template get --out-file login.json "Login"

2. Edit the template.
3. Create a new item using the '-—template' flag to specify the path to the
edited template:

	op item create --template=login.json

4. After 1Password CLI creates the item, delete the edited template.

You can also create an item from standard input using an item JSON template.
Pass the '-' character as the first argument, followed by any assignment
statements.

	op item template get Login | op item create --vault personal -

You can’t use both piping and the '--template' flag in the same command, to
avoid collisions.

Usage:  op item create [ - ] [ <assignment>... ] [flags]

Examples:
Create a Login item with a random password and website set using flags
and custom and built-in fields set with assignment statements, including
a one-time password field and a file attachment:

	op item create --category=login --title='My Example Item' --vault='Test' \
		--url https://www.acme.com/login \
		--generate-password=20,letters,digits \
		username[username]=jane@acme.com \
		'Test Section 1.Test Field3[otp]=otpauth://totp/<website>:<user>?secret=<secret>&issuer=<issuer>' \
		'FileName[file]=/path/to/your/file'

Create an item by duplicating an existing item from another vault and modifying
it with assignment statements:

	op item get "My Item" --format json | op item create --vault prod - \
	username="My Username" password="My Password"

Duplicate all items in a vault in one account to a vault in another account:

	op item list --vault test-vault --format json --account agilebits | \
	op item get --format json --account agilebits - | \
	op item create --account work -

Flags:
      --category category            Set the item's category.
      --dry-run                      Test the command and output a preview of the resulting item.
      --favorite                     Add item to favorites.
      --generate-password[=recipe]   Add a randomly-generated password to a Login or Password item.
  -h, --help                         help for create
      --ssh-generate-key             The type of SSH key to create: Ed25519 or RSA. For RSA, specify 2048, 3072, or 4096 (default) bits. Possible
                                     values: 'ed25519', 'rsa', 'rsa2048', 'rsa3072', 'rsa4096'. (default Ed25519)
      --tags tags                    Set the tags to the specified (comma-separated) values.
      --template string              Specify the file path to read an item template from.
      --title title                  Set the item's title.
      --url URL                      Set the URL associated with the item
      --vault vault                  Save the item in this vault. Default: Private.

To list the global flags available on every command, run  'op --help'.
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
Edit an item's details.

Specify the item by its name, ID, or sharing link. Use flags to update the
title, tags, or generate a new random password.

You can use assignment statements as command arguments to update built-in
or custom fields. For sensitive values, use a template instead.


EDIT AN ITEM USING ASSIGNMENT STATEMENTS

Caution: Command arguments can be visible to other
processes on your machine.

	[<section>.]<field>[[<fieldType>]]=<value>

To create a new field or section, specify a field or section name that doesn’t
already exist on the item.

To edit an existing field, specify the current section and field name, then make
changes to the fieldType or value. If you don’t specify a fieldType or value,
it will stay the same.

To delete a custom field, specify '[delete]' in place of the fieldType. If a
section no longer has any fields, the section will also be deleted. You can't
delete built-in fields, but you can set them to empty strings.

Learn more about assignment statements: 'op item create –-help'.

Learn more about available fields and fieldTypes:
https://developer.1password.com/docs/cli/item-fields

EDIT AN ITEM USING A TEMPLATE

You can use a JSON template to edit an item, alone or in combination with
command arguments. Field assignment statements overwrite values in the
template.

1. Get the item you want to edit in JSON format and save it to a file:

	op item get oldLogin --format=json > updatedLogin.json

2. Edit the file.

3. Use the '--template' flag to specify the path to the edited file and edit
the item:

	op item edit oldLogin --template=updatedLogin.json

4. Delete the file.

You can also edit an item using piped input:

	cat updatedLogin.json | op item edit oldLogin

To avoid collisions, you can't combine piped input and the '--template'
flag in the same command.

Usage:  op item edit { <itemName> | <itemID> | <shareLink> } [ <assignment> ... ] [flags]

Examples:
Add a 32-character random password that includes upper- and lower-case letters,
numbers, and symbols to an item:

	op item edit 'My Example Item' --generate-password='letters,digits,symbols,32'

Edit a custom field's value without changing the fieldType:

	op item edit 'My Example Item' 'field1=new value'

Edit a custom field's fieldType without changing the value:

	op item edit 'My Example Item' 'field1[password]'

Edit a custom field's type and value:

	op item edit 'My Example Item' 'field1[monthyear]=2021/09'

Remove an existing custom field:

	op item edit 'My Example Item' 'section2.field5[delete]'

Set the built-in username field to an empty value:

	op item edit 'My Example Item' 'username='


Flags:
      --dry-run                      Perform a dry run of the command and output a preview of the resulting item.
      --favorite                     Whether this item is a favorite item. Options: true, false
      --generate-password[=recipe]   Give the item a randomly generated password.
  -h, --help                         help for edit
      --tags tags                    Set the tags to the specified (comma-separated) values. An empty value will remove all tags.
      --template string              Specify the filepath to read an item template from.
      --title title                  Set the item's title.
      --url URL                      Set the URL associated with the item
      --vault vault                  Edit the item in this vault.

To list the global flags available on every command, run  'op --help'.
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
Move an item between vaults.
		
Moving an item creates a copy of the item in the destination vault and
deletes the item from the current vault. As a result, the item gets a new ID.

To restore or permanently delete the original item, find the item in Recently Deleted 
in your 1Password app or on 1Password.com.

Moving an item between vaults may change who has access to the item.

Usage:  op item move [{ <itemName> | <itemID> | <shareLink> | - }] [flags]

Aliases:
  move, mv

Examples:
Move an item from the Private vault to the Shared vault:

	op item move "My Example Item" --current-vault Private --destination-vault Shared

Flags:
      --current-vault string       Vault where the item is currently saved.
      --destination-vault string   The vault you want to move the item to.
  -h, --help                       help for move

To list the global flags available on every command, run  'op --help'.
Share an item.

You can securely share copies of passwords and other items you've saved in
1Password with anyone, even if they don't use 1Password.

When you share an item, you'll get a unique link that you can send to others.
Copy the URL, then send the link to the person or people you want to share
the item copy with, like in an email or text message. Anyone with the
link can view the item copy unless you specify addresses with the emails
flag.

If you edit an item, your changes won't be shared until you share the item
again. Note that file attachments and Document items cannot be shared.

Usage:  op item share { <itemName> | <itemID> } [flags]

Flags:
      --emails strings    Email addresses to share with.
      --expiry duration   Link expiring after the specified duration in (s)econds, (m)inutes, or (h)ours (default 7h).
  -h, --help              help for share
      --vault string      Look for the item in this vault.
      --view-once         Expire link after a single view.

To list the global flags available on every command, run  'op --help'.
