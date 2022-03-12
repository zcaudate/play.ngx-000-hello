-- xt.lang.base-lib/type-native [20] 
local function type_native(obj)
  local t = type(obj)
  if t == 'table' then
    if nil == (obj)[1] then
      return 'object'
    else
      return 'array'
    end
  else
    return t
  end
end

-- xt.lang.base-lib/type [26] 
local function type(x)
  local ntype = type_native(x)
  if ntype == 'object' then
    return x['::/__type__'] or ntype
  else
    return ntype
  end
end

-- xt.lang.base-lib/key-fn [36] 
local function key_fn(k)
  return function (x)
    return x[k]
  end
end

-- xt.lang.base-lib/inc-fn [43] 
local function inc_fn(init)
  local i = init
  if nil == i then
    i = -1
  end
  local function inc_fn()
    i = (i + 1)
    return i
  end
  return inc_fn
end

-- xt.lang.base-lib/step-nil [61] 
local function step_nil(obj,pair)
  return nil
end

-- xt.lang.base-lib/step-thrush [67] 
local function step_thrush(x,f)
  return f(x)
end

-- xt.lang.base-lib/step-call [73] 
local function step_call(f,x)
  return f(x)
end

-- xt.lang.base-lib/step-push [79] 
local function step_push(arr,e)
  table.insert(arr,e)
  return arr
end

-- xt.lang.base-lib/step-set-key [86] 
local function step_set_key(obj,k,v)
  obj[k] = v
  return obj
end

-- xt.lang.base-lib/step-set-fn [93] 
local function step_set_fn(obj,k)
  return function (v)
    return step_set_key(obj,k,v)
  end
end

-- xt.lang.base-lib/step-set-pair [99] 
local function step_set_pair(obj,e)
  obj[e[1]] = e[2]
  return obj
end

-- xt.lang.base-lib/step-del-key [108] 
local function step_del_key(obj,k)
  obj[k] = nil
  return obj
end

-- xt.lang.base-lib/starts-with? [120] 
local function starts_withp(s,match)
  return string.sub(s,1,#match) == match
end

-- xt.lang.base-lib/ends-with? [129] 
local function ends_withp(s,match)
  return match == string.sub(s,(#s - #match) + 1,#s)
end

-- xt.lang.base-lib/capitalize [141] 
local function capitalize(s)
  return string.upper(string.sub(s,1,1)) .. string.sub(s,2)
end

-- xt.lang.base-lib/decapitalize [152] 
local function decapitalize(s)
  return string.lower(string.sub(s,1,1)) .. string.sub(s,2)
end

-- xt.lang.base-lib/pad-left [163] 
local function pad_left(s,n,ch)
  local l = n - (#s + 1)
  local out = s
  for i = 0,l,1 do
    out = (ch .. out)
  end
  return out
end

-- xt.lang.base-lib/pad-right [173] 
local function pad_right(s,n,ch)
  local l = n - (#s + 1)
  local out = s
  for i = 0,l,1 do
    out = (out .. ch)
  end
  return out
end

-- xt.lang.base-lib/pad-lines [183] 
local function pad_lines(s,n,ch)
  local lines =   (function (s,tok)
      local out = {}
      string.gsub(s,string.format('([^%s]+)',tok),function (c)
        table.insert(out,c)
      end)
      return out
    end)(s,'\n')
  local out = ''
  for _, line in  ipairs(lines) do
    if 0 < #(out) then
      out = (out .. '\n')
    end
    out = (out .. pad_left('',n,' ') .. line)
  end
  return out
end

-- xt.lang.base-lib/mod-pos [200] 
local function mod_pos(val,modulo)
  local out = val % modulo
  return (out < 0) and (out + modulo) or out
end

-- xt.lang.base-lib/mod-offset [209] 
local function mod_offset(pval,nval,modulo)
  local offset = (nval - pval) % modulo
  if math.abs(offset) > (modulo / 2) then
    if offset > 0 then
      return offset - modulo
    else
      return offset + modulo
    end
  else
    return offset
  end
end

-- xt.lang.base-lib/gcd [225] 
local function gcd(a,b)
  return (0 == b) and a or gcd(b,a % b)
end

-- xt.lang.base-lib/lcm [233] 
local function lcm(a,b)
  return (a * b) / gcd(a,b)
end

-- xt.lang.base-lib/mix [240] 
local function mix(x0,x1,v,f)
  if nil == f then
    f = function (x)
      return x
    end
  end
  return x0 + ((x1 - x0) * f(v))
end

-- xt.lang.base-lib/sign [249] 
local function sign(x)
  return (x < 0) and -1 or 1
end

-- xt.lang.base-lib/round [256] 
local function round(x)
  return math.floor(x + 0.5)
end

-- xt.lang.base-lib/sym-full [266] 
local function sym_full(ns,id)
  return ns .. '/' .. id
end

-- xt.lang.base-lib/sym-name [272] 
local function sym_name(sym)
  local idx = string.find(sym,'/') or -1
  return string.sub(sym,(idx - 0) + 1)
end

-- xt.lang.base-lib/sym-ns [280] 
local function sym_ns(sym)
  local idx = string.find(sym,'/') or -1
  if 0 < idx then
    return string.sub(sym,0,idx - 1)
  else
    return nil
  end
end

-- xt.lang.base-lib/sym-pair [289] 
local function sym_pair(sym)
  return {sym_ns(sym),sym_name(sym)}
end

-- xt.lang.base-lib/not-empty? [302] 
local function not_emptyp(res)
  if nil == res then
    return false
  elseif 'string' == type(res) then
    return 0 < #res
  elseif ('table' == type(res)) and (nil ~= (res)[1]) then
    return 0 < #(res)
  elseif ('table' == type(res)) and (nil == (res)[1]) then
    for k, v in  pairs(res) do
      return true
    end
    return false
  else
    error('Invalid type.')
  end
end

-- xt.lang.base-lib/is-empty? [317] 
local function is_emptyp(res)
  if nil == res then
    return true
  elseif 'string' == type(res) then
    return 0 == #res
  elseif ('table' == type(res)) and (nil ~= (res)[1]) then
    return 0 == #(res)
  elseif ('table' == type(res)) and (nil == (res)[1]) then
    for k, v in  pairs(res) do
      return false
    end
    return true
  else
    error('Invalid type.')
  end
end

-- xt.lang.base-lib/arr-lookup [332] 
local function arr_lookup(arr)
  local out = {}
  for _, k in  ipairs(arr) do
    out[k] = true
  end
  return out
end

-- xt.lang.base-lib/arr-every [341] 
local function arr_every(arr,pred)
  for i, v in  ipairs(arr) do
    if not pred(v) then
      return false
    end
  end
  return true
end

-- xt.lang.base-lib/arr-some [350] 
local function arr_some(arr,pred)
  for i, v in  ipairs(arr) do
    if pred(v) then
      return true
    end
  end
  return false
end

-- xt.lang.base-lib/arr-each [359] 
local function arr_each(arr,f)
  for _, e in  ipairs(arr) do
    f(e)
  end
  return true
end

-- xt.lang.base-lib/arr-reverse [366] 
local function arr_reverse(arr)
  local out = {}
  for i = #arr,1,-1 do
    table.insert(out,arr[i])
  end
  return out
end

-- xt.lang.base-lib/arr-zip [377] 
local function arr_zip(ks,vs)
  local out = {}
  for i, k in  ipairs(ks) do
    out[k] = vs[i]
  end
  return out
end

-- xt.lang.base-lib/arr-map [386] 
local function arr_map(arr,f)
  local out = {}
  for _, e in  ipairs(arr) do
    table.insert(out,f(e))
  end
  return out
end

-- xt.lang.base-lib/arr-clone [395] 
local function arr_clone(arr)
  local out = {}
  for _, e in  ipairs(arr) do
    table.insert(out,e)
  end
  return out
end

-- xt.lang.base-lib/arr-append [404] 
local function arr_append(arr,other)
  for _, e in  ipairs(other) do
    table.insert(arr,e)
  end
  return arr
end

-- xt.lang.base-lib/arr-slice [412] 
local function arr_slice(arr,start,finish)
  local out = {}
  for i = start + 1,finish,1 do
    table.insert(out,arr[i])
  end
  return out
end

-- xt.lang.base-lib/arr-rslice [421] 
local function arr_rslice(arr,start,finish)
  local out = {}
  for i = start + 1,finish,1 do
    table.insert(out,1,arr[i])
  end
  return out
end

-- xt.lang.base-lib/arr-tail [430] 
local function arr_tail(arr,n)
  local t = #(arr)
  return arr_rslice(arr,math.max(t - n,0),t)
end

-- xt.lang.base-lib/arr-mapcat [437] 
local function arr_mapcat(arr,f)
  local out = {}
  for _, e in  ipairs(arr) do
    local res = f(e)
    if nil ~= res then
      for _, v in  ipairs(res) do
        table.insert(out,v)
      end
    end
  end
  return out
end

-- xt.lang.base-lib/arr-partition [449] 
local function arr_partition(arr,n)
  local out = {}
  local i = 0
  local sarr = {}
  for _, e in  ipairs(arr) do
    if i == n then
      table.insert(out,sarr)
      i = 0
      sarr = {}
    end
    table.insert(sarr,e)
    i = (i + 1)
  end
  if 0 < #sarr then
    table.insert(out,sarr)
  end
  return out
end

-- xt.lang.base-lib/arr-filter [467] 
local function arr_filter(arr,pred)
  local out = {}
  for _, e in  ipairs(arr) do
    if pred(e) then
      table.insert(out,e)
    end
  end
  return out
end

-- xt.lang.base-lib/arr-keep [477] 
local function arr_keep(arr,f)
  local out = {}
  for _, e in  ipairs(arr) do
    local v = f(e)
    if nil ~= v then
      table.insert(out,v)
    end
  end
  return out
end

-- xt.lang.base-lib/arr-keepf [488] 
local function arr_keepf(arr,pred,f)
  local out = {}
  for _, e in  ipairs(arr) do
    if pred(e) then
      table.insert(out,f(e))
    end
  end
  return out
end

-- xt.lang.base-lib/arr-juxt [498] 
local function arr_juxt(arr,key_fn,val_fn)
  local out = {}
  for _, e in  ipairs(arr) do
    out[key_fn(e)] = val_fn(e)
  end
  return out
end

-- xt.lang.base-lib/arr-foldl [508] 
local function arr_foldl(arr,f,init)
  local out = init
  for _, e in  ipairs(arr) do
    out = f(out,e)
  end
  return out
end

-- xt.lang.base-lib/arr-foldr [517] 
local function arr_foldr(arr,f,init)
  local out = init
  for i = #arr,1,-1 do
    out = f(out,arr[i])
  end
  return out
end

-- xt.lang.base-lib/arr-pipel [528] 
local function arr_pipel(arr,e)
  return arr_foldl(arr,step_thrush,e)
end

-- xt.lang.base-lib/arr-piper [534] 
local function arr_piper(arr,e)
  return arr_foldr(arr,step_thrush,e)
end

-- xt.lang.base-lib/arr-group-by [540] 
local function arr_group_by(arr,key_fn,view_fn)
  local out = {}
  for _, e in  ipairs(arr) do
    local g = key_fn(e)
    local garr = out[g] or {}
    out[g] = {}
    table.insert(garr,view_fn(e))
    out[g] = garr
  end
  return out
end

-- xt.lang.base-lib/arr-range [553] 
local function arr_range(x)
  local arr = (('table' == type(x)) and (nil ~= (x)[1])) and x or {x}
  local arrlen = #arr
  local start = (1 < arrlen) and arr[1] or 0
  local finish = (1 < arrlen) and arr[2] or arr[1]
  local step = (2 < arrlen) and arr[3] or 1
  local out = {start}
  local i = step + start
  if (0 < step) and (start < finish) then
    while i < finish do
      table.insert(out,i)
      i = (i + step)
    end
  elseif (0 > step) and (finish < start) then
    while i > finish do
      table.insert(out,i)
      i = (i + step)
    end
  else
    return {}
  end
  return out
end

-- xt.lang.base-lib/arr-intersection [579] 
local function arr_intersection(arr,other)
  local lu = {}
  for _, k in  ipairs(arr) do
    lu[k] = true
  end
  local out = {}
  for _, e in  ipairs(other) do
    if lu[e] ~= nil then
      table.insert(out,e)
    end
  end
  return out
end

-- xt.lang.base-lib/arr-difference [590] 
local function arr_difference(arr,other)
  local lu = {}
  for _, k in  ipairs(arr) do
    lu[k] = true
  end
  local out = {}
  for _, e in  ipairs(other) do
    if not (lu[e] ~= nil) then
      table.insert(out,e)
    end
  end
  return out
end

-- xt.lang.base-lib/arr-union [601] 
local function arr_union(arr,other)
  local lu = {}
  for _, e in  ipairs(arr) do
    lu[e] = e
  end
  for _, e in  ipairs(other) do
    lu[e] = e
  end
  local out = {}
  for _, v in  pairs(lu) do
    table.insert(out,v)
  end
  return out
end

-- xt.lang.base-lib/arr-sort [616] 
local function arr_sort(arr,key_fn,comp_fn)
  local out = {unpack(arr)}
  table.sort(out,function (a,b)
    return comp_fn(key_fn(a),key_fn(b))
  end)
  return out
end

-- xt.lang.base-lib/arr-shuffle [624] 
local function arr_shuffle(arr)
  local tmp_val = nil
  local tmp_idx = nil
  local total = #(arr)
  for i = 1,total,1 do
    tmp_idx = (1 + math.floor(math.random() * total))
    tmp_val = arr[tmp_idx]
    arr[tmp_idx] = arr[i]
    arr[i] = tmp_val
  end
  return arr
end

-- xt.lang.base-lib/arr-pushl [638] 
local function arr_pushl(arr,v,n)
  table.insert(arr,v)
  if #arr > n then
    table.remove(arr,1)
  end
  return arr
end

-- xt.lang.base-lib/arr-pushr [647] 
local function arr_pushr(arr,v,n)
  table.insert(arr,1,v)
  if #arr > n then
    table.remove(arr)
  end
  return arr
end

-- xt.lang.base-lib/arr-join [656] 
local function arr_join(arr,s)
  return table.concat(arr,s)
end

-- xt.lang.base-lib/arr-repeat [662] 
local function arr_repeat(x,n)
  local out = {}
  for i = 0,n - 1,1 do
    table.insert(out,('function' == type(x)) and x() or x)
  end
  return out
end

-- xt.lang.base-lib/arr-random [673] 
local function arr_random(arr)
  local idx = math.floor(#arr * math.random())
  return arr[idx + 1]
end

-- xt.lang.base-lib/obj-empty? [684] 
local function obj_emptyp(obj)
  for k, _ in  pairs(obj) do
    return false
  end
  return true
end

-- xt.lang.base-lib/obj-not-empty? [692] 
local function obj_not_emptyp(obj)
  for k, _ in  pairs(obj) do
    return true
  end
  return false
end

-- xt.lang.base-lib/obj-first-key [700] 
local function obj_first_key(obj)
  for k, _ in  pairs(obj) do
    return k
  end
  return nil
end

-- xt.lang.base-lib/obj-first-val [708] 
local function obj_first_val(obj)
  for _, v in  pairs(obj) do
    return v
  end
  return nil
end

-- xt.lang.base-lib/obj-keys [716] 
local function obj_keys(obj)
  local out = {}
  for k, _ in  pairs(obj) do
    table.insert(out,k)
  end
  return out
end

-- xt.lang.base-lib/obj-vals [725] 
local function obj_vals(obj)
  local out = {}
  for _, v in  pairs(obj) do
    table.insert(out,v)
  end
  return out
end

-- xt.lang.base-lib/obj-pairs [734] 
local function obj_pairs(obj)
  local out = {}
  for k, v in  pairs(obj) do
    table.insert(out,{k,v})
  end
  return out
end

-- xt.lang.base-lib/obj-clone [743] 
local function obj_clone(obj)
  local out = {}
  for k, v in  pairs(obj) do
    out[k] = v
  end
  return out
end

-- xt.lang.base-lib/obj-assign [752] 
local function obj_assign(obj,m)
  if nil ~= m then
    for k, v in  pairs(m) do
      obj[k] = v
    end
  end
  return obj
end

-- xt.lang.base-lib/obj-assign-nested [761] 
local function obj_assign_nested(obj,m)
  if nil ~= m then
    for k, mv in  pairs(m) do
      local v = obj[k]
      if (('table' == type(mv)) and (nil == (mv)[1])) and (('table' == type(v)) and (nil == (v)[1])) then
        obj[k] = obj_assign_nested(v,mv)
      else
        obj[k] = mv
      end
    end
  end
  return obj
end

-- xt.lang.base-lib/obj-assign-with [776] 
local function obj_assign_with(obj,m,f)
  if nil ~= m then
    local input = m or {}
    for k, mv in  pairs(input) do
      obj[k] = ((obj[k] ~= nil) and f(obj[k],mv) or mv)
    end
  end
  return obj
end

-- xt.lang.base-lib/obj-from-pairs [790] 
local function obj_from_pairs(pairs)
  local out = {}
  for _, pair in  ipairs(pairs) do
    out[pair[1]] = pair[2]
  end
  return out
end

-- xt.lang.base-lib/obj-del [801] 
local function obj_del(obj,ks)
  for _, k in  ipairs(ks) do
    obj[k] = nil
  end
  return obj
end

-- xt.lang.base-lib/obj-del-all [809] 
local function obj_del_all(obj)
  for _, k in  ipairs(obj_keys(obj)) do
    obj[k] = nil
  end
  return obj
end

-- xt.lang.base-lib/obj-pick [818] 
local function obj_pick(obj,ks)
  local out = {}
  for _, k in  ipairs(ks) do
    local v = obj[k]
    if nil ~= v then
      out[k] = v
    end
  end
  return out
end

-- xt.lang.base-lib/obj-omit [829] 
local function obj_omit(obj,ks)
  local out = {}
  local lu = {}
  for _, k in  ipairs(ks) do
    lu[k] = true
  end
  for k, v in  pairs(obj) do
    if not (lu[k] ~= nil) then
      out[k] = v
    end
  end
  return out
end

-- xt.lang.base-lib/obj-transpose [842] 
local function obj_transpose(obj)
  local out = {}
  for k, v in  pairs(obj) do
    out[v] = k
  end
  return out
end

-- xt.lang.base-lib/obj-nest [851] 
local function obj_nest(arr,v)
  local idx = #arr
  local out = v
  while true do
    if idx == 0 then
      return out
    end
    local nested = {}
    local k = arr[idx]
    nested[k] = out
    out = nested
    idx = (idx - 1)
  end
end

-- xt.lang.base-lib/obj-map [866] 
local function obj_map(obj,f)
  local out = {}
  for k, v in  pairs(obj) do
    out[k] = f(v)
  end
  return out
end

-- xt.lang.base-lib/obj-filter [875] 
local function obj_filter(obj,pred)
  local out = {}
  for k, v in  pairs(obj) do
    if pred(v) then
      out[k] = v
    end
  end
  return out
end

-- xt.lang.base-lib/obj-keep [885] 
local function obj_keep(obj,f)
  local out = {}
  for k, e in  pairs(obj) do
    local v = f(e)
    if nil ~= v then
      out[k] = v
    end
  end
  return out
end

-- xt.lang.base-lib/obj-keepf [896] 
local function obj_keepf(obj,pred,f)
  local out = {}
  for k, e in  pairs(obj) do
    if pred(e) then
      out[k] = f(e)
    end
  end
  return out
end

-- xt.lang.base-lib/obj-intersection [906] 
local function obj_intersection(obj,other)
  local out = {}
  for k, _ in  pairs(other) do
    if obj[k] ~= nil then
      table.insert(out,k)
    end
  end
  return out
end

-- xt.lang.base-lib/obj-difference [916] 
local function obj_difference(obj,other)
  local out = {}
  for k, _ in  pairs(other) do
    if not (obj[k] ~= nil) then
      table.insert(out,k)
    end
  end
  return out
end

-- xt.lang.base-lib/to-flat [930] 
local function to_flat(obj)
  local out = {}
  if ('table' == type(obj)) and (nil == (obj)[1]) then
    for k, v in  pairs(obj) do
      table.insert(out,k)
      table.insert(out,v)
    end
  elseif ('table' == type(obj)) and (nil ~= (obj)[1]) then
    for _, e in  ipairs(obj) do
      table.insert(out,e[1])
      table.insert(out,e[2])
    end
  end
  return out
end

-- xt.lang.base-lib/from-flat [946] 
local function from_flat(arr,f,init)
  local out = init
  local k = nil
  for i, e in  ipairs(arr) do
    if 0 == ((i + 1) % 2) then
      k = e
    else
      out = f(out,k,e)
    end
  end
  return out
end

-- xt.lang.base-lib/get-in [958] 
local function get_in(obj,arr)
  if nil == obj then
    return nil
  elseif 0 == #arr then
    return obj
  elseif 1 == #arr then
    return obj[arr[1]]
  else
    local total = #arr
    local i = 0
    local curr = obj
    while i < total do
      local k = arr[i + 1]
      curr = curr[k]
      if nil == curr then
        return nil
      else
        i = (i + 1)
      end
    end
    return curr
  end
end

-- xt.lang.base-lib/set-in [983] 
local function set_in(obj,arr,v)
  if 0 == #(arr or {}) then
    return obj
  elseif not (('table' == type(obj)) and (nil == (obj)[1])) then
    return obj_nest(arr,v)
  else
    local k = arr[1]
    local narr = {unpack(arr)}
    table.remove(narr,1)
    local child = obj[k]
    if 0 == #narr then
      obj[k] = v
    else
      obj[k] = set_in(child,narr,v)
    end
    return obj
  end
end

-- xt.lang.base-lib/memoize-key [1003] 
local function memoize_key(f)
  local cache = {}
  local function cache_fn(key)
    local res = f(key)
    cache[key] = res
    return res
  end
  return function (key)
    return cache[key] or cache_fn(key)
  end
end

-- xt.lang.base-lib/eq-nested-loop [1020] 
local function eq_nested_loop(src,dst,eq_obj,eq_arr,cache)
  if (('table' == type(src)) and (nil == (src)[1])) and (('table' == type(dst)) and (nil == (dst)[1])) then
    if cache and cache[tostring(src)] and cache[tostring(dst)] then
      return true
    else
      return eq_obj(src,dst,eq_obj,eq_arr,cache or {})
    end
  elseif (('table' == type(src)) and (nil ~= (src)[1])) and (('table' == type(dst)) and (nil ~= (dst)[1])) then
    if cache and cache[tostring(src)] and cache[tostring(dst)] then
      return true
    else
      return eq_arr(src,dst,eq_obj,eq_arr,cache or {})
    end
  else
    return src == dst
  end
end

-- xt.lang.base-lib/eq-nested-obj [1041] 
local function eq_nested_obj(src,dst,eq_obj,eq_arr,cache)
  cache[tostring(src)] = src
  cache[tostring(dst)] = dst
  local ks_src = obj_keys(src)
  local ks_dst = obj_keys(dst)
  if #ks_src ~= #ks_dst then
    return false
  end
  for _, k in  ipairs(ks_src) do
    if not eq_nested_loop(src[k],dst[k],eq_obj,eq_arr,cache) then
      return false
    end
  end
  return true
end

-- xt.lang.base-lib/eq-nested-arr [1060] 
local function eq_nested_arr(src_arr,dst_arr,eq_obj,eq_arr,cache)
  cache[tostring(src_arr)] = src_arr
  cache[tostring(dst_arr)] = dst_arr
  if #src_arr ~= #dst_arr then
    return false
  end
  for i, v in  ipairs(src_arr) do
    if not eq_nested_loop(v,dst_arr[i],eq_obj,eq_arr,cache) then
      return false
    end
  end
  return true
end

-- xt.lang.base-lib/eq-nested [1077] 
local function eq_nested(obj,m)
  return eq_nested_loop(obj,m,eq_nested_obj,eq_nested_arr,nil)
end

-- xt.lang.base-lib/obj-diff [1087] 
local function obj_diff(obj,m)
  if nil == m then
    return {}
  end
  if nil == obj then
    return m
  end
  local out = {}
  for k, v in  pairs(m) do
    if not eq_nested(obj[k],m[k]) then
      out[k] = v
    end
  end
  return out
end

-- xt.lang.base-lib/obj-diff-nested [1100] 
local function obj_diff_nested(obj,m)
  if nil == m then
    return {}
  end
  if nil == obj then
    return m
  end
  local out = {}
  local ks = obj_keys(m)
  for _, k in  ipairs(ks) do
    local v = obj[k]
    local mv = m[k]
    if (('table' == type(v)) and (nil == (v)[1])) and (('table' == type(mv)) and (nil == (mv)[1])) then
      local dv = obj_diff_nested(v,mv)
      if obj_not_emptyp(dv) then
        out[k] = dv
      end
    elseif not eq_nested(v,mv) then
      out[k] = mv
    end
  end
  return out
end

-- xt.lang.base-lib/sort [1119] 
local function sort(arr)
  return arr_sort(arr,function (x)
    return x
  end,function (a,b)
    return a < b
  end)
end

-- xt.lang.base-lib/sort-edges-build [1125] 
local function sort_edges_build(nodes,edge)
  local n_from = edge[1]
  local n_to = edge[2]
  if not (nodes[n_from] ~= nil) then
    nodes[n_from] = {id=n_from,links={}}
  end
  if not (nodes[n_to] ~= nil) then
    nodes[n_to] = {id=n_to,links={}}
  end
  local links = nodes[n_from]['links']
  table.insert(links,n_to)
end

-- xt.lang.base-lib/sort-edges-visit [1140] 
local function sort_edges_visit(nodes,visited,sorted,id,ancestors)
  if visited[id] then
    return
  end
  local node = nodes[id]
  if not node then
    error('Not available: ' .. id)
  end
  ancestors = (ancestors or {})
  table.insert(ancestors,id)
  visited[id] = true
  local input = node['links']
  for _, aid in  ipairs(input) do
    sort_edges_visit(nodes,visited,sorted,aid,{unpack(ancestors)})
  end
  table.insert(sorted,1,id)
end

-- xt.lang.base-lib/sort-edges [1157] 
local function sort_edges(edges)
  local nodes = {}
  local sorted = {}
  local visited = {}
  for _, e in  ipairs(edges) do
    sort_edges_build(nodes,e)
  end
  for id, _ in  pairs(nodes) do
    sort_edges_visit(nodes,visited,sorted,id,nil)
  end
  return sorted
end

-- xt.lang.base-lib/sort-topo [1170] 
local function sort_topo(input)
  local edges = {}
  for _, link in  ipairs(input) do
    local root = link[1]
    local deps = link[2]
    for _, d in  ipairs(deps) do
      table.insert(edges,{root,d})
    end
  end
  return arr_reverse(sort_edges(edges))
end

-- xt.lang.base-lib/clone-nested-loop [1183] 
local function clone_nested_loop(obj,cache)
  if nil == obj then
    return obj
  end
  local cached_output = cache[tostring(obj)]
  if cached_output then
    return cached_output
  elseif ('table' == type(obj)) and (nil == (obj)[1]) then
    local out = {}
    cache[tostring(obj)] = out
    for k, v in  pairs(obj) do
      out[k] = clone_nested_loop(v,cache)
    end
    return out
  elseif ('table' == type(obj)) and (nil ~= (obj)[1]) then
    local out = {}
    cache[tostring(obj)] = out
    for _, e in  ipairs(obj) do
      table.insert(out,clone_nested_loop(e,cache))
    end
    return out
  else
    return obj
  end
end

-- xt.lang.base-lib/clone-nested [1210] 
local function clone_nested(obj)
  if not ((('table' == type(obj)) and (nil == (obj)[1])) or (('table' == type(obj)) and (nil ~= (obj)[1]))) then
    return obj
  else
    return clone_nested_loop(obj,{})
  end
end

-- xt.lang.base-lib/get-spec-loop [1221] 
local function get_spec_loop(obj,path,cache)
  local cached_path = cache[tostring(obj)]
  local function inner_fn(k)
    table.insert({unpack(path)},k)
    local npath = {unpack(path)}
    return get_spec_loop(obj[k],npath,cache)
  end
  if cached_path then
    return {'<ref>',cached_path}
  elseif nil == obj then
    return obj
  elseif ('table' == type(obj)) and (nil == (obj)[1]) then
    cache[tostring(obj)] = path
    return arr_juxt(obj_keys(obj),function (x)
      return x
    end,inner_fn)
  else
    return type(obj)
  end
end

-- xt.lang.base-lib/get-spec [1248] 
local function get_spec(obj)
  if not ((('table' == type(obj)) and (nil == (obj)[1])) or (('table' == type(obj)) and (nil ~= (obj)[1]))) then
    return obj
  else
    return get_spec_loop(obj,{},{})
  end
end

-- xt.lang.base-lib/wrap-callback [1257] 
local function wrap_callback(callbacks,key)
  callbacks = (callbacks or {})
  local function result_fn(result)
    local f = callbacks[key]
    if nil ~= f then
      return f(result)
    else
      return result
    end
  end
  return result_fn
end

-- xt.lang.base-lib/walk [1270] 
local function walk(obj,pre_fn,post_fn)
  obj = pre_fn(obj)
  if nil == obj then
    return post_fn(obj)
  elseif ('table' == type(obj)) and (nil == (obj)[1]) then
    local out = {}
    for k, v in  pairs(obj) do
      out[k] = walk(v,pre_fn,post_fn)
    end
    return post_fn(out)
  elseif ('table' == type(obj)) and (nil ~= (obj)[1]) then
    local out = {}
    for _, e in  ipairs(obj) do
      table.insert(out,walk(e,pre_fn,post_fn))
    end
    return post_fn(out)
  else
    return post_fn(obj)
  end
end

-- xt.lang.base-lib/split-long [1298] 
local function split_long(s,lineLen)
  if is_emptyp(s) then
    return ''
  end
  lineLen = (lineLen or 50)
  local total = #(s)
  local lines = math.ceil(total / lineLen)
  local out = {}
  for i = 0,lines,1 do
    local line = string.sub(s,(i * lineLen) + 1,(i + 1) * lineLen)
    if 0 < #line then
      table.insert(out,line)
    end
  end
  return out
end

-- xt.lang.base-lib/with-delay [1320] 
local function with_delay(thunk,ms)
  return ngx.thread.spawn(function ()
    ngx.sleep(ms / 1000)
    local f = thunk
    return f()
  end)
end

-- xt.lang.base-lib/trace-log [1330] 
local function trace_log()
  if TRACE ~= nil then
    return TRACE
  else
    TRACE = {}
    return TRACE
  end
end

-- xt.lang.base-lib/trace-log-clear [1339] 
local function trace_log_clear()
  TRACE = {}
  return TRACE
end

-- xt.lang.base-lib/trace-log-add [1346] 
local function trace_log_add(data,tag,opts)
  local log = trace_log()
  local m = obj_assign({tag=tag,data=data,time=math.floor(1000 * os.time())},opts)
  table.insert(log,m)
  return #log
end

-- xt.lang.base-lib/trace-filter [1359] 
local function trace_filter(tag)
  return arr_filter(trace_log(),function (e)
    return tag == e['tag']
  end)
end

-- xt.lang.base-lib/trace-last-entry [1365] 
local function trace_last_entry(tag)
  local log = trace_log()
  if nil == tag then
    return log[#log + 0]
  else
    local tagged = trace_filter(tag)
    return tagged[#tagged + 0]
  end
end

-- xt.lang.base-lib/trace-data [1375] 
local function trace_data(tag)
  return arr_map(trace_log(),function (e)
    return e['data']
  end)
end

-- xt.lang.base-lib/trace-last [1381] 
local function trace_last(tag)
  return (trace_last_entry(tag))['data']
end

-- xt.lang.base-lib/trace-run [1397] 
local function trace_run(f)
  trace_log_clear()
  f()
  return trace_log()
end

local MODULE = {
  type_native=type_native,
  type=type,
  key_fn=key_fn,
  inc_fn=inc_fn,
  step_nil=step_nil,
  step_thrush=step_thrush,
  step_call=step_call,
  step_push=step_push,
  step_set_key=step_set_key,
  step_set_fn=step_set_fn,
  step_set_pair=step_set_pair,
  step_del_key=step_del_key,
  starts_withp=starts_withp,
  ends_withp=ends_withp,
  capitalize=capitalize,
  decapitalize=decapitalize,
  pad_left=pad_left,
  pad_right=pad_right,
  pad_lines=pad_lines,
  mod_pos=mod_pos,
  mod_offset=mod_offset,
  gcd=gcd,
  lcm=lcm,
  mix=mix,
  sign=sign,
  round=round,
  sym_full=sym_full,
  sym_name=sym_name,
  sym_ns=sym_ns,
  sym_pair=sym_pair,
  not_emptyp=not_emptyp,
  is_emptyp=is_emptyp,
  arr_lookup=arr_lookup,
  arr_every=arr_every,
  arr_some=arr_some,
  arr_each=arr_each,
  arr_reverse=arr_reverse,
  arr_zip=arr_zip,
  arr_map=arr_map,
  arr_clone=arr_clone,
  arr_append=arr_append,
  arr_slice=arr_slice,
  arr_rslice=arr_rslice,
  arr_tail=arr_tail,
  arr_mapcat=arr_mapcat,
  arr_partition=arr_partition,
  arr_filter=arr_filter,
  arr_keep=arr_keep,
  arr_keepf=arr_keepf,
  arr_juxt=arr_juxt,
  arr_foldl=arr_foldl,
  arr_foldr=arr_foldr,
  arr_pipel=arr_pipel,
  arr_piper=arr_piper,
  arr_group_by=arr_group_by,
  arr_range=arr_range,
  arr_intersection=arr_intersection,
  arr_difference=arr_difference,
  arr_union=arr_union,
  arr_sort=arr_sort,
  arr_shuffle=arr_shuffle,
  arr_pushl=arr_pushl,
  arr_pushr=arr_pushr,
  arr_join=arr_join,
  arr_repeat=arr_repeat,
  arr_random=arr_random,
  obj_emptyp=obj_emptyp,
  obj_not_emptyp=obj_not_emptyp,
  obj_first_key=obj_first_key,
  obj_first_val=obj_first_val,
  obj_keys=obj_keys,
  obj_vals=obj_vals,
  obj_pairs=obj_pairs,
  obj_clone=obj_clone,
  obj_assign=obj_assign,
  obj_assign_nested=obj_assign_nested,
  obj_assign_with=obj_assign_with,
  obj_from_pairs=obj_from_pairs,
  obj_del=obj_del,
  obj_del_all=obj_del_all,
  obj_pick=obj_pick,
  obj_omit=obj_omit,
  obj_transpose=obj_transpose,
  obj_nest=obj_nest,
  obj_map=obj_map,
  obj_filter=obj_filter,
  obj_keep=obj_keep,
  obj_keepf=obj_keepf,
  obj_intersection=obj_intersection,
  obj_difference=obj_difference,
  to_flat=to_flat,
  from_flat=from_flat,
  get_in=get_in,
  set_in=set_in,
  memoize_key=memoize_key,
  eq_nested_loop=eq_nested_loop,
  eq_nested_obj=eq_nested_obj,
  eq_nested_arr=eq_nested_arr,
  eq_nested=eq_nested,
  obj_diff=obj_diff,
  obj_diff_nested=obj_diff_nested,
  sort=sort,
  sort_edges_build=sort_edges_build,
  sort_edges_visit=sort_edges_visit,
  sort_edges=sort_edges,
  sort_topo=sort_topo,
  clone_nested_loop=clone_nested_loop,
  clone_nested=clone_nested,
  get_spec_loop=get_spec_loop,
  get_spec=get_spec,
  wrap_callback=wrap_callback,
  walk=walk,
  split_long=split_long,
  with_delay=with_delay,
  trace_log=trace_log,
  trace_log_clear=trace_log_clear,
  trace_log_add=trace_log_add,
  trace_filter=trace_filter,
  trace_last_entry=trace_last_entry,
  trace_data=trace_data,
  trace_last=trace_last,
  trace_run=trace_run
}

return MODULE