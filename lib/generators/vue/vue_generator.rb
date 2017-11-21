class VueGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)
  argument :attributes, :type => :array

  class_option :scope, type: :string, default: 'read_products'

  def create_form
    template "form.vue.erb", "app/javascript/packs/components/forms/#{component_file_name}_form.vue"
  end

  private

  def type
    name.split(":").last
  end

  def component_file_name
    name.pluralize.underscore
  end

  def component_name
    "#{component_file_name.gsub('_', '-')}-form"
  end

  def fields
    attributes.map {|attribute| {field: attribute.name, type: vue_field_type(attribute)} }
  end

  def vue_field_type(attribute)
    case attribute.field_type
    when :number_field then "input-box-number"
    when :text         then "text-area"
    when :boolean      then "checkbox"
    when :date         then "date-field"
    else                    "input-box"
    end
  end

  def editable?
    attributes.map(&:name).include?("id")
  end
end
