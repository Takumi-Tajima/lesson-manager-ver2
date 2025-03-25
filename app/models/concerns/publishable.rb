module Publishable
  extend ActiveSupport::Concern

  included do
    scope :published, -> { where.not(published_at: nil) }
  end

  def published
    published_at.present?
  end

  def published?
    published
  end

  def published=(vaule)
    self.published_at = vaule == '1' ? Time.current : nil
  end
end
