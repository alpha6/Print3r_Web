#!/usr/bin/env perl

use v5.20;
use strict;
use warnings;

use lib 'lib';

use Plack;
use Plack::Request;
use Plack::Request::Upload;
use Plack::Builder;

use Text::Xslate qw(mark_raw);

use Print3r::Web::Utils;


use File::Copy;
use File::Spec;
use Cwd;

use Data::Dumper;


my $tx = Text::Xslate->new();
my $utils = Print3r::Web::Utils->new();

my $GCODE_LOCATION = '/home/alpha6/GCODE/';

my $CWD = getcwd;

my $app = sub {
    my $env    = shift;

    my $req    = Plack::Request->new($env);
    my $res    = $req->new_response(200);
    my $params = $req->parameters();

    my $files_list = $utils->get_files_list($GCODE_LOCATION);

    # say Dumper($files_list);
    my %vars = (
        files => $files_list
    );

    my $body = $tx->render('templates/index.tx', \%vars);
    

    $res->body($body);

    return $res->finalize();
};

my $upload_app = sub {
    my $env = shift;

    my $req    = Plack::Request->new($env);
    my $upload = $req->uploads->{'gcode'};
 
    my $res    = $req->new_response(200);
    my $params = $req->parameters();

    say $upload->size;
    say $upload->path;
    say $upload->content_type;
    say $upload->basename;

    copy($upload->path, sprintf('%s/%s', $GCODE_LOCATION, $upload->basename));

    $res->body('Ok');

    return $res->finalize();
};


my $main_app = builder {
    enable "Static", path => qr!^/css|img!, root => File::Spec->catdir($CWD, '/public');
    mount '/upload' => builder { $upload_app };
    mount "/" => builder { $app; };
};