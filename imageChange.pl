#!/usr/local/bin/perl

use MP3::Tag;
use Image::Magick;
use File::Find;

my $dir   = "Billie Eilish - dont smile at me";
my $image = "imagine.jpg";

opendir(DH, $dir);
my @files = readdir(DH);
closedir(DH);

foreach my $file (@files) {
  print $file . "\n";
  next if($file =~ /^\.$/);
  next if($file =~ /^\.\.$/);
  cover_art($image, "$dir/$file");
}

sub cover_art {
    my ($jpg, $file) = @_;
    my $image = Image::Magick->new;
    unless ($image->Read($jpg)) {
        my $imagedata = $image->ImageToBlob(magick => 'jpg');
        undef $image;
        my $mp3 = MP3::Tag->new($file);
        $mp3->get_tags();
        my $id3v2 = $mp3->new_tag("ID3v2");
        $id3v2->add_frame("APIC", chr(0x0), 'image/jpg', chr(0x0), 'Cover (front)', $imagedata);
        $id3v2->write_tag();
        $mp3->close();
    } else {
        print "Couldn’t read image '$jpg'\n";
    }
}
