class OrganizationsController < ApplicationController

  layout "locations"

  def show
    @organization = params[:organization]
    @organization_tables = Location::Whitelist.organization_tables(@organization)
    if !@organization_tables.present?
      redirect_to root_path, notice: "Unable to find organization."
    end
  end
end
