/* chroot -- run command or shell with special root directory
   Copyright (C) 95, 96, 1997, 1999 Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software Foundation,
   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  */

/* Written by Roland McGrath.  */

#include <config.h>
#include <stdio.h>
#include <sys/types.h>

#include "system.h"
#include "long-options.h"
#include "error.h"

/* The official name of this program (e.g., no `g' prefix).  */
#define PROGRAM_NAME "chroot"

#define AUTHORS "Roland McGrath"

/* The name this program was run with, for error messages. */
char *program_name;

void
usage (int status)
{
  if (status != 0)
    fprintf (stderr, _("Try `%s --help' for more information.\n"),
	     program_name);
  else
    {
      printf (_("\
Usage: %s [OPTION] NEWROOT [COMMAND...]\n\
  or:  %s OPTION\n\
"), program_name, program_name);
      printf (_("\
Run COMMAND with root directory set to NEWROOT.\n\
\n\
      --help       display this help and exit\n\
      --version    output version information and exit\n\
\n\
If no command is given, run ``${SHELL} -i'' (default: /bin/sh).\n\
"));
      puts (_("\nReport bugs to <bug-sh-utils@gnu.org>."));
    }
  exit (status);
}

int
main (int argc, char **argv)
{
  program_name = argv[0];
  setlocale (LC_ALL, "");
  bindtextdomain (PACKAGE, LOCALEDIR);
  textdomain (PACKAGE);

  parse_long_options (argc, argv, PROGRAM_NAME, GNU_PACKAGE, VERSION,
		      AUTHORS, usage);
  if (argc == 1)
    {
      error (0, 0, _("too few arguments"));
      usage (1);
    }

  if (chroot (argv[1]))
    error (1, errno, _("cannot change root directory to %s"), argv[1]);

  if (chdir ("/"))
    error (1, errno, _("cannot chdir to root directory"));

  if (argc == 2)
    {
      /* No command.  Run an interactive shell.  */
      char *shell = getenv ("SHELL");
      if (shell == NULL)
	shell = "/bin/sh";
      argv[0] = shell;
      argv[1] = "-i";
    }
  else
    {
      /* The following arguments give the command.  */
      argv += 2;
    }

  /* Execute the given command.  */
  execvp (argv[0], argv);
  error (1, errno, _("cannot execute %s"), argv[0]);

  exit (1);
  return 1;
}
