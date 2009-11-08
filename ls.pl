#!/usr/bin/perl
use strict;
use warnings;
use Cwd;

my $pwd = cwd();

# Check to see if any of the arguments exist as directories.
my @directories = grep { -d $_ || -d "$pwd/$_" } @ARGV;

# Use anything beginning with a - as an argument for ls
my @arguments = grep { /^-/ } @ARGV;

my $ls_arguments = join(' ', @arguments);

if (!@directories)
{
    # If no directories were specified, and all of the other arguments are valid, work on the current directory.
    if (@arguments == @ARGV)
    {
        push @directories, ".";
    }
    else
    {
        # Enumerate the invalid directories
        foreach(grep { !($_ ~~ @directories || $_ ~~ @arguments) } @ARGV)
        {
            print "ls: cannot access $_: No such file or directory\n";
        }
    }
}

foreach(@directories)
{
    # Correct any spaces in filenames.
    my $fixed_dir = $_;
    $fixed_dir =~ s/ /\\ /;

    # Call ls on each directory separately so that we can output the .ls file beside it.
    if (system("ls $fixed_dir $ls_arguments") == 0)
    {
        # Open the .ls file, if it exists. Otherwise, go on to the next directory.
        open(my $file, '<', "$_/.ls") or next;
        print "---\n";
        print <$file>;
        print "---\n";
        close($file);
    }
}
