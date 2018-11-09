Name:           cracklib
Version:        2.9.6
Release:        1%{?dist}
Summary:        The CrackLib package contains a library used to enforce strong passwords by comparing user selected passwords to words in chosen word lists.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          System Environment/Libraries
License:        LGPLv2
URL:            https://github.com/cracklib/cracklib
Source0:        https://github.com/cracklib/cracklib/releases/download/cracklib-2.9.6/cracklib-2.9.6.tar.gz
Source1:		https://github.com/cracklib/cracklib/releases/download/cracklib-2.9.6/cracklib-words-2.9.6.gz

%description
The CrackLib package contains a library used to enforce strong passwords by comparing user selected passwords to words in chosen word lists.

%prep
%setup -q
sed -i '/skipping/d' util/packer.c

%build
./configure --prefix=/usr    \
            --disable-static \
            --with-default-dict=/lib/cracklib/pw_dict
make %{?_smp_mflags}

%check
make test

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
install -v -m755 -d $RPM_BUILD_ROOT/lib

mv -v $RPM_BUILD_ROOT/usr/lib/libcrack.so.* $RPM_BUILD_ROOT/lib
ln -sfv ../../lib/$(readlink $RPM_BUILD_ROOT/usr/lib/libcrack.so) $RPM_BUILD_ROOT/usr/lib/libcrack.so

install -v -m644 -D $RPM_SOURCE_DIR/cracklib-words-2.9.6.gz \
                    $RPM_BUILD_ROOT/usr/share/dict/cracklib-words.gz
gunzip -v $RPM_BUILD_ROOT/usr/share/dict/cracklib-words.gz
ln -v -sf cracklib-words $RPM_BUILD_ROOT/usr/share/dict/words
echo $(hostname) >> $RPM_BUILD_ROOT/usr/share/dict/cracklib-extra-words
install -v -m755 -d $RPM_BUILD_ROOT/lib/cracklib

create-cracklib-dict $RPM_BUILD_ROOT/usr/share/dict/cracklib-words \
                     $RPM_BUILD_ROOT/usr/share/dict/cracklib-extra-words
%find_lang %{name}

%clean
rm -rf $RPM_BUILD_ROOT


%files -f %{name}.lang
/lib/libcrack.so*
%{_libdir}/*
%{_datadir}/cracklib
%{_datadir}/dict
%{_sbindir}/*

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}.

%description devel
Development files for %{name}.

%files devel
%{_includedir}/*


%changelog
*	Tue Nov 6 2018 Samuel Raynor <samuel@samuelraynor.com> 2.9.2-1
-	Initial build.
