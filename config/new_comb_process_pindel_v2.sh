######################################################################################
####USAGE sh new_comb_process_pindel.sh PATIENT Tumor_Library Normal_library    ######
######################################################################################

#source /mctp/wkgrps/bioinfo/sw/rhel6/init.sh
#module add bioinfo
#module add samtools/0.1.19
#module add epd
#module add pindel/0.2.4t
echo "running parameters requiered"
echo "PATIENT TUMORLIB NORMALLIB"

export PATIENT=$1
export TUMORLIB=$2
export NORMALLIB=$3
#export INDELS=$4
#export LANE=$5

# mioncoseq patient directory:
export SAMPLEDIR=/mctp/wkgrps/bioinfo/dnaseq/snv_analysis/analysis/$PATIENT/
export WRKDIR=/mctp/wkgrps/bioinfo/dnaseq/snv_analysis/
####
date
echo "Processing new Indel pipline"


if [ -s $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_germline_v1.txt ] && [ -s $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_somatic_v1.txt ]; then
    echo "#step1:germline and somatic calls exists"
else
    echo "#step1:processing germline and somatic indel calls..." 
    perl $WRKDIR/process_som_germ_pindel_v1.pl $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new.anno_v1.hg19_multianno.txt $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_germline_v1.txt $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_somatic_v1.txt

fi
####germline calls HC vs LC 
date
#if [ -s $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_germline_PLC_map2194.txt ] && [ -s $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_germline_PHC_map2194.txt ]; then
#    echo "#step2:germline LC and HC calls exists"
#else
echo "#step2:processing Indels germline post filtering started..."
perl $WRKDIR/process_germ_pindel_v1.pl $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_germline_v1.txt $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_germline_PLC.txt  $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_germline_PHC.txt

echo "germline HC vs LC calls completed"
#echo "HC germline calls mapped2157 predisposition genes"

#fi
###germline Uniq Pass filter ####
date
if [ -s $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.temp_D ] && [ -s $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.temp_SI ] ; then
    echo "#step3:Uniq and anchor reads detail file exists"
else
    echo "#step3:germline unique reads and occurence filter..."
	grep -w ChrID $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_new_out_D >$SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.temp_D
	grep -w ChrID $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_new_out_SI >$SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.temp_SI

fi

perl $WRKDIR/pindel_uniq_reads_map_germ_v2.pl $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_germline_PHC.txt $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.temp_D $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.temp_SI $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_germline_PFHC.txt $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_germline_FFHC.txt

perl $WRKDIR/map_1500_gene2pindel-v1.pl $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_germline_PFHC.txt $WRKDIR/194_Germline_GRCh37_Feb2016.txt >$SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_germline_PFHC_map2194.txt

perl $WRKDIR/map_1500_gene2pindel-v1.pl $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_germline_FFHC.txt $WRKDIR/194_Germline_GRCh37_Feb2016.txt >$SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_germline_FFHC_map2194.txt
echo "PFHC germline calls mapped2172 actionable genes"

perl $WRKDIR/map_1500_gene2pindel-v1.pl $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_germline_PLC.txt $WRKDIR/194_Germline_GRCh37_Feb2016.txt >$SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_germline_PLC_map2194.txt

echo "PFHC,FFHC,PLC germline calls mapped2172 actionable genes"

#fi

####somatic calls HC vs LC
date
#if [ -s $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_somatic_PLC_map21500.txt ] && [ -s $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_somatic_PHC_map21500.txt ]; then
    echo "#step4:Somatic PLC and PHC calls exists"
#else
echo "#step4:processing Indels somatic post filtering started..."
perl $WRKDIR/process_som_pindel_v1.pl $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_somatic_v1.txt $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_somatic_PLC.txt $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_somatic_PHC.txt
echo "somatic HC vs LC calls completed"

#fi
###Somatic Uniq PASS filter##########
date
#if [ -s $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_somatic_PFHC_map21500.txt ] && [ -s $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_somatic_PLC_map21500.txt ]; then
    echo "#step5:Uniq and anchor reads detail file exists"
#else
echo "#step5:somatic unique reads and occurence filter..."
perl $WRKDIR/pindel_uniq_reads_map_v5.pl $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_somatic_PHC.txt $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.temp_D $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.temp_SI $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_somatic_PFHC.txt $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_somatic_FFHC.txt

perl $WRKDIR/map_1500_gene2pindel-v1.pl $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_somatic_PFHC.txt $WRKDIR/1500_interesting_gene.txt >$SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_somatic_PFHC_map21500.txt

perl $WRKDIR/map_1500_gene2pindel-v1.pl $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_somatic_FFHC.txt $WRKDIR/1500_interesting_gene.txt >$SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_somatic_FFHC_map21500.txt

perl $WRKDIR/map_1500_gene2pindel-v1.pl $SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_somatic_PLC.txt $WRKDIR/1500_interesting_gene.txt >$SAMPLEDIR/$PATIENT.$TUMORLIB.$NORMALLIB.pindel_indels_new_somatic_PLC_map21500.txt

echo "PFHC somatic calls mapped21500 actionable genes"
echo "# Indel calls are completed"

date
#fi

