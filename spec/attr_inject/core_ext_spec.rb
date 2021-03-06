require "spec_helper"
require "attr_inject"

class SimpleInject

  attr_inject :foo
  attr_inject :bar

end

class InjectViaInitialize

  attr_inject :bat
  attr_inject :baz
  attr_inject :blam, :required => false

  def initialize(params)
    inject_attributes params
  end

end

class BlankClass
  def initialize
  end
end

describe "attr_inject" do
  it "creates a method with attr_inject" do
    i = SimpleInject.new
    i.foo.should == nil
    i.bar.should == nil
  end

  it "injects into new attributes with inject_attributes" do
    a_string = "hello"
    an_array = ["hello", "world"]
    i = InjectViaInitialize.new :bat => a_string, :baz => an_array

    i.bat.should == a_string
    i.baz.should == an_array
  end

  it "raises an error when an required attribute is unfulfiled" do
    expect{InjectViaInitialize.new :foo => "bar"}.to raise_error(Inject::InjectionError)
  end

  it "allows injection on classes with no attr_inject" do
    blank = BlankClass.new
    blank.inject_attributes :foo => "foo", :bar => "bar"
  end

end
