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
    try:
        f = open(file_path,'rb')
        read_bytes = f.read()
        f.close()
        return read_bytes, 0
    except IOError as e:
        print("Error {} opening {}".format(e, file_path))
        return "", -1

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

"""
Check for ref <name> in list of ref_list format
"""
def check_list(name, ref_list):
    for entry in ref_list:
        # Alias found
        if name == entry["alias"]:
            ref_found = entry["ref"]
            log_print("Alias {} matches ref {}".format(name, ref_found))
            return ref_found, 0
        # Ref is not aliased
        elif image_name == alias_found["ref"]:
            item_found = 1
            return name, 0
    # if we hit here ref was not found
    print("Ref {} not found! Exiting".format(ref_list))
    return '', -1

def check_image_list(image_name, storage_config):
    storage_location = storage_config['storage_location']
    image_list_path = "/".join([storage_location,"images.conf"])
    image_list = json.dumps(image_list_path)
    image_list_data = image_list["images"]
    return check_list(image_name, image_list_data)

def check_layer_list(image_name, storage_config):
    storage_location = storage_config['storage_location']
    layer_list = "/".join([storage_location,"layers.conf"])
    layer_list = json.dumps(layer_list_path)
    layer_list_data = layer_list["layers"]
    return check_list(layer_name, layer_list_data)

def mount_layer(layer_to_mount, mount_location):
    # idk what this is supposed to do
    return

def mount_image_rw(image_name, storage_config):
    storage_location = storage_config['storage_location']
    # look up image ref
    image_ref, err = check_image_list(image_name, storage_config)
    image_json, err = get_value(image_ref)
    image_data = json.dumps(image_json)
    layers = image_data["layers"]
    layer_paths = []
    for layer in layers:
        layer_file_path = "/".join([storage_location, layer])
        err = mount_layer(layer_file_path, layer_mount_location)
        layer_paths.append(layer_mount_location)
    writable_layer, err = make_writable_layer
    
    return

def make_writable_layer(mount_point):
    return

def save_layer():
    return

"""
Bldr command wrapper

No idea what we actually want user commands to be. End goal is we want to 
* Mount image writable
* Save image
"""
class Bldr():
    def __init__(self):
        return
    def mount(self):
        return
    def commit(self):
        return
    def bundle(self):
        return
