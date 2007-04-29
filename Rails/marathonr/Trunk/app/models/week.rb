class Week
	
	attr_reader :day_rows
	attr_reader :log_entries
	attr_reader :schedule_entries
	attr_reader :total_weekly_miles
	attr_reader :total_scheduled_miles
  attr_reader :last_day_of_this_week

	def initialize(target_date, running_log)

          week_array = build_week_array(target_date)
          
          @day_rows = []
          @schedule_entries = []
          @total_weekly_miles = 0
          @total_scheduled_miles = 0

      
            week_array.each do |day|
       
              day_row = running_log.log_entries.find(:first, :conditions => ["date = ?", day])
              schedule_entry = ScheduleEntry.find(:first, :conditions => ["date = ?", day])
            
              if schedule_entry != nil
                @schedule_entries << schedule_entry.miles
              else
                @schedule_entries << 0
              end  
            
            
            if day_row != nil 
            else
               day_row = running_log.log_entries.create(:date => day)
             end 
             @day_rows << day_row
           end
           
           total_actual_miles()
           total_schedule_miles()
           
	end
	
	def average_pace
	
	end	
	
	#private methods
	
	private
	    def build_week_array(current_date)
	      today = current_date
	      
	      if today.wday != 0
	      @last_day_of_this_week = today + (7 - today.wday)
	      else
	      @last_day_of_this_week = today
	      end
	      
	      date_array = []
	      n = 0
	      
	      
	      
	      7.times do
	        date_array << last_day_of_this_week - n
	        n+=1
	      end
	      return date_array.reverse
	end
	
		def total_actual_miles
	  @day_rows.each do |entry|
					@total_weekly_miles += entry.miles || 0
	  			end
	end
	
	
	def total_schedule_miles
	  @schedule_entries.each do |entry|
	  				if entry.class.to_s == "Fixnum"
    	  				  @total_scheduled_miles += entry
	  				else
					  @total_scheduled_miles += entry.miles
					end
	  			end	
	end

end