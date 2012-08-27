require "spec_helper"
require "polygon"

describe :Line do
  let(:line){ Line.new(Point.new(0, 0), Point.new(0, 3)) }
  describe :contains? do
    it "should return true if the point is one of the defined" do
      line.contains?(Point.new(0, 0)).should == true
      line.contains?(Point.new(0, 3)).should == true
    end
    it "should return true if the point is in between the defined nodes" do
      line.contains?(Point.new(0, 2)).should == true
    end
    it "should return false" do
      line.contains?(Point.new(0, 4)).should == false
      line.contains?(Point.new(0, -1)).should == false
      line.contains?(Point.new(1, 0)).should == false
    end
    it "should return true for inverse points" do
      line = Line.new(Point.new(3, 3), Point.new(3, 0))
      line.contains?(Point.new(3, 2)).should == true
    end
    it "should return true sample01 case" do
      line = Line.new(Point.new(4, 6), Point.new(4, 3))
      line.contains?(Point.new(4, 5)).should == true
    end
  end
end

describe :Polygon do
  let(:polygon){ Polygon.new }
  it "should create a new instance" do
    polygon.should be_a(Polygon)
  end

  describe :add_point do
    it "should add a point to to a new line" do
      point = Point.new(0, 0)
      polygon.add_point(point)
      polygon.number_of_lines.count.should == 1
      polygon.number_of_lines.last.point1.should == point
    end

    it "should add a second point to the last line" do
      point = Point.new(0, 1)
      polygon.number_of_lines << Line.new(Point.new(0, 0))
      polygon.add_point(point)
      polygon.number_of_lines.count.should == 1
      polygon.number_of_lines.last.point2.should == point
    end

    it "should create a new line when point2 is set" do
      point2 = Point.new(0, 1)
      polygon.number_of_lines << Line.new(Point.new(0, 0), point2)
      polygon.add_point(Point.new(1, 1))
      polygon.number_of_lines.count.should == 2
      polygon.number_of_lines.last.point1 == point2
    end

    it "should add line to vertical_lines" do
      polygon.add_point(Point.new(0, 0))
      polygon.add_point(Point.new(0, 2))
      polygon.vertical_lines.count.should == 1
    end

    it "should not add line to vertical_lines" do
      polygon.add_point(Point.new(0, 0))
      polygon.add_point(Point.new(2, 0))
      polygon.vertical_lines.count.should == 0
    end
  end

  describe :close do
    it "should add a line to link last to first" do
      point1 = Point.new(0, 0)
      polygon.number_of_lines << Line.new(point1, Point.new(0, 1))
      point2 = Point.new(3, 0)
      polygon.number_of_lines << Line.new(Point.new(3, 3), point2)
      polygon.close
      polygon.number_of_lines.count.should == 3
      polygon.number_of_lines.last.point2.should == point1
      polygon.number_of_lines.last.point1.should == point2
    end
  end

  describe :is_point_in? do
    def square
      polygon.add_point(Point.new(0, 0))
      polygon.add_point(Point.new(0, 3))
      polygon.add_point(Point.new(3, 3))
      polygon.add_point(Point.new(3, 0))
      polygon.close
    end
    it "should return for a point located on a line" do
      square
      polygon.is_point_in?(Point.new(0, 0)).should == true
    end
    it "should return false for a point outside" do
      square
      polygon.is_point_in?(Point.new(0, 4)).should == false
    end
    it "should return true for a point inside" do
      square
      polygon.is_point_in?(Point.new(2, 2)).should == true
    end
  end
end
