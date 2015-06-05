module ScopedToAgency
  extend ActiveSupport::Concern

  included do
    before_filter :load_agency
  end

  protected

  def load_agency
    @agency = Agency.find_by_id(params[:agency_id])
  end
end

