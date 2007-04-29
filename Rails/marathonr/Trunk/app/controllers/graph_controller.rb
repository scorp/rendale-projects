class GraphController < ApplicationController
  
  def progress_graph

    if @session['user'].running_logs.find(:first) == nil
      running_log = @session['user'].running_logs.create
      running_log.save
    else  
      running_log = @session['user'].running_logs.find(:first)
    end
    
    weekly_totals = running_log.get_weekly_totals(params[:start_dt], params[:end_dt])
    schedule_weekly_totals = running_log.get_schedule_totals_by_week(params[:start_dt], params[:end_dt])
    schedule_miles = schedule_weekly_totals.collect{|week| week["total miles"].to_i}
    miles = weekly_totals.collect{|week| week["total miles"].to_i}
    week_labels = Hash.new
    weeks = weekly_totals.collect{|week| week["week ending"].to_s}.each_with_index do |item, index|
              week_labels[index] = item
    end
 
#    render_text week_labels
      
  g = Gruff::Bar.new(1000)
  g.title = "Progress Graph" 

  g.data("miles ran", miles, '#ff0000')
  g.data("schedule miles", schedule_miles, '#ffffff')
#  g.labels = week_labels
  g.marker_font_size = 12.0
  g.theme = {
     :colors => %w(#ff0000),
     :marker_color => '#D8CCCC',
     :background_colors => %w(#232121 #232121)
   }
  
  send_data(g.to_blob, 
                :disposition => 'inline', 
                :type => 'image/png', 
                :filename => "miles.png")              
  end
end
