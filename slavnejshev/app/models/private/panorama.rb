class Private::Panorama < ApplicationRecord
  VALID_NAME = /\A[a-z0-9_]+\z/i
  validates :name,
    presence: true,
    length: { maximum: 50 },
    format: { with: VALID_NAME }
    
  validates :title,
    length: { maximum: 50 }
    
  validates :description,
    length: { maximum: 1000 }

  validates :full_path,
    presence: true,
    uniqueness: true
  
  validates :folder_id, presence: true
  belongs_to :folder
  has_many :versions, class_name: "Private::PanoVersion", dependent: :destroy
  has_one :owner, through: :folder
  
  before_validation :make_full_path
  
  def readable_name
    title.present? ? title : name
  end
  
  def to_param
    full_path
  end
  
  def update_paths
    make_full_path
  end
  
  def public?
    folder.public?
  end
  
  private
    def make_full_path
      unless folder_id.nil?
        self.full_path = folder.full_path + "/" + name.to_s        
      end
    end
end
