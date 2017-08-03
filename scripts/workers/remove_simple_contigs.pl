#
# this script intend to remove contigs containing only one cds. the input is the prodigal log. The output is a log containing only the selected contigs.
#

use 5.010;
use strict;
use warnings;

use LWP::Simple;
use LWP::UserAgent;
use File::Copy;
use Net::FTP;
use XML::LibXML;
use Bio::SeqIO;

my $cds = $ARGV[0];
my $output= $ARGV[1];

my $in  = Bio::SeqIO-> new ( -file   => $cds,
				-format => 'fasta' );
my $out = Bio::SeqIO-> new ( -file   => ">> $output",
                		-format => 'fasta' );

my $previousContig="init";
my $previous="init";
my $cpt=0;

print "begin file analysis $cds";

while (my $record = $in->next_seq()) {
				
	my $seq_id = $record->id();
	print "$seq_id\n";
	my @temp1=split(/\|/, $seq_id);
	my $contig=$temp1[1];

	if($contig eq $previousContig){
		if($cpt==0){
			$cpt=1;
			$out->write_seq($previous);
			$out->write_seq($record);
		}else{
			$out->write_seq($record);
		}
	}else{
		$cpt=0;
		$previous=$record;
		my $previousid=$record->id();
		my @temp2=split(/\|/, $previousid);
		$previousContig=$temp2[1];
	}			
}
#end of job  
