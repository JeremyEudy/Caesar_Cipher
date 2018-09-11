# **************************************************************************** #
#                                                                              #
#                                                             |\               #
#    CharArrayFreq.pl                                   ------| \----          #
#                                                       |    \`  \  |  p       #
#    By: jeudy2552 <jeudy2552@floridapoly.edu>          |  \`-\   \ |  o       #
#                                                       |---\  \   `|  l       #
#    Created: 2018/09/05 14:13:01 by jeudy2552          | ` .\  \   |  y       #
#    Updated: 2018/09/10 23:21:56 by jeudy2552          -------------          #
#                                                                              #
# **************************************************************************** #
#!/usr/bin/perl -w

use warnings;
use strict;
use Data::Dumper;

my $fileName = $ARGV[0];
#Open file for read only
my $content = '';
open(my $fileContents, "<$fileName") or die "Could't open file $fileName, $!";
{
    local $/;
    $content = <$fileContents>;
}
close($fileContents);
$content = uc $content;                                        #Remove case sensitivity
$content =~ s/[^a-zA-Z]//g;                                    #Remove non alpha from str
my @charArray = split(//, $content);                           #Split into char array
my %charHash = map {                                           #Generate hash from char array and count frequency of each character
    my $search = $_;
    $_ ne "\n" ?
        ($search => scalar grep {$_ eq $search} @charArray) :
        () } @charArray;

print "Letter | Count | Frequency in File \n";
print "-------+-------+-------------------\n";
foreach (reverse sort {$charHash{$a} <=> $charHash{$b}} keys %charHash) {
    my $fileFreq = $charHash{$_}/scalar @charArray;
    $fileFreq*=100;
    printf "$_      | %-4s  |  %.5f\n", $charHash{$_}, $fileFreq;
}
