class AbstinenceTracker < ApplicationRecord
  belongs_to :user

  def start_time
    self.date
  end
end
