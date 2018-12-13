Name:           bogofilter
Version:        1.2.4
Release:        1%{?dist}
Summary:        The Bogofilter application is a mail filter that classifies mail as spam or ham (non-spam) by a statistical analysis of the message's header and content (body).
Vendor:			LeoWare
Distribution:	MyLFS

Group:          Applications/System
License:        GPLv2
URL:            http://asciidoc.org
Source0:        https://downloads.sourceforge.net/bogofilter/bogofilter-1.2.4.tar.gz

%description
The Bogofilter application is a mail filter that classifies mail as spam or ham (non-spam) by a statistical analysis of the message's header and content (body).

%prep
%setup -q


%build
%configure --sysconfdir=/etc/bogofilter
make %{?_smp_mflags}

%check

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT

%files
/etc/bogofilter/bogofilter.cf.example
/usr/bin/bf_compact
/usr/bin/bf_copy
/usr/bin/bf_tar
/usr/bin/bogofilter
/usr/bin/bogolexer
/usr/bin/bogotune
/usr/bin/bogoupgrade
/usr/bin/bogoutil
/usr/share/man/man1/bf_compact.1.gz
/usr/share/man/man1/bf_copy.1.gz
/usr/share/man/man1/bf_tar.1.gz
/usr/share/man/man1/bogofilter.1.gz
/usr/share/man/man1/bogolexer.1.gz
/usr/share/man/man1/bogotune.1.gz
/usr/share/man/man1/bogoupgrade.1.gz
/usr/share/man/man1/bogoutil.1.gz


%changelog
*	Wed Nov 14 2018 Samuel Raynor <samuel@samuelraynor.com> 1.2.4-1
-	Initial build.