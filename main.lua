local k = require('./xt/lang/base-lib')

-- play.ngx-000-hello.main/thr [14] 
local thr = ngx.thread

-- play.ngx-000-hello.main/timer [16] 
local timer = ngx.timer

-- play.ngx-000-hello.main/main [18] 
local function main()
  ngx.say('\n---THREAD-TEST-')
  thr.spawn(function ()
    for _, i in  ipairs(k.arr_range(10)) do
      ngx.sleep(math.random() / 5)
      ngx.say('Thread 1: ',i)
    end
  end)
  thr.spawn(function ()
    for _, i in  ipairs(k.arr_range(10)) do
      ngx.sleep(math.random() / 5)
      ngx.say('Thread 2: ',i)
    end
  end)
end

-- play.ngx-000-hello.main/__init__ [31] 
-- f51c1bd4-ac3e-4228-8e76-d5d57db9b4d0
main()