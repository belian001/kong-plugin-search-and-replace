local typedefs = require "kong.db.schema.typedefs"

-- Grab pluginname from module name
local plugin_name = ({...})[1]:match("^kong%.plugins%.([^%.]+)")

local schema = {
  name = plugin_name,
  fields = {
    -- the 'fields' array is the top-level entry with fields defined by Kong
    { consumer = typedefs.no_consumer },  -- this plugin cannot be configured on a consumer (typical for auth plugins)
    { protocols = typedefs.protocols_http },
    { config = {
        -- The 'config' record is the custom part of the plugin schema
        type = "record",
        fields = {
          -- a standard defined field (typedef), with some customizations
          { request_maximum_payload_size = {
	      type = "integer",
              required = false,
              gt = 0,
               } },
          { request_maximum_payload_no_content_length_forward_unprocessed = {
	      type = "boolean",
              required = false,
              default = false,
               } },
          { request_maximum_payload_exceeded_forward_unprocessed = {
	      type = "boolean",
              required = false,
              default = true,
               } },
          { request_search_string = {
	      type = "string",
              required = false
               } },
          { request_replace_string = {
	      type = "string",
              required = false
               } },
          { response_maximum_payload_size = {
	      type = "integer",
              required = false,
              gt = 0,
               } },
          { response_maximum_payload_no_content_length_forward_unprocessed = {
	      type = "boolean",
              required = false,
              default = true,
               } },
          { response_maximum_payload_exceeded_forward_unprocessed = {
	      type = "boolean",
              required = false,
              default = true,
               } },
          { response_search_string = {
	      type = "string",
              required = false
               } },
          { response_replace_string = {
	      type = "string",
              required = false
               } },
        },
        entity_checks = {
          -- add some validation rules across fields
          -- the following is silly because it is always true, since they are both required
          -- { at_least_one_of = { "request_header", "response_header" }, },
          -- We specify that both header-names cannot be the same
          -- { distinct = { "request_header", "response_header"} },
        },
      },
    },
  },
}

return schema
