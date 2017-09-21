class Connect::FlaggedMarkersController < ApplicationController
  before_action :authenticate_admin!
  helper_method :fields

  def index
    logger.info current_user
    @flagged_markers = ::Connect::Marker.unresolved.flagged
  end

  def show
    @flagged_marker = ::Connect::Marker.find(params[:id])
  end

  def update
    ::Connect::Marker.find(params[:id]).update!(resolved: true)
    logger.info "#{current_user.email} confirmed marker[#{params[:id]}] as inappropriate."
    redirect_to connect_flagged_markers_url, notice: 'Marker confirmed.'
  end

  def destroy
    ::Connect::Marker.find(params[:id]).clear_inappropriate_flag!
    logger.info "#{current_user.email} cleared marker[#{params[:id]}]."
    redirect_to connect_flagged_markers_url, notice: 'Marker cleared.'
  end

  private

  def fields
    %w(flagged_at flagged_for marker_type name address)
  end
end
