class Post < ActiveRecord::Base
  belongs_to :user
  
  has_attached_file :picture, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "http://placehold.it/400x400"
  
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
end