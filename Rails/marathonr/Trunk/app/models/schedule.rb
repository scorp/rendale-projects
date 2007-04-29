class Schedule < ActiveRecord::Base
  belongs_to :running_log
  has_many :schedule_entries
end
