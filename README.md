# UPROC_AMG_detection
Pipeline for detection of potential AMG in assembled metagenome using UPROC

## Requirements

### UPROC databases
This pipeline necessites to download a Uproc database and working model. Several databases are available in the `UProC homepage`_ and Uproc provide a pipeline to create custom databases. 

.. _`UProC homepage`: http://uproc.gobics.de

### UPROC
Uproc (at least version 1.2.0) should be previously installed and included in the user PATH. Uproc is available at https://github.com/gobics/uproc.

### Prodigal
Prodigal (at least version 2.6) should be installed. The location of installation should be provided in the config file.
Prodigal is available at https://github.com/hyattpd/Prodigal .

## Quick start

### Edit scripts/config.sh file

please modify the

  - SAMPLE = indicate here the metagenome file to analyze
  - SAMPLE_DIR = indicate here the output directory
  - DB_DIR = indicate here the Uproc database directory
  - MODEL = indicate here the Uproc model directory
  -PFAM_VIR = provide a list of known viral pfam id
  - MAIL_USER = indicate here your arizona.edu email
  - GROUP = indicate here your group affiliation

You can also modify

  - BIN = change for your own bin directory.
  - PRODIGAL = give the prodigal install folder.
  - MAIL_TYPE = change the mail type option. By default set to "bea".
  - QUEUE = change the submission queue. By default set to "standard".
  
  ### Split input file
  
  Run ./split.sh
  
  This command will remove short contigs from the dataset (<500pb) and split the remaining contigs in manageable files for the analysis (10.000 contigs/files). The split files are stored in $SAMPLE_DIR/div/raw.
  
  Once the job is completed successfully, the analysis can be run.
  
  ### Run analysis
  
  Run ./submit.sh
  
  Will place in queue two successive jobs for the analysis.
  The final output is located in $SAMPLE_DIR/results_AMG.log
