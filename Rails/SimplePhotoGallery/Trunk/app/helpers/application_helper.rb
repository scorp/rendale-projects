# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

def set_active_tab(controller)
  "<script>
    try
    {
      $('#{controller}').addClassName('active');
      //page_controller.addEffectToQueue(addClass, '#{controller}', 'active');
    }
    catch(e)
    {}
  </script>"
end

end
