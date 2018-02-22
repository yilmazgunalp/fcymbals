require "rails_helper"
require "#{Rails.root}/app/models/maker.rb"
require "#{Rails.root}/lib/allocate/strobj.rb"
require "#{Rails.root}/lib/allocate/productmatch.rb"


RSpec.describe Productmatch do

    context "match_kind method" do 
     

  it "returns crash type correctly" do 
  expect(Productmatch.match_kind("Paiste 16\" Signature Dark Energy Mark I Crash Cymbal")).to eql("crash")
  end	
  

  it "returns hi hat type correctly" do 
  expect(Productmatch.match_kind("Bosphorus Antique 14\" Dark Hi Hat Cymbals")).to eql("hi hat")
  end	


  it "returns splash type correctly" do 
  expect(Productmatch.match_kind("Istanbul 8\" Traditional Splash Cymbal")).to eql("splash")
  end	

  end	
  

 end


 