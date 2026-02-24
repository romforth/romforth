Thank you for your interest in contributing to romforth.

Contributions of bug reports, documentation improvements, feature requests and
code changes are all welcome.

Code contributions in the form of new ports or improvements to the existing
code base are even more welcome. Improvements may only include changes which
_reduce_ the code - in space or time or both. New feature requests which
_increases_ the resources (ROM/RAM/Cycles/CPI/...) used by the generated code
may be considered - but only if it fixes a bug or if there is some other really
good reason for it.

By contributing code here, you agree to the same conditions as the Linux kernel
developers where you sign your work to certify the provenance of the code.
See the section "Developer’s Certificate of Origin" in
https://www.kernel.org/doc/html/latest/process/submitting-patches.html

To summarize : by submitting code here, you confirm that
1. You wrote/co-developed the code and understand what it does
2. does not violate any other software licenses or infringe on any IP rights
3. can be redistributed under the terms of the AGPL V3 license as spelled out
   in the LICENSE file under which this code is available.

When you create a new port, you have a choice of doing a full ("fourforth") port
or any partial/"prefix" port (currently categorized as "oneforth", "twoforth",
and "threeforth") or anything in between - all of these are acceptable choices
although the preference is for full ports.

Although this code is currently hosted on Github, you do _not_ need a Github
account to create a new port but if you do, it may make many of the steps
listed below a little easier. If you do not wish to use Github, I'm quite happy
to accept your patches using the Linux kernel's `git send-email` workflow.
If you don't want to bother with even that, just send me a link to your git
repository which I can clone/pull from and I can take care of the rest.

You are welcome to use any source control system (not necessarily `git` either)
and mail me a set of patches generated to match the format of `git format-patch`
Please send all of the patches as a single tar/zip attachment in a single email
with an suitable subject line.

The rest of this doc assumes you are using Github - but please read through it
to be familiar with the non-Github specific parts.

Before starting off on a new port, it might be a good idea to broadcast your
intention of working on that port by first creating a Github Issue for it at:
https://github.com/romforth/romforth

Creating a Github issue requires a Github account though so if you'd rather not
create an account on Github, feel free to send me an email to let me know your
plans and I can create the Github issue for you.

That way, any other folks who may want to work on that port can be aware that
someone else is already working on it and depending on their patience, either
wait for you to finish your port or create a new Github issue to work on it
themselves.

Once that is done, you can start working on any additional toolchain that might
be needed for your port. I'd prefer to not have to make even more additions to
the existing toolchain which is required to build the code but if your port
requires it, make sure to upstream the toolchain changes first to
https://github.com/romforth/toolchain (either via a Github pull request or by
emailing me the patches as described earlier).

With the toolchain in place, you can then start work on your port but there are
some restrictions on how your code contributions must be structured. To help
navigate these restrictions please follow this recipe:

1. Create your own fork of https://github.com/romforth/romforth
   - You are free to fork it on to any source repository of your choice but the
     rest of the recipe here assumes Github - modify as appropriate.
2. Clone your forked repo locally to your machine:
	`git clone https://github.com/your_user_name_on_github/romforth`
	or `git clone https://$forge/$user/$repo`
3. In your local repo, create a new git branch where you can do your work:
	`git checkout -b $port`
4. Create a new directory for the port by using the `newport` script:
   - Using the `newport` script is not a requirement - you can do all the setup
     required on your own but I'm leaving it here since it might be helpful and
     reduce the grunt work you need to do. See `git log` and look for "step 0"
     commits for the sample changes that are typical at the start of a port.
   - See `PORTING`, `pseudo/code` or the `newport` script itself for details:
	`./newport $dirport $portname $portsuffix`
5. Change directory to the new port and make all your changes there:
	`cd $dirport` # ... and work on your port in that directory
6. Each porting step must be a separate commit (expect ~74 commits to a port)
   - See the `git log` to look at how existing ports have been structured
7. Each step of the port must pass all tests. Prior to each step, which you
   `git commit`, run `make` and ensure that it was successful. You could make
   judicious use of the `git_auto_commit` script to do this automatically since
   that adds the correct commit message automatically for each step.
8. After the port is complete, run `./runallsteps $port` from the toplevel
   as an additional sanity check and verify that you have followed all the
   steps documented in pseudo/code
9. When you are sure that all the tests pass, push your changes to your repo.
10. Send me a link to your fork which I can review and after I have approved the
    changes, create a pull request on Github to merge your changes upstream or
    if you need to discuss something before that, feel free to update the Github
    issue that you created initially.

Before your pull request can be merged, I will do a final review of the changes
whenever I can and run the sanity checks myself with each of your commits. Your
code contribution will be merged only if all tests pass.
