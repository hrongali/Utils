
python ~/python/ClusterAudit.py

filename=`ls -t ~/python/out | head -n1`
echo $filename
tarfilename="$filename.tar"
echo $tarfilename
cd ~/python/out
tar -czvf $tarfilename $filename
ls -lrt

dt=`date`
echo "Cluster metrics from production cluster" | mutt -a <home directory>/python/out/$tarfilename -s "Cluster Metrics as of  $dt" -- <email address>
