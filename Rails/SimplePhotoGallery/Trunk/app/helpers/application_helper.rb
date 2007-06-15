# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper


def user_area(&block)
  concat content_tag(:div, capture(&block), :class=>"user_area"), block.binding if logged_in?
end

def display_avatar
    image_tag @user.avatar.public_filename(:tiny), :class=>"avatar" rescue image_tag "/images/default_avatar.gif", :class => "avatar"
end



def set_active_tab(controller)
  "<script>
    try
    {
      $('#{controller.gsub("user_","")}').addClassName('active');
      //page_controller.addEffectToQueue(addClass, '#{controller}', 'active');
    }
    catch(e)
    {}
  </script>"
end

def set_active_secondary
  "<script>
    try
    {
      $('#{params[:controller]}_secondary').addClassName('active');
      //page_controller.addEffectToQueue(addClass, '#{controller}', 'active');
    }
    catch(e)
    {}
  </script>"
end

end
