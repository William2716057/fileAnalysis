#!/bin/bash

# Check if the file is provided
if [ $# -eq 0 ]; then
    echo "Enter file: $0 <input_file>"
    exit 1
fi

input_file=$1
output_file="analysis.txt"

# Clear previous results file
> $output_file

# Execute exiftool and append to results.txt
echo "Running exiftool on $input_file..." >> $output_file
exiftool $input_file >> $output_file 2>&1
echo -e "\n\n" >> $output_file

# Execute objdump and append to results.txt
echo "Running objdump on $input_file..." >> $output_file
objdump -x $input_file >> $output_file 2>&1
echo -e "\n\n" >> $output_file

# Execute hexdump and append to results.txt
echo "Running hexdump on $input_file..." >> $output_file
hexdump -C $input_file >> $output_file 2>&1
echo -e "\n\n" >> $output_file

# Execute objdump and check if stripped
echo "Checking if $input_file is stripped..." >> $output_file
if objdump -h $input_file | grep -q ".strtab"; then
    echo "$input_file is not stripped." >> $output_file
else
    echo "$input_file is stripped." >> $output_file
    echo "Running readelf and grepping Entry..." >> $output_file
    readelf -a $input_file | grep Entry >> $output_file 2>&1
fi

echo "Results saved to $output_file."
