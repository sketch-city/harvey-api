class AddNeedsToShelter < ActiveRecord::Migration[5.1]
  def change

    add_column :shelters, :needs, :string, array: true, default: [] 
  end
end
