use Test::More;

use strict;
use warnings;

use PPI::Xref;

use FindBin qw[$Bin];
require "$Bin/util.pl";

use File::Temp qw[tempdir];
my $cache_directory = tempdir(CLEANUP => 1);

my ($xref, $lib) = get_xref({cache_directory     => $cache_directory,
                             cache_verbose => 1,
                             abslib       => 1});

ok($xref->process("$lib/B.pm"), "process file $lib/B.pm");

my $cachefile = File::Spec->catfile($cache_directory, PPI::Xref->__safe_dir_and_file("$lib/B.pm.cache", 1));

ok(-s $cachefile, "non-empty cachefile exists ($cachefile)");

# Using the internal utilities here for testing is a bit evil, but
# reimplementing the code here for testing would be even more evil.

my $cache = $xref->__decode_from_file($cachefile);

my ($currenthash) = $xref->__current_filehash_and_mtime("$lib/B.pm");

is($cache->{file_hash}, $currenthash, "file_hash matches");

done_testing();
