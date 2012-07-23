require "spec_helper"
require "matching"

describe Matching do
  it { should be_a(Matching) }

  it "should calculate the 3'th catalan number" do
    subject.solve(3).should == 5
  end

  it "should calculate the 4'th catalan number" do
    subject.solve(4).should == 14
  end

  it "should calculate the 12'th catalan number" do
    subject.solve(12).should == 208012
  end

  it "should calculate the 21'th catalan number" do
    subject.solve(21).should == 466266852
  end

  describe "#decompose" do
    it "should return for primes" do
      subject.decompose(5, [2, 3, 5], []).should == [0, 0, 1]
    end
    it "should return for non primes" do
      subject.decompose(10, [2, 3, 5], []).should == [1, 0, 1]
    end
  end
end
