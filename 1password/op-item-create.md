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
