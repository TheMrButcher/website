class Private::File < ApplicationRecord
  validates :original_name,
    presence: true,
    length: { maximum: 256 }
    
  validates :key,
    presence: true,
    length: { maximum: 1024 },
    uniqueness: true
    
  validates :file_type, presence: true
  enum file_type: [ :ordinary, :pano_config, :pano_tile, :pano_hotspot_image ]
  
  validates :datum_id, presence: true
  belongs_to :datum
  belongs_to :storage, polymorphic: true
end
