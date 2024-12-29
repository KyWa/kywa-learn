import os
from pypdf import PdfReader
import tabula

pdf_name = "pitched-battle-profiles.pdf"
d_names = ["/tmp/battleprofiles","battleprofiles"]

## TODO - Cleanup tmp dir in final
## Creates directories for the extracted files
for d in d_names:
    try:
        os.mkdir(d)
    except FileExistsError:
        print(f"Directory '{d}' already exists.")
    except PermissionError:
        print(f"Permission denied: Unable to create '{d}'.")
    except Exception as e:
        print(f"An error occurred: {e}")

## PdfReader testing
pdf_reader = PdfReader(pdf_name)
n_pages = len(pdf_reader.pages)
page = pdf_reader.pages[33]
text = page.extract_text()

print(text)

## TODO - Parse instead of having to write twice
## Generates the files needed and then reads the actual battle profile pages and creates those elsewhere
for i in range(n_pages):
    page = pdf_reader.pages[i]
    text = page.extract_text()
    f = open("%s/page-%s.txt" % (d_names[0], i), "w")
    f.write(text)
    f.close()
    read_f = open("%s/page-%s.txt" % (d_names[0], i))
    content = read_f.readlines()
    if "BATTLE PROFILES" in content[1]:
        z = open("%s/page-%s.txt" % (d_names[1], i), "w")
        z.write(text)
        z.close()

## Trying tabula
### pulls in the PDF and reads the tables in it
### Can be printed out with print(dfs[0])
dfs = tabula.read_pdf(pdf_name, pages="6-37")

### Converter function to just grab the tables from specific pages
tabula.convert_into(pdf_name, "battle-profiles.csv", output_format="csv", pages='6-37')
#print(dfs[0])
#tabula.convert_into(pdf_name, "/mnt/c/Users/unixi/Downloads/ironjawz.csv", output_format="csv", pages='34')
#tabula.convert_into(pdf_name, "/mnt/c/Users/unixi/Downloads/slaves.xlsx", output_format="csv", pages='26-27')
