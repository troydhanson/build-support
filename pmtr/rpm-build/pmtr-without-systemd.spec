Summary: pmtr process supervisor
Name: pmtr
Version: 17.10
Release: 1%{?dist}
Group: System Environment/Daemons
License: MIT
Url: https://troydhanson.github.io/pmtr/
Source: https://github.com/troydhanson/pmtr/archive/%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

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
         ${RPM_BUILD_ROOT}%{_sysconfdir}
make DESTDIR=${RPM_BUILD_ROOT} install
touch ${RPM_BUILD_ROOT}%{_sysconfdir}/pmtr.conf

%clean
rm -rf ${RPM_BUILD_ROOT}

%files
%defattr(-,root,root)
%{_bindir}/pmtr
%config %{_sysconfdir}/pmtr.conf 

