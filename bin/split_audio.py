#! /usr/bin/env python3

import ffmpeg
import argparse
import csv

def ts_to_seconds(ts):
    parts = [int(_) for _ in ts.split(':')]
    secs = 0
    secs += (parts[-1] if len(parts) >= 1 else 0)
    secs += (parts[-2] * 60) if len(parts) >= 2 else 0
    secs += (parts[-3] * 60 * 60) if len(parts) >= 3 else 0

    return secs


def main():
    parser = argparse.ArgumentParser("Split audio file by timestamps using ffmpeg")
    parser.add_argument('timestamps', metavar="timestamps.csv", help="CSV file formatted as <start>,<end>,<filename>")
    parser.add_argument('input', metavar="input.mp3", help="Input audio file")

    args = parser.parse_args()

    splits = []
    with open(args.timestamps) as tsfile:
        tsreader = csv.reader(tsfile)
        for row in tsreader:
            splits.append((
                ts_to_seconds(row[0]),
                ts_to_seconds(row[1]),
                row[2]))

    for i, tp in enumerate(splits):
        start, end, filename = tp

        print("========================================")
        print("Extracting %s (%d out of %d)" % (filename, i, len(splits)))
        print("========================================")
        print()
        # open a file, from `ss`, for duration `t`
        stream = ffmpeg.input(args.input, ss=start, t=(end-start))
        # output to named file
        stream = ffmpeg.output(stream, filename)
        # this was to make trial and error easier
        stream = ffmpeg.overwrite_output(stream)

        # and actually run
        ffmpeg.run(stream)

    print("done")

if __name__ == '__main__':
    main()
