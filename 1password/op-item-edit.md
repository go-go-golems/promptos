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
