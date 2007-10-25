#!/usr/bin/perl -w
#
# Small helper, (C) 2007 Dr. Thomas Fischbacher
#

my $ver=shift;

my $changelog_file="debian/packages/nsim/debian/changelog";

my $svnversion=`cd tmp/nsim/; svnversion`;

$svnversion=~/^(\d+)/ or die "Fatal: svnversion is '$svnversion'\n";
$svnversion=$1;

warn "SVN Version: $svnversion\n";

my @days=qw(Sun Mon Tue Wed Thu Fri Sat);
my @months=qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);

my @time=localtime(time());

my $changelog=sprintf qq^nsim ($ver.$svnversion) testing; urgency=low

  * SVN-version-aligned autobuild of debian package

 -- The Nmag team <nmag\@soton.ac.uk>  %s, %02d %s %d %02d:%02d:%02d +0000

^,$days[$time[6]], $time[3], $months[$time[4]],1900+$time[5],
  $time[2], $time[1], $time[0];

open OUT, ">$changelog_file" and do
  {
    print OUT $changelog;
    close OUT;
  };

