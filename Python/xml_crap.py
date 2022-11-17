import os
import xmltodict
import json


def dictionary_check(input):
    """
    First prints the final entry in the dictionary (most nested) and its key
    Then prints the keys leading into this
    * could be reversed to be more useful, I guess
    """
    for key, value in input.items():
        if isinstance(value, dict):
            dictionary_check(value)
            print(key)
        else:
            print(key, value)


ecrvForms = []
directory = "C:\\Users\\JohnHupperts\\Downloads\\2022-11-14-07-11-06_eCRVExtract"
for filename in os.listdir(directory):
    print(filename)
    file_path = os.path.join(directory, filename)
    with open(file_path) as f:
        xml = f.read()
        my_dict = xmltodict.parse(xml)
        ecrvForms.append(my_dict)
        print(len(ecrvForms))

