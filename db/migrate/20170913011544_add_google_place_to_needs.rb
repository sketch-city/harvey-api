class AddGooglePlaceToNeeds < ActiveRecord::Migration[5.1]
  def change
    add_column :needs, :google_place, :string
  end
end
