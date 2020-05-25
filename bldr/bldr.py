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
    return storage_config, 0

def check_image_list(image_name, storage_config):
    storage_location = storage_config['storage_location']
    image_list_path = "/".join([storage_location,"images.conf"])
    image_list = json.dumps(image_list_path)
    image_list_data = image_list["images"]
    image_found = 0
    for entry in image_list_data:
        # Alias found
        if image_name == alias_found["alias"]:
            image_ref = alias_found["ref"]
            log_print("Alias {} matches ref {}".format(image_name, image_ref))
            image_found = 1
            image_name = image_ref
        # Ref is not aliased
        elif image_name == alias_found["ref"]:
            image_found = 1
    # Check if image was found
    if image_found == 0:
        print("Image {} not found! Exiting".format(image_name))
        return '',-1
    return image_name, 0

def mount_image_rw(image_name):
    # Get image name
    # 
    return

def make_writable_layer(mount_point):
    return

def save_layer():
    return
