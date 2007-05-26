# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

def set_active_tab(controller, action)
  "<script>
    try
    {
      $('#{controller + "_" + action}').addClassName('active');
      //page_controller.addEffectToQueue(addClass, '#{controller + "_" + action}', 'active');
    }
    catch(e)
    {}
  </script>"
end

end
