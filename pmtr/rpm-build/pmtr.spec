# This version installs the pmtr binary, an empty pmtr.conf a systemd unit file

%{?systemd_requires}
BuildRequires: systemd

Summary: pmtr process supervisor
Name: pmtr
Version: 17.11
Release: 1%{?dist}
Group: System Environment/Daemons
License: MIT
Url: https://troydhanson.github.io/pmtr/
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

# Packager, retrieve upstream source and rename it using:
# VERSION=17.11
# UPSTREAM=https://github.com/troydhanson/pmtr/archive/v${VERSION}.tar.gz
# wget -O ~/rpmbuild/SOURCES/pmtr-v${VERSION}.tar.gz  ${UPSTREAM}
Source: %{name}-v%{version}.tar.gz

%description
A lightweight process supervisor with everything in one config file.

%prep
%setup -q

%build
autoreconf -ivf
./configure --sysconfdir=%{_sysconfdir}     \
            --bindir=%{_bindir}             \
             CFLAGS="${RPM_OPT_FLAGS}"
make

%install
rm -rf ${RPM_BUILD_ROOT}
mkdir -p ${RPM_BUILD_ROOT}%{_bindir}     \
         ${RPM_BUILD_ROOT}%{_sysconfdir} \
         ${RPM_BUILD_ROOT}%{_unitdir}
make DESTDIR=${RPM_BUILD_ROOT} install
touch ${RPM_BUILD_ROOT}%{_sysconfdir}/pmtr.conf
cp initscripts/systemd.template ${RPM_BUILD_ROOT}%{_unitdir}/pmtr.service
sed -i s^__SYSBINDIR__^%{_bindir}^ ${RPM_BUILD_ROOT}%{_unitdir}/pmtr.service

%clean
rm -rf ${RPM_BUILD_ROOT}

%files
%defattr(-,root,root)
%{_bindir}/pmtr
%{_unitdir}/pmtr.service
%config %{_sysconfdir}/pmtr.conf 

# systemd
%post
%systemd_post pmtr.service

%preun
%systemd_preun pmtr.service

%postun
%systemd_postun_with_restart pmtr.service

