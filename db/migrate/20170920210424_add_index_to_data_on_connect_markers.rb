class AddIndexToDataOnConnectMarkers < ActiveRecord::Migration[5.1]
  def change
    add_index  :connect_markers, :data, using: :gin
  end
end
