#
# This script is intended to select potential AMGs (cds with a bacterial hit on a contig containing a viral matching cds). This script uses a figFam annotation log allowing to translate the FIGFAM annotation and a Taxonomic log allowing to identify the potential bacterial host. Those logs are generated with the database.
#

use 5.010;
use strict;
use warnings;

my $hits = $ARGV[0];
my $out_file= $ARGV[1];
my $virPfam= $ARGV[2];

if(open(my $fh, '<', $hits)){
if(open(my $fhout, '>', $out_file)){
if(open(my $pfam, '<', $virPfam)){

#load VirPfam id

my %pfam_info;
while(my $id=<$pfam>){
	chomp $id;
	$pfam_info{$id}="vir";
}


my @pfam_hits;
my @vir_hits;
my @bact_hits;

#init with first line
my $first_row=<$fh>;
chomp $first_row;
my @split=split(",", $first_row);
my @contig_split=split(/\|/, $split[1]);
my $contig=$contig_split[1];
my $cds=$contig_split[2];
print "working on : $contig --> $cds\n";
push (@pfam_hits, $split[3]);

my $pred_cds=$cds;
my $pred_contig=$contig;

#look for protential AMGs in the file
while(my $row=<$fh>){
	chomp $row;
	my @split=split(",", $row);
	my @contig_split=split(/\|/, $split[1]);
	my $contig=$contig_split[1];
	my $cds=$contig_split[2];
	
	if(!($pred_cds eq $cds)){
		print "end of cds hits\n";
		#look if the cds is viral or bacterial
		my $bool=0;
		my $pfam_list="";
		foreach (@pfam_hits){
			if(exists $pfam_info{$_}){
				$bool=1;
				$pfam_list=$pfam_list.",$_";
				print "vir !\n";
			}else{$pfam_list=$pfam_list.",$_";}	
		}
		#reinit pfam_hits
		@pfam_hits=();
		
		my $record=$pred_cds."_".$pfam_list;
		if($bool){
			push (@vir_hits, $record);
		}else{
			push (@bact_hits, $record);
		}
		print "@vir_hits __ @bact_hits \n";
		$pred_cds=$cds;
		
		#if end of contig, look for potential AMGs
		print "comparer $pred_contig and $contig\n";
		if(!($pred_contig eq $contig)){
			print "end of contig \n \n";
			if((@vir_hits > 0) && (@bact_hits > 0)){
				print $fhout "AMG :\n";
				foreach (@bact_hits){
				     print $fhout "Potential AMG : $_\n";
				}
				foreach (@vir_hits){
				     print $fhout "Viral confirmation : $_\n";
				}
				print $fhout "\n";
				}
				
		#reinit vir_hits, bact_hits
		@vir_hits=();
		@bact_hits=();
		
		$pred_contig=$contig;
		print "working on : $contig --> $cds\n";		
		}else{"working on : $contig --> $cds\n";}
	}
	
	push (@pfam_hits, $split[3]);
}
}else{die "could not open $virPfam";}
}else{die "could not open $out_file";}
}else{die "could not open $hits";}

#end of job  
