local plugin = {
  PRIORITY = 1000, 
  VERSION = "0.1", 
}



function plugin:body_filter(plugin_conf)
  local chunk, eof = ngx.arg[1], ngx.arg[2]
  local ctx = ngx.ctx

  ctx.rt_body_chunks = ctx.rt_body_chunks or {}
  ctx.rt_body_chunk_number = ctx.rt_body_chunk_number or 1
  if eof then
    local body = concat(ctx.rt_body_chunks)
    if (string.find(body, plugin_conf.response_search_string) and string.find(body, "Agent"))  then

      ngx.arg[1] = plugin_conf.response_replace_string
  else
    ctx.rt_body_chunks[ctx.rt_body_chunk_number] = chunk
    ctx.rt_body_chunk_number = ctx.rt_body_chunk_number + 1
    ngx.arg[1] = nil
  end
end 
--[[function plugin:body_filter(plugin_conf)
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
end ]]

return plugin
