Name:           sqlite
Version:        3.22.0
Release:        1%{?dist}
Summary:        The SQLite package is a software library that implements a self-contained, serverless, zero-configuration, transactional SQL database engine.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          Applications/Databases
License:        None
URL:            https://sqlite.org/
Source0:        https://sqlite.org/2018/sqlite-autoconf-3220000.tar.gz
Source1:		https://sqlite.org/2018/sqlite-doc-3220000.zip

%description
The SQLite package is a software library that implements a self-contained, serverless, zero-configuration, transactional SQL database engine.

%prep
%setup -q -n sqlite-autoconf-3220000
#setup -q -T -D -a 1
/usr/bin/unzip $RPM_SOURCE_DIR/sqlite-doc-3220000.zip

%build
%configure --prefix=/usr     \
            --disable-static  \
            --enable-fts5     \
            CFLAGS="-g -O2                    \
            -DSQLITE_ENABLE_FTS4=1            \
            -DSQLITE_ENABLE_COLUMN_METADATA=1 \
            -DSQLITE_ENABLE_UNLOCK_NOTIFY=1   \
            -DSQLITE_ENABLE_DBSTAT_VTAB=1     \
            -DSQLITE_SECURE_DELETE=1          \
            -DSQLITE_ENABLE_FTS3_TOKENIZER=1"
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

install -v -m755 -d $RPM_BUILD_ROOT%{_docdir}/%{name}-%{version}
cp -v -R sqlite-doc-3220000/* $RPM_BUILD_ROOT%{_docdir}/%{name}-%{version}

find $RPM_BUILD_ROOT -name "*.la" -delete

%clean
rm -rf $RPM_BUILD_ROOT
#rm -rf $RPM_BUILD_DIR

%files
%{_bindir}/*
%{_libdir}/*.so*
%doc %{_docdir}/%{name}-%{version}/*
%doc %{_mandir}/*/*

%package devel
Summary: Development files for %{name}.

%description devel
Development files for %{name}.

%files devel
%{_includedir}/*
%{_libdir}/pkgconfig/*.pc

%changelog
*	Sun Oct 21 2018 Samuel Raynor <samuel@samuelraynor.com> 3.22.0-1
-	Initial build.
