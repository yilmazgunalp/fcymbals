require "rails_helper"



RSpec.describe Maker do
  it "has none to begin with" do
    expect(Maker.count).to eq 0
  end

  it "has one after adding one" do
    Maker.create
    expect(Maker.count).to eq 1
  end

  it "has one after one was created in a previous example" do
    expect(Maker.count).to eq 0
  end


  context "find cymbals  by brand" do 

    it "returns all 'Zildjian' brand cymbals" do 
      Maker.create!(brand: "zildjian")

      expect(Maker.zildjian.length).to eq(1)
    end

it "returns all 'Istanbul Mehmet' brand cymbals" do 
      10.times {Maker.create(brand: "istanbul mehmet")}
      expect(Maker.mehmet.length).to eq(10)
    end


  end  

  end