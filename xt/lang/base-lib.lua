-- xt.lang.base-lib/proto-create [20] 
local function proto_create(m)
  local mt = m
  mt.__index = mt
  return mt
end

-- xt.lang.base-lib/type-native [26] 
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

-- xt.lang.base-lib/type-class [32] 
local function type_class(x)
  local ntype = type_native(x)
  if ntype == 'object' then
    return x['::'] or ntype
  else
    return ntype
  end
end

-- xt.lang.base-lib/fn? [41] 
local function fnp(x)
  return 'function' == type(x)
end

-- xt.lang.base-lib/arr? [48] 
local function arrp(x)
  return (('table' == type(x)) and (nil ~= (x)[1])) or ('array' == type(x))
end

-- xt.lang.base-lib/obj? [55] 
local function objp(x)
  return (('table' == type(x)) and (nil == (x)[1])) or ('object' == type(x))
end

-- xt.lang.base-lib/id-fn [62] 
local function id_fn(x)
  return x['id']
end

-- xt.lang.base-lib/key-fn [69] 
local function key_fn(k)
  return function (x)
    return x[k]
  end
end

-- xt.lang.base-lib/eq-fn [76] 
local function eq_fn(k,v)
  return function (x)
    return fnp(v) and v(x[k]) or (v == x[k])
  end
end

-- xt.lang.base-lib/inc-fn [86] 
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

-- xt.lang.base-lib/identity [101] 
local function identity(x)
  return x
end

-- xt.lang.base-lib/noop [107] 
local function noop()
  return nil
end

-- xt.lang.base-lib/T [113] 
local function T(x)
  return true
end

-- xt.lang.base-lib/F [119] 
local function F(x)
  return false
end

-- xt.lang.base-lib/step-nil [130] 
local function step_nil(obj,pair)
  return nil
end

-- xt.lang.base-lib/step-thrush [136] 
local function step_thrush(x,f)
  return f(x)
end

-- xt.lang.base-lib/step-call [142] 
local function step_call(f,x)
  return f(x)
end

-- xt.lang.base-lib/step-push [148] 
local function step_push(arr,e)
  table.insert(arr,e)
  return arr
end

-- xt.lang.base-lib/step-set-key [155] 
local function step_set_key(obj,k,v)
  obj[k] = v
  return obj
end

-- xt.lang.base-lib/step-set-fn [162] 
local function step_set_fn(obj,k)
  return function (v)
    return step_set_key(obj,k,v)
  end
end

-- xt.lang.base-lib/step-set-pair [168] 
local function step_set_pair(obj,e)
  obj[e[1]] = e[2]
  return obj
end

-- xt.lang.base-lib/step-del-key [177] 
local function step_del_key(obj,k)
  obj[k] = nil
  return obj
end

-- xt.lang.base-lib/starts-with? [189] 
local function starts_withp(s,match)
  return string.sub(s,1,#match) == match
end

-- xt.lang.base-lib/ends-with? [198] 
local function ends_withp(s,match)
  return match == string.sub(s,(#s - #match) + 1,#s)
end

-- xt.lang.base-lib/capitalize [210] 
local function capitalize(s)
  return string.upper(string.sub(s,1,1)) .. string.sub(s,2)
end

-- xt.lang.base-lib/decapitalize [221] 
local function decapitalize(s)
  return string.lower(string.sub(s,1,1)) .. string.sub(s,2)
end

-- xt.lang.base-lib/pad-left [232] 
local function pad_left(s,n,ch)
  local l = n - (#s + 1)
  local out = s
  for i = 0,l,1 do
    out = (ch .. out)
  end
  return out
end

-- xt.lang.base-lib/pad-right [242] 
local function pad_right(s,n,ch)
  local l = n - (#s + 1)
  local out = s
  for i = 0,l,1 do
    out = (out .. ch)
  end
  return out
end

-- xt.lang.base-lib/pad-lines [252] 
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

-- xt.lang.base-lib/mod-pos [269] 
local function mod_pos(val,modulo)
  local out = val % modulo
  return (out < 0) and (out + modulo) or out
end

-- xt.lang.base-lib/mod-offset [278] 
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

-- xt.lang.base-lib/gcd [294] 
local function gcd(a,b)
  return (0 == b) and a or gcd(b,a % b)
end

-- xt.lang.base-lib/lcm [302] 
local function lcm(a,b)
  return (a * b) / gcd(a,b)
end

-- xt.lang.base-lib/mix [309] 
local function mix(x0,x1,v,f)
  if nil == f then
    f = identity
  end
  return x0 + ((x1 - x0) * f(v))
end

-- xt.lang.base-lib/sign [318] 
local function sign(x)
  if x == 0 then
    return 0
  elseif x < 0 then
    return -1
  else
    return 1
  end
end

-- xt.lang.base-lib/round [326] 
local function round(x)
  return math.floor(x + 0.5)
end

-- xt.lang.base-lib/clamp [332] 
local function clamp(min,max,v)
  if v < min then
    return min
  elseif max < v then
    return max
  else
    return v
  end
end

-- xt.lang.base-lib/bit-count [345] 
local function bit_count(x)
  local v0 = x - bit.band(bit.rshift(x,1),0x55555555)
  local v1 = bit.band(v0,0x33333333) + bit.band(bit.rshift(v0,2),0x33333333)
  return bit.rshift(bit.band(v1 + bit.rshift(v1,4),0xF0F0F0F) * 0x1010101,24)
end

-- xt.lang.base-lib/sym-full [364] 
local function sym_full(ns,name)
  if nil == ns then
    return name
  else
    return ns .. '/' .. name
  end
end

-- xt.lang.base-lib/sym-name [372] 
local function sym_name(sym)
  local idx = string.find(sym,'/') or -1
  return string.sub(sym,(idx - 0) + 1)
end

-- xt.lang.base-lib/sym-ns [380] 
local function sym_ns(sym)
  local idx = string.find(sym,'/') or -1
  if 0 < idx then
    return string.sub(sym,0,idx - 1)
  else
    return nil
  end
end

-- xt.lang.base-lib/sym-pair [389] 
local function sym_pair(sym)
  return {sym_ns(sym),sym_name(sym)}
end

-- xt.lang.base-lib/is-empty? [400] 
local function is_emptyp(res)
  if nil == res then
    return true
  elseif 'string' == type(res) then
    return 0 == #res
  elseif arrp(res) then
    return 0 == #(res)
  elseif objp(res) then
    for k, v in  pairs(res) do
      return false
    end
    return true
  else
    error(
      'Invalid type - ' .. type_native(res) .. ' - ' .. tostring(res)
    )
  end
end

-- xt.lang.base-lib/arr-lookup [418] 
local function arr_lookup(arr)
  local out = {}
  for _, k in  ipairs(arr) do
    out[k] = true
  end
  return out
end

-- xt.lang.base-lib/arr-every [427] 
local function arr_every(arr,pred)
  for i, v in  ipairs(arr) do
    if not pred(v) then
      return false
    end
  end
  return true
end

-- xt.lang.base-lib/arr-some [436] 
local function arr_some(arr,pred)
  for i, v in  ipairs(arr) do
    if pred(v) then
      return true
    end
  end
  return false
end

-- xt.lang.base-lib/arr-each [445] 
local function arr_each(arr,f)
  for _, e in  ipairs(arr) do
    f(e)
  end
  return true
end

-- xt.lang.base-lib/arr-omit [452] 
local function arr_omit(arr,i)
  local out = {}
  for j, e in  ipairs(arr) do
    if (i + 1) ~= j then
      table.insert(out,e)
    end
  end
  return out
end

-- xt.lang.base-lib/arr-reverse [462] 
local function arr_reverse(arr)
  local out = {}
  for i = #arr,1,-1 do
    table.insert(out,arr[i])
  end
  return out
end

-- xt.lang.base-lib/arr-find [473] 
local function arr_find(arr,pred)
  for i, v in  ipairs(arr) do
    if pred(v) then
      return i - 1
    end
  end
  return -1
end

-- xt.lang.base-lib/arr-zip [482] 
local function arr_zip(ks,vs)
  local out = {}
  for i, k in  ipairs(ks) do
    out[k] = vs[i]
  end
  return out
end

-- xt.lang.base-lib/arr-map [491] 
local function arr_map(arr,f)
  local out = {}
  for _, e in  ipairs(arr) do
    table.insert(out,f(e))
  end
  return out
end

-- xt.lang.base-lib/arr-clone [500] 
local function arr_clone(arr)
  local out = {}
  for _, e in  ipairs(arr) do
    table.insert(out,e)
  end
  return out
end

-- xt.lang.base-lib/arr-append [509] 
local function arr_append(arr,other)
  for _, e in  ipairs(other) do
    table.insert(arr,e)
  end
  return arr
end

-- xt.lang.base-lib/arr-slice [517] 
local function arr_slice(arr,start,finish)
  local out = {}
  for i = start + 1,finish,1 do
    table.insert(out,arr[i])
  end
  return out
end

-- xt.lang.base-lib/arr-rslice [526] 
local function arr_rslice(arr,start,finish)
  local out = {}
  for i = start + 1,finish,1 do
    table.insert(out,1,arr[i])
  end
  return out
end

-- xt.lang.base-lib/arr-tail [535] 
local function arr_tail(arr,n)
  local t = #(arr)
  return arr_rslice(arr,math.max(t - n,0),t)
end

-- xt.lang.base-lib/arr-mapcat [542] 
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

-- xt.lang.base-lib/arr-partition [554] 
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

-- xt.lang.base-lib/arr-filter [572] 
local function arr_filter(arr,pred)
  local out = {}
  for _, e in  ipairs(arr) do
    if pred(e) then
      table.insert(out,e)
    end
  end
  return out
end

-- xt.lang.base-lib/arr-keep [582] 
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

-- xt.lang.base-lib/arr-keepf [593] 
local function arr_keepf(arr,pred,f)
  local out = {}
  for _, e in  ipairs(arr) do
    if pred(e) then
      table.insert(out,f(e))
    end
  end
  return out
end

-- xt.lang.base-lib/arr-juxt [603] 
local function arr_juxt(arr,key_fn,val_fn)
  local out = {}
  if nil ~= arr then
    for _, e in  ipairs(arr) do
      out[key_fn(e)] = val_fn(e)
    end
  end
  return out
end

-- xt.lang.base-lib/arr-foldl [614] 
local function arr_foldl(arr,f,init)
  local out = init
  for _, e in  ipairs(arr) do
    out = f(out,e)
  end
  return out
end

-- xt.lang.base-lib/arr-foldr [623] 
local function arr_foldr(arr,f,init)
  local out = init
  for i = #arr,1,-1 do
    out = f(out,arr[i])
  end
  return out
end

-- xt.lang.base-lib/arr-pipel [634] 
local function arr_pipel(arr,e)
  return arr_foldl(arr,step_thrush,e)
end

-- xt.lang.base-lib/arr-piper [640] 
local function arr_piper(arr,e)
  return arr_foldr(arr,step_thrush,e)
end

-- xt.lang.base-lib/arr-group-by [646] 
local function arr_group_by(arr,key_fn,view_fn)
  local out = {}
  if nil ~= arr then
    for _, e in  ipairs(arr) do
      local g = key_fn(e)
      local garr = out[g] or {}
      out[g] = {}
      table.insert(garr,view_fn(e))
      out[g] = garr
    end
  end
  return out
end

-- xt.lang.base-lib/arr-range [660] 
local function arr_range(x)
  local arr = ((('table' == type(x)) and (nil ~= (x)[1])) or ('array' == type(x))) and x or {x}
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

-- xt.lang.base-lib/arr-intersection [686] 
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

-- xt.lang.base-lib/arr-difference [697] 
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

-- xt.lang.base-lib/arr-union [708] 
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

-- xt.lang.base-lib/arr-sort [723] 
local function arr_sort(arr,key_fn,comp_fn)
  local out = {unpack(arr)}
  table.sort(out,function (a,b)
    return comp_fn(key_fn(a),key_fn(b))
  end)
  return out
end

-- xt.lang.base-lib/arr-sorted-merge [731] 
local function arr_sorted_merge(arr,brr,comp_fn)
  arr = (arr or {})
  brr = (brr or {})
  local alen = #(arr)
  local blen = #(brr)
  local i = 0
  local j = 0
  local k = 0
  local out = {}
  while (i < alen) and (j < blen) do
    local aitem = arr[i + 1]
    local bitem = brr[j + 1]
    if comp_fn(aitem,bitem) then
      i = (i + 1)
      table.insert(out,aitem)
    else
      j = (j + 1)
      table.insert(out,bitem)
    end
  end
  while i < alen do
    local aitem = arr[i + 1]
    i = (i + 1)
    table.insert(out,aitem)
  end
  while j < blen do
    local bitem = brr[j + 1]
    j = (j + 1)
    table.insert(out,bitem)
  end
  return out
end

-- xt.lang.base-lib/arr-shuffle [766] 
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

-- xt.lang.base-lib/arr-pushl [780] 
local function arr_pushl(arr,v,n)
  table.insert(arr,v)
  if #arr > n then
    table.remove(arr,1)
  end
  return arr
end

-- xt.lang.base-lib/arr-pushr [789] 
local function arr_pushr(arr,v,n)
  table.insert(arr,1,v)
  if #arr > n then
    table.remove(arr)
  end
  return arr
end

-- xt.lang.base-lib/arr-join [798] 
local function arr_join(arr,s)
  return table.concat(arr,s)
end

-- xt.lang.base-lib/arr-interpose [804] 
local function arr_interpose(arr,elem)
  local out = {}
  for _, e in  ipairs(arr) do
    table.insert(out,e)
    table.insert(out,elem)
  end
  table.remove(out)
  return out
end

-- xt.lang.base-lib/arr-repeat [815] 
local function arr_repeat(x,n)
  local out = {}
  for i = 0,n - 1,1 do
    table.insert(out,('function' == type(x)) and x() or x)
  end
  return out
end

-- xt.lang.base-lib/arr-random [826] 
local function arr_random(arr)
  local idx = math.floor(#arr * math.random())
  return arr[idx + 1]
end

-- xt.lang.base-lib/arr-normalise [833] 
local function arr_normalise(arr)
  local total = arr_foldl(arr,function (a,b)
    return a + b
  end,0)
  return arr_map(arr,function (x)
    return x / total
  end)
end

-- xt.lang.base-lib/arr-sample [840] 
local function arr_sample(arr,dist)
  local q = math.random()
  for i, p in  ipairs(dist) do
    q = (q - p)
    if q < 0 then
      return arr[i]
    end
  end
end

-- xt.lang.base-lib/arrayify [850] 
local function arrayify(x)
  return ((('table' == type(x)) and (nil ~= (x)[1])) or ('array' == type(x))) and x or ((nil == x) and {} or {x})
end

-- xt.lang.base-lib/obj-empty? [867] 
local function obj_emptyp(obj)
  for k, _ in  pairs(obj) do
    return false
  end
  return true
end

-- xt.lang.base-lib/obj-not-empty? [875] 
local function obj_not_emptyp(obj)
  for k, _ in  pairs(obj) do
    return true
  end
  return false
end

-- xt.lang.base-lib/obj-first-key [883] 
local function obj_first_key(obj)
  for k, _ in  pairs(obj) do
    return k
  end
  return nil
end

-- xt.lang.base-lib/obj-first-val [891] 
local function obj_first_val(obj)
  for _, v in  pairs(obj) do
    return v
  end
  return nil
end

-- xt.lang.base-lib/obj-keys [899] 
local function obj_keys(obj)
  local out = {}
  if nil ~= obj then
    for k, _ in  pairs(obj) do
      table.insert(out,k)
    end
  end
  return out
end

-- xt.lang.base-lib/obj-vals [909] 
local function obj_vals(obj)
  local out = {}
  if nil ~= obj then
    for _, v in  pairs(obj) do
      table.insert(out,v)
    end
  end
  return out
end

-- xt.lang.base-lib/obj-pairs [919] 
local function obj_pairs(obj)
  local out = {}
  if nil ~= obj then
    for k, v in  pairs(obj) do
      table.insert(out,{k,v})
    end
  end
  return out
end

-- xt.lang.base-lib/obj-clone [929] 
local function obj_clone(obj)
  local out = {}
  if nil ~= obj then
    for k, v in  pairs(obj) do
      out[k] = v
    end
  end
  return out
end

-- xt.lang.base-lib/obj-assign [939] 
local function obj_assign(obj,m)
  if nil == obj then
    obj = {}
  end
  if nil ~= m then
    for k, v in  pairs(m) do
      obj[k] = v
    end
  end
  return obj
end

-- xt.lang.base-lib/obj-assign-nested [950] 
local function obj_assign_nested(obj,m)
  if nil == obj then
    obj = {}
  end
  if nil ~= m then
    for k, mv in  pairs(m) do
      local v = obj[k]
      if objp(mv) and objp(v) then
        obj[k] = obj_assign_nested(v,mv)
      else
        obj[k] = mv
      end
    end
  end
  return obj
end

-- xt.lang.base-lib/obj-assign-with [967] 
local function obj_assign_with(obj,m,f)
  if nil ~= m then
    local input = m or {}
    for k, mv in  pairs(input) do
      obj[k] = ((obj[k] ~= nil) and f(obj[k],mv) or mv)
    end
  end
  return obj
end

-- xt.lang.base-lib/obj-from-pairs [981] 
local function obj_from_pairs(pairs)
  local out = {}
  for _, pair in  ipairs(pairs) do
    out[pair[1]] = pair[2]
  end
  return out
end

-- xt.lang.base-lib/obj-del [992] 
local function obj_del(obj,ks)
  for _, k in  ipairs(ks) do
    obj[k] = nil
  end
  return obj
end

-- xt.lang.base-lib/obj-del-all [1000] 
local function obj_del_all(obj)
  for _, k in  ipairs(obj_keys(obj)) do
    obj[k] = nil
  end
  return obj
end

-- xt.lang.base-lib/obj-pick [1009] 
local function obj_pick(obj,ks)
  local out = {}
  if nil == obj then
    return out
  end
  for _, k in  ipairs(ks) do
    local v = obj[k]
    if nil ~= v then
      out[k] = v
    end
  end
  return out
end

-- xt.lang.base-lib/obj-omit [1022] 
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

-- xt.lang.base-lib/obj-transpose [1035] 
local function obj_transpose(obj)
  local out = {}
  if nil ~= obj then
    for k, v in  pairs(obj) do
      out[v] = k
    end
  end
  return out
end

-- xt.lang.base-lib/obj-nest [1045] 
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

-- xt.lang.base-lib/obj-map [1060] 
local function obj_map(obj,f)
  local out = {}
  if nil ~= obj then
    for k, v in  pairs(obj) do
      out[k] = f(v)
    end
  end
  return out
end

-- xt.lang.base-lib/obj-filter [1070] 
local function obj_filter(obj,pred)
  local out = {}
  if nil ~= obj then
    for k, v in  pairs(obj) do
      if pred(v) then
        out[k] = v
      end
    end
  end
  return out
end

-- xt.lang.base-lib/obj-keep [1081] 
local function obj_keep(obj,f)
  local out = {}
  if nil ~= obj then
    for k, e in  pairs(obj) do
      local v = f(e)
      if nil ~= v then
        out[k] = v
      end
    end
  end
  return out
end

-- xt.lang.base-lib/obj-keepf [1093] 
local function obj_keepf(obj,pred,f)
  local out = {}
  if nil ~= obj then
    for k, e in  pairs(obj) do
      if pred(e) then
        out[k] = f(e)
      end
    end
  end
  return out
end

-- xt.lang.base-lib/obj-intersection [1104] 
local function obj_intersection(obj,other)
  local out = {}
  for k, _ in  pairs(other) do
    if obj[k] ~= nil then
      table.insert(out,k)
    end
  end
  return out
end

-- xt.lang.base-lib/obj-difference [1114] 
local function obj_difference(obj,other)
  local out = {}
  for k, _ in  pairs(other) do
    if not (obj[k] ~= nil) then
      table.insert(out,k)
    end
  end
  return out
end

-- xt.lang.base-lib/obj-keys-nested [1124] 
local function obj_keys_nested(m,path)
  local out = {}
  for k, v in  pairs(m) do
    local npath = {unpack(path)}
    table.insert(npath,k)
    if objp(v) then
      for _, e in  ipairs(obj_keys_nested(v,npath)) do
        table.insert(out,e)
      end
    else
      table.insert(out,{npath,v})
    end
  end
  return out
end

-- xt.lang.base-lib/to-flat [1145] 
local function to_flat(obj)
  local out = {}
  if objp(obj) then
    for k, v in  pairs(obj) do
      table.insert(out,k)
      table.insert(out,v)
    end
  elseif arrp(obj) then
    for _, e in  ipairs(obj) do
      table.insert(out,e[1])
      table.insert(out,e[2])
    end
  end
  return out
end

-- xt.lang.base-lib/from-flat [1161] 
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

-- xt.lang.base-lib/get-in [1173] 
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

-- xt.lang.base-lib/set-in [1198] 
local function set_in(obj,arr,v)
  if 0 == #(arr or {}) then
    return obj
  elseif not objp(obj) then
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

-- xt.lang.base-lib/memoize-key [1218] 
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

-- xt.lang.base-lib/not-empty? [1231] 
local function not_emptyp(res)
  if nil == res then
    return false
  elseif 'string' == type(res) then
    return 0 < #res
  elseif arrp(res) then
    return 0 < #(res)
  elseif objp(res) then
    for i, v in  pairs(res) do
      return true
    end
    return false
  else
    error(
      'Invalid type - ' .. type_native(res) .. ' - ' .. tostring(res)
    )
  end
end

-- xt.lang.base-lib/eq-nested-loop [1253] 
local function eq_nested_loop(src,dst,eq_obj,eq_arr,cache)
  if objp(src) and objp(dst) then
    if cache and cache[tostring(src)] and cache[tostring(dst)] then
      return true
    else
      return eq_obj(
        src,
        dst,
        eq_obj,
        eq_arr,
        cache or setmetatable({},{['__mode']='k'})
      )
    end
  elseif arrp(src) and arrp(dst) then
    if cache and cache[tostring(src)] and cache[tostring(dst)] then
      return true
    else
      return eq_arr(
        src,
        dst,
        eq_obj,
        eq_arr,
        cache or setmetatable({},{['__mode']='k'})
      )
    end
  else
    return src == dst
  end
end

-- xt.lang.base-lib/eq-nested-obj [1274] 
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

-- xt.lang.base-lib/eq-nested-arr [1293] 
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

-- xt.lang.base-lib/eq-nested [1310] 
local function eq_nested(obj,m)
  return eq_nested_loop(obj,m,eq_nested_obj,eq_nested_arr,nil)
end

-- xt.lang.base-lib/obj-diff [1320] 
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

-- xt.lang.base-lib/obj-diff-nested [1333] 
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
    if objp(v) and objp(mv) then
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

-- xt.lang.base-lib/sort [1352] 
local function sort(arr)
  return arr_sort(arr,identity,function (a,b)
    return a < b
  end)
end

-- xt.lang.base-lib/objify [1358] 
local function objify(v)
  if 'string' == type(v) then
    return cjson.decode(v)
  else
    return v
  end
end

-- xt.lang.base-lib/template-entry [1367] 
local function template_entry(obj,template,props)
  if fnp(template) then
    return template(obj,props)
  elseif nil == template then
    return obj
  elseif arrp(template) then
    return get_in(obj,template)
  else
    return template
  end
end

-- xt.lang.base-lib/template-fn [1383] 
local function template_fn(template)
  return function (obj,props)
    return template_entry(obj,template,props)
  end
end

-- xt.lang.base-lib/template-multi [1389] 
local function template_multi(arr)
  local function template_fn(entry,props)
    for _, template in  ipairs(arr) do
      local out = template_entry(entry,template,props)
      if nil ~= out then
        return out
      end
    end
  end
  return template_fn
end

-- xt.lang.base-lib/sort-by [1401] 
local function sort_by(arr,inputs)
  local keys = arr_map(inputs,function (e)
    return arrp(e) and e[1] or e
  end)
  local inverts = arr_map(inputs,function (e)
    return arrp(e) and e[2] or false
  end)
  local function get_fn(e,key)
    if fnp(key) then
      return key(e)
    else
      return e[key]
    end
  end
  local function key_fn(e)
    return arr_map(keys,function (key)
      return get_fn(e,key)
    end)
  end
  local function comp_fn(a0,a1)
    for i, v0 in  ipairs(a0) do
      local v1 = a1[i]
      local invert = inverts[i]
      if v0 ~= v1 then
        if invert then
          if 'number' == type(v0) then
            return v1 < v0
          else
            return tostring(v1) < tostring(v0)
          end
        else
          if 'number' == type(v0) then
            return v0 < v1
          else
            return tostring(v0) < tostring(v1)
          end
        end
      end
    end
    return false
  end
  return arr_sort(arr,key_fn,comp_fn)
end

-- xt.lang.base-lib/sort-edges-build [1440] 
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

-- xt.lang.base-lib/sort-edges-visit [1455] 
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

-- xt.lang.base-lib/sort-edges [1472] 
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

-- xt.lang.base-lib/sort-topo [1485] 
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

-- xt.lang.base-lib/clone-shallow [1498] 
local function clone_shallow(obj)
  if nil == obj then
    return obj
  elseif objp(obj) then
    return obj_clone(obj)
  elseif arrp(obj) then
    return arr_clone(obj)
  else
    return obj
  end
end

-- xt.lang.base-lib/clone-nested-loop [1507] 
local function clone_nested_loop(obj,cache)
  if nil == obj then
    return obj
  end
  local cached_output = cache[tostring(obj)]
  if cached_output then
    return cached_output
  elseif objp(obj) then
    local out = {}
    cache[tostring(obj)] = out
    for k, v in  pairs(obj) do
      out[k] = clone_nested_loop(v,cache)
    end
    return out
  elseif arrp(obj) then
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

-- xt.lang.base-lib/clone-nested [1534] 
local function clone_nested(obj)
  if not (objp(obj) or arrp(obj)) then
    return obj
  else
    return clone_nested_loop(obj,setmetatable({},{['__mode']='k'}))
  end
end

-- xt.lang.base-lib/wrap-callback [1545] 
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

-- xt.lang.base-lib/walk [1558] 
local function walk(obj,pre_fn,post_fn)
  obj = pre_fn(obj)
  if nil == obj then
    return post_fn(obj)
  elseif objp(obj) then
    local out = {}
    for k, v in  pairs(obj) do
      out[k] = walk(v,pre_fn,post_fn)
    end
    return post_fn(out)
  elseif arrp(obj) then
    local out = {}
    for _, e in  ipairs(obj) do
      table.insert(out,walk(e,pre_fn,post_fn))
    end
    return post_fn(out)
  else
    return post_fn(obj)
  end
end

-- xt.lang.base-lib/get-data [1581] 
local function get_data(obj)
  local function data_fn(obj)
    if ('string' == type(obj)) or ('number' == type(obj)) or ('boolean' == type(obj)) or ((('table' == type(obj)) and (nil == (obj)[1])) or ('object' == type(obj))) or ((('table' == type(obj)) and (nil ~= (obj)[1])) or ('array' == type(obj))) or (nil == obj) then
      return obj
    else
      return '<' .. type_native(obj) .. '>'
    end
  end
  return walk(obj,identity,data_fn)
end

-- xt.lang.base-lib/get-spec [1597] 
local function get_spec(obj)
  local function spec_fn(obj)
    if not (objp(obj) or arrp(obj)) then
      return type_native(obj)
    else
      return obj
    end
  end
  return walk(obj,identity,spec_fn)
end

-- xt.lang.base-lib/split-long [1613] 
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

-- xt.lang.base-lib/proto-spec [1631] 
local function proto_spec(spec_arr)
  local function acc_fn(acc,e)
    local spec_i,spec_map = unpack(e)
    for _, key in  ipairs(spec_i) do
      if nil == spec_map[key] then
        error(
          'NOT VALID.' .. cjson.encode({required=key,actual=obj_keys(spec_map)})
        )
      end
    end
    return obj_assign(acc,spec_map)
  end
  return arr_foldl(spec_arr,acc_fn,{})
end

-- xt.lang.base-lib/with-delay [1653] 
local function with_delay(thunk,ms)
  return ngx.thread.spawn(function ()
    ngx.sleep(ms / 1000)
    local f = thunk
    return f()
  end)
end

-- xt.lang.base-lib/trace-log [1696] 
local function trace_log()
  if TRACE ~= nil then
    return TRACE
  else
    TRACE = {}
    return TRACE
  end
end

-- xt.lang.base-lib/trace-log-clear [1705] 
local function trace_log_clear()
  TRACE = {}
  return TRACE
end

-- xt.lang.base-lib/trace-log-add [1712] 
local function trace_log_add(data,tag,opts)
  local log = trace_log()
  local m = obj_assign({tag=tag,data=data,time=math.floor(1000 * os.time())},opts)
  table.insert(log,m)
  return #log
end

-- xt.lang.base-lib/trace-filter [1725] 
local function trace_filter(tag)
  return arr_filter(trace_log(),function (e)
    return tag == e['tag']
  end)
end

-- xt.lang.base-lib/trace-last-entry [1731] 
local function trace_last_entry(tag)
  local log = trace_log()
  if nil == tag then
    return log[#log + 0]
  else
    local tagged = trace_filter(tag)
    return tagged[#tagged + 0]
  end
end

-- xt.lang.base-lib/trace-data [1741] 
local function trace_data(tag)
  return arr_map(trace_log(),function (e)
    return e['data']
  end)
end

-- xt.lang.base-lib/trace-last [1747] 
local function trace_last(tag)
  return (trace_last_entry(tag))['data']
end

-- xt.lang.base-lib/trace-run [1763] 
local function trace_run(f)
  trace_log_clear()
  f()
  return trace_log()
end

local MODULE = {
  proto_create=proto_create,
  type_native=type_native,
  type_class=type_class,
  fnp=fnp,
  arrp=arrp,
  objp=objp,
  id_fn=id_fn,
  key_fn=key_fn,
  eq_fn=eq_fn,
  inc_fn=inc_fn,
  identity=identity,
  noop=noop,
  T=T,
  F=F,
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
  clamp=clamp,
  bit_count=bit_count,
  sym_full=sym_full,
  sym_name=sym_name,
  sym_ns=sym_ns,
  sym_pair=sym_pair,
  is_emptyp=is_emptyp,
  arr_lookup=arr_lookup,
  arr_every=arr_every,
  arr_some=arr_some,
  arr_each=arr_each,
  arr_omit=arr_omit,
  arr_reverse=arr_reverse,
  arr_find=arr_find,
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
  arr_sorted_merge=arr_sorted_merge,
  arr_shuffle=arr_shuffle,
  arr_pushl=arr_pushl,
  arr_pushr=arr_pushr,
  arr_join=arr_join,
  arr_interpose=arr_interpose,
  arr_repeat=arr_repeat,
  arr_random=arr_random,
  arr_normalise=arr_normalise,
  arr_sample=arr_sample,
  arrayify=arrayify,
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
  obj_keys_nested=obj_keys_nested,
  to_flat=to_flat,
  from_flat=from_flat,
  get_in=get_in,
  set_in=set_in,
  memoize_key=memoize_key,
  not_emptyp=not_emptyp,
  eq_nested_loop=eq_nested_loop,
  eq_nested_obj=eq_nested_obj,
  eq_nested_arr=eq_nested_arr,
  eq_nested=eq_nested,
  obj_diff=obj_diff,
  obj_diff_nested=obj_diff_nested,
  sort=sort,
  objify=objify,
  template_entry=template_entry,
  template_fn=template_fn,
  template_multi=template_multi,
  sort_by=sort_by,
  sort_edges_build=sort_edges_build,
  sort_edges_visit=sort_edges_visit,
  sort_edges=sort_edges,
  sort_topo=sort_topo,
  clone_shallow=clone_shallow,
  clone_nested_loop=clone_nested_loop,
  clone_nested=clone_nested,
  wrap_callback=wrap_callback,
  walk=walk,
  get_data=get_data,
  get_spec=get_spec,
  split_long=split_long,
  proto_spec=proto_spec,
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