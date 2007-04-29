require_dependency "login_system"

class MarathonrController < ApplicationController
include LoginSystem
before_filter :login_required
#	model :user, :running_log, :log_entry
    
    def index
      if @session['user'].running_logs.find(:first) == nil
        running_log = @session['user'].running_logs.create
        running_log.save
      else  
        running_log = @session['user'].running_logs.find(:first)
      end 
    	
      redirect_to(:action => 'current_week')
    end
   
    def current_week
      week_array = build_week_array(Date.today)
      @day_rows = []
      
      week_array.each do |day|
         day_row = @session['user'].running_logs.find(:first).log_entries.find(:first, :conditions => ["date = ?", day])
         if day_row != nil
    
         else
           day_row = @session['user'].running_logs.find(:first).log_entries.create(:date => day)
         end 
         @day_rows << day_row
       end
      
    end
    
    def save
     # text = []
      
      #params[:day_row].each do | log_entry |
       # x = 0
        #text << log_entry.to_s + ' ' + x.to_s
      #  x += 1
    #  end
      
      LogEntry.update(params[:day_row].keys, params[:day_row].values)
      
      #render :text => params.to_s
      
      redirect_to (:action=> 'current_week')
      
    end
    
    private
    def build_week_array(current_date)
      today = Date.today
      last_day_of_this_week = Date.today + (6 - Date.today.wday)
      date_array = []
      n = 0
      7.times do
        date_array << last_day_of_this_week - n
        n+=1
      end
      return date_array.reverse
    end
    
end
