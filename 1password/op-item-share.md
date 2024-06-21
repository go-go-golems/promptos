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
