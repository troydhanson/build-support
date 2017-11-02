# Quick RPM bump notes

## bump pmtr revision

    cd pmtr
    git tag -a -s v17.11 
    git push --tags

## grab previous source RPM

    VERSION=17.11
    SRPM=pmtr-${VERSION}-1.el7.src.rpm
    URL=https://packagecloud.io/troydhanson/pmtr/packages/el/7/${SRPM}/download.rpm
    wget --content-disposition $URL

## install previous source RPM into ~/rpmbuild

    rpm -i $SRPM

## bump SPEC file in ~rpmbuild/SPECS

    vi ~/rpmbuild/SPECS/pmtr.spec

Edit the "Version" line to match the new tag. E.g. Version: 17.11 for tag v17.11.

## Grab new upstream source into ~rpmbuld/SOURCES

    UPSTREAM=https://github.com/troydhanson/pmtr/archive/v${VERSION}.tar.gz
    wget -O ~/rpmbuild/SOURCES/pmtr-v${VERSION}.tar.gz ${UPSTREAM}

## Build all

    rpmbuild -ba --sign ~/rpmbuild/SPECS/pmtr.spec

## Upload new SRPMS and RPMS

Browse to https://packagecloud.io/troydhanson/pmtr


