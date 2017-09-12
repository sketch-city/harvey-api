class Api::V1::SheltersController < ApplicationController

  before_action do
    request.format = :json
  end

  def index
    @filters = {}
    @shelters = Shelter.all

    if params[:lat].present? && params[:lon].present?
      @filters[:lon] = params[:lon]
      @filters[:lat] = params[:lat]
      @shelters = @shelters.near([params[:lat], params[:lon]], 100, order: "distance")
    end

    if params[:county].present?
      @filters[:county] = params[:county]
      @shelters = @shelters.where("county ILIKE ?", "%#{@filters[:county]}%")
    end

    if params[:shelter].present?
      @filters[:shelter] = params[:shelter]
      @shelters = @shelters.where("shelter ILIKE ?", "%#{@filters[:shelter]}%")
    end

    if params[:accepting].present?
      @filters[:accepting] = params[:accepting]
      @shelters = @shelters.where(accepting: true)
    end

    if stale?(etag: @shelters, last_modified: @shelters.maximum(:updated_at), public: true)

      # here because limit is causing a SQL problem:  column "distance" does not exist
      if params[:limit].to_i > 0
        @filters[:limit] = params[:limit].to_i
        @shelters = @shelters.take(params[:limit].to_i)
      end

    end
  end

end
