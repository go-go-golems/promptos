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
