# **************************************************************************** #
#                                                                              #
#                                                             |\               #
#    CaesarCipher.pl                                    ------| \----          #
#                                                       |    \`  \  |  p       #
#    By: jeudy2552 <jeudy2552@floridapoly.edu>          |  \`-\   \ |  o       #
#                                                       |---\  \   `|  l       #
#    Created: 2018/09/07 14:21:13 by jeudy2552          | ` .\  \   |  y       #
#    Updated: 2018/09/10 22:59:37 by jeudy2552          -------------          #
#                                                                              #
# **************************************************************************** #

#!/usr/bin/env perl

use warnings;
use strict;
use 5.010;
use List::MoreUtils qw(first_index);

my @alpha = ('A' .. 'Z');
START:
print "Would you like to encode or decode?\n1 - Encode\n2 - Decode\n>";
my $userInput = <>;

if($userInput == 1){
SHIFT:
    print "File import or user input?\n1 - User Input\n2 - File Import\n>";
    my $inputChoice = <>;
    system('clear');
    print "What letter would you like to shift by? (A=>?): ";
    my $shiftLetter = <>;
    $shiftLetter = uc $shiftLetter;
    chomp $shiftLetter;
    my ( $shift )= grep { $alpha[$_] =~ /$shiftLetter/ } 0..$#alpha;
    if($shift == -1){
        print "Please input a valid choice.\n";
        goto SHIFT;
    }
    my $plainText = "";
    if($inputChoice == 1){
        print "Please input plaintext: ";
        $plainText = <>;
        chomp $plainText;
    }
    elsif($inputChoice == 2){
        print "Please input file name: ";
        my $fileName = <>;
        chomp $fileName;
        my @lines;
        open(my $fileContent, "<", $fileName) or die "Couldn't open file $fileName, $!\n";
        {
            local $/;
            @lines = <$fileContent>;
        }
        close($fileContent);
        $plainText = "@lines";
    }
    else{
        print "Please choose an appropriate option.\n";
        goto SHIFT;
    }
    $plainText = uc $plainText;
    $plainText =~ s/[^a-zA-Z]//g;
    my @cipherArray = qw();
    my @charArray = split(//, $plainText);
    for(my $i = 0; $i<$#charArray; $i++){
        my $search = $charArray[$i];
        my ( $index )= grep { $alpha[$_] =~ /$search/ } 0..$#alpha;
        my $cipherIndex = $index+$shift%26;
        push @cipherArray, $alpha[$cipherIndex];
    }
    my $cipherText = join('', @cipherArray);
    open(my $fileContents, ">", "cipherText.txt") or die "Couldn't open file cipherText.txt, $!\n";
    print $fileContents $cipherText;
    close $fileContents;
    system('clear;perl CharArrayFreq.pl cipherText.txt');
}

else{
    print "Not supported yet. :(\n";
    goto START;
}
