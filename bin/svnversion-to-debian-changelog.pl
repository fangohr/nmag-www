#!/usr/bin/perl -w
#
# Small helper, (C) 2007 Dr. Thomas Fischbacher
#

my $ver=shift;

my $changelog_file="debian/packages/nsim-$ver/debian/changelog";

my $changelog=`cat $changelog_file`;

my $svnversion=`cd tmp/nmag-$ver/nsim/; svnversion`;

$svnversion=~/^(\d+)/ or die "Fatal: svnversion is '$svnversion'\n";
$svnversion=$1;


$changelog=~/^(\S+)\s*\(\d+\.\d+\.(\d+)\)/ or die "Bad changelog file!\n";
$svnversion eq $1 and do
  {
    warn "SVN Version number did not change. No adjustment necessary.\n";
    exit(0);
  };

warn "SVN Version: $svnversion\n";

my @days=qw(Sun Mon Tue Wed Thu Fri Sat);
my @months=qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);

my @time=localtime(time());

my $extra_changelog=sprintf qq^nsim (0.1.$svnversion) testing; urgency=low

  * Automatic version sync with SVN

 -- The Nmag team <nmag\@soton.ac.uk>  %s, %02d %s %d %02d:%02d:%02d +0000

^,$days[$time[6]], $time[3], $months[$time[4]],1900+$time[5],
  $time[2], $time[1], $time[0];

my $new_changelog="$extra_changelog$changelog";

open OUT, ">$changelog_file" and do
  {
    print OUT $new_changelog;
    close OUT;
  };

