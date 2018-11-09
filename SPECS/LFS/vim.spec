Summary:	Text editor
Name:		vim
Version:	8.0.586
Release:	1
License:	Charityware
URL:		http://www.vim.org
Group:		Applications/Editors
Vendor:		LeoWare
Distribution:	MyLFS
Source:		%{name}-%{version}.tar.bz2

%description
The Vim package contains a powerful text editor.

%prep
%setup -q -n %{name}80
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
sed -i '/call/{s/split/xsplit/;s/303/492/}' src/testdir/test_recover.vim

%build
./configure \
	--prefix=%{_prefix} \
	--enable-multibyte
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=%{buildroot} install
ln -sv vim %{buildroot}%{_bindir}/vi
for L in  $RPM_BUILD_ROOT/usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done
install -vdm 755 $RPM_BUILD_ROOT%{_docdir}
ln -sv ../vim/vim80/doc $RPM_BUILD_ROOT%{_docdir}/%{name}-%{version}

install -vdm 755 %{buildroot}/etc
cat > %{buildroot}%{_sysconfdir}/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1 

set nocompatible
set backspace=2
set mouse=a
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
"
EOF

%files
%defattr(-,root,root)
%config(noreplace) /etc/vimrc
%{_bindir}/*
%doc %{_mandir}/*/*
%doc %{_datarootdir}/vim/vim80/doc/*
%{_docdir}/%{name}-%{version}
%{_datarootdir}/applications/*.desktop
%{_datarootdir}/icons/*
%{_datarootdir}/vim/vim80/defaults.vim
%{_datarootdir}/vim/vim80/rgb.txt
%{_datarootdir}/vim/vim80/pack/*
%{_datarootdir}/vim/vim80/autoload/*
%{_datarootdir}/vim/vim80/bugreport.vim
%{_datarootdir}/vim/vim80/colors/*
%{_datarootdir}/vim/vim80/compiler/*
%{_datarootdir}/vim/vim80/delmenu.vim
%{_datarootdir}/vim/vim80/evim.vim
%{_datarootdir}/vim/vim80/filetype.vim
%{_datarootdir}/vim/vim80/ftoff.vim
%{_datarootdir}/vim/vim80/ftplugin.vim
%{_datarootdir}/vim/vim80/ftplugin/*
%{_datarootdir}/vim/vim80/ftplugof.vim
%{_datarootdir}/vim/vim80/gvimrc_example.vim
%{_datarootdir}/vim/vim80/indent.vim
%{_datarootdir}/vim/vim80/indent/*
%{_datarootdir}/vim/vim80/indoff.vim
%{_datarootdir}/vim/vim80/keymap/*
%{_datarootdir}/vim/vim80/macros/*
%{_datarootdir}/vim/vim80/menu.vim
%{_datarootdir}/vim/vim80/mswin.vim
%{_datarootdir}/vim/vim80/optwin.vim
%{_datarootdir}/vim/vim80/plugin/*
%{_datarootdir}/vim/vim80/synmenu.vim
%{_datarootdir}/vim/vim80/vimrc_example.vim
%{_datarootdir}/vim/vim80/print/*
%{_datarootdir}/vim/vim80/scripts.vim
%{_datarootdir}/vim/vim80/spell/*
%{_datarootdir}/vim/vim80/syntax/*
%{_datarootdir}/vim/vim80/tools/*
%{_datarootdir}/vim/vim80/tutor/*
%{_datarootdir}/vim/vim80/lang/*.vim
%doc %{_datarootdir}/vim/vim80/lang/*.txt
%lang(af) %{_datarootdir}/vim/vim80/lang/af/LC_MESSAGES/vim.mo
%lang(ca) %{_datarootdir}/vim/vim80/lang/ca/LC_MESSAGES/vim.mo
%lang(cs) %{_datarootdir}/vim/vim80/lang/cs/LC_MESSAGES/vim.mo
%lang(de) %{_datarootdir}/vim/vim80/lang/de/LC_MESSAGES/vim.mo
%lang(eb_GB) %{_datarootdir}/vim/vim80/lang/en_GB/LC_MESSAGES/vim.mo
%lang(eo) %{_datarootdir}/vim/vim80/lang/eo/LC_MESSAGES/vim.mo
%lang(es) %{_datarootdir}/vim/vim80/lang/es/LC_MESSAGES/vim.mo
%lang(fi) %{_datarootdir}/vim/vim80/lang/fi/LC_MESSAGES/vim.mo
%lang(fr) %{_datarootdir}/vim/vim80/lang/fr/LC_MESSAGES/vim.mo
%lang(ga) %{_datarootdir}/vim/vim80/lang/ga/LC_MESSAGES/vim.mo
%lang(it) %{_datarootdir}/vim/vim80/lang/it/LC_MESSAGES/vim.mo
%lang(ja) %{_datarootdir}/vim/vim80/lang/ja/LC_MESSAGES/vim.mo
%lang(ko.UTF-8) %{_datarootdir}/vim/vim80/lang/ko.UTF-8/LC_MESSAGES/vim.mo
%lang(ko) %{_datarootdir}/vim/vim80/lang/ko/LC_MESSAGES/vim.mo
%lang(nb) %{_datarootdir}/vim/vim80/lang/nb/LC_MESSAGES/vim.mo
%lang(no) %{_datarootdir}/vim/vim80/lang/no/LC_MESSAGES/vim.mo
%lang(pl) %{_datarootdir}/vim/vim80/lang/pl/LC_MESSAGES/vim.mo
%lang(pt_BR) %{_datarootdir}/vim/vim80/lang/pt_BR/LC_MESSAGES/vim.mo
%lang(ru) %{_datarootdir}/vim/vim80/lang/ru/LC_MESSAGES/vim.mo
%lang(sk) %{_datarootdir}/vim/vim80/lang/sk/LC_MESSAGES/vim.mo
%lang(sv) %{_datarootdir}/vim/vim80/lang/sv/LC_MESSAGES/vim.mo
%lang(uk) %{_datarootdir}/vim/vim80/lang/uk/LC_MESSAGES/vim.mo
%lang(vi) %{_datarootdir}/vim/vim80/lang/vi/LC_MESSAGES/vim.mo
%lang(zh_CN.UTF-8) %{_datarootdir}/vim/vim80/lang/zh_CN.UTF-8/LC_MESSAGES/vim.mo
%lang(zh_CN) %{_datarootdir}/vim/vim80/lang/zh_CN/LC_MESSAGES/vim.mo
%lang(zh_TW.UTF-8) %{_datarootdir}/vim/vim80/lang/zh_TW.UTF-8/LC_MESSAGES/vim.mo
%lang(zh_TW) %{_datarootdir}/vim/vim80/lang/zh_TW/LC_MESSAGES/vim.mo
%lang(cs.cp1250)  %{_datarootdir}/vim/vim80/lang/cs.cp1250/LC_MESSAGES/vim.mo
%lang(ja.euc-jp)  %{_datarootdir}/vim/vim80/lang/ja.euc-jp/LC_MESSAGES/vim.mo
%lang(ja.sjis)    %{_datarootdir}/vim/vim80/lang/ja.sjis/LC_MESSAGES/vim.mo
%lang(nl) 	  %{_datarootdir}/vim/vim80/lang/nl/LC_MESSAGES/vim.mo
%lang(pl.UTF-8)   %{_datarootdir}/vim/vim80/lang/pl.UTF-8/LC_MESSAGES/vim.mo
%lang(pl.cp1250)  %{_datarootdir}/vim/vim80/lang/pl.cp1250/LC_MESSAGES/vim.mo
%lang(ru.cp1251)  %{_datarootdir}/vim/vim80/lang/ru.cp1251/LC_MESSAGES/vim.mo
%lang(sk.cp1250)  %{_datarootdir}/vim/vim80/lang/sk.cp1250/LC_MESSAGES/vim.mo
%lang(uk.cp1251)  %{_datarootdir}/vim/vim80/lang/uk.cp1251/LC_MESSAGES/vim.mo
%lang(zh_CN.cp936) %{_datarootdir}/vim/vim80/lang/zh_CN.cp936/LC_MESSAGES/vim.mo

%changelog
*	Tue Oct 16 2018 Samuel Raynor <samuel@samuelraynor.com> 8.0.586-1
-	Initial build.
