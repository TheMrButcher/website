class Private::Datum < ApplicationRecord
  validates :path,
    presence: true,
    uniqueness: true
  
  validates :datum_hash,
    presence: true,
    uniqueness: true
  
  has_many :files
  
  def self.digest(datum)
    Digest::SHA1.hexdigest(datum)
  end
end
