import cgi
import cgitb
import sys
import json
import os
import subprocess
import datetime
import hashlib

#cgitb.enable(display=0, logdir='/webfs/scratch/img/logs')
cgitb.enable()
log = open('/webfs/scratch/img/logs/ABC.log', 'a')
log.write('---\n{0}\n---\n'.format(datetime.datetime.utcnow()))

#JACCARD_PATH = "/global/homes/j/jinghua/biosyn/jaccard_from_bcids.sh"
JACCARD_PATH = "/global/homes/e/ewanders/biosyn/jaccard_from_bcids.sh"
#JACCARD_PATH = "/global/u1/k/klchu/biosyn/jaccard_from_bcids.sh"
TEMPDIR_TEMPLATE = "/global/projectb/scratch/img/www-data/service/tmp/abc_{0}" 
BC_IDS_FILENAME = "bc_ids.txt"
SIM_SIM_FILENAME = "ABCsimilarities.txt"
SIM_META_FILENAME = "ABCmetadata.txt"
SIM_ZIP_FILENAME = "ABCsimilarities.zip"

#HEATMAP_PATH = "./bin/heatmap_from_BCids.sh";
#HEATMAP_PATH = "/global/homes/j/jinghua/biosyn/heatmap_from_BCids.sh"
HEATMAP_PATH = "/global/homes/e/ewanders/biosyn/heatmap_from_BCids.sh"
#HEATMAP_PATH = "/global/u1/k/klchu/biosyn/heatmap_from_BCids.sh"
INCHLIB_CLUST_PATH = "python /global/dna/projectdirs/microbial/omics-biosynthetic/inchlib_clust-0.1.4/inchlib_clust_copy.py"
#INCHLIB_CLUST_PATH = "python /global/dna/projectdirs/microbial/omics-biosynthetic/inchlib_clust-0.1.4/inchlib_clust.py"
HEATMAP_GENEE_FILENAME = "genee_matrix.csv"
HEATMAP_CLUSTER_FILENAME = "output.json"
HEATMAP_FILENAME = "matrix.csv"

def getHashFor(bc_ids):
  m = hashlib.md5()
  for id in bc_ids:
    m.update(id)
  return m.hexdigest()

def getTempDirForHash(hash):
  return TEMPDIR_TEMPLATE.format(hash)

def getTempDir(bc_ids):
  hash = getHashFor(bc_ids)
  tempdir = TEMPDIR_TEMPLATE.format(hash)
  if not os.path.exists(tempdir):
    os.mkdir(tempdir)
  if not os.path.exists(tempdir+'/'+BC_IDS_FILENAME):
    bcidsFile = open(tempdir+'/'+BC_IDS_FILENAME, 'w')
    for i, val in enumerate(bc_ids):
      log.write('writing bc_id: '+val+'\n')
      bcidsFile.write(val+'\n')
    bcidsFile.close()
  return tempdir

def downloadFile(filename, mimetype, saveas):
  if os.path.isfile(filename):
    print "Content-Type: " + mimetype
    print "Content-Disposition: attachment; filename=\"" + saveas + "\"\n"
    f = open(filename, "rb")
    print f.read()
    f.close()

def downloadSimilaritiesFile(hash, type):
    tempdir = getTempDirForHash(hash)
    if type == "metadata":
      downloadFile(tempdir + "/" + SIM_META_FILENAME, "text/csv", SIM_META_FILENAME)
    elif type == "similarities":
      downloadFile(tempdir + "/" + SIM_SIM_FILENAME, "text/csv", SIM_SIM_FILENAME)
    elif type == "zip":
      downloadFile(tempdir + "/" + SIM_ZIP_FILENAME, "application/zip", SIM_ZIP_FILENAME)
    else:
      sys.stderr.write( "Error: unknown file type" )

def downloadHeatmapGenee(hash):
    tempdir = getTempDirForHash(hash)
    downloadFile(tempdir + "/" + HEATMAP_GENEE_FILENAME, "text/csv", HEATMAP_GENEE_FILENAME)

def downloadHeatmapCluster(hash):
    tempdir = getTempDirForHash(hash)
    downloadFile(tempdir + "/" + HEATMAP_CLUSTER_FILENAME, "application/json", HEATMAP_CLUSTER_FILENAME)

def computeHeatmap(bc_ids):
  hash = getHashFor(bc_ids)
  log.write('computeHeatmap hash: {0}\n'.format(hash))
  tempdir = getTempDir(bc_ids)
  #log.write('tempdir=' + tempdir +'\n')
  #log.write('HEATMAP_PATH=' + HEATMAP_PATH +'\n')
  #log.write('BC_IDS_FILENAME=' + BC_IDS_FILENAME +'\n')
  #log.write('INCHLIB_CLUST_PATH=' + INCHLIB_CLUST_PATH +'\n')
  #log.write('HEATMAP_FILENAME=' + HEATMAP_FILENAME +'\n')
  #log.write('HEATMAP_CLUSTER_FILENAME=' + HEATMAP_CLUSTER_FILENAME +'\n')
  if not os.path.exists(tempdir + '/' + HEATMAP_CLUSTER_FILENAME +'\n'):
    #cmdline = ['/usr/bin/ssh', 'genepool', '. .bash_profile; cd {0}; {1} {2} && {3} {4} -m row_metadata.csv -cm col_metadata.csv -dh -mh -cmh -rd jaccard -rl ward -a both -dd , -md , -cmd , -o {5}'.format(
    cmdline = ['/usr/bin/ssh', 'genepool', '. .bash_profile; cd {0}; {1} {2} && {3} {4} -m row_metadata.csv -cm col_metadata.csv -dh -mh -cmh -rd jaccard -rl ward -cd jaccard -cl ward -dd , -md , -cmd , -o {5}'.format(
      tempdir,
      HEATMAP_PATH,
      BC_IDS_FILENAME,
      INCHLIB_CLUST_PATH,
      HEATMAP_FILENAME,
      HEATMAP_CLUSTER_FILENAME)]
    for c in cmdline:
      log.write(c + '\n')
    proc = subprocess.Popen(cmdline, stdout=subprocess.PIPE)
    while True:
      line = proc.stdout.readline()
      if line != '':
        log.write('proc stdout: '+line.rstrip()+'\n')
      else:
        break
  else:
    log.write(tempdir+'/'+HEATMAP_CLUSTER_FILENAME+' already exists. Using cache.\n')

  result = json.dumps({'id':hash})
  log.write(result+'\n')
  print "Content-Type: application/json\n"
  print result

def computeSimilarityNetwork(bc_ids):
  hash = getHashFor(bc_ids)
  log.write('computeSimilarityNetwork hash: {0}\n'.format(hash))
  tempdir = getTempDir(bc_ids)
  if not os.path.exists(tempdir + '/' + SIM_ZIP_FILENAME):
    cmdline = ['/usr/bin/ssh', 'genepool', '. .bash_profile; cd {0}; {1} {2} {3} {4} && /usr/bin/zip {5} {4} {3}'.format(
      tempdir,
      JACCARD_PATH,
      BC_IDS_FILENAME,
      SIM_SIM_FILENAME,
      SIM_META_FILENAME,
      SIM_ZIP_FILENAME)]
    proc = subprocess.Popen(cmdline, stdout=subprocess.PIPE)
    while True:
      line = proc.stdout.readline()
      if line != '':
        log.write('proc stdout: '+line.rstrip()+'\n')
      else:
        break
  else:
    log.write(tempdir+'/'+SIM_ZIP_FILENAME+' already exists. Using cache.\n')

  result = json.dumps({'id':hash})
  log.write(result+'\n')
  print "Content-Type: application/json\n"
  print result

def main():
  log.write('main\n')
  postdata = sys.stdin.read()
  log.write('POST: '+postdata+'\n')
  if len(postdata) > 0:
    p = json.loads(postdata)
    if p['section'] == 'computeSimilarities':
      computeSimilarityNetwork(p['bc_id'])
      return
    elif p['section'] == 'similarities':
      downloadSimilaritiesFile(p['id'], p['type'])
      return
    elif p['section'] == 'computeHeatmap':
      computeHeatmap(p['bc_id'])
      return
    elif p['section'] == 'heatmap' and p['type'] == 'cluster':
      downloadHeatmapCluster(p['id'])
      return
  else:
    p = cgi.FieldStorage()
    if p['section'].value == 'similarities':
      downloadSimilaritiesFile(p['id'].value, p['type'].value)
      return
    elif p['section'].value == 'heatmap' and p['type'].value == 'genee':
      downloadHeatmapGenee(p['id'].value)
      return

  log.write( 'Error: couldn\'t parse input.' )

if __name__ == "__main__":
  main()
  log.write('Exiting\n')

