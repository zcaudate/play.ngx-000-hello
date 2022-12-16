local k = require('./xt/lang/base-lib')

-- play.ngx-000-hello.main/thr [9] 
local thr = ngx.thread

-- play.ngx-000-hello.main/main [9] 
local function main()
  ngx.say('\n---THREAD-TEST-')
  ngx.thread.spawn(function ()
    for _, i in  ipairs(k.arr_range(10)) do
      ngx.sleep(math.random() / 5)
      ngx.say('Thread 1: ',i)
    end
  end)
  ngx.thread.spawn(function ()
    for _, i in  ipairs(k.arr_range(10)) do
      ngx.sleep(math.random() / 5)
      ngx.say('Thread 2: ',i)
    end
  end)
end

-- play.ngx-000-hello.main/timer [10] 
local timer = ngx.timer

-- play.ngx-000-hello.main/__init__ [23] 
main()