package Filesys::Statfs;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require DynaLoader;

@ISA = qw(Exporter DynaLoader);
@EXPORT = qw(statfs);
$VERSION = '0.02';
bootstrap Filesys::Statfs $VERSION;

1;
__END__

=head1 NAME

Filesys::Statfs - Perl extension for statfs().

=head1 SYNOPSIS

  use Filesys::Statfs;

	my($ftype, $bsize, $blocks, $bfree, $files,
	   $ffree, $bavail) = statfs("/tmp");

=head1 DESCRIPTION

Interface for statfs();

The statfs() function will return a list
of values or will return undef and 
set $! if there was an error.

The values returned are described in the statfs header or
the statfs() man page.

=head1 AUTHOR

Ian Guthrie
IGuthrie@aol.com

Copyright (c) 2003 Ian Guthrie. All rights reserved.
               This program is free software; you can redistribute it and/or
               modify it under the same terms as Perl itself.

=head1 SEE ALSO

statfs(2), df(1M)

=cut
