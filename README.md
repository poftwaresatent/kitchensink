kitchensink
===========

Trying to get some sensible way of archiving all my files based on SHA
and hardlinks, with reverse lookup as well. Will start out as a hacky
shell script, may evolve if it turns out useful.

Features freely mixed with wishlist:
- files get stashed away in an object hierarchy based on their SHA256
- they also get an entry in the symbol hierarchy, as hard links to the
  objects
- files that appear more than once thus do not take up extra space,
  especially important for big file
- in case of symbol name clashes, do some smart conflict resolution
  (right now simply create a CLASHES directory where every version of
  the clashing symbol gets an entry, disambiguated with a filename
  that contains the hash and timestamp).
- preserve timestamps (original file creation time)
- would be nice to have also a reverse lookup: for any given object,
  list the symbols under which it exists, and also when they were
  created, entered into the symbol hierarchy, the filetype, etcetc.
- would also be nice to have a timestamp-based hierarchy in parallel
  to the object and symbol hierarchies.
- an efficient way to re-crawl already stashed hierarchies would
  definitely be nice, a la rsync, instead of recomputing every single
  file's hash.
- rewriting paths, or at least some prefix thereof, is high on the
  to-do list as well (right now it's simply the absolute path, which
  is mighty weird when pulling things from various external backup
  discs that follow similar layouts).

kitchensink-stash.sh
====================

A bash script that takes file names on stdin, and stashes them away in
object and symbl hierarchies, attempting to resolve conflicts etc.

Hard-codes the base directory, and uses a couple of other half-baked
tweaks that kind of just seem to work for me right now.

kitchensik-crawl.sh
===================

A bash script to find files underneath a given directory, ignoring
.svn and .git subhierarchies, and attempting to escape all manners of
special characters. Probably best to rewrite this in Perl, but it's
been probably a decade or so since I last touched Perl...
