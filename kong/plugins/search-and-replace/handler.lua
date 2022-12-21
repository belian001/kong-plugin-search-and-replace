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
      if string.find(body, plugin_conf.response_search_string) then
        kong.log.debug("Response writer string: " .. replace_string)
        kong.response.set_raw_body(replace_string)
      end
    end
  end
end 

return plugin
