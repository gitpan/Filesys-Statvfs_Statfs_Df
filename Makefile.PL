use ExtUtils::MakeMaker;
use Config(%Config);

my $module_namespace = "Filesys::Statvfs";
my $module_name = "Statvfs.pm";
my $statvfs_path = "sys/statvfs.h";
my $statfs_path = "sys/statfs.h";
my $df_file = "./Df.pm";
my $test_file = "./test.pl";
my $include_path = $Config{usrinc};
my $header_found = 0;



#### The include path is defined.
#### Use this first to determine what
#### stat call to use.
#if(0) {
if($include_path) {
	if(-e "$include_path/$statvfs_path") {
		print "$include/$statvfs_path exists.\n";
		print "Using statvfs() with Df.pm ....\n";

		$header_found = 1;

		switch_to_statvfs();
	}

	elsif(-e "$include_path/$statfs_path") {
		print "\n$include_path/$statvfs_path does not exist,\n";
		print "but $include_path/$statfs_path exists.\n";
		print "Using statfs() with Df.pm\n";

		$header_found = 1;

		switch_to_statfs();
	}

	else {

		#### Switch to statfs() for these systems
		#### since they dont support statvfs().
		if($Config{osname} eq "darwin" || $Config{osname} =~ /bsd$/) {
			print "It looks like you are on a Darwin or BSD system.\n";
			print "Since I could not find a statfs or statvfs header,\n";
			print "I will assume you use the mount.h and param.h headers\n";
			print "and statfs()\n";
			switch_to_statfs();
		} 

		else {
			print "Warning:$include_path/$statvfs_path or $include_path/$statvfs_path\n";
			print "could not be found.\n\n";
			print "Assuming that you use use statvfs() ....\n";
			switch_to_statvfs();
		}
	}
}

#### include path is not defined 
#### make best guess
else {
	print "Include path is not defined. Using best guess for which module to use.\n\n";

	#### Switch to statfs() for these systems
	#### since they dont support statvfs().
	if($Config{osname} eq "darwin" || $Config{osname} =~ /bsd$/) {
		print "Since the \$Config\{usrinc\} value was undef and you are\n";
		print "using a system that normally did not have statvfs() at\n";
		print "the time this module was written, I am going to assume\n";
		print "that you can only use statfs().\n";
		switch_to_statfs();
	} 

	else {
		print "Using statvfs() ....\n";
		switch_to_statvfs();
	}
}


sub switch_to_statfs {
	$module_namespace = "Filesys::Statfs";
	$module_name = "Statfs.pm";

	# copy test.pl and df.pm
	open(FILE, "./test_statfs") or die "$! ./test_statfs\n";
	open(TEST, ">$test_file") or die "$! $test_file\n";
	@contents = <FILE>;
	print TEST @contents;
	close(TEST);
	close(FILE);

	open(FILE, "./DfStatfs") or die "$! ./DfStatfs\n";
	open(DF, ">$df_file") or die "$! $df_file\n";
	@contents = <FILE>;
	print DF @contents;
	close(DF);
	close(FILE);
}


sub switch_to_statvfs {
	$module_namespace = "Filesys::Statvfs";
	$module_name = "Statvfs.pm";

	# copy test.pl and df.pm
	open(FILE, "./test_statvfs") or die "$! ./test_statvfs\n";
	open(TEST, ">$test_file") or die "$! $test_file\n";
	@contents = <FILE>;
	print TEST @contents;
	close(TEST);
	close(FILE);

	open(FILE, "./DfStatvfs") or die "$! ./DfStatvfs\n";
	open(DF, ">$df_file") or die "$! $df_file\n";
	@contents = <FILE>;
	print DF @contents;
	close(DF);
	close(FILE);
}



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

($Config{osname} eq "cygwin") &&
        (print CONFIG "#define _CYGWIN__\n");

if($Config{osname} eq "darwin") {
	($header_found == 1) ? 
        	(print CONFIG "#define _DARWIN__\n") :
        	(print CONFIG "#define _DARWIN__NOHEADER\n");
}

if($Config{osname} eq "freebsd") {
	($header_found == 1) ?
        	(print CONFIG "#define _FREEBSD__\n") :
        	(print CONFIG "#define _FREEBSD__NOHEADER\n");
}

close(CONFIG);


WriteMakefile(
    'NAME'	=> $module_namespace,
    'VERSION_FROM' => $module_name, # finds $VERSION
    'LIBS'	=> [''],   # e.g., '-lm' 
    'DEFINE'	=> '',     # e.g., '-DHAVE_SOMETHING' 
    'INC'	=> '',     # e.g., '-I/usr/include/other' 
    'clean'     => {FILES => 'config.h'},
    'DISTNAME'  => 'Filesys-Statvfs_Statfs_Df',
    'XSPROTOARG' => '-prototypes' 
);
