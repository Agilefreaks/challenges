require "spec_helper"
require "weapon"

describe Weapon do
  it { should be_a(Weapon) }

  describe :can_swap do
    it "should return true for a direct swap" do
      subject.swap_matrix = Matrix[[0, 0, 0],
                                   [0, 1, 1],
                                   [0, 1, 0]]
      subject.can_swap?(1, 1).should == true
    end
    it "should return false when no direct swap" do
      subject.swap_matrix = Matrix[[0, 0, 0],
                                   [0, 1, 1],
                                   [0, 1, 0]]
      subject.can_swap?(0, 0).should == false
    end
    it "should return true for indirect swaps" do
      subject.swap_matrix = Matrix[[0, 0, 1],
                                   [0, 0, 1],
                                   [1, 1, 0]]
      subject.can_swap?(0, 1).should == true
      subject.swap_matrix[0, 1].should == 1
      subject.swap_matrix[1, 0].should == 1
    end
    it "should return true for inverse indirect swaps" do
      subject.swap_matrix = Matrix[[0, 0, 1],
                                   [0, 0, 1],
                                   [1, 1, 0]]
      subject.can_swap?(1, 0).should == true
      subject.swap_matrix[0, 1].should == 1
      subject.swap_matrix[1, 0].should == 1
    end
  end

  describe :calibrate do
    it "should se direct swaps" do
      subject.swap_matrix = Matrix[[0, 0, 1],
                                   [0, 0, 0],
                                   [1, 0, 0]]
      subject.configuration = [3, 1, 2]
      subject.calibrate.should == [2, 1, 3]
    end
    it "should see indirect swaps" do
      subject.swap_matrix = Matrix[[0, 0, 1, 0],
                                   [0, 0, 1, 1],
                                   [1, 1, 0, 0],
                                   [0, 0, 1, 0]]
      subject.configuration = [4, 3, 2, 1]
      subject.calibrate.should == [1, 2, 3, 4]
    end
  end
end