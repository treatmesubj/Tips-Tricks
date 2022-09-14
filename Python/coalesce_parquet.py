"""coalesce_parquets.py

gist of how to coalesce small row groups into larger row groups.
Solves the problem described in https://issues.apache.org/jira/browse/PARQUET-1115
via https://gist.github.com/NickCrews/7a47ef4083160011e8e533531d73428c
"""
from __future__ import annotations

import sys
from pathlib import Path
from typing import Callable, Iterable, TypeVar

import pyarrow as pa
import pyarrow.parquet as pq


def stream_to_parquet(path: Path, tables: Iterable[pa.Table]) -> None:
    try:
        first = next(tables)
    except StopIteration:
        return
    schema = first.schema
    with pq.ParquetWriter(path, schema) as writer:
        writer.write_table(first)
        for table in tables:
            table = table.cast(schema)  # enforce schema
            writer.write_table(table)


def stream_from_parquet(path: Path) -> Iterable[pa.Table]:
    reader = pq.ParquetFile(path)
    for batch in reader.iter_batches():
        yield pa.Table.from_batches([batch])


T = TypeVar("T")


def coalesce(
    items: Iterable[T], max_size: int, sizer: Callable[[T], int] = len
) -> Iterable[list[T]]:
    """Coalesce items into chunks. Tries to maximize chunk size and not exceed max_size.

    If an item is larger than max_size, we will always exceed max_size, so make a
    best effort and place it in its own chunk.

    You can supply a custom sizer function to determine the size of an item.
    Default is len.

    >>> list(coalesce([1, 2, 11, 4, 4, 1, 2], 10, lambda x: x))
    [[1, 2], [11], [4, 4, 1], [2]]
    """
    batch = []
    current_size = 0
    for item in items:
        this_size = sizer(item)
        if current_size + this_size > max_size:
            yield batch
            batch = []
            current_size = 0
        batch.append(item)
        current_size += this_size
    if batch:
        yield batch


def stream_from_dir(directory: Path) -> Iterable[pa.Table]:
    directory = Path(directory)
    for path in directory.glob("*.parquet"):
        yield from stream_from_parquet(path)


def coalese_parquets(in_directory: Path, outpath, max_size: int = 2**20) -> None:
    tables = stream_from_dir(in_directory)
    # Instead of coalescing using number of rows as your metric, you could
    # use pa.Table.nbytes or something.
    # table_groups = coalesce(tables, max_size, sizer=lambda t: t.nbytes)
    table_groups = coalesce(tables, max_size)
    coalesced_tables = (pa.concat_tables(group) for group in table_groups)
    stream_to_parquet(outpath, coalesced_tables)


if __name__ == "__main__":
    """
    Coalesces a directory of parquet files into a single parquet.
    If no desired resulting colesced parquet file-path is given,
    the parquet is created in the given directory of parquet files.
    """
    in_dir = sys.argv[1]
    try:
        out_file = sys.argv[2]
    except IndexError:
        out_file = f"{in_dir}/coalesced.parquet"
    coalese_parquets(in_directory=in_dir, outpath=out_file)