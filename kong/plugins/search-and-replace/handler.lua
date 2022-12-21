local plugin = {
  PRIORITY = 1000, 
  VERSION = "0.1", 
}


function plugin:body_filter(plugin_conf)
  if kong.ctx.plugin.dont_process then
    return
  end
  if plugin_conf.response_search_string then
    local body = kong.response.get_raw_body()
    if body then
      kong.log.debug("Response search string: " .. plugin_conf.response_search_string)
      local replace_string = plugin_conf.response_replace_string
      if not replace_string then
        replace_string = ""
      end
      kong.log.debug("Response replace string: " .. replace_string)
	      
      local replaced_body = body:gsub(plugin_conf.response_search_string, replace_string)
      kong.response.set_raw_body(replaced_body)
    end
  end
end 

return plugin
