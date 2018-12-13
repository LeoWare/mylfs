Name:           autoconf213
Version:        2.13
Release:        1%{?dist}
Summary:        Autoconf2.13 is an old version of Autoconf .

License:        TBD
URL:            https://www.gnu.org/software/autoconf/
Source0:        https://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz
Patch0:			http://www.linuxfromscratch.org/patches/blfs/8.2/autoconf-2.13-consolidated_fixes-1.patch

Provides: perl(find.pl)

%description
Autoconf2.13 is an old version of Autoconf . This old version accepts switches which are not valid in more recent versions. Now that firefox has started to use python2 for configuring, this old version is required even if configure files have not been changed.

%prep
%setup -q -n autoconf-2.13
%patch -P 0 -p1
mv -v autoconf.texi autoconf213.texi
rm -v autoconf.info

%build
%configure --program-suffix=2.13
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
install -v -m644 autoconf213.info $RPM_BUILD_ROOT/usr/share/info
cat > $RPM_BUILD_ROOT%{_datadir}/autoconf-2.13/find.pl << -EOF
# This library is deprecated and unmaintained. It is included for
# compatibility with Perl 4 scripts which may use it, but it will be
# removed in a future version of Perl. Please use the File::Find module
# instead.

# Usage:
#              require "find.pl";
#
#              &find('/foo','/bar');
#
#              sub wanted { ... }
#                            where wanted does whatever you want. $dir contains the
#                            current directory name, and $_ the current filename within
#                            that directory. $name contains "$dir/$_". You are cd'ed
#                            to $dir when the function is called. The function may
#                            set $prune to prune the tree.
#
# For example,
#
# find / -name .nfs\* -mtime +7 -exec rm -f {} \; -o -fstype nfs -prune
#
# corresponds to this
#
#              sub wanted {
#               /^\.nfs.*$/ &&
#               (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
#               int(-M _) > 7 &&
#               unlink($_)
#               ||
#               ($nlink || (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_))) &&
#               $dev < 0 &&
#               ($prune = 1);
#              }
#
# Set the variable $dont_use_nlink if you're using AFS, since AFS cheats.


use File::Find ();


*name                            = *File::Find::name;
*prune                            = *File::Find::prune;
*dir                            = *File::Find::dir;
*topdir                            = *File::Find::topdir;
*topdev                            = *File::Find::topdev;
*topino                            = *File::Find::topino;
*topmode              = *File::Find::topmode;
*topnlink              = *File::Find::topnlink;
 

sub find {
  &File::Find::find(\&wanted, @_);
}


1;
EOF

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%{_datadir}/autoconf-2.13/*
%{_infodir}/*


%changelog
*	Mon Dec 03 2018 Samuel Raynor <samuel@samuelraynor.com> 2.13-1
-	Initial build.