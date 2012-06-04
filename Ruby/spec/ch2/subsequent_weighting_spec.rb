require "spec_helper"
require "subsequent_weighting"

describe Node do
  it "should not be nil" do
    node = Node.new
    node.should_not be_nil
  end
  it "should set the value and weight" do
    node = Node.new(1, 10)
    node.value.should == 1
    node.weight.should == 10
  end
end

describe SubsequentWeighting do
  let(:subject) { SubsequentWeighting.new }

  it "should not be nil" do
    subject.should_not be_nil
  end

  describe :add_values do
    it "should add new nodes" do
      subject.add_values(%w(1 2 3))
      subject.tuplets.count.should == 3
      subject.tuplets.first[:value].should == 1
    end
  end

  describe :add_weights do
    it "should add weight to the existing nodes" do
      subject.tuplets << {:value => 1, :weight => 0}
      subject.add_weights(%w(42))
      subject.tuplets.first[:weight].should == 42
    end
  end

  describe :parse do
    it "should be 100" do
      subject.tuplets << {:value => 1, :weight => 10}
      subject.tuplets << {:value => 2, :weight => 20}
      subject.tuplets << {:value => 3, :weight => 30}
      subject.tuplets << {:value => 4, :weight => 40}

      subject.parse().should == 100
    end

    it "should be 110" do
      subject.tuplets << {:value => 1, :weight => 10}
      subject.tuplets << {:value => 2, :weight => 20}
      subject.tuplets << {:value => 3, :weight => 30}
      subject.tuplets << {:value => 4, :weight => 40}
      subject.tuplets << {:value => 1, :weight => 15}
      subject.tuplets << {:value => 2, :weight => 15}
      subject.tuplets << {:value => 3, :weight => 15}
      subject.tuplets << {:value => 4, :weight => 50}

      subject.parse().should == 110
    end

    it "should delete" do
      subject.tuplets << {:value => 1, :weight => 10}
      subject.tuplets << {:value => 8, :weight => 20}
      subject.tuplets << {:value => 9, :weight => 30}
      subject.tuplets << {:value => 3, :weight => 80}

      subject.parse().should == 90
    end
  end
end