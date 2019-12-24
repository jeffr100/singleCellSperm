## convertBAMfull.perl
use strict;
my($inLine,$rgTag,$cbTag,$rawTag,%allRG,$thisOut,$thisRG,@inSplit,$fixedLine,$i,$counter,%allReadLines,%rgCounter);

keys(%allReadLines) = 100000000;
keys(%rgCounter) = 10000000;
keys(%allRG) = 10000000;
open(INTAKE,$ARGV[0]);
while($inLine=<INTAKE>) {
    $counter ++;

    if($counter % 100000 ==0) 
    {print STDERR "$counter\n";
    }
    
    if($inLine =~/^@/) {# a header line
	print $inLine;
	next;
    }

    @inSplit=split(/\t/,$inLine);
    $cbTag= $inSplit[18];
    $rawTag= (split(/:|-/,$cbTag))[2];
    $rgTag = "RG:Z:$rawTag";
   
    $allRG{$rawTag}=$rawTag;

    $inSplit[18]=$rgTag;
   
    $fixedLine=join("\t",@inSplit);
    push(@{ $allReadLines {$rawTag}}, $fixedLine);
    $rgCounter{$rawTag} ++;
}

foreach $thisRG(keys(%allRG)) { #print tags with enough reads
       if($rgCounter{$thisRG} > 5) {
    print "\@RG\tID:$thisRG\tSM:$thisRG\n";
    }
}

foreach $thisRG(keys(%allRG)) { #print tags with enough reads
    if($rgCounter{$thisRG} > 5) {
    
    foreach $thisOut  (@{$allReadLines{$thisRG}}) {
	print $thisOut;
	}
    }
}
