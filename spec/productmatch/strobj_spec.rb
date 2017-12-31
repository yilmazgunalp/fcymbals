require "rails_helper"

RSpec.describe Strobj do

  it "has alternatives attribute" do
  	ex = Strobj.new("crash") 
    expect(ex).to respond_to(:alternatives)
    expect(ex.alternatives).to be_nil	 
  end

it "reads alternatives from vars.yml" do
  	ex = Strobj.new("hi hat") 
    expect(ex.alternatives).to eql(["hats","hi-hats","hat","hi hats"])	 
  end  

it "matches the exact string" do 
ex = Strobj.new("ride")
expect(ex.match("Istanbul 15 Turk Ride Cymbals")).to eql("ride")
end

it "matches the alternative string for 'hi hat'" do 
ex = Strobj.new("hi hat")
expect(ex.match("Istanbul 15 Turk hats Cymbals")).to eql("hi hat")
end

it "returns nil for no match" do 
ex = Strobj.new("crash")
expect(ex.match("Istanbul 15 Turk crs Cymbals")).to be_nil
end


it "returns nil for no match" do 
ex = Strobj.new("splash")
expect(ex.match("Istanbul 15 Turk crs Cymbals")).to be_nil
end

it "returns splash correctly" do 
ex = Strobj.new("splash")
expect(ex.match("Istanbul 8\" Traditional Splash Cymbal")).to eql("splash")
end

it "returns nil correctly for wrong Cymbal type" do 
ex = Strobj.new("hi hat")
expect(ex.match("Istanbul 8\" Traditional Splash Cymbal")).to be_nil
end

end