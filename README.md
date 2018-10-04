# LFS-GUI
Git LFS Scripts for non-programmers to allow them to learn and use **File Locking** quicker.

Of course, it's also usable by geeks ;)

## Files
There are two main files in this repository:

File Name | Description
--- | ---
`LFS_GUI.sh` | **Main script** to run GUI.
`LFS_Drop Files Here.bat` | For Windows user, **drag and drop** a file to edit it.

#### Addons
There are two optional addons in this repository:

File Name | Description
--- | ---
`LFS_ContextMenu.sh` | For Windows user; adds an option in the **right-click context menu** to send files directly into `LFS_Drop Files Here.bat`
`LFS_BulkUnlock.sh` | Shows all locked files as **editable text file** and re-reads it to **unlock all listed entries**. 

## Features
#### Direct Use

Action | Command Executed
--- | ---
Lock a File | `git lfs lock <path>`
Unlock a File | `git lfs unlock <path> \| --id=<id>`
Verify a File | `git log --follow --oneline HEAD...origin/master -- <path>`
View Locked Files | `git lfs locks`
View Tracked Files | `git lfs ls-files`

#### Drag and Drop (Single or Multiple)

Action | Command Executed
--- | ---
Lock dropped File(s) | `git lfs lock <dropped_file>`
Unlock dropped File(s) | `git lfs unlock <dropped_file>`
Verify dropped File(s) | `git log --follow --oneline HEAD...origin/master -- <dropped_file>`
