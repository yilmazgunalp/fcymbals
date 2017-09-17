class Maker < ApplicationRecord

scope  :zildjian, -> {where(brand: "zildjian")}	
scope  :sabian, -> {where(brand: "sabian")}	
scope  :meinl, -> {where(brand: "meinl")}
scope  :paiste, -> {where(brand: "paiste")}	
scope :mehmet, -> {where(brand: "istanbul mehmet")}	
scope  :istanbul, -> {where(brand: "istanbul")}	
scope  :bosphorus, -> {where(brand: "bosphorus")}	
scope  :dream, -> {where(brand: "dream")}	
scope  :ufip, -> {where(brand: "ufip")}		
end
