# adios-bonjour
A user friendly app to transfer files between Windows and Android, written in Qt C++ and QML, and uses cURL as backend.

# Gen Info
cUrl is used as the socket client, and the FTP server app servers as server for android. The project just binds these two
into user friendly GUI, and uses the data made available by the former two apps.

# Building
Compiled using Qt 5.12, it should work with latest versions too. Some deprecations may be there, but those can be easily sorted out.
To compile, open myQtp in Qt Creator, change the paths for resources in the code (the res folder), and it should compile fine.

# Binaries
Check the release section.
