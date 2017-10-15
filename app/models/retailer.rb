class Retailer < ApplicationRecord
  belongs_to :maker, :inverse_of => :retailers





end
