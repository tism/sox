require 'sox/file'

# FIXME: this is a bit pants but init/read/quit, init/read/quit 
# currently causes a seg fault on the second read, need to track 
# down why, for now just to it once globally
Native::Sox.init
at_exit {
  Native::Sox.quit
}
