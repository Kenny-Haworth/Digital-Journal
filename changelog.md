# Digital Journal Changelog

**"Bugfixes"** update, <ins>May 3, 2020</ins>.

**Bugfixes:**
- If the user selects a memory and then types in the search bar, the view, edit, and delete memory buttons can no longer be pressed, preventing loading of null memories (which caused a crash).
- If the user is typing a long description and it extends past the size of the window, the scroll bar now...
  - Moves with the text.
  - Does not show half lines.
- The window no longer shows space outside the viewport (what the user is supposed to see).
- The window now centers in the middle of the screen on startup to fix screen sizing issues.
- Tags entered on the "add a new memory" and "edit memory" windows now have the same seperation horizontally and vertically.

**Additional Notes:**

This update took longer due to the nature of these bugs. Some were obscure or difficult to reproduce, and others were difficult to fix thanks to restrictions from the Godot Engine. There is still an existing bug where photos are not rotated properly when loading in, which will be fixed in a later update.

<hr />

**"Edit"** update, <ins>April 25, 2020</ins>.

**Changes:**
- The user may now edit memories by selecting a memory and pressing "Edit Memory".
- The user may now delete photos by double clicking on them when on the "add a new memory" or "edit memory" windows.
- Added labels to the "add a new memory" and "edit memory" windows to inform the user of the menu they are currently viewing.
- The application window now maximizes automatically upon startup to avoid screen sizing issues.

**Bugfixes:**
- When the user has filtered down memories and then adds a new one, the list is no longer repopulated without the current search query filter active.
- When the user has filtered down memories and then deletes one, the list is no longer repopulated without the current search query filter active.

<hr />

**"Delete"** update, <ins>April 21, 2020</ins>.

**Changes:**
- The checkboxes next to memories are now mutually exclusive and enable the view, edit, and delete memory buttons.
- The user may now delete memories by selecting a memory and pressing "Delete Memory".

**Bugfixes:**

- The game now correctly creates a thumbnails folder if it does not exist when saving a thumbnail for the first time.

**Additional Notes:**

If the multiple memories rely upon the same thumbnail, it will not be deleted when one of the memories is deleted.
Thumbnails are only deleted if all memory dependencies are deleted as well.

<hr />

**"Thumbnails"** update, <ins>April 20, 2020</ins>.

**Changes:**

- Thumbnails of photos are now saved to massively speed up loading previews of memories on the home screen.
  - Thumbnail size is 46x40 pixels.
  - The original image in full resolution will still be loaded upon viewing a memory (when that feature is added).
  - The path for thumbnails on Windows systems is *C:\Users\username\AppData\Roaming\Godot\app_userdata\Digital Journal\Thumbnails"*

**Additional Notes:**

In testing, loading 100 full-sized images and downscaling them resulted in a bootup time of 17 seconds. Saving thumbnails of all images associated with new memories and loading them instead resulted in loading 3000 images in less than 3 seconds. The generated thumbnails were collectively just over 12 MB, showing fantastic compression results and speed for many images.

Additionally, if multiple memories require the same image, they smartly use the same thumbnail rather than generating two or more identical thumbnails for the same image, given that the image sources are located in the same location on the user's harddrive.

<hr />

**Original upload**, <ins>April 15, 2020</ins>.

Created a repository for Digital Journal for the first time.

**Features:**

- Home Screen
  - The home screen displays a list of current memories and their name, date, location, description, how long ago they occurred, and media.
  - The user can narrow down to specific memories using the search bar (case insensitive). Memories can be found by typing their name, date, location, or any of their tags. Multiple search parameters can be used by separating keywords with a space.
- Add new memories
  - Memories contain a mandatory name and date and optional location, description, tags, and media (photos and videos). Use "Tab" to easily change between text fields, and drag and drop media from your computer into the program to add them.