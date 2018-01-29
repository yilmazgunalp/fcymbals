class Maker < ApplicationRecord
has_many :retailers, :inverse_of => :maker


def to_hash
{id: id, brand: brand,code: code, kind: kind, size: size, series: series, model: model}
end #to_hash	

end
