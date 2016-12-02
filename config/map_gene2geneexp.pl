#!usr/bin/perl
###################usage ./test.pl file1.csv ref_gene.txt#########
#use warnings;
use Bio::SeqIO;
#use IO::File;
my $seqio = Bio::SeqIO->newFh(-format => 'Fasta', -fh => \*ARGV);
while(my $seq= <$seqio>){#->next_seq()){
my $head =$seq->id;
my $hd=$seq->desc;
my $seq =$seq->seq;
#print"$hd\n";
if($hd =~/WILDTYPE/){
#my @wtpos=split(/\(position/,$hd);
#my ($wp1,$wp2,$wp3,$wp4)=split(/\s+/,$wtpos[1]);
#my $wtseql =substr($seq,$wp2-9,18);
print">wt_$hd\n$seq\n";
}else{
#if($hd != /WILDTYPE/)
#{
#my $head =$seq->id;
#my $hd=$seq->desc;
#my $seq =$seq->seq;
my @pos=split(/\(position/,$hd);
my ($p1,$p2,$p3,$p4,$p5,$p6,$p7)=split(/\s+/,$pos[1]);
if($p2 >=9)
{
my $seql =substr($seq,$p2-9,18);
#f ($pos[0] != /WILDTYPE/)
$seql =~ s/\*//g;
###print "$hd:$p2\n$seq\n$seql\n";
print ">mt_$hd\n$seql\n";
}elsif($p2=8){my $seql =substr($seq,$p2-8,17);print ">mt_$hd\n$seql\n";}
elsif($p2=7){my $seql =substr($seq,$p2-7,16);print ">mt_$hd\n$seql\n";} 
elsif($p2=6){my $seql =substr($seq,$p2-6,15);print ">mt_$hd\n$seql\n";}
elsif($p2=5){my $seql =substr($seq,$p2-5,15);print ">mt_$hd\n$seql\n";}
elsif($p2=4){my $seql =substr($seq,$p2-4,15);print ">mt_$hd\n$seql\n";}
elsif($p2=3){my $seql =substr($seq,$p2-3,15);print ">mt_$hd\n$seql\n";}
elsif($p2=2){my $seql =substr($seq,$p2-2,15);print ">mt_$hd\n$seql\n";}
elsif($p2=1){print">mt_$hd\tNo_peptide_formed\n";}
}
}


