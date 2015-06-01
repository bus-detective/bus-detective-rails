class ApplicationSearcher
  include ActiveModel::SerializerSupport

  def initialize(params)
    @params = params
  end

  def results
    @results ||= scoped_results.page(page).per(per_page)
  end

  def per_page
    @per_page ||= positive_or_default(@params[:per_page].to_i, Kaminari.config.default_per_page)
  end

  def page
    @page ||= positive_or_default(@params[:page].to_i, 1)
  end

  def total_results
    @total_results ||= results.total_count
  end

  def total_pages
    @total_pages ||= results.total_pages
  end

  def valid?
    true
  end

  private

  def positive_or_default(v, d)
    v > 0 ? v : d
  end

  def scoped_results
    raise StandardError.new("scoped_results method not implimented")
  end
end
