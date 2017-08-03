#
# this script is intented to remove very short contigs and divide the file in managable chunks
#
use 5.010;
use strict;
use warnings;

use Bio::SeqIO;
use Bio::Seq;

my $fcds=$ARGV[0];
my $outdir=$ARGV[1];
my $size=$ARGV[2];

my $in  = Bio::SeqIO-> new ( -file   => $fcds,
                             -format => 'fasta' );

my $cpt=0;
my @list;

while (my $record = $in->next_seq()) {
    print "$record\n";
    if($record->length > 500){
        push @list, $record;
        if(scalar(@list)==$size){
            $cpt++;
            my $name = "$outdir/file_$cpt".".fasta";
            my $out = Bio::SeqIO-> new ( -file   => ">>  $name",
                                  -format => 'fasta' );

            foreach my $seq (@list){
                bless $seq, "Bio::Seq";
                my $test=$seq->id();
                print "$test\n";
                $out->write_seq($seq);
           }
		
           @list=();
           }
       }
}
