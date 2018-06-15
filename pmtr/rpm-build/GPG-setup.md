# Setting up a PGP public key 

## Generate

    gpg --gen-key 

The directory ~/.gnupg gets created

## List keys

   gpg -K

## Export public key

    gpg -a --export <keyid>

### Sharing public key

The public key can now be uploaded to GitHub, shared on public sites, etc.
It can be populated into public key servers, where it is associated with the
email address you entered when creating the key.

    gpg --keyserver hkp://pgp.mit.edu --send-key <keyid>
    gpg --keyserver hkp://keyserver.ubuntu.com --send-key <keyid>
    gpg --keyserver hkp://pool.sks-keyservers.net --send-key <keyid>

It can also be uploaded to [PGP Global Directory](https://keyserver.pgp.com).

## Git integraton

Set up git to sign commits by default, and tell it what key to use.

    git config --global commit.gpgsign true
    gpg --list-secret-keys --keyid-format LONG
    git config --global user.signingkey <keyid>

The <keyid> is the long, 40-hex character identifier
listed on the line after the `sec rsa2048/...` line 
in the key listing.

Set this environment variable to help GPG prompt for passphrase:

    echo 'export GPG_TTY=$(tty)' >> ~/.bash_profile

or

    echo 'export GPG_TTY=$(tty)' >> ~/.bashrc
