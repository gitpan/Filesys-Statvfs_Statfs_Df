use ExtUtils::MakeMaker;
use Config(%Config);

my $module_namespace = "Filesys::Statvfs";
my $module_name = "Statvfs.pm";


#### Create header with OS version.
open(CONFIG, ">config.h") or die "$! config.h";

($Config{osname} eq "hpux") &&
        (print CONFIG "#define _HPUX__\n");

($Config{osname} eq "dec_osf") &&
        (print CONFIG "#define _DEC__\n");

($Config{osname} eq "linux") &&
        (print CONFIG "#define _LINUX__\n");

($Config{osname} eq "aix") &&
        (print CONFIG "#define _AIX__\n");

($Config{osname} eq "solaris") &&
        (print CONFIG "#define _SOLARIS__\n");

($Config{osname} eq "darwin") &&
        (print CONFIG "#define _DARWIN__\n");

close(CONFIG);


#### Switch to statfs() for these systems
#### since they dont have statvfs().
#### I hope I have the correct OSes. :-P
if($Config{osname} eq "darwin" ||
   $Config{osname} eq "openbsd" ||
   $Config{osname} eq "freebsd") {
	$module_namespace = "Filesys::Statfs";
	$module_name = "Statfs.pm";

	# copy test.pl and df.pm
	open(FILE, "./test_statfs") or die "$! ./test_statfs\n";
	open(TEST, ">./test.pl") or die "$! ./test.pl\n";
	@contents = <FILE>;
	print TEST @contents;
	close(TEST);
	close(FILE);

	open(FILE, "./DfStatfs") or die "$! ./DfStatfs\n";
	open(DF, ">./Df.pm") or die "$! ./Df.pm\n";
	@contents = <FILE>;
	print DF @contents;
	close(DF);
	close(FILE);
} 


WriteMakefile(
    'NAME'	=> $module_namespace,
    'VERSION_FROM' => $module_name, # finds $VERSION
    'LIBS'	=> [''],   # e.g., '-lm' 
    'DEFINE'	=> '',     # e.g., '-DHAVE_SOMETHING' 
    'INC'	=> '',     # e.g., '-I/usr/include/other' 
);
