# **************************************************************************** #
#                                                                              #
#                                                             |\               #
#    Cracker.pl                                         ------| \----          #
#                                                       |    \`  \  |  p       #
#    By: jeudy2552 <jeudy2552@floridapoly.edu>          |  \`-\   \ |  o       #
#                                                       |---\  \   `|  l       #
#    Created: 2018/09/05 14:13:01 by jeudy2552          | ` .\  \   |  y       #
#    Updated: 2018/09/13 09:07:59 by jeudy2552          -------------          #
#                                                                              #
# **************************************************************************** #
#!/usr/bin/perl -w

use warnings;
use strict;
use Data::Dumper;
use List::UtilsBy qw(max_by);

my @alpha = ('A' .. 'Z');
INPUT:
print "Welcome to the Caesar cipher cracker.\nWould you like to import a file or input ciphertext manually?\n1 - File Import\n2 - User Input\n>";
my $userInput = <>;
system('clear');
if($userInput == 1){
    my $fileName = <>;
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
}

elsif($userInput == 2){
    print "Please input ciphertext: ";
    my $content = <>;
    $content = uc $content;                                        #Remove case sensitivity
    $content =~ s/[^a-zA-Z]//g;                                    #Remove non alpha from str
    my @charArray = split(//, $content);                           #Split into char array
    my %charHash = map {                                           #Generate hash from char array and count frequency of each character
        my $search = $_;
        $_ ne "\n" ?
            ($search => scalar grep {$_ eq $search} @charArray) :
            () } @charArray;

}

else{
    print "Please input a proper response.\n";
    goto INPUT;
}

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
for(my $i=0; $i<$#charArray+1; $i++){
    my $search = $charArray[$i];
    my ( $index )= grep { $alpha[$_] =~ /$search/ } 0..$#alpha;
    my $plainIndex = $index-$shift;
    push @decodeArray, $alpha[$plainIndex];
}
my $plainText = join('', @decodeArray);
print "Guessed Shift amount: $shift\n";
open(my $fileData, "+>>", "plainText.txt") or die "Couldn't open file plainText.txt, $!";
print $fileData $plainText;
close $fileData;
print "Cracked plaintext stored in plainText.txt\n";
