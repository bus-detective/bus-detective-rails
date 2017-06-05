class IndexController < ApplicationController
  force_ssl if: :ssl_configured?, except: [:letsencrypt]

  def show
    if s3_bucket_url.present?
      render text: index_html
    else
      render layout: false
    end
  end

  def letsencrypt
    case params[:id]
    when 'gTrmpuvlhFtL3v0N2Rkhk9GBxkzXsnkfwyf_-XWRsj0'
      render text: 'gTrmpuvlhFtL3v0N2Rkhk9GBxkzXsnkfwyf_-XWRsj0.3agPbEGMW8yyXAdNJmtYhleq07pUgmnN1oCrhN9iRwA'
    when "GmEiT2D0UoKH2AHimAjBr45hrmMyMhYhw7hNipFxa-0"
      render text: "GmEiT2D0UoKH2AHimAjBr45hrmMyMhYhw7hNipFxa-0.jOl0WYrEi5GTa1BlXCSMh31NLeYmWZbZA_QaK-ZpnIE"
    when "t0FKxYEVT4eFdtrbOjyqouQ-KcAwY_2wCjukfQjCc5M"
      render text: "t0FKxYEVT4eFdtrbOjyqouQ-KcAwY_2wCjukfQjCc5M.jOl0WYrEi5GTa1BlXCSMh31NLeYmWZbZA_QaK-ZpnIE"
    else
      render text: "#{params[:id]}.jOl0WYrEi5GTa1BlXCSMh31NLeYmWZbZA_QaK-ZpnIE"
    end
    end

  def robots
    @enable_robots = Rails.configuration.ENABLE_ROBOTS
    render layout: false, content_type: 'text/plain'
  end

  private

  def index_html
    uri = URI("#{s3_bucket_url}/index.html")
    Net::HTTP.get(uri)
  end

  def s3_bucket_url
    Rails.configuration.S3_BUCKET_URL
  end

  def ssl_configured?
    Rails.env.production?
  end
end
