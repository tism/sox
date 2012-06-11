require 'rubygems'
require 'ffi'

$:.unshift('lib')

require 'sox/native/sox'

test_file = '/home/lucas/work/sox/spec/fixtures/sample.flac'

Native::Sox.init
p = Native::Sox.open_read(test_file, nil, nil, nil)
Native::Sox.close(p)
p.free
Native::Sox.quit

Native::Sox.init
p = Native::Sox.open_read(test_file, nil, nil, nil)
Native::Sox.close(p)
p.free
Native::Sox.quit
