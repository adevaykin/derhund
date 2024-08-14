import csv

input_file = 'nouns.csv'
output_file = 'german_nouns.txt'
article_map = {
    'f': "die",
    'm': "der",
    'n': "das"
}

with open(input_file, newline='') as infile, open(output_file, 'w', newline='') as outfile:
    reader = csv.reader(infile)
    writer = csv.writer(outfile)
    for row in reader:
        contains_digit = any(char.isdigit() for char in row[0])
        contains_minus = any(char == '-' for char in row[0])
        contains_space = any(char == ' ' for char in row[0])
        
        if (len(row) >= 3 and
            row[0] and
            not contains_digit and
            not contains_minus and
            not contains_space and
            not "Abkürzung" in row[1] and
            not "Buchstabe" in row[1] and
            not "adjektivische Deklination" in row[1] and
            row[2]):
            word = row[0]
            article = article_map.get(row[2], "unknown")
            writer.writerow([word, article])

print(f"Processed CSV file saved to {output_file}")
