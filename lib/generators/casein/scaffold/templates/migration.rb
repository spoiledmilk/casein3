class Create<%= class_name.pluralize %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
      <% attributes.each do |attribute| %>t.<%= attribute.type %> :<%= attribute.name %>
      <% end %>
      t.timestamps
    end
  end

  def self.down
    drop_table :<%= table_name %>
  end
end