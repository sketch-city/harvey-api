class Api::V1::HooksController < ApplicationController

  before_action do
    request.format = :json
  end

  def sheet_update
    head :ok
  end

end
