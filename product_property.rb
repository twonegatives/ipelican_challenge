class ProductProperty < ActiveRecord::Base

  belongs_to :product
  belongs_to :property
  belongs_to :possible_value

  scope :for_defined_product, lambda{ |product| joins(:property => {:taxon_properties => :taxon}).where(:taxons => {:id => product.taxon_id}, :product_properties => {:product_id => product.id}) }
  scope :group_by_product, lambda{ group('product_id').select('product_id, COUNT(*) as total').order('COUNT(*) DESC') }
end
