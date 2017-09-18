class Maker < ApplicationRecord


#brands
scope  :zildjian, -> {where(brand: "zildjian")}	
scope  :sabian, -> {where(brand: "sabian")}	
scope  :meinl, -> {where(brand: "meinl")}
scope  :paiste, -> {where(brand: "paiste")}	
scope :mehmet, -> {where(brand: "istanbul mehmet")}	
scope  :istanbul, -> {where(brand: "istanbul")}	
scope  :bosphorus, -> {where(brand: "bosphorus")}	
scope  :dream, -> {where(brand: "dream")}	
scope  :ufip, -> {where(brand: "ufip")}
#types
scope  :crash, -> {where(kind: "crash")}
scope  :ride, -> {where(kind: "ride")}
scope  :hi_hat, -> {where(kind: "hi hat")}
scope  :china, -> {where(kind: "china")}
scope  :splash, -> {where(kind: "splash")}
scope  :crash_ride, -> {where(kind: "crash ride")}
scope  :flat_ride, -> {where(kind: "flat ride")}
scope  :bell, -> {where(kind: "bell")}
scope  :effect, -> {where(kind: "effect")}
scope  :oschestra, -> {where(kind: "orchestra")}
scope  :marching, -> {where(kind: "marching")}
scope  :gong, -> {where(kind: "gong")}
scope  :set, -> {where(kind: "set")}
scope  :finger, -> {where(kind: "finger cymbals")}
scope  :hand, -> {where(kind: "hand cymbals")}
scope  :suspended, -> {where(kind: "suspended")}
scope  :crotales, -> {where(kind: "crotales")}




end
