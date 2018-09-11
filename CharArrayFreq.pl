# **************************************************************************** #
#                                                                              #
#                                                             |\               #
#    CharArrayFreq.pl                                   ------| \----          #
#                                                       |    \`  \  |  p       #
#    By: jeudy2552 <jeudy2552@floridapoly.edu>          |  \`-\   \ |  o       #
#                                                       |---\  \   `|  l       #
#    Created: 2018/09/05 14:13:01 by jeudy2552          | ` .\  \   |  y       #
#    Updated: 2018/09/11 09:28:03 by jeudy2552          -------------          #
#                                                                              #
# **************************************************************************** #
#!/usr/bin/perl -w

use warnings;
use strict;
use Data::Dumper;
use List::UtilsBy qw(max_by);

my @alpha = ('A' .. 'Z');

my $fileName = $ARGV[0];
#Open file for read only
my $content = '';
open(my $fileContents, "<$fileName") or die "Could't open file $fileName, $!";
{
    local $/;
    $content = <$fileContents>;
}
close($fileContents);
print "File contents: $content\n";
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

my $common = max_by { $charHash{$_} } keys %charHash;
my ( $shift )= grep { $alpha[$_] =~ /$common/ } 0..$#alpha;
$shift = $shift - 4;
my @decodeArray;
my @cipherArray = keys %charHash;
print "@cipherArray\n";
for(my $i=0; $i<$#cipherArray; $i++){
    my $search = $cipherArray[$i];
    my ( $index )= grep { $alpha[$_] =~ /$search/ } 0..$#alpha;
    my $plainIndex = $index-$shift;
    push @decodeArray, $alpha[$plainIndex];
}
my $plainText = join('', @decodeArray);
print "Guessed Shift amount: $shift\n";
open(my $fileData, "+>>", "plainText.txt") or die "Couldn't open file plainText.txt, $!";
print $fileData $plainText;
close $fileData;

