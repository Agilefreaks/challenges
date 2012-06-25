require "spec_helper"
require "fraud_detection"

describe FraudDetection do
  let(:fraud_detection) { FraudDetection.new }

  describe :parse_email do
    it "should return all email in lower case" do
      fraud_detection.parse_email("BuGS@buNNY.com").should == "bugs@bunny.com"
    end
    it "should ignore point" do
      fraud_detection.parse_email("bugs.1@bunny.com").should == "bugs1@bunny.com"
    end
    it "should ignore everything after the +" do
      fraud_detection.parse_email("bugs+10@bunny.com").should == "bugs@bunny.com"
    end
    it "should ignore everything after the +" do
      fraud_detection.parse_email("b.u.g.s+10+11@bunny.com").should == "bugs@bunny.com"
    end
  end

  describe :parse_address do
    it "should return all address in lower case" do
      fraud_detection.parse_address("123 SaSAME st.").should == "123 sasame street"
    end
    it "should remove the st. abbreviation" do
      fraud_detection.parse_address("123 sasame st.").should == "123 sasame street"
    end
    it "should replace Rd. with road" do
      fraud_detection.parse_address("123 SAsaMe rd.").should == "123 sasame road"
    end
    it "should work" do
      fraud_detection.parse_address("123 sasame street").should == "123 sasame street"
    end
  end

  describe :parse_state do
    it "should replace IL with Illinois" do
      fraud_detection.parse_state("IL").should == "illinois"
      fraud_detection.parse_state("il").should == "illinois"
    end
    it "should replace CA with California" do
      fraud_detection.parse_state("CA").should == "california"
    end
    it "should replace NY with new york" do
      fraud_detection.parse_state("NY").should == "new york"
    end
    it "should not parse california" do
      fraud_detection.parse_state("California").should == "california"
    end
  end

  describe :parse_city do
    it "should return lower case" do
      fraud_detection.parse_city("New York").should == "new york"
    end
  end

  describe :detect do
    it "should detect orders with the same deal_id and email address, but different card_nr regardless of the street address" do
      lines = ["1,1,bugs@bunny.com,123 Sesame St.,New York,NY,10011,12345689010",
               "2,1,bugs@bunny.com,123 Sesame St.,New York,NY,10011,10987654321",
               "3,1,rabbit@bunny.com,123 Sesame St.,New York,NY,10011,10987654321"]
      fraud_detection.detect(lines).should == "1,2,3"
    end
    it "should add fraud only once" do
      lines = ["1,1,bugs@bunny.com,123 Sesame St.,New York,NY,10011,12345689010",
               "2,1,bugs@bunny.com,123 Sesame St.,California,CA,10011,10987654321",
               "3,1,bugs@bunny.com,Semaforului 23,Sibiu,NY,10011,12345689011"]
      fraud_detection.detect(lines).should == "1,2,3"
    end
    it "should not fraud with the same email and deal_id and same card_nr" do
      lines = ["1,1,bugs@bunny.com,123 Sesame St.,New York,NY,10011,12345689010",
               "2,1,bugs@bunny.com,123 Sesame St.,California,CA,10011,12345689010"]
      fraud_detection.detect(lines).should == ""
    end
    it "should detect order with the same address and deal_id" do
      lines = ["1,1,bugs@bunny.com,123 Sesame St.,New York,NY,10011,12345689010",
               "2,1,rabit@bunny.com,123 Sesame St.,New York,NY,10011,12345689011"]
      fraud_detection.detect(lines).should == "1,2"
    end
    it "should detect order with the same address and deal_id" do
      lines = ["1,1,bugs@bunny.com,123 Sesame St.,New York,NY,10011,12345689010",
               "2,1,bugs@bunny.com,123 Sesame St.,New York,NY,10011,12345689011"]
       fraud_detection.detect(lines).should == "1,2"
    end
    it "should not detect fraud for the same address and same credit card information" do
      lines = ["1,1,bugs@bunny.com,123 Sesame St.,New York,NY,10011,12345689010",
               "2,1,bugs@bunny.com,123 Sesame St.,New York,NY,10011,12345689010"]
       fraud_detection.detect(lines).should == ""
    end
    it "should return results in asc order" do
      lines = [ "1,1,bugs@bunny.com,123 Sesame St.,New York,NY,10011,12345689010",
                "2,1,bugs@bunny.com,124 Sesame St.,California,CA,10011,12345689010",
                "3,1,bugs@bunny.com,123 Sesame St.,California,CA,10011,12345689011"]
      fraud_detection.detect(lines).should == "1,2,3"
    end
    it "should pass the test case" do
      lines = [ "1,1,bugs@bunny.com,123 Sesame St.,New York,NY,10011,12345689010",
                "2,1,elmer@fudd.com,123 Sesame St.,New York,NY,10011,10987654321",
                "3,2,bugs@bunny.com,123 Sesame St.,New York,NY,10011,12345689010"]
      fraud_detection.detect(lines).should == "1,2"
    end
    it "should work on california" do
      lines = [ "72,49849,dion_ankunding@yahoo.com,8181 Rempel Port,South Considine,California,51423,7723562022",
                "82,49849,gislasona@yahoo.com,8181 Rempel Port,South Considine,CA,51423,2551503213"]
      fraud_detection.detect(lines).should == "72,82"
    end
  end
end