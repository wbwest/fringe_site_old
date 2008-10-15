require 'rubygems'
require 'activeresource'

class Activeyoutube < ActiveResource::Base
  class << self
  ## Remove format from the url.
  def element_path(id, prefix_options = {}, query_options = nil)
    prefix_options, query_options = split_options(prefix_options) if query_options.nil?
    "#{prefix(prefix_options)}#{collection_name}/#{id}#{query_string(query_options)}"
  end
    
  ## Remove format from the url.
  def collection_path(prefix_options = {}, query_options = nil)
    prefix_options, query_options = split_options(prefix_options) if query_options.nil?
    "#{prefix(prefix_options)}#{collection_name}#{query_string(query_options)}"
  end

  ## For a collection call, ActiveResource formatting is not 
  ## compliant with YouTube's output.
  def instantiate_collection(collection, prefix_options = {})
    unless collection.kind_of? Array
      [instantiate_record(collection, prefix_options)]
    else
      collection.collect! { |record| instantiate_record(record, prefix_options) }
    end
  end

  ## To convert output into proper standard.
  ## If single element is present in output then entry is not an array.
  ## So this method will ensure entry is always an array.
  alias :old_find :find
  def find(*args)
    output=old_find(*args)
    if output.respond_to?:entry and !(output.entry.kind_of? Array)
      output.entry=[output.entry]
    end
    output
  end

  ## When using ActiveResource::CustomMethods, ActiveResource first tries to retrieve the id using find() 
  ## and then makes a get() call using that id. 
  ## But, youtube returns the url of this item as id, which we don't want. This method overrides the behavior.
  ## Example: comments = Video.find_custom("ZTUVgYoeN_o").get(:comments)
  def find_custom(arg)
    object = self.new
    object.id = arg
    object
  end

  ##  Following method from ActiveResource::CustomMethods extends the capabilities of activeresource for non-standard urls ;-)
  ##  The objects returned from this method are not automatically converted into ActiveResource instances - they are ordinary Hashes. 
  ##  Modifications below ensures that you get ActiveResource instances.
  def get(method_name, options = {})
    object_array = connection.get(custom_method_collection_url(method_name, options), headers)
    if object_array.class.to_s=="Array"
      object_array.collect! {|record| self.class.new.load(record)}
    else
      self.class.new.load(object_array)
    end
  end
  end

  ## Instance Methods: (modifying the ActiveRecord::CustomMethods).
 
  ## This modification is same as defined in above method 
  def get(method_name, options = {})
    self.class.new.load(connection.get(custom_method_element_url(method_name, options), self.class.headers))
  end

  ## Modifying the url formation to make it Youtube API complaint
  def custom_method_element_url(method_name, options = {})    
    "#{self.class.prefix(prefix_options)}#{self.class.collection_name}/#{id}/" +
    "#{method_name}#{self.class.send!(:query_string, options)}"
  end
end