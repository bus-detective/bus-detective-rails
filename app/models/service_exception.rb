class ServiceException < ActiveRecord::Base
  belongs_to :service
  belongs_to :agency

  def self.added
    where(exception: 1)
  end

  def self.removed
    where(exception: 2)
  end
end
