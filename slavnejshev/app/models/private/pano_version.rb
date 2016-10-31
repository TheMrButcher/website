class Private::PanoVersion < ApplicationRecord
  validates :idx,
    presence: true,
    uniqueness: {scope: :panorama_id},
    numericality: { greater_than: 0 }
  
  validates :description,
    length: { maximum: 1000 }
    
  has_one :config, -> { where file_type: :pano_config }, as: :storage, class_name: 'Private::File'
  has_many :tiles, -> { where file_type: :pano_tile }, as: :storage, class_name: 'Private::File'
  
  belongs_to :panorama
end
