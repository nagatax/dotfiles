# Check whether go command can execute
GO_INSTALL_PATH=/usr/local/go
COMMAND_NOT_FOUND=127
go > /dev/null 2>&1
if [ $? -eq $COMMAND_NOT_FOUND ]; then
  PATH=$PATH:$GO_INSTALL_PATH/bin
fi

# Define GOROOT
export GOROOT=$(go env GOROOT)

# Define GOPATH
export GOPATH=$(go env GOPATH)

# ADD executables to a PATH
export PATH=$PATH:$GOPATH/bin
