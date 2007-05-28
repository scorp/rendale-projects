# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

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
