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

return plugin
