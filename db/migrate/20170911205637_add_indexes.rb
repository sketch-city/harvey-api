class AddIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :shelters, :active
    add_index :shelters, :accepting
    add_index :shelters, [:latitude, :longitude]
    add_index :needs, :active
    add_index :needs, [:latitude, :longitude]
    add_index :locations, :active
    add_index :locations, [:latitude, :longitude]
    add_index :charitable_organizations, :active
  end
end
