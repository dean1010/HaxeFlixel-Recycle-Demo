# HaxeFlixel-Recylce-Demo

An example of object pooling and recycling that demonstrates the way maxSize affects how 
many objects are instantiated. The group of bullets will grow by creating new instances 
as needed, depending on how many non-living are available and the maxSize of the group. 
If dead bullets are available, it will recycle them from the pool, otherwise, it creates 
a new one. If there are maxSize living objects, a living one is recycled. With maxSize 
of 0 (default) the group continues to grow indefinitely and no living ones are recycled.
