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
    if params[:id] == 'LKgzYKUJjp71CZ5s9PUA6_cj6xebp_u7VmTLX4NDun8'
      render text: 'LKgzYKUJjp71CZ5s9PUA6_cj6xebp_u7VmTLX4NDun8.x2TXuRtPY5PkPL4YMeiKaMl4xBtFrjfOe94AR0Iyg1M'
    elsif params[:id] == 'gTrmpuvlhFtL3v0N2Rkhk9GBxkzXsnkfwyf_-XWRsj0'
      render text: 'gTrmpuvlhFtL3v0N2Rkhk9GBxkzXsnkfwyf_-XWRsj0.3agPbEGMW8yyXAdNJmtYhleq07pUgmnN1oCrhN9iRwA'
    else
      render text: '8BuARSATWEUgzbNUlNsz-RHS6WENQ2G9A6DbaPUwPNY.3agPbEGMW8yyXAdNJmtYhleq07pUgmnN1oCrhN9iRwA'
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
