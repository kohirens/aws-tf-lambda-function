# Contributing

We try to keep things idiomatic. Here's how you can contribute.

## Mind Git Commit Messages

This project uses the Version Release Tool in our CI. So it relies on Git commit
messages to indicate when to increment the semantic version. So Git commit
messages are **VERY** important in this repo.

1. Using [Conventional Commits] is **required**.
2. Create meaningful Git __commit messages__, but keep it simple by just stating
   what the change does. Don't put garbage or your life story in there.
3. Make an effort to keep your __commits changes__ small; try to keep your
   commits changes to 1-49 lines, 50-99 is also fine, 100 and over is pushing
   it.
4. If you touch a lot of files try to make multiple commits that make sense.
   Grouping them based on what belongs together. This can be tricky and knowing
   how to do it comes with experience over time; but it helps organize your
   commits, keeps them small, and reduced conflicts.

## Mind The Dependencies

1. Be mindful of the dependencies that you pull in. Investigate them, make sure
   they do not go overboard with pulling in other dependencies creating a
   nightmare chain of yet more dependencies or licenses. The ideal dependency
   would not pull in another dependency, but it's fine if they do. It becomes
   unmanageable if they pull in 10 or more which also pull in yet even more.
   When you add a dependency, check the number of lines it adds to the "go.mod"
   file or look at its graph by running `go mod graph` in a terminal. From there
   judge if it is worth pulling in based on what you need from it. 
2. Mind the licenses of the dependencies, for example MIT is O.K. What our for
   anything other than that.

---

[Conventional Commits]: https://www.conventionalcommits.org/en/v1.0.0/
