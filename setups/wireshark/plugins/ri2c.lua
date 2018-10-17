
-- utils

function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))
    else
      print(formatting .. tostring(v))
    end
  end
end

-- Protocol

local ri2c = Proto("ri2c","Reduced I2C protocol")

local fields = {
  mickey = ProtoField.uint16 ("ri2c.mickey", "Mickey"),
  minnie = ProtoField.uint8  ("ri2c.minnie", "Minnie"),
  donald = ProtoField.uint8  ("ri2c.donald", "Donald", base.DEC, {[1]="happy", [2]="cool", [3]="angry"})
}
ri2c.fields = fields -- this is stupid but I don't know how to fix it


----------------------------------------
-- The following creates the callback function for the dissector.
-- It's the same as doing "dns.dissector = function (tvbuf,pkt,root)"
-- The 'tvbuf' is a Tvb object, 'pktinfo' is a Pinfo object, and 'root' is a TreeItem object.
function ri2c.dissector(tvbuf, pktinfo, root)

  -- set the protocol column to show our protocol name
  pktinfo.cols.protocol:set("RI2C")

  local pktlen = tvbuf:reported_length_remaining()
  local tree = root:add(ri2c, tvbuf:range(0,pktlen))


  tree:add(fields.mickey, tvbuf:range(0,2))
  tree:add(fields.minnie, tvbuf:range(2,1))
  tree:add(fields.donald, tvbuf:range(3,1))

  -- tell wireshark how much of tvbuff we dissected
  return pos
end
