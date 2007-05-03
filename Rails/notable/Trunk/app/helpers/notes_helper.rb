module NotesHelper
  
  def asset_url(asset)
             secret = "verysecret" # same as in lighttpd
             uri_prefix = "/files/"  # same as in lighttpd
             filename = "/#{asset.note.user.login}/#{asset.note.id}/#{asset.filename}"
             #filepath = "/#{asset.systempath}"
             t = Time.now.to_i.to_s( base=16 ) # unixtime in hex
             hash = Digest::MD5.new( "#{secret}#{filename}#{t}" )
             "#{uri_prefix}#{hash}/#{t}#{filename}"
  end

  def asset_thumb_url(asset)
             secret = "verysecret" # same as in lighttpd
             uri_prefix = "/files/"  # same as in lighttpd
             filename = "/#{asset.note.user.login}/#{asset.note.id}/thumb_#{asset.filename}"
             #filepath = "/#{asset.systempath}"
             t = Time.now.to_i.to_s( base=16 ) # unixtime in hex
             hash = Digest::MD5.new( "#{secret}#{filename}#{t}" )
             "#{uri_prefix}#{hash}/#{t}#{filename}"
  end
  
  def generate_tag_cloud
    cloud_hash = Hash.new
    if not session['user'].nil?
          User.find(session['user'].id).notes.each do | user_note |
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
        cloud = ""

        begin
        max = cloud_hash.values.collect.max
        min = cloud_hash.values.collect.min
        distrib = ((max - min)/5)
        cloud_hash.sort.each do | pair |
        tag_key = pair[0]
        count = pair[1]  
        size = if count == max 
          3
        elsif count == min  
          1
        elsif count > distrib * 2
          2.5
        elsif count > distrib
          2
        else
          1.5
        end
          cloud += link_to(tag_key, {:controller=>'notes', :action=>'search_by_tag', :tag_search=>tag_key},{:class=>"cloud_link", :style=>"font-size:#{size}em;"}) + " "
        end
      rescue
      end
      end
      cloud
  end
  
  def GetFileIcon(file)
    if File.exists?("../public/images/icon_#{file.filetype}_big.gif")
      "/images/icon_#{file.filetype}_big.gif"
    else
      "/images/icon_Generic_big.gif"
    end
  end  
end
