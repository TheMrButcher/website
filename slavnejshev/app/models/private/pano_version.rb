class Private::PanoVersion < ApplicationRecord
  validates :idx,
    presence: true,
    uniqueness: {scope: :panorama_id},
    numericality: { greater_than: 0 }
  
  validates :description,
    length: { maximum: 1000 }
    
  has_one :config, -> { where file_type: :pano_config }, as: :storage, class_name: 'Private::File'
  has_many :tiles, -> { where file_type: :pano_tile }, as: :storage, class_name: 'Private::File'
  has_many :hotspots, -> { where file_type: :pano_hotspot_image }, as: :storage, class_name: 'Private::File'
  
  belongs_to :panorama
  
  def min_pano?
    config.present? && tiles.present?
  end
  
  def full?
    min_pano? && hotspots.present?
  end
end
