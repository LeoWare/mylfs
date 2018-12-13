Name:           alsa-tools
Version:        1.1.5
Release:        1%{?dist}
Summary:        The ALSA Tools package contains advanced tools for certain sound cards.

License:        TBD
URL:            http://alsa-project/org
Source0:        ftp://ftp.alsa-project.org/pub/tools/alsa-tools-1.1.5.tar.bz2

%description
The ALSA Tools package contains advanced tools for certain sound cards.

%prep
%setup -q
rm -rf qlo10k1 Makefile gitcompile


%build
for tool in *
do
  case $tool in
  	hdspconf )
		continue
	;;
	hdsploader )
		continue
	;;
	hdspmixer )
		continue
	;;
    seq )
      tool_dir=seq/sbiload
    ;;
    * )
      tool_dir=$tool
    ;;
  esac

  pushd $tool_dir
    %configure --without-fltk
    make %{?_smp_mflags}
  popd

done
unset tool tool_dir


%install
rm -rf $RPM_BUILD_ROOT
for tool in *
do
  case $tool in
    hdspconf )
		continue
	;;
	hdsploader )
		continue
	;;
	hdspmixer )
		continue
	;;
    seq )
      tool_dir=seq/sbiload
    ;;
    * )
      tool_dir=$tool
    ;;
  esac

  pushd $tool_dir
    make install DESTDIR=$RPM_BUILD_ROOT
    /sbin/ldconfig
  popd

done
unset tool tool_dir


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_sysconfdir}/hotplug/*
%{_bindir}/*
%{_lib64dir}/*
%{_sbindir}/*
%{_datadir}/ld10k1/*
%doc %{_mandir}/*/*
%{_datadir}/sounds/*

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Summary: Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_datadir}/aclocal/*

%changelog
*	Sat Dec 01 2018 Samuel Raynor <samuel@samuelraynor.com> 1.1.5-1
-	Initial build.