require 'sox/native'

module Sox
  class File

    attr_reader :format

    def initialize(file_name)
      format_pointer = Sox::Native.open_read(file_name, nil, nil, nil)
      @format = Sox::Native::Format.new(format_pointer)
    end

    def read(samples)
      channel_count = @format[:signal][:channels]
      raise "Sample count must be divisible by number of channels (#{channel_count})" unless samples%channel_count == 0

      buffer = FFI::MemoryPointer.new(:int, samples)
      Sox::Native.read(@format, buffer, samples)
      buffer.read_array_of_int(samples).each_slice(channel_count).to_a
    end

    def close
      Sox::Native.close(@format)
    end

    class << self

      def open(file_name)
        sox = new(file_name)
        begin
          yield(sox)
        ensure
          sox.close
        end
      end

    end

  end
end
