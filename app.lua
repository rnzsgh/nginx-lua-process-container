
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

local cjson = require "cjson"

ngx.req.read_body()

function cleanup ()
  os.remove('/tmp/Test.java')
  os.remove('/tmp/Test.class')
  os.remove('/tmp/compile_output')
  os.remove('/tmp/run_output')
end

function readFile (fileName)
  local file = io.open(fileName, 'r')
  local content = file:read('*a')
  file:close()
  return content
end

cleanup()

local code = ngx.req.get_body_data()

local java_file = io.open('/tmp/Test.java', 'w+')
java_file:write(code)
java_file:close()

os.execute('javac -d /tmp/ /tmp/Test.java 2> /tmp/compile_output')
local compileError = readFile('/tmp/compile_output')

-- Only run if the compile did not fail
local run = ''
if compileError == '' then
  -- This is really powerful if Java can run any command. Configure runtime security
  -- to limit socket, network, file, etc.
  os.execute('java -classpath /tmp Test > /tmp/run_output')
  run = readFile('/tmp/run_output')
end

ngx.say(cjson.encode({
  compileError = compileError,
  runOutput = run,
  code = code
}))

cleanup()

ngx.exit(200)

