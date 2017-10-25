package Print3r::Web::Utils;

use v5.20;
use strict;
use warnings;

sub new {
    bless {}, shift;
}


sub get_files_list {
    my $self =  shift;
    my $folder_path = shift;

    my @files_list = ();

    opendir my $DIR, $folder_path or die $!;
    for my $file (readdir($DIR)) {
        next if ($file !~ m/\.gcode$/);
        push @files_list, {title => $file};
    }
    closedir $DIR;

    return \@files_list;
}

1;