Name:           Perl-File-BaseDir
Version:        0.08
Release:        1%{?dist}
Summary:        The File::BaseDir module compares two perl data structures. 
Vendor:			LeoWare
Distribution:	MyLFS

Requires: perl(Module::Build) perl(File::Which) perl(IPC::System::Simple)

License:        Unknown
URL:            Localhost
Source0:        https://www.cpan.org/authors/id/K/KI/KIMRYAN/File-BaseDir-%{version}.tar.gz

%description
The File::BaseDir module compares two perl data structures. 

%prep
%setup -q -n File-BaseDir-%{version}

%build
perl Build.PL
./Build

%check
./Build test

%install
rm -rf $RPM_BUILD_ROOT
./Build --destdir=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files


%changelog
* Wed Nov 21 2018 Samuel Raynor <samuel@samuelraynor.com> 0.08-1
- Initial Build.