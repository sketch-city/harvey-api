class AddCalculatedValuesForShelters < ActiveRecord::Migration[5.1]
  def change
    add_column :shelters, :calculated_needs, :string, array: true
    add_column :shelters, :calculated_updated_at_rfc3339, :string
    add_column :shelters, :calculated_phone, :string

    add_column :needs, :calculated_needs, :string, array: true
    add_column :needs, :calculated_updated_at_rfc3339, :string
    add_column :needs, :calculated_phone, :string
  end
end
