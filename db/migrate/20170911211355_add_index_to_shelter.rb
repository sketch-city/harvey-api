class AddIndexToShelter < ActiveRecord::Migration[5.1]
  def change
    add_index :shelters, :active
  end
end
