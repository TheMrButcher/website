class Private::PanoVersion < ApplicationRecord
  validates :idx,
    presence: true,
    uniqueness: {scope: :panorama_id},
    numericality: { greater_than: 0 }
  
  validates :description,
    length: { maximum: 1000 }
  
  belongs_to :panorama
end
