# Learning RPM packaging

The notes below derive from this
[guide](https://access.redhat.com/sites/default/files/attachments/rpm_building_practice_10082013.pdf).
Procedures for signing below come from
[here](https://gist.github.com/fernandoaleman/1376720/aaff3a7a7ede636b6913f17d97e6fe39b5a79dc0)
and [here](http://cholla.mmto.org/computers/linux/rpm/signing.html). 

## Get source package to practice on

Grab a .src.rpm to learn from:

    wget ftp://ftp.redhat.com/pub/redhat/linux/enterprise/6Workstation/en/os/SRPMS/tree-1.5.3-2.el6.src.rpm

Expand it:

    rpm -ihv tree-1.5.3-2.el6.src.rpm

Notice rpmbuild directory appears in ~

    find rpmbuild/
    rpmbuild/
    rpmbuild/SPECS
    rpmbuild/SPECS/tree.spec
    rpmbuild/SOURCES
    rpmbuild/SOURCES/tree-no-color-by-default.patch
    rpmbuild/SOURCES/tree-1.5.3.tgz
    rpmbuild/SOURCES/tree-1.2-carrot.patch
    rpmbuild/SOURCES/tree-preserve-timestamps.patch
    rpmbuild/SOURCES/tree-1.2-no-strip.patch
    
Note rpmbuild/SPECS/tree.spec.  

To continue we need some packages:

    sudo yum install rpm-build
    sudo yum install rpm-sign

## Build the RPM (source and binary):

    rpmbuild -ba ~/rpmbuild/SPECS/tree.spec

See resulting RPM's:

    find rpmbuild/ | grep .rpm
    rpmbuild/RPMS/x86_64/tree-1.5.3-2.amzn1.x86_64.rpm
    rpmbuild/SRPMS/tree-1.5.3-2.amzn1.src.rpm

## Sign the RPM

### Initial set up

Create `~/.rpmmacros`:

    %_signature gpg
    %_gpg_path /home/<USERNAME>/.gnupg
    %_gpg_name <YOUR NAME>
    %_gpgbin /usr/bin/gpg

The name should match the one used in the `gpg gen-key` step.

### Sign during build:

    rpmbuild -ba --sign ~/rpmbuild/SPECS/tree.spec

Alternatively, an RPM can be signed after the fact.

    rpm --addsign ~/rpmbuild/RPMS/x86_64/tree-1.5.3-2.amzn1.x86_64.rpm

## Verify signature

Verify an RPM against the keys known to RPM:

    rpm --checksig ~/rpmbuild/RPMS/x86_64/tree-1.5.3-2.amzn1.x86_64.rpm

If it fails, import your public key to RPM database:

    gpg --export -a "<YOUR NAME>" > ~/RPM-GPG-KEY-<username>
    sudo rpm --import ~/RPM-GPG-KEY-<username>
    rm ~/RPM-GPG-KEY-<username>

View the list of gpg public keys in RPM DB:

    rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n'

Now try to verify again:

    rpm --checksig ~/rpmbuild/RPMS/x86_64/tree-1.5.3-2.amzn1.x86_64.rpm

Or on the SRPM:

    rpm --checksig ~/rpmbuild/SRPMS/tree-1.5.3-2.amzn1.src.rpm
    ... rsa sha1 (md5) pgp md5 OK

If you remove our key from the RPM database then checksig fails:

    sudo rpm -e gpg-pubkey-<keyname>
    rpm --checksig ~/rpmbuild/SRPMS/tree-1.5.3-2.amzn1.src.rpm
    ...  NOT OK (MISSING KEYS: (MD5) PGP#7048d6a5)

