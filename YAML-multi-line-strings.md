# [StackOverflow](https://stackoverflow.com/questions/3790454/how-do-i-break-a-string-in-yaml-over-multiple-lines)

- `>`, `|`: "clip": keep the line feed, remove the trailing blank lines.
- `>-`, `|-`: "strip": remove the line feed, remove the trailing blank lines.
- `>+`, `|+`: "keep": keep the line feed, keep trailing blank lines.

## TL;DR
Use `>` most of the time: interior line breaks are stripped out, although you get one at the end:
```yaml
key: >
  Your long
  string here.
```

Use `|` if you want those linebreaks to be preserved as `\n` (for instance, embedded markdown with paragraphs).
```yaml
key: |
  ### Heading

  * Bullet
  * Points
```

Use `>-` or `|-` instead if you don't want a linebreak appended at the end.\
Use `"..."` if you need to split lines in the middle of words or want to literally type linebreaks as `\n`:
```yaml
key: "Antidisestab\
 lishmentarianism.\n\nGet on it."
```
