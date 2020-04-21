#Digital Journal Changelog

<strong>"Thumbnails"</strong> update, <ins>April 20, 2020</ins>.

<strong>Changes:</strong>

<ul>
<li>Thumbnails of photos are now saved to massively speed up loading previews of memories on the home screen.</li>
<ul>
	<li>Thumbnail size is 46x40 pixels.</li>
	<li>The original image in full resolution will still be loaded upon viewing a memory (when that feature is added).</li>
	<li>The path for thumbnails on Windows systems is <ins>C:\Users\username\AppData\Roaming\Godot\app_userdata\Digital Journal\Thumbnails"</ins></li>
</ul>
</ul>

<strong>Additional Notes:</strong>

In testing, loading 100 full-sized images and downscaling them resulted in a bootup time of 17 seconds. Saving thumbnails of all images associated with new memories and loading them instead resulted in loading 3000 images in less than 3 seconds. The generated thumbnails were collectively just over 12 MB, showing fantastic compression results and speed for many images.
Additionally, if multiple memories require the same image, they smartly use the same thumbnail rather than generating two or more identical thumbnails for the same image, given that the image sources are located in the same location on the user's harddrive.

<hr />

<strong>Original upload</strong>, <ins>April 15, 2020</ins>.

Created a repository for Digital Journal for the first time.

<strong>Features:</strong>

<ul>
<li>Home Screen</li>
<ul>
	<li>The home screen displays a list of current memories and their name, date, location, description, how long ago they occurred, and media.</li>
	<li>The user can narrow down to specific memories using the search bar (case insensitive). Memories can be found by typing their name, date, location, or any of their tags. Multiple search parameters can be used by separating keywords with a space.</li>
</ul>
<li>Add new memories</li>
<ul>
	<li>Memories contain a mandatory name and date and optional location, description, tags, and media (photos and videos). Use "Tab" to easily change between text fields, and drag and drop media from your computer into the program to add them.</li>
</ul>
</ul>