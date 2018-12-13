Name:           ffmpeg
Version:        3.4.2
Release:        1%{?dist}
Summary:        FFmpeg is a solution to record, convert and stream audio and video.

License:        GPLv2
URL:            http://ffmpeg.org/
Source0:        http://ffmpeg.org/releases/ffmpeg-3.4.2.tar.xz

BuildRequires:  libass, libass-devel, fdk-aac, fdk-aac-devel, freetype, freetype-devel
BuildRequires:  lame, lame-devel, libtheora, libtheora-devel, libvorbis, libvorbis-devel
BuildRequires:  libvpx, libvpx-devel, opus, opus-devel, x264, x264-devel, x265, x265-devel
BuildRequires:  yasm, yasm-devel

%description
FFmpeg is a solution to record, convert and stream audio and video. It is a very fast video and audio converter and it can also acquire from a live audio/video source. Designed to be intuitive, the command-line interface (ffmpeg) tries to figure out all the parameters, when possible. FFmpeg can also convert from any sample rate to any other, and resize video on the fly with a high quality polyphase filter. FFmpeg can use a Video4Linux compatible video source and any Open Sound System audio source.

%prep
%setup -q
sed -i 's/-lflite"/-lflite -lasound"/' configure

%build
./configure --prefix=/usr \
			--libdir=/usr/lib64 \
			--disable-rpath \
			--enable-gpl         \
            --enable-version3    \
            --enable-nonfree     \
            --disable-static     \
            --enable-shared      \
            --disable-debug      \
            --enable-libass      \
            --enable-libfdk-aac  \
            --enable-libfreetype \
            --enable-libmp3lame  \
            --enable-libopus     \
            --enable-libtheora   \
            --enable-libvorbis   \
            --enable-libvpx      \
            --enable-libx264     \
            --enable-libx265     \
            --docdir=/usr/share/doc/ffmpeg-3.4.2
make %{?_smp_mflags}
gcc tools/qt-faststart.c -o tools/qt-faststart

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

install -v -m755    tools/qt-faststart $RPM_BUILD_ROOT/usr/bin &&
install -v -m755 -d           $RPM_BUILD_ROOT/usr/share/doc/ffmpeg-3.4.2 &&
install -v -m644    doc/*.txt $RPM_BUILD_ROOT/usr/share/doc/ffmpeg-3.4.2

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{!?_licensedir:%global license %%doc}
%license add-license-file-here
%doc add-docs-here



%changelog
*	Tue Dec 04 2018 Samuel Raynor <samuel@samuelraynor.com> 3.6.2-1
-	Initial build.