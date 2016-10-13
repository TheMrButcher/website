class Private::Folder < ApplicationRecord
  VALID_NAME = /\A[a-z0-9]+\z/i
  validates :name, presence: true, length: { maximum: 50 }, format: { with: VALID_NAME }
  
  validates :owner_id, presence: true
  belongs_to :owner, class_name: "Private::User"
  
  after_initialize :make_full_path
  before_save :make_full_path
  
  acts_as_tree
  
  private
    def make_full_path
      if root?
        self.full_path = "/" + name
      else
        self.full_path = parent.full_path + "/" + name
      end
    end
end
