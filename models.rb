class Taxon < ActiveRecord::Base
  has_many :products
  has_many :taxon_properties
  has_many :properties, :through => :taxon_properties
end

class Product < ActiveRecord::Base
  has_many :product_properties, :include => {:property => [:possible_values]}
  has_many :properties, :through => :product_properties
  belongs_to :taxon
end

class Property < ActiveRecord::Base
  has_many :product_properties, :dependent => :destroy
  has_many :products, :through => :product_properties
  has_many :possible_values
  has_many :taxon_properties
  has_many :taxons, :through => :taxon_properties
end

class ProductProperty < ActiveRecord::Base
  belongs_to :product
  belongs_to :property
  belongs_to :possible_value
end

class TaxonProperty < ActiveRecord::Base
  self.table_name = "properties_taxons"
  
  belongs_to :taxon
  belongs_to :property
end

class PossibleValue < ActiveRecord::Base
  belongs_to :property
end

