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
      subject.nodes << Node.new(1, 10)
      subject.nodes << Node.new(2, 20)
      subject.nodes << Node.new(3, 30)
      subject.nodes << Node.new(4, 40)

      subject.parse().should == 100
    end

    it "should be 110" do
      subject.nodes << Node.new(1, 10)
      subject.nodes << Node.new(2, 20)
      subject.nodes << Node.new(3, 30)
      subject.nodes << Node.new(4, 40)
      subject.nodes << Node.new(1, 15)
      subject.nodes << Node.new(2, 15)
      subject.nodes << Node.new(3, 15)
      subject.nodes << Node.new(4, 50)

      subject.parse().should == 110
    end

    it "should delete" do
      subject.nodes << Node.new(1, 10)
      subject.nodes << Node.new(8, 20)
      subject.nodes << Node.new(9, 30)
      subject.nodes << Node.new(2, 80)

      subject.parse().should == 90
    end

    it "should parse" do
      subject.nodes << Node.new(110925242, 314423693) << Node.new(201639028, 873602173) << Node.new(556332723, 781795859) << Node.new(933170582, 204866864) << Node.new(91473533, 426547185)
      subject.nodes << Node.new(797815483, 265986717) << Node.new(915476633, 170924814)

      subject.parse()
    end
  end

  describe :find_index do
    it "should return the index of the closes number" do
      list = []
      list << Node.new(1, 10) << Node.new(2, 10) << Node.new(5, 20) << Node.new(8, 30)

      subject.find_index(list, 3).should == 1
    end
    it "should return the index of the lower number" do
      list = []
      list << Node.new(0, 0) << Node.new(1, 10) << Node.new(3, 10) << Node.new(5, 20) << Node.new(8, 30)

      subject.find_index(list, 3).should == 1
    end
    it "should return the first element" do
      list = []
      list << Node.new(0, 0)

      subject.find_index(list, 3).should == 0
    end
    it "should return the last element" do
      list = []
      list << Node.new(0, 0) << Node.new(1, 10) << Node.new(2, 20)

      subject.find_index(list, 3).should == 2
    end
    it "should work" do
      list = []
      list << Node.new(0, 0) << Node.new(1, 0) << Node.new(2, 10)

      subject.find_index(list, 1).should == 0
    end
    it "shoud work with equal elements" do
      list = []
      list << Node.new(0, 0) << Node.new(1, 10) << Node.new(2, 20) << Node.new(3, 30) << Node.new(4, 40)

      subject.find_index(list, 1).should == 0
    end
  end
end