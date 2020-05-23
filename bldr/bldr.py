#!/usr/bin/env python3

import hashlib
import json

"""
storage config
{ storage_location: }

image list
{ images: [{alias: <>, ref: <>}], layers:[{alias: <>, ref: <>}] }

metadata
{ name: <>, desc: <>, author: <>, date: <> }

image config
{ metadata: <>, layers: [{alias: <>, ref: <>}] }

layer config
{ metadata: <>, ref: <> }
"""

config_path = "/etc/bldr/storage_config.json"

def get_value(value_file_name, storage_config):
    storage_location = storage_config['storage_location']
    file_path =  "/".join([storage_location, output_name])
    f = open(file_path,'rb')
    read_bytes = f.read()
    f.close()
    return read_bytes

def put_value(data_bytes, storage_config):
    storage_location = storage_config['storage_location']
    hashed_name = hashlib.sha256(data_bytes).hexdigest()
    output_name = "/".join([storage_location, output_name])
    if os.path.exists(output_name):
        print("File {} exists! Unable to write.".format(output_name))
        return -1
    f = open(output_name,'wb')
    f.write(data_bytes)
    f.close()
    return

def load_storage_config(storage_config_path):
    storage_config = json.dumps(storage_config_path)
    return storage_config

def get_alias(storage_config_path):
    return
