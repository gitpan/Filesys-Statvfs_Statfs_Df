use ExtUtils::MakeMaker;
use Config(%Config);

my $module_namespace = "Filesys::Statvfs";
my $module_name = "Statvfs.pm";
my $statvfs_path = "sys/statvfs.h";
my $statfs_path = "sys/statfs.h";
my $include_path = $Config{usrinc};



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


#### The include path is defined.
#### Use this first to determine what
#### stat call to use.
#if(0) {
if($include_path) {
	if(-e "$include_path/$statvfs_path") {
		print "$include/$statvfs_path exists.\n";
		print "Using statvfs() with Df.pm ....\n";
	}

	elsif(-e "$include_path/$statfs_path") {
		print "\n$include_path/$statvfs_path does not exist.\n";
		print "Checking for $include_path/$statfs_path ....\n";
		print "$include_path/$statfs_path exists.\n";
		print "Using statfs() with Df.pm\n";

		print "\nNOTE: If you want to use statvfs() and the header is located\n";
		print "somewhere other than $include_path/$statvfs_path you can\n";
		print "change the statvfs_path, statfs_path, and include_path variables\n";
		print "in Makefile.PL, and the include statement in statvfs.xs to\n";
		print "reflect the proper path. Then re-run perl Makefile.PL.\n";

		sleep 3;

		switch_to_statfs();
	}

	else {
		print "Warning:$include_path/$statvfs_path or $include_path/$statvfs_path\n";
		print "could not be found.\n\n";
		print "Assuming the \$Config\{usrinc\} value is incorrect and proceeding ....\n";
		sleep 3;

		#### Switch to statfs() for these systems
		#### since they dont have statvfs().
		#### I hope I have the correct OSes. :-P
		if($Config{osname} eq "darwin" ||
   	   	   $Config{osname} eq "openbsd" ||
   	   	   $Config{osname} eq "freebsd") {
			print "Since the \$Config\{usrinc\} value was not useable, and you are\n";
			print "using a system that normally did not have statvfs() at\n";
			print "the time this module was written, we are going to assume\n";
			print "that you can only use statfs().\n";
			switch_to_statfs();
		} 

		else {
			print "Using statvfs() ....\n";
		}
	}
}

#### include path is not defined 
#### make best guess
else {
	print "Include path is not defined. Using best guess for which module to use.\n\n";

	#### Switch to statfs() for these systems
	#### since they dont have statvfs().
	#### I hope I have the correct OSes. :-P
	if($Config{osname} eq "darwin" ||
   	   $Config{osname} eq "openbsd" ||
   	   $Config{osname} eq "freebsd") {
		print "Since the \$Config\{usrinc\} value was undef and you are\n";
		print "using a system that normally did not have statvfs() at\n";
		print "the time this module was written, we are going to assume\n";
		print "that you can only use statfs().\n";
		switch_to_statfs();
	} 

	else {
		print "Using statvfs() ....\n";
	}
}


sub switch_to_statfs {
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
