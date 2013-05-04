module ApplicationHelper
  
  def class_for_link_to_namespace(tested_namespace)
    return 'selected' if tested_namespace == namespace
    nil
  end
  
  def class_for_link_to_namespace_controller(tested_namespace_controller)
    return 'selected' if tested_namespace_controller == namespace_controller
    nil
  end
  
  def namespace
    params[:controller].split("/").first
  end
  
  def current_namespace?(current_namespace)
    namespace == current_namespace
  end
  
  def namespace_controller
    params[:controller].split("/").second
  end
  
  def current_namespace_controller?(current_namespace_controller)
    namespace_controller == current_namespace_controller
  end
  
  def namespace_action
    params[:action]
  end
  
  def current_action?(current_action)
    namespace_action == current_action
  end
  
  def pennies_to_decimal(pennies)
    pennies.to_f / 100
  end
  
  def icon_for(filename, options={})
    size = "#{options[:size]}/" if options[:size]
    "/assets/file_icons/#{"#{size}/" if size}#{filename}.png"
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields button", data: {id: id, fields: fields.gsub("\n", "")})
  end
end