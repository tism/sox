require 'ffi'

module Sox
  module Native
    extend FFI::Library
    ffi_lib 'libsox'

    SUCCESS = 0
    FAILURE = -1

    attach_function :init, :sox_init, [  ], :int
    attach_function :quit, :sox_quit, [  ], :void
    attach_function :open_read, :sox_open_read, [ :string, :pointer, :pointer, :string ], :pointer
    attach_function :read, :sox_read, [ :pointer, :buffer_out, :uint ], :uint
    attach_function :close, :sox_close, [ :pointer ], :int

    class SignalInfo < FFI::Struct
      layout(
        :rate, :double,
        :channels, :uint,
        :precision, :uint,
        :length, :uint,
        :mult, :pointer
      )
    end

    class EncodingInfo < FFI::Struct
      layout(
        :encoding, :int,
        :bits_per_sample, :uint,
        :compression, :double,
        :reverse_bytes, :int,
        :reverse_nibbles, :int,
        :reverse_bits, :int,
        :opposite_endian, :int
      )
    end

    class InstrumentInfo < FFI::Struct
      layout(
        :MIDInote, :char,
        :MIDIlow, :char,
        :MIDIhi, :char,
        :loopmode, :char,
        :nloops, :uint
      )
    end

    class LoopInfo < FFI::Struct
      layout(
        :start, :uint,
        :length, :uint,
        :count, :uint,
        :type, :uchar
      )
    end

    class OutOfBandData < FFI::Struct
      layout(
        :comments, :pointer,
        :instr, InstrumentInfo,
        :loops, [LoopInfo, 8]
      )
    end

    class FormatHandler < FFI::Struct
      layout(
        :sox_lib_version_code, :uint,
        :description, :pointer,
        :names, :pointer,
        :flags, :uint,
        :startread, callback([ :pointer ], :int),
        :read, callback([ :pointer, :pointer, :uint ], :size_t),
        :stopread, callback([ :pointer ], :int),
        :startwrite, callback([ :pointer ], :int),
        :write, callback([ :pointer, :pointer, :uint ], :size_t),
        :stopwrite, callback([ :pointer ], :int),
        :seek, callback([ :pointer, :ulong_long ], :int),
        :write_formats, :pointer,
        :write_rates, :pointer,
        :priv_size, :uint
      )
    end

    class Format < FFI::Struct
      layout(
        :filename, :pointer,
        :signal, SignalInfo,
        :encoding, EncodingInfo,
        :filetype, :pointer,
        :oob, OutOfBandData,
        :seekable, :int,
        :mode, :char,
        :olength, :uint,
        :clips, :uint,
        :sox_errno, :int,
        :sox_errstr, [:char, 256],
        :fp, :pointer,
        :io_type, :int,
        :tell_off, :long,
        :data_start, :long,
        :handler, FormatHandler,
        :priv, :pointer
      )
    end

  end
end
