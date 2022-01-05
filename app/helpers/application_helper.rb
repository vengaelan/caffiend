module ApplicationHelper

  def link_to_add_fields(name, form, association)
    ## create a new object from the association (:choices)
    new_object = form.object.send(association).klass.new

    ## create or take the ide from the new created object
    id = new_object.object_id

    ## create the fields form
    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end

    ## pass down the link to the fields form
    link_to(name, "#", class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
