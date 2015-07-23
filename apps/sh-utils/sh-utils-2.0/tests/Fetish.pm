package Fetish;
# This is a testing framework.

# In case you're wondering about the name, it comes from the
# names of the three packages: FIleutils, SH-utils, TExtutils.

require 5.003;
use strict;
use vars qw($VERSION @ISA @EXPORT);

use FileHandle;
use File::Compare qw(compare);

@ISA = qw(Exporter);
($VERSION = '$Revision: 1.6 $ ') =~ tr/[0-9].//cd;
@EXPORT = qw (run_tests);

my $debug = $ENV{DEBUG};

my @Types = qw (IN OUT ERR EXIT PRE POST);
my %Types = map {$_ => 1} @Types;
my %Zero_one_type = map {$_ => 1} qw (OUT ERR EXIT PRE POST);
my $srcdir = $ENV{srcdir};
my $Global_count = 1;

# A file spec: a scalar or a reference to a single-keyed hash
# ================
# 'contents'               contents only (file name is derived from test name)
# {filename => 'contents'} filename and contents
# {filename => undef}      filename only -- $(srcdir)/filename must exist
#
# FIXME: If there is more than one input file, the you can't specify REDIRECT.
# PIPE is still ok.
#
# I/O spec: a hash ref with the following properties
# ================
# - one key/value pair
# - the key must be one of these strings: IN, OUT, ERR, EXIT
# - the value must be a file spec
# {OUT => 'data'}    put data in a temp file and compare it to stdout from cmd
# {OUT => {'filename'=>undef}} compare contents of existing filename to
#           stdout from cmd
# {OUT => {'filename'=>[$CTOR, $DTOR]}} $CTOR and $DTOR are references to
#           functions, each which is passed the single argument `filename'.
#           $CTOR must create `filename'.
#           DTOR may be omitted in which case `sub{unlink @_[0]}' is used.
#           FIXME: implement this
# Ditto for `ERR', but compare with stderr
# {EXIT => N} expect exit status of cmd to be N
#
# There may be many input file specs.  File names from the input specs
# are concatenated in order on the command line.
# There may be at most one of the OUT-, ERR-, and EXIT-keyed specs.
# If the OUT-(or ERR)-keyed hash ref is omitted, then expect no output
#   on stdout (or stderr).
# If the EXIT-keyed one is omitted, then expect the exit status to be zero.

# FIXME: Make sure that no junkfile is also listed as a
# non-junkfile (i.e. with undef for contents)

sub _shell_quote ($)
{
  my ($string) = @_;
  $string =~ s/\'/\'\\\'\'/g;
  return "'$string'";
}

sub _create_file ($$$$)
{
  my ($program_name, $test_name, $file_name, $data) = @_;
  my $file;
  if (defined $file_name)
    {
      $file = $file_name;
    }
  else
    {
      $file = "$test_name.$Global_count";
      ++$Global_count;
    }

  warn "creating file `$file' with contents `$data'\n" if $debug;

  # The test spec gave a string.
  # Write it to a temp file and return tempfile name.
  my $fh = new FileHandle "> $file";
  die "$program_name: $file: $!\n" if ! $fh;
  print $fh $data;
  $fh->close || die "$program_name: $file: $!\n";

  return $file;
}

# FIXME: cleanup on interrupt
# FIXME: extract `do_1_test' function

# FIXME: having to include $program_name here is an expedient kludge.
# Library code doesn't `die'.
sub run_tests ($$$$$)
{
  my ($program_name, $prog, $t_spec, $save_temps, $verbose) = @_;

  # Warn about empty t_spec.
  # FIXME

  # Remove all temp files upon interrupt.
  # FIXME

  # Verify that test names are distinct.
  my $found_duplicate = 0;
  my %seen;
  my $t;
  foreach $t (@$t_spec)
    {
      my $test_name = $t->[0];
      if ($seen{$test_name})
	{
	  warn "$program_name: $test_name: duplicate test name\n";
	  $found_duplicate = 1;
	}
      $seen{$test_name} = 1;
    }
  return 1 if $found_duplicate;

  # FIXME check exit status
  system ($prog, '--version') if $verbose;

  my @junk_files;
  my $fail = 0;
  foreach $t (@$t_spec)
    {
      my $test_name = shift @$t;
      my $expect = {};
      my ($pre, $post);

      # FIXME: maybe don't reset this.
      $Global_count = 1;
      my @args;
      my $io_spec;
      my %seen_type;
      foreach $io_spec (@$t)
	{
	  if (!ref $io_spec)
	    {
	      push @args, $io_spec;
	      next;
	    }

	  die "$program_name: $test_name: invalid test spec\n"
	    if ref $io_spec ne 'HASH';

	  my $n = keys %$io_spec;
	  die "$program_name: $test_name: spec has $n elements --"
	    . " expected 1\n"
	      if $n != 1;
	  my ($type, $val) = each %$io_spec;
	  die "$program_name: $test_name: invalid key `$type' in test spec\n"
	    if ! $Types{$type};

	  # Make sure there's no more than one of OUT, ERR, EXIT.
	  die "$program_name: $test_name: more than one $type spec\n"
	    if $Zero_one_type{$type} and $seen_type{$type}++;

	  if ($type eq 'PRE' or $type eq 'POST')
	    {
	      $expect->{$type} = $val;
	      next;
	    }

	  if ($type eq 'EXIT')
	    {
	      die "$program_name: $test_name: invalid EXIT code\n"
		if $val !~ /^\d+$/;
	      # FIXME: make sure $data is numeric
	      $expect->{EXIT} = $val;
	      next;
	    }

	  my $file_spec = $val;
	  my ($file_name, $contents);
	  if (!ref $file_spec)
	    {
	      ($file_name, $contents) = (undef, $file_spec);
	    }
	  elsif (ref $file_spec eq 'HASH')
	    {
	      my $n = keys %$file_spec;
	      die "$program_name: $test_name: $type spec has $n elements --"
		. " expected 1\n"
		  if $n != 1;
	      ($file_name, $contents) = each %$file_spec;
	    }
	  else
	    {
	      die "$program_name: $test_name: invalid RHS in $type-spec\n"
	    }

	  my $is_junk_file = (! defined $file_name
			      || ($type eq 'IN' && defined $contents));
	  my $file = _create_file ($program_name, $test_name,
				   $file_name, $contents);
	  if ($type eq 'IN')
	    {
	      push @args, _shell_quote $file;
	    }
	  else
	    {
	      $expect->{$type} = $file;
	    }

	  if ($is_junk_file)
	    {
	      push @junk_files, $file
	    }
	  else
	    {
	      # FIXME: put $srcdir in here somewhere
	      warn "$program_name: $test_name: specified file `$file' does"
		. " not exist\n"
		  if ! -f "$srcdir/$file";
	    }
	}

      # Expect an exit status of zero if it's not specified.
      $expect->{EXIT} ||= 0;

      # Allow ERR to be omitted -- in that case, expect no error output.
      my $eo;
      foreach $eo (qw (OUT ERR))
	{
	  if (!exists $expect->{$eo})
	    {
	      $expect->{$eo} = _create_file ($program_name, $test_name,
					     undef, '');
	      push @junk_files, $expect->{$eo};
	    }
	}

      # FIXME: Does it ever make sense to specify a filename *and* contents
      # in OUT or ERR spec?

      warn "$test_name...\n" if $verbose;
      &{$expect->{PRE}} if $expect->{PRE};
      my %tmp;
      $tmp{OUT} = "$test_name.O";
      $tmp{ERR} = "$test_name.E";
      push @junk_files, $tmp{OUT}, $tmp{ERR};
      my @cmd = ($prog, @args, "> $tmp{OUT}", "2> $tmp{ERR}");
      my $cmd_str = join ' ', @cmd;
      warn "Running command: `$cmd_str'\n" if $debug;
      my $rc = 0xffff & system $cmd_str;
      if ($rc == 0xff00)
	{
	  warn "$program_name: test $test_name failed: command failed:\n"
	    . "  `$cmd_str': $!\n";
	  $fail = 1;
	  goto cleanup;
	}
      $rc >>= 8 if $rc > 0x80;
      if ($expect->{EXIT} != $rc)
	{
	  warn "$program_name: test $test_name failed: exit status mismatch:"
	    . "  expected $expect->{EXIT}, got $rc\n";
	  $fail = 1;
	  goto cleanup;
	}

      foreach $eo (qw (OUT ERR))
	{
	  my $eo_lower = lc $eo;
	  if (compare ($expect->{$eo}, $tmp{$eo}))
	    {
	      warn "$program_name: test $test_name: std$eo_lower mismatch,"
		. " comparing $expect->{$eo} and $tmp{$eo}\n";
	      $fail = 1;
	    }
	}

    cleanup:
      &{$expect->{POST}} if $expect->{POST};

    }

  # FIXME: maybe unlink files inside the big foreach loop?
  unlink @junk_files if ! $save_temps;

  return $fail;
}

## package return
1;
