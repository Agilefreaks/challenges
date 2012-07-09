require "spec_helper"
require "travel"

describe Travel do
  it { should be_a(Travel) }

  it "should set roads" do
    subject.roads.should == []
  end

  describe :add_road do
    it "should add a road" do
      subject.add_road(1, 2, 1)
      subject.roads[1].should == [ { :city => 2, :cost => 1 } ]
      subject.roads[2].should == [ { :city => 1, :cost => 1 } ]
    end
  end

  describe :add_city do
    it "should add the value of the city" do
      subject.add_city(1, 10)
      subject.cities[1].should == 10
    end
  end

  describe :solve do
    it "should return the current amount" do
      subject = Travel.new(2, 1)
      subject.add_road(1, 2, 1)
      subject.add_city(1, 4)
      subject.add_city(2, 54)
      subject.solve.should == 36
    end
  end
end