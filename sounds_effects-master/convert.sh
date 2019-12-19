NAMES=`ls -1 finals_wav | cut -d '.' -f1`

for var in $NAMES
do
echo "convert  $var"
ffmpeg -i finals_wav/$var.wav finals_ogg/$var.ogg
done
