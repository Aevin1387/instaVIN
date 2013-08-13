require_relative "minitest_helper"

describe InstaVIN do
  before do
    InstaVIN.remove_class_variable :@@config if InstaVIN.class_variable_defined? :@@config
  end

  it "should yield a configuration object to block" do
    InstaVIN.configure do |config|
      config.foo = "bar"
    end

    InstaVIN.config.foo.must_equal "bar"
  end
end
