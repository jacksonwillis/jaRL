$LOAD_PATH << File.expand_path("../", __FILE__)
require "spec_helper"

describe Jarl::Parser do
  it "parses jarl syntax" do
    Jarl::Parser.parse("(a (b 1 2) (c 3 4))").should == [[:a, [:b, 1.0, 2.0], [:c, 3.0, 4.0]]]
  end
end
