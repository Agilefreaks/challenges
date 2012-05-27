require "spec_helper"
require "test"

describe Test do
  describe :thurty do
    it "should return true" do
      test = Test.new
      test.thruty.should == true
    end
  end
end