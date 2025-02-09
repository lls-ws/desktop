#print("Hello World!")
#input("Press any key to close")

import pandas as pd
#from bs4 import BeautifulSoup

# Read the HTML file into a Pandas dataframe
#with open('/tmp/fundamentus.html') as file:
#    soup = BeautifulSoup(file, 'html.parser')
#tables = pd.read_html(str(soup), encoding='latin-1')

#pd.read_html('https://www.fundamentus.com.br/fii_resultado.php')

# Extract the table from the dataframe
#table = tables[0]
#print(table)

import requests

url = 'https://www.fundamentus.com.br/fii_resultado.php'

header = {
  "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.75 Safari/537.36",
  "X-Requested-With": "XMLHttpRequest"
}

r = requests.get(url, headers=header)

dfs = pd.read_html(r.text)
