class Private::File < ApplicationRecord
  validates :original_name,
    presence: true,
    length: { maximum: 256 }
    
  validates :key,
    presence: true,
    length: { maximum: 1024 },
    uniqueness: true
  
  validates :datum_id, presence: true
  belongs_to :datum
end
