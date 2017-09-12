class Api::V1::NeedsController < ApplicationController

  before_action do
    request.format = :json
  end

  def index
      @filters = {}
      @needs = Need.all

      if params[:lat].present? && params[:lon].present?
        @filters[:lon] = params[:lon]
        @filters[:lat] = params[:lat]
        @needs = @needs.near([params[:lat], params[:lon]], 100)
      end

      if params[:location_name].present?
        @filters[:location_name] = params[:location_name]
        @needs = @needs.where("location_name ILIKE ?", "%#{params[:location_name]}%")
      end

      if params[:volunteers_needed].present?
        @filters[:volunteers_needed] = params[:volunteers_needed]
        @needs = @needs.where(are_volunteers_needed: true)
      end

      if params[:supplies_needed].present?
        @filters[:supplies_needed] = params[:supplies_needed]
        @needs = @needs.where(are_supplies_needed: true)
      end


      if stale?(etag: @needs, last_modified: @needs.maximum(:updated_at), public: true)

        # here because limit is causing a SQL problem:  column "distance" does not exist
        if params[:limit].to_i > 0
          @filters[:limit] = params[:limit].to_i
          @needs = @needs.take(params[:limit].to_i)
        end

      end
      
  end

end
