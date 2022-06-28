for i in {34..51}
do
sample=HBR${i}_S$(($i-18))_L002
echo $sample
sbatch filter_bamfile.sh $sample
done

for i in {15..33}
do
sample=HBR${i}_S$(($i-5))_L002
echo $sample
sbatch filter_bamfile.sh $sample
done