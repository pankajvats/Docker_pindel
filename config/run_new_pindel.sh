######################################################################################
####USAGE sh run_new_pindel.sh PATIENT Tumor_Library Normal_library  INSERTSIZE ######
######################################################################################
echo "running parameters requiered"
echo "PATIENT TUMORLIB NORMALLIB INSERTSIZE "

export PATIENT=$1
export TUMORLIB=$2
export NORMALLIB=$3
export INSERTSIZE=$4

# mioncoseq patient directory:
export SAMPLEDIR=/mctp/wkgrps/bioinfo/dnaseq/snv_analysis/analysis/$PATIENT
####
date
echo "Processing new Indel pipline"
###changed to run on rmd.bam July 5 2016###
if [ -s $SAMPLEDIR/$NORMALLIB.rmd.bam ] && [ -s $SAMPLEDIR/$TUMORLIB.rmd.bam ]; then
    echo "#step1: Sorted Bam files exist"
else
    echo "# Exiting -- Couldn't find file NORMALLIB.rmd.bam or TUMORLIB.rmd.bam "
        
fi

#######
if [ -s $SAMPLEDIR/$TUMORLIB.srt.bam.bai ] && [$SAMPLEDIR/$NORMALLIB.srt.bam.bai ] ; then
	echo"Bam index file exist "
else
	ln -s $SAMPLEDIR/$NORMALLIB.srt.bai $SAMPLEDIR/$NORMALLIB.srt.bam.bai
	ln -s $SAMPLEDIR/$TUMORLIB.srt.bai $SAMPLEDIR/$TUMORLIB.srt.bam.bai

fi

##########
if [ -s $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.config.txt ] ; then
     echo "#step2: Config file exists "
else
     echo "#step2: Creating Config file "
printf "$SAMPLEDIR/$TUMORLIB.srt.bam 300 $PATIENT.TUMOR.$TUMORLIB\n$SAMPLEDIR/$NORMALLIB.srt.bam $INSERTSIZE $PATIENT.NORMAL.$NORMALLIB" >$SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.config.txt
fi
###############
###############
if [ -s $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_new_out_D ] && [ -s $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_new_out_SI ] ; then
	echo "step3: pindel files exist"
else
	echo "#step3: started pindel "
#/mctp/users/pankajv/softwares/pindel/pindel_08172016_pull/pindel/

pindel -f /mctp/wkgrps/bioinfo/dnaseq/snv_analysis/Novoalign_index/genome.fa -i $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.config.txt -c ALL -o $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_new_out -T 64 -M 5 -C true -A 30 -k true -l true -s true -L /mctp/wkgrps/bioinfo/dnaseq/snv_analysis/logfiles/${PATIENT}.${TUMORLIB}.${NORMALLIB}.pindel_new_out.log 

fi

date
###############
###############
if [ -s $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_new_out_D.vcf ] ; then
        echo "#step4: pindel vcf files exist"
else
	echo "#step4: converting Deletion file2vcf "
pindel2vcf  -p $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_new_out_D -r /mctp/wkgrps/bioinfo/dnaseq/snv_analysis/Novoalign_index/genome.fa -R 1000GenomePilot-NCBI37 -d 20101123  -v $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_new_out_D.vcf -e 5

fi

##############
##############
if [ -s $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_new_out_SI.vcf ] ; then
        echo "#step5: pindel vcf files exist"
else
        echo "#step5: converting insertion file2vcf "
pindel2vcf  -p $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_new_out_SI -r /mctp/wkgrps/bioinfo/dnaseq/snv_analysis/Novoalign_index/genome.fa -R 1000GenomePilot-NCBI37 -d 20101123  -v $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_new_out_SI.vcf -e 5
fi
date

if [ -s $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new.vcf ] ; then
	echo "#step6: deletion vcf and insertion vcf merged"
else
	echo "#step6: merging deletion file and insertion file "
	perl /mctp/wkgrps/bioinfo/dnaseq/snv_analysis/pindel_process_new_vcf.pl $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_new_out_D.vcf $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_new_out_SI.vcf $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new.vcf

fi

############################
############################
echo "#pindel vcf file completed and ready for annotation"
date
############################

if [ -s $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new.anno.hg19_multianno.csv ] && [ -s $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new.anno_v1.hg19_multianno.txt ] ; then
	echo "#step7: annotation of merged indel file is done"
else
	echo "#step7: annotating merged indel file "
	perl /mctp/users/pankajv/annovar-02.01.16/annovar/table_annovar.pl $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new.vcf  /mctp/wkgrps/bioinfo/dnaseq/snv_analysis/annotation/humandb/ --buildver hg19 --outfile $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new.anno_v1 --remove --protocol refGene,genomicSuperDups,clinvar_20140929,cosmic75,esp6500si_all,1000g2014oct_all,popfreq_max_20150413,avsnp147 --operation g,r,f,f,f,f,f,f -nastring . --otherinfo -vcfinput >/mctp/wkgrps/bioinfo/dnaseq/snv_analysis/logfiles/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new.anno.log 


##withexac003
#/mctp/users/pankajv/annovar-02.01.16/annovar/./table_annovar.pl /mctp/wkgrps/bioinfo/dnaseq/snv_analysis/analysis/SU-15-4281/SU-15-4281.SI_10115.SI_10116.varscan.snp.vcf.Somatic  /mctp/wkgrps/bioinfo/dnaseq/snv_analysis/annotation/humandb/ --buildver hg19 --outfile tt.varscan.snp.vcf.Somatic_new.anno_v1 --remove --protocol refGene,genomicSuperDups,clinvar_20140929,cosmic75,esp6500si_all,1000g2014oct_all,popfreq_max_20150413,exac03,avsnp144 --operation g,r,f,f,f,f,f,f,f -nastring . --otherinfo -vcfinput

fi
########################
if [ -s $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_somatic_LC_map21500.csv ] ; then
	echo "step8: processing of somatic/germline indels is done" 
else
	#sleep 5m
	echo "step8: processing the somatic/germline indels "
#	sh /mctp/wkgrps/bioinfo/dnaseq/snv_analysis/new_comb_process_pindel.sh $PATIENT $TUMORLIB $NORMALLIB >& /mctp/wkgrps/bioinfo/dnaseq/snv_analysis/logfiles/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new.som_germ_process.log &
       	
	sh /mctp/wkgrps/bioinfo/dnaseq/snv_analysis/new_comb_process_pindel_v2.sh $PATIENT $TUMORLIB $NORMALLIB >/mctp/wkgrps/bioinfo/dnaseq/snv_analysis/logfiles/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new.som_germ_process.log 


fi
date
exit
