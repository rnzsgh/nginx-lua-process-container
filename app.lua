
-- Any code, applications, scripts, templates, proofs of concept,
-- documentation and other items are provided for illustration purposes only.
--
-- Copyright 2017 Amazon Web Services
--
-- Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--   http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

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

