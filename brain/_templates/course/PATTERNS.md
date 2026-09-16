# Lessons from earlier courses

Experience, not a blueprint. **Each course folder is designed around its own exam format**,
not copied from the last one. Read this to avoid repeating mistakes, not to pick "the right
pattern".

Below are lessons that held up across courses with different exam formats. Add your own
under "My courses" as you finish each course: format, what worked, what didn't.

---

## What carried over

1. **Course description and exam format first.** Everything else follows from them.

2. **`progress.md` and `mistakes.md` from day one.** They are why the next session doesn't
   start from zero.

3. **School material in `_source/`, text extracts in `_raw/`, everything else is yours.**

4. **Verify against the syllabus, don't remember.** Search `_raw/` before claiming something
   is part of the course. Without this, Claude will happily bring in theory that isn't.

5. **Small, bounded tasks with checkable done criteria.** Large, open mapping tasks
   ("summarise the whole course") go wrong.

6. **Build what you bring to the exam first.** If aids are allowed, the tools and texts you
   will actually use in the exam room matter more than explanations. Explanations come after.

7. **Rank past exams by similarity, not by year.** Three things decide: same exam format,
   same examiner, same syllabus. If the format hasn't changed in years, every set is a
   question bank and the newest ones show the format. If it has changed, only sets with
   the current format show the format.

## Structures that worked, by exam type

**Written exam with all aids allowed:** one folder per question type with a recipe per
type, each recipe listing the exact phrases from past exams that trigger it (so it can be
found with Ctrl+F during the exam), plus ready-made tools and answer texts.

**Report plus oral exam:** a course map showing how topics connect, a detailed map per
lecture block, the outline kept separate from the report text so structure can be
discussed without touching the prose.

**Project with your own data:** theory in `.claude/rules/`, one file per theory, with
`paths:` so the rule loads when the report is edited. Note that `.claude/rules/` only
works when the session starts in the course folder itself.

---

## My courses

<!-- For each finished course: name, exam format, folder structure, what worked, what didn't. -->
