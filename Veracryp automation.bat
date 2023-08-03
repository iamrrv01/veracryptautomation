@echo off

rem Input validation function to check if the drive letter is "1"
:CheckDriveLetter
set /p drive_letter=Enter the drive letter of the connected disk (e.g., E): 
if /I "%drive_letter%"=="1" (
    echo Disk 1 is not allowed. Please select a different disk.
    goto CheckDriveLetter
)

rem Delete the disk volume (with user permission)
set /p delete_partitions=Do you want to delete existing partitions on the disk? (Y/N): 
if /I "%delete_partitions%"=="Y" (
    echo sel disk %drive_letter% > diskpart_script.txt
    echo remove all noerr >> diskpart_script.txt
    diskpart /s diskpart_script.txt
)

rem Create two volumes - one of 1024 MB and the other using the remaining space
echo sel disk %drive_letter% > diskpart_script.txt
echo create partition primary size=1024 >> diskpart_script.txt
echo format fs=ntfs quick >> diskpart_script.txt
echo create partition primary >> diskpart_script.txt
echo format fs=ntfs quick >> diskpart_script.txt
diskpart /s diskpart_script.txt

rem Veracrypt the disk
set /p veracrypt_drive_letter=Enter the drive letter to mount VeraCrypt volume: 
set /p veracrypt_password=Enter the Veracrypt password: 
veracrypt /v %drive_letter%2 /l %veracrypt_drive_letter% /p %veracrypt_password% --encryption=AES

rem Ask for file system and perform quick format
set /p file_system=Enter the desired file system (NTFS/FAT32/exFAT): 
format %veracrypt_drive_letter% /FS:%file_system% /Q
