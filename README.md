# osg_dependencies
Build dependencies for OpenSceneGraph

This has been tested on Windows.  It assumes that you have Git Bash https://git-scm.com/downloads and cmake https://cmake.org/download/ installed

# edit build.sh to make sure that both cmake.exe and cmd.exe will be in the path
* Start a git bash shell
* run fetch.sh from the project source directory.  This should retrieve the repositories of source using git and curl
* run build.sh from the project source directory.  This shoudl patch sources and build into "install"
