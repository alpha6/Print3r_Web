#!/usr/bin/env perl

use v5.20;
use strict;
use warnings;

use Plack;
use Plack::Request;
use Plack::Request::Upload;
use Plack::Builder;


use File::Copy;


my $GCODE_LOCATION = '/home/alpha6/GCODE/';

my $app = sub {
    my $env    = shift;

    my $req    = Plack::Request->new($env);
    my $res    = $req->new_response(200);
    my $params = $req->parameters();

    my $body = qq~<html><body><form method=POST action=/upload enctype="multipart/form-data">
    <input type="file" name="gcode" id="fileToUpload">
    <input type="submit" value="Upload Image" name="submit">
    </form>
    </body>
    </html>~;
    

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
    mount '/upload' => builder { $upload_app };
    mount "/" => builder { $app; };
};