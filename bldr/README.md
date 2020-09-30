Just planning stuff out and typing out loud.

Want better tooling around building and running containers from squashed
images. Don't need to save and extract each tar layer, mount layers
independently. First goal is creating and storing collections of squashed
layers.

Create and save a new rw layer
local storage is hashed filesystem. Images are collections of layers, layers
are blobs with metadata, blobs are raw squashed images. md5sum of all is the
name ID.
Remote storage is native s3 bucket.
repo.yaml or something similar lists all known images and layers in this storage

First steps - image/layer API. Should we just copy OCI? Probably, but we'd have
to ignore and shoehorn in a bunch of options. Wait why not? 

Back to this later. Go is hard. Python script to template mount commands and r/w
json is easy. Easy is better.

Easy plan:
  * Storage - kv filestore of squashed layers, layer info files, image info
    files, and root storage_conf pointing aliased names to layers/images info
    files
  * `from/new/groove/mount_rw <image>/<layer>`: Mount the image rw
  * `info`: Describe the object
  * `save`: Make a new squashed layer from containers r/w overlay
  * `join`: Joins layers to make an image

Images are collections of layers. What's the distinction? Do we need one?
Multiple lower layers shouldn't matter.

Layer config:
```
{
}
```

Image config
```
{
  name: image name,
  layers: [ bottom layer to top, short or long names, ]

}
```
