#!/usr/bin/perl
use strict;
use warnings;
use Image::Magick;

# Check command-line arguments
if (@ARGV != 3) {
    die "Usage: $0 <background_image> <overlay_image> <output_image>\n";
}

my ($bg_image_path, $overlay_image_path, $output_image_path) = @ARGV;

# Create ImageMagick objects
my $bg_image = Image::Magick->new;
my $overlay_image = Image::Magick->new;

# Read input images
$bg_image->Read($bg_image_path);
$overlay_image->Read($overlay_image_path);

# Get the dimensions of the background image
my ($bg_width, $bg_height) = $bg_image->Get('width', 'height');

# Resize overlay image to match background dimensions
$overlay_image->Resize(width => $bg_width, height => $bg_height);

# Composite the images
$bg_image->Composite(image => $overlay_image, compose => 'Over');

# Write the output image
$bg_image->Write($output_image_path);

# Clean up
undef $bg_image;
undef $overlay_image;

print "Images successfully overlaid and saved to $output_image_path\n";
