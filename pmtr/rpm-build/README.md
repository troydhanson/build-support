# RPM build

For authoritative information see the [RPM Packaging
Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/rpm_packaging_guide/).

## Initial setup

### Get packages

Install rpm-build and rpm-sign:

    sudo yum install rpm-build
    sudo yum install rpm-sign
    sudo yum install rpmlint
    sudo yum install rpmdevtools

### Set up signing key

See [GPG-setup](./GPG-setup.md).

Edit `~/.rpmmacros` to reference the key:

    %_signature gpg
    %_gpg_path /home/<USERNAME>/.gnupg
    %_gpg_name <YOUR NAME>
    %_gpgbin /usr/bin/gpg

The name should match the one used in the `gpg gen-key` step.

# Building a pmtr RPM

## Option 1: Set up RPM build directory (from scratch)

If you already have a src RPM, skip this section and use "Option 2" instead. 

### Construct the source RPM hierarchy.

You could just make the ~/rpmbuild directory and its subdirectories, but
rpmdevtools includes a utility to do it for you:

    rpmdev-setuptree

You can see its result:

    find ~/rpmbuild
    rpmbuild
    rpmbuild/RPMS
    rpmbuild/SOURCES
    rpmbuild/SPECS
    rpmbuild/SRPMS
    rpmbuild/BUILD

### Set up the SPEC file:

The rpmdevtools package includes a utility to set up a starting spec file:

    cd ~/rpmbuild/SPECS
    rpmdev-newspec pmtr.spec

However for these notes we will just copy in the one from this directory:

    cp <this-directory>/pmtr.spec ~/rpmbuild/SPECS/

You can "lint" the spec file, to see if it has any warnings:

    rpmlint ~/rpmbuild/SPECS/pmtr.spec

### Get the upstream source

You can see the sources that the SPEC file expects using grep:

    cd ~/rpmbuild
    grep Source SPECS/pmtr.spec 
    Source: https://github.com/troydhanson/${name}/archive/v%{version}.tar.gz

    grep Version SPECS/pmtr.spec
    Version: 17.11

We retrieve the needed source tarball:

    VERSION=17.11
    UPSTREAM=https://github.com/troydhanson/pmtr/archive/v${VERSION}.tar.gz
    wget -O ~/rpmbuild/SOURCES/pmtr-v${VERSION}.tar.gz  ${UPSTREAM}

### Build all (source and binary RPM's):

    rpmbuild -ba --sign ~/rpmbuild/SPECS/pmtr.spec

## Option 2: Set up RPM build directory (from existing src RPM)

The src RPM encapsulates what you need to rebuild both src and binary RPM's.
If you already have the source RPM, there is no need to manually create the
~/rpmbuild directory and populate it. Instead we just install the src RPM.

Install the src RPM to populate the ~/rpmbuild directory:

    rpm -i pmtr-17.10-1.el7.src.rpm 
    ls  ~/rpmbuild
    SOURCES  SPECS

Issue the build all command. Afterward the RPMS and SRPMS are ready to use:

    rpmbuild -ba --sign ~/rpmbuild/SPECS/pmtr.spec 
    ls ~/rpmbuild
    BUILD  BUILDROOT  RPMS  SOURCES  SPECS  SRPMS

## Examine resulting packages

Look at package info:

    rpm -qip ~/rpmbuild/RPMS/x86_64/<.rpm>

Look at package files:

    rpm -qlp ~/rpmbuild/RPMS/x86_64/<.rpm>

## Verify signatures

Verify an RPM against the keys known to RPM:

    rpm --checksig <.rpm>

If it fails, import your public key to RPM database:

    gpg --export -a "<YOUR NAME>" > ~/RPM-GPG-KEY-<username>
    sudo rpm --import ~/RPM-GPG-KEY-<username>
    rm ~/RPM-GPG-KEY-<username>

View the list of gpg public keys in RPM DB:

    rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n'

Now try to verify again:

    rpm --checksig <.rpm>

To remove our key from the RPM database and see that it makes checksig fail:

    sudo rpm -e gpg-pubkey-<keyname>
    rpm --checksig <.src.rpm>
    ...  NOT OK (MISSING KEYS: (MD5) PGP#7048d6a5)

