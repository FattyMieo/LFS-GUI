# LFS-GUI
Git LFS GUI for non-programmers to allow them to learn **File Locking** quicker.

## Files
There are two files in this repository:

File Name | Description
--- | ---
LFS_GUI.sh | **Main script** to run GUI.
LFS_Drop Files Here.bat | For Windows user, **drag and drop** a file to edit it.

## Features
| Type | Action | Command Executed |
| --- | --- | --- |
| Direct Use | Lock a File | `git lfs lock <path>` |
| | Unlock a File | `git lfs unlock <path> \| --id=<id>` |
| | View Locked Files | `git lfs locks` |
| | View Tracked Files | `git lfs ls-files` |
| Drag and Drop<br>(Single or Multiple) | Lock dropped File(s) | `git lfs lock <dropped_file>` |
| | Unlock dropped File(s) | `git lfs unlock <dropped_file>` |
