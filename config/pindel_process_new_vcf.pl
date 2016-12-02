#!usr/bin/perl
###########################################################################################################
###################usage ./pindel_process.pl pindel_out_D.vcf pindel_out_SI.vcf pindel_indels.vcf #########
###########################################################################################################
$file=$ARGV[0];
$file1=$ARGV[1];
open(FH,$ARGV[0]) or die "Error opening No Deletion .vcf file not found $file:$!\n";
open(FH1,$ARGV[1]) or die "Error opening No SmallInsertion .vcf file not found $file1:$!\n";
open(OUTPUT,">>",$ARGV[2]) or die "Error opening No SmallInsertion .vcf file not found $file2:$!\n";
while ($del=<FH>)
{
print OUTPUT"$del";
}
my @ins=<FH1>;
shift@ins;
shift@ins;
shift@ins;
shift@ins;
shift@ins;
shift@ins;
shift@ins;
shift@ins;
shift@ins;
shift@ins;
shift@ins;
shift@ins;
shift@ins;
shift@ins;
shift@ins;
shift@ins;
#print OUTPUT"$del\n";
foreach my $ins1 (@ins)
{
print OUTPUT"$ins1";
}

