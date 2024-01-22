# Regular Expressions (REGEX)

A regular expression is a specification of a text-matching-pattern.\
The syntax of a regex is comprised of **_elements_**: tokens, characters, and groups.\
Characters are either simply plain literal characters in text to be matched, or regex **_metacharacters_**, which have special meaning; they represent prescribed patterns.\
**_Groups_**, signified by parentheses, define scope & precendence of operators. They can be a piece of a regex, and match sub-text-strings within the whole string matched by a regex.\
**_Quantifiers_** specify how many times a preceding element can occur.

## Character Classes
```
[abc]       a, b, or c
[^abc]      not a, b, or c
[a-z]       a to z
[A-Z]       A to Z
[a-zA-Z]    a to z, A to Z
[0-9]       0 to 9
.           any character except line-breaks
\w          alphanumeric character, including underline
\W          non-alphanumeric character
\d          numeric character
\D          non-numeric character
\s          whitespace character
\S          non-whitespace character
```

## Anchors/Assertions
```
^           start of string or line
$           end of string or line
\b          character at end of word
\B          character is not end of word
```

## Quantifiers
```
         occurs 1 time
?        occurs 0 or 1 time
+        occurs 1 or more times
*        ocurrs 0 or more times
{n}      occurs n times
{n,}     occurs n or more times
{y,z}    occurs at least y times, but less than z times
|        preceding expression or following expression occurs
```

## Groups
```
()      groups an expression
\1      references a grouped expression
(?:)    non-capturing group
```
