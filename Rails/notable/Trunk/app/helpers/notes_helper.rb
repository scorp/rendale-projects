module NotesHelper
  
  def generate_tag_cloud
    cloud_hash = Hash.new
    @notes.each do | user_note |
      if user_note.tags.blank?
      else
        user_note.tags.collect do | tag |
          if not cloud_hash.has_key?(tag.name)
            cloud_hash[tag.name] = 1
          else
            cloud_hash[tag.name] = cloud_hash[tag.name].to_i + 1
          end
       end  
      end 
    end
    cloud=""
    begin
      max = cloud_hash.values.collect.max
      min = cloud_hash.values.collect.min
      distrib = ((max - min)/5)
      cloud_hash.sort.each do | pair |
        tag_key = pair[0]
        count = pair[1]  
        size = if count == max 
          3.5
        elsif count == min  
          1.5
        elsif count > distrib * 2
          3
        elsif count > distrib
          2.5
        else
          2
        end
          cloud += link_to(tag_key, {:controller=>'notes', :action=>'search_by_tag', :tag_search=>tag_key},{:id=>"tag_#{tag_key}", :class=>"cloud_link", :style=>"font-size:#{size}em;"}) + " "
      end
    rescue
    end      
    cloud
  end
  
  def GetFileIcon(file)
    if File.exists?(RAILS_ROOT + "/public/images/icon_#{file.filename.match(/\.(...)$/)[1].upcase}_big.gif")
      "/images/icon_#{file.filename.match(/\.(...)$/)[1].upcase}_big.gif"
    else  
       #file.filename.match(/\.(...)$/)[1].upcase
       "/images/icon_Generic_big.gif"
    end
  end  
  
  
  # def in_place_editor(field_id, options = {})
  #   function =  "new Ajax.InPlaceEditor("
  #   function << "'#{field_id}', "
  #   function << "'#{url_for(options[:url])}'"
  # 
  #   js_options = {}
  #   js_options['highlightcolor'] = %('#{options[:highlightColor]}')
  #   js_options['highlightendcolor'] = %('#{options[:highlightEndColor]}')
  #   js_options['cancelText'] = %('#{options[:cancel_text]}') if options[:cancel_text]
  #   js_options['okText'] = %('#{options[:save_text]}') if options[:save_text]
  #   js_options['loadingText'] = %('#{options[:loading_text]}') if options[:loading_text]
  #   js_options['savingText'] = %('#{options[:saving_text]}') if options[:saving_text]
  #   js_options['rows'] = options[:rows] if options[:rows]
  #   js_options['cols'] = options[:cols] if options[:cols]
  #   js_options['size'] = options[:size] if options[:size]
  #   js_options['externalControl'] = "'#{options[:external_control]}'" if options[:external_control]
  #   js_options['loadTextURL'] = "'#{url_for(options[:load_text_url])}'" if options[:load_text_url]        
  #   js_options['ajaxOptions'] = options[:options] if options[:options]
  #   js_options['evalScripts'] = options[:script] if options[:script]
  #   js_options['callback']   = "function(form) { return #{options[:with]} }" if options[:with]
  #   js_options['clickToEditText'] = %('#{options[:click_to_edit_text]}') if options[:click_to_edit_text]
  #   function << (', ' + options_for_javascript(js_options)) unless js_options.empty?
  #   
  #   function << ')'
  # 
  #   javascript_tag(function)
  # end
end
