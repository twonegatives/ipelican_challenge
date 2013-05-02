class Product < ActiveRecord::Base

  has_many :product_properties, :include => {:property => [:possible_values]}
  has_many :properties, :through => :product_properties
  belongs_to :taxon

  scope :relevant, lambda do |query, amount|
    if query.present? && amount >= 0
      where(:id => ProductProperty.where(query).group_by_product.limit(amount).pluck(:product_id))
    else
      where('FALSE')
    end
  end

  def most_relevant
    
    query                       = ProductProperty.for_defined_product(self).map do |single_property|
                                    "(product_properties.property_id=#{single_property.property_id} AND " +
                                    ['num_value', 'bool_value', 'str_value'].map do |column_name|
                                      if (present_value = single_property.try(column_name)).present?
                                        "product_properties.#{column_name}=#{present_value}"
                                      else
                                        "product_properties.#{column_name} IS NULL"
                                      end
                                    end.join(' AND ') + ')'
                                  end.join(' OR ')
    Product.relevant(query, 6)
  end
end
