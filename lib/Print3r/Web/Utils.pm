package Print3r::Web::Utils;

use v5.20;
use strict;
use warnings;
use File::Spec;

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
        my @stat = stat(File::Spec->catfile($folder_path, $file));
        push @files_list, {title => $file, size => $stat[7], mtime => $stat[9]};
    }
    closedir $DIR;

    return \@files_list;
}

1;