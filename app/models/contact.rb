class Contact
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :name, :email, :message
  
  validates_presence_of :email, :message
  validates_format_of :email, :with => /\A([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})\z/i
  validates_length_of :message, :maximum => 1000
  
  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end
  
  def persisted?
    false
  end
end