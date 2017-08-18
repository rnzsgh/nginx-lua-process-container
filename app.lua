
  require("os")

  ngx.req.read_body()

  local code = ngx.req.get_body_data()
  ngx.say(code)

  testFile = io.open("/tmp/Test.java", "w+")
  testFile:write(code)
  testFile:close()

  local compileCommand = io.popen("javac -d /tmp/ /tmp/Test.java")
  local compileResult = compileCommand:read("*a")
  compileCommand:close()
  ngx.say(compileResult)

  local runCommand = io.popen("java -classpath /tmp/ Test")
  local runResult = runCommand:read("*a")
  runCommand:close()
  ngx.say(runResult)

  ngx.exit(200)

