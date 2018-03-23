Summary:	The Vim package contains a powerful text editor.
Name:		vim
Version:	8.0.586
Release:	1
License:	Charityware
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Requires:	texinfo
Source0:	ftp://ftp.vim.org/pub/vim/unix/%{name}-%{version}.tar.bz2
%define	_optflags	-march=x86-64 -mtune=generic -O2 -pipe -fPIC
%description
	The Vim package contains a powerful text editor.
%prep
%setup -q -n %{NAME}80
	echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
	sed -i '/call/{s/split/xsplit/;s/303/492/}' src/testdir/test_recover.vim
%build
	./configure \
		--prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	install -vdm 755 %{buildroot}/etc/vimrc
	cat > /etc/vimrc <<- "EOF"
		" Begin /etc/vimrc

		set nocompatible
		set backspace=2
		set mouse=r
		syntax on
		if (&term == "xterm") || (&term == "putty")
			set background=dark
		endif

		" End /etc/vimrc
	EOF
	rm -rf %{buildroot}/usr/share/info/dir
	#	Copy license/copying file
	install -D -m644 README.txt %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	#	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man/d' filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 8.0.586-1
-	Initial build.	First version
