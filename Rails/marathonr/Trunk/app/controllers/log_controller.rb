require_dependency "login_system"

class LogController < ApplicationController
include LoginSystem
before_filter :login_required
helper :calendar
       
    def index
      if @session['user'].running_logs.find(:first) == nil
        running_log = @session['user'].running_logs.create
        running_log.save
      else  
        running_log = @session['user'].running_logs.find(:first)
      end
      if params.has_key?("year") && params.has_key?("month") && params.has_key?("day") 
        @current_date = Date::civil(y=params[:year].to_i,m=params[:month].to_i,d=params[:day].to_i)
      else
        @current_date = Date.today
      end
      @view_week = Week.new(@current_date, running_log)
      @session['view_week'] = @view_week
    end

    
    def save
        LogEntry.update(params[:day_row].keys, params[:day_row].values)
				render :nothing => true
    end
    
    def save_field
      @id = params[:id]
      @field_to_update = params[:field_to_update]
      @day_row = @session['user'].running_logs.find(:first).log_entries.find(@id)
      @old_pace = @day_row.time/@day_row.miles unless @day_row.miles == 0 || @day_row.time == 0 || @day_row.miles.nil? || @day_row.time.nil? 
      @day_row = LogEntry.update(params[:id],{@field_to_update=>params[:field_value]})      
      @new_pace = @day_row.time/@day_row.miles unless @day_row.miles == 0 || @day_row.time == 0 || @day_row.miles.nil? || @day_row.time.nil? 
    end
    
end
