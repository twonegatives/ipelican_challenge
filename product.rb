class Product < ActiveRecord::Base
  has_many :product_properties, :include => {:property => [:possible_values]}
  has_many :properties, :through => :product_properties
  belongs_to :taxon
end
