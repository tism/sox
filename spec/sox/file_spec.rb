require 'spec_helper'
require 'sox/file'

describe Sox::File do

  TEST_FILE = 'spec/fixtures/sample.flac'

  describe ".initialize" do

    it "should open the file for reading" do
      Sox::Native.should_receive(:open_read).with(TEST_FILE, nil, nil, nil)

      Sox::File.new(TEST_FILE)
    end

    it "should create a format handler" do
      Sox::Native.stub(:open_read).and_return(:format_pointer)
      Sox::Native::Format.should_receive(:new).with(:format_pointer).and_return(:wrapped_format)

      sox = Sox::File.new(TEST_FILE)
      sox.format.should eql :wrapped_format
    end

  end

  describe ".read" do

    before(:each) do
      @sox = Sox::File.new(TEST_FILE)
    end

    after(:each) do
      @sox.close
    end

    it "should return the number of requested samples" do
      @sox.read(2).should eql [[-162922496, -65470464]]
    end

    it "should split the samples into nested arrays based on the number of channels" do
      @sox.read(4).should eql [[-162922496, -65470464], [-146538496, -62849024]]
    end

    it "should raise an exception if the sample count isn't divisible by the number of channels" do
      lambda { @sox.read(3) }.should raise_error("Sample count must be divisible by number of channels (2)")
    end

  end

  describe "#open" do

    before(:each) do
      @sox = mock(Sox::File)

      Sox::File.stub(:new).with(TEST_FILE).and_return(@sox)
    end

    it "should create an instance of Sox::File and yield it" do
      Sox::File.should_receive(:open).and_yield(@sox)

      Sox::File.open(TEST_FILE) {}
    end

    it "should close the sox instance after yielding it" do
     @sox.should_receive(:close)

     Sox::File.open(TEST_FILE) {}
    end

    it "should attempt to close the sox instance in the event of an exception" do
      @sox.should_receive(:close)

      Sox::File.open(TEST_FILE) {}
    end

  end

  describe ".close" do

    before(:each) do
      @sox = Sox::File.new(TEST_FILE)
    end

    it "should close the sox handle" do
      Sox::Native.should_receive(:close).with(@sox.format)

      @sox.close
    end

  end

end
