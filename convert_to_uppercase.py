#Python script that reads data from one file, converts the text to uppercase, and writes it to another file.

input_file = 'input.txt'
output_file = 'output.txt'

try:
    
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        
        for line in infile:
            uppercase_line = line.upper()
            print(uppercase_line, end='')
            outfile.write(uppercase_line)  

    print(f"\nData has been processed and written to {output_file}.")

except FileNotFoundError:
    print(f"Error: {input_file} not found.")

