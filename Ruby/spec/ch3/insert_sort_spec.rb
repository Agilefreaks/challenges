require "spec_helper"
require "insert_sort"

describe InsertSort do
  let(:subject) { InsertSort.new }
  it "should be a instance of InsertSort" do
    subject.should be_a(InsertSort)
  end
  it "should return 0 for a sorted input" do
    input = double("input")
    input.stub(:gets).and_return("0", "1 2 3")
    subject.number_of_swaps(input).should == 0
  end
  it "should return 0 for a sorted input with equal elements" do
    input = double("input")
    input.stub(:gets).and_return("0", "1 1 1 2 2")
    subject.number_of_swaps(input).should == 0
  end
  it "should return correct for a not sorted array" do
    input = double("input")
    input.stub(:gets).and_return("0", "2 1 3 1 2")
    subject.number_of_swaps(input).should == 4
  end
end