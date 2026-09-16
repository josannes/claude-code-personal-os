# Studies

Applies to everything under `01_studies/`. Inherits the root `CLAUDE.md`.

## Structure

One folder per term, one subfolder per course, made with `/new-project`.

- Term folders: `<YYYY>-<term>`, for example `2026-autumn`. TODO: change to how your school
  names terms, and keep it the same forever. Renamed folders lose their session history.
- Course folders: the course code or a short name.
- Each term folder has a `deadlines.md` with exams and hand-ins for all its courses.

## Three rules for every course

**1. The exam format first.** The first task in a new course is reading the course
description and the exam format. The folder is designed around the exam, not copied from
an earlier course. Lessons from earlier courses: `_templates/course/PATTERNS.md`.

**2. `progress.md` and `mistakes.md` from day one.** `progress.md` says where we are, so the
next session starts where the last one stopped. `mistakes.md` has two kinds of entries:
subject errors (didn't know the material) and lookup errors (couldn't find it fast enough,
which means the material is broken, not you).

**3. School material in `_source/`, text extracts in `_raw/`, everything else is yours.**
Verify against the syllabus, don't remember: search `_raw/` before claiming something is
part of the course.

## Never

- Change an old course folder. It is a record of how that course went.
- Put the school's material (exam sets, slides, textbooks) in a public place.
