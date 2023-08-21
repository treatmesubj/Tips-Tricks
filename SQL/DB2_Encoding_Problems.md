So, I guess z/OS uses [EBCDIC (Extended Binary Coded Decimal Interchange Code)](https://simple.wikipedia.org/wiki/EBCDIC) 127 character encoding.
Its text strings have an additional 2 byte binary number - [CCSID (Coded Character Set Identifier)](https://www.ibm.com/docs/en/db2-for-zos/12?topic=conversion-coded-character-sets-ccsids)
- DB2 z/OS Character Conversion [Docs](https://www.ibm.com/docs/en/db2-for-zos/12?topic=concepts-character-conversion)
- CCSID for EBCDIC [reference values](https://www.ibm.com/docs/en/rdfi/9.6.0?topic=reference-ccsid-values)
For our DB2 z/OS source, they're CCSID 37
```
SELECT NAME, CCSID
FROM SYSIBM.SYSCOLUMNS
WHERE TBNAME = 'AM_ORD'
AND TBCREATOR = 'SMS01'
WITH UR;
```

DB2 z/OS has some logic to parse strings for magic bytes and determine the correct visible characters to display. It can be seen in...
```
SELECT *
FROM SYSIBM.SYSSTRINGS
WITH UR;
```
Ultimately, it seems like we are taking these strings from the DB2 z/OS and putting it into our DB2 LUW/Cloud, which must have Unicode tables, and doesn't know how to interpret the weird EBCDIC encoded text, so the extra bytes sometimes get converted to additional weird Unicode characters
They document this potential problem [here](https://www.ibm.com/docs/en/db2-for-zos/11?topic=dcup-potential-problems-when-inserting-non-unicode-data-into-unicode-table)
