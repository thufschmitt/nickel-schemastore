import urllib.request
import urllib.parse
import json
import subprocess
import os.path
from multiprocessing import Pool

out_path="out"

def fetch_schema_list():
    with urllib.request.urlopen("https://www.schemastore.org/api/json/catalog.json") as response:
        return json.load(response)

def fetch_schema(schema_descr):
    with urllib.request.urlopen(schema_descr["url"]) as response:
        return response.read()

def parse_attr_name(raw_url):
    url = urllib.parse.urlparse(raw_url)
    original_filename = os.path.basename(url.path)
    return os.path.splitext(original_filename)[0]

def convert_to_nickel(raw_schema, dest_file_name):
    os.makedirs(os.path.dirname(dest_file_name), exist_ok = True)
    with open(dest_file_name, "w+") as out:
        js2n = subprocess.run(["json-schema-to-nickel"],
            input = raw_schema,
            stdout = out,
            check = True,
        )

def process_one_schema(schema_descr):
    name = schema_descr["name"]
    attr_name = schema_descr["name"]
    dest_file_name = os.path.join(out_path, attr_name + ".ncl")
    try:
        raw_schema = fetch_schema(schema_descr)
        convert_to_nickel(raw_schema, dest_file_name)
        print(f"“{name}”: OK")
    except Exception as e:
        with open(dest_file_name, "w+") as dest:
            print("null", file=dest)
        print(f"“{name}”: Failure")
        print(e)
    return f'"{attr_name}" = import "{dest_file_name}",'

def main():
    schemas = fetch_schema_list()["schemas"]

    with Pool(16) as p:
        record_fields = p.map(process_one_schema, schemas)

    with open("main.ncl", "w+") as entrypoint:
        print("{", file=entrypoint)
        for line in record_fields:
              print(line, file=entrypoint)
        print("}", file=entrypoint)

main()
