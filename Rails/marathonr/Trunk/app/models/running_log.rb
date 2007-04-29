class RunningLog < ActiveRecord::Base
  has_one :schedule
  has_many :log_entries
  belongs_to :user
        
  def get_weekly_totals(begin_dt, end_dt)
    weekly_totals = self.log_entries.find(:all, {:group=>"'week ending'", :select=>"STR_TO_DATE(CONCAT(yearweek(date,5), ' Sunday'), '%x%v %W') as 'week ending', sum(miles) as 'total miles'",:order=>'yearweek(date,5)',:conditions=>['yearweek(date,5) between yearweek(?,5) and yearweek(?,5)', begin_dt, end_dt ]})
  end

  def get_schedule_totals_by_week(begin_dt, end_dt)
    weekly_totals = self.schedule.schedule_entries.find(:all, {:group=>"'week ending'", :select=>"STR_TO_DATE(CONCAT(yearweek(date,5), ' Sunday'), '%x%v %W') as 'week ending', sum(miles) as 'total miles'",:order=>'yearweek(date,5)',:conditions=>['yearweek(date,5) between yearweek(?,5) and yearweek(?,5)', begin_dt, end_dt ]})
  end
  
  def get_weeks
    
  end
  
end