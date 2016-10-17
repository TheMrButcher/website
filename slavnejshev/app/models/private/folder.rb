class Private::Folder < ApplicationRecord
  VALID_NAME = /\A[a-z0-9_]+\z/i
  validates :name,
    presence: true,
    length: { maximum: 50 },
    format: { with: VALID_NAME }
    
  validates :full_path,
    presence: true,
    uniqueness: true
  
  validates :owner_id, presence: true
  belongs_to :owner, class_name: "Private::User", foreign_key: "owner_id"
  
  before_validation :make_full_path
  
  acts_as_tree
  
  def to_param
    full_path
  end
  
  def update_paths
    make_full_path
  end
  
  private
    def make_full_path
      if root?
        self.full_path = name.to_s
      else
        self.full_path = parent.full_path + "/" + name.to_s
      end
    end
end
