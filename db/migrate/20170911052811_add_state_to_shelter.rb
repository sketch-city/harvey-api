class AddStateToShelter < ActiveRecord::Migration[5.1]
  def change
    add_column :shelters, :state, :string
  end
end
