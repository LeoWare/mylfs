Name:           alsa-utils
Version:        1.1.5
Release:        1%{?dist}
Summary:        The ALSA Utilities package contains various utilities which are useful for controlling your sound card.

License:        TBD
URL:            http://alsa-project.org
Source0:        ftp://ftp.alsa-project.org/pub/utils/%{name}-%{version}.tar.bz2

%description
The ALSA Utilities package contains various utilities which are useful for controlling your sound card.

%prep
%setup -q


%build
%configure --disable-alsaconf --with-curses=ncursesw
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT


%files
#% {!?_licensedir:% global license %%doc}
#% doc % {_docdir}/% {name}-% {version}/*
   /lib/systemd/system/alsa-restore.service
   /lib/systemd/system/alsa-state.service
   /lib/systemd/system/sound.target.wants/alsa-restore.service
   /lib/systemd/system/sound.target.wants/alsa-state.service
   /lib/udev/rules.d/90-alsa-restore.rules
   %{_bindir}/aconnect
   %{_bindir}/alsabat
   %{_bindir}/alsaloop
   %{_bindir}/alsamixer
   %{_bindir}/alsatplg
   %{_bindir}/alsaucm
   %{_bindir}/amidi
   %{_bindir}/amixer
   %{_bindir}/aplay
   %{_bindir}/aplaymidi
   %{_bindir}/arecord
   %{_bindir}/arecordmidi
   %{_bindir}/aseqdump
   %{_bindir}/aseqnet
   %{_bindir}/iecset
   %{_bindir}/speaker-test
   %{_sbindir}/alsa-info.sh
   %{_sbindir}/alsabat-test.sh
   %{_sbindir}/alsactl
   %{_datadir}/alsa/init/00main
   %{_datadir}/alsa/init/ca0106
   %{_datadir}/alsa/init/default
   %{_datadir}/alsa/init/hda
   %{_datadir}/alsa/init/help
   %{_datadir}/alsa/init/info
   %{_datadir}/alsa/init/test
   %{_datadir}/alsa/speaker-test/sample_map.csv
   %{_datadir}/locale/de/LC_MESSAGES/alsa-utils.mo
   %{_datadir}/locale/fr/LC_MESSAGES/alsa-utils.mo
   %{_datadir}/locale/ja/LC_MESSAGES/alsa-utils.mo
   %{_mandir}/man1/aconnect.1.gz
   %{_mandir}/man1/alsa-info.sh.1.gz
   %{_mandir}/man1/alsabat.1.gz
   %{_mandir}/man1/alsactl.1.gz
   %{_mandir}/man1/alsaloop.1.gz
   %{_mandir}/man1/alsamixer.1.gz
   %{_mandir}/man1/amidi.1.gz
   %{_mandir}/man1/amixer.1.gz
   %{_mandir}/man1/aplay.1.gz
   %{_mandir}/man1/aplaymidi.1.gz
   %{_mandir}/man1/arecord.1.gz
   %{_mandir}/man1/arecordmidi.1.gz
   %{_mandir}/man1/aseqdump.1.gz
   %{_mandir}/man1/aseqnet.1.gz
   %{_mandir}/man1/iecset.1.gz
   %{_mandir}/man1/speaker-test.1.gz
   %{_mandir}/man7/alsactl_init.7.gz
   %{_datadir}/sounds/alsa/*


%changelog
*	Sat Dec 01 2018 Samuel Raynor <samuel@samuelraynor.com> 1.1.5-1
-	Initial build.