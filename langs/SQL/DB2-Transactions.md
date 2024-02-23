- `COMMIT`
    - `LUW`: terminates a unit of work and commits the database changes that were made by that unit of work.
    - `z/OS`: ends the unit of recovery in which it is executed and a new unit of recovery is started for the process
- `ROLLBACK`
    - used to back out of the database changes that were made within a unit of work or a savepoint.

# DB2 LUW Transactions
In Db2-LUW, all statements execute in a transaction, automatically.
The transaction begins on the first statement after a previous transaction
ends, or after a connect. The transaction ends when there is a `COMMIT`, or a
`ROLLBACK`
```sql
begin atomic
   update accounts set accbalance = accbalance -50
   where accnumber = 'C-009';
   update accounts set accbalance = accbalance +50
   where accnumber = 'C-009';
   commit;
end@

-- or

commit;  -- if you want to end any previous transaction
update accounts set accbalance = accbalance -50
where accnumber = 'C-009';
update accounts set accbalance = accbalance +50
where accnumber = 'C-009';
commit;
```

# DB2 z/OS Transactions
Superficially, these resemble explicit transactions, but they are not. Instead,
they really are just points in time within a single implicit transaction.
```sql
SAVEPOINT A ON ROLLBACK RETAIN CURSORS;

UPDATE MYTABLE SET MYCOL = 'VAL' WHERE 1;

ROLLBACK WORK TO SAVEPOINT A;
```
