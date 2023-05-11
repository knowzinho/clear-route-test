import re

# Regex pattern
age_pattern = r"\b5[0-9]\b|\b4[0-9]\b"

with open('stage-1/latest-customers.txt', 'r') as input_file:

    # Split file by lines
    file = input_file.read().splitlines()

    with open("stage-1/affected-customers.txt", "w") as output_file:

        # Loop through each line
        for line in file:

            # Find affected customers by age
            if re.search(age_pattern, line):

                customer_info = line.split(",")                    
                name = customer_info[0]
                phone = re.sub(r'\(|\)', '', customer_info[-2])
                email = customer_info[-1]

                # Write the name, phone number, and email to the output file
                output_file.write(f"Name: {name}, Phone: {phone}, Email: {email}\n")