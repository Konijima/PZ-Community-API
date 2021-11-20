local enabled = true

if enabled then
    local logWriter = getFileWriter("CAPI_UNIT_TEST.txt", true, true)
    logWriter:writeln("######################################################")
    logWriter:writeln("#                   UNIT TEST                        #")
    logWriter:writeln("######################################################")
    logWriter:writeln("Time: " .. os.date('%A, %B %d %Y at %I:%M:%S %p'))
    logWriter:writeln("Project Zomboid Version: " .. getCore():getVersionNumber())
    logWriter:writeln("CommunityAPI Version: " .. require("CommunityAPI/Version"))
    logWriter:writeln("")
    logWriter:close()
end

local instances = {}

---@class UnitTestInstance
local UnitTestInstance = {}
UnitTestInstance.Type = "UnitTestInstance"

function UnitTestInstance:new(name)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.name = name
    o.results = {}
    o.counts = {
        passed = 0,
        failed = 0,
        error = 0,
    }
    return o
end

--- Test a method return a lua type
---@param testDescription string Description of the expected behavior
---@param expectedResult string The string representation of the type of value
---@param method function|any The method or value to test
---@vararg any
function UnitTestInstance:typeOf(testDescription, expectedResult, method, ...)
    if not enabled then return; end

    local result = "UNTESTED"
    local function test(...)
        local methodResult
        if type(method) == "function" then methodResult = method(...)
        else methodResult = method end
        if type(methodResult) == expectedResult then
            result = "PASSED"
            self.counts.passed = self.counts.passed + 1
        else
            result = "FAILED"
            self.counts.failed = self.counts.failed + 1
        end
    end

    if not pcall(test, ...) then
        result = "ERROR"
        self.counts.error = self.counts.error + 1
    end

    table.insert(self.results, { desc = testDescription, result = result })
end

--- Test a method return a java instance type
---@param testDescription string Description of the expected behavior
---@param expectedResult string The string representation of the type of value
---@param method function|any The method or value to test
---@vararg any
function UnitTestInstance:instanceOf(testDescription, expectedResult, method, ...)
    if not enabled then return; end

    local result = "UNTESTED"
    local function test(...)
        local methodResult
        if type(method) == "function" then methodResult = method(...)
        else methodResult = method end
        if type(methodResult) == "userdata" and instanceof(methodResult, expectedResult) then
            result = "PASSED"
            self.counts.passed = self.counts.passed + 1
        else
            result = "FAILED"
            self.counts.failed = self.counts.failed + 1
        end
    end

    if not pcall(test, ...) then
        result = "ERROR"
        self.counts.error = self.counts.error + 1
    end

    table.insert(self.results, { desc = testDescription, result = result })
end

--- Test a method return an other with a specific metatable
---@param testDescription string Description of the expected behavior
---@param expectedResult table The expected metatable table
---@param method function|table The method or value to test
---@vararg any
function UnitTestInstance:isMetatableOf(testDescription, expectedResult, method, ...)
    if not enabled then return; end

    local result = "UNTESTED"
    local function test(...)
        local methodResult
        if type(method) == "function" then methodResult = method(...)
        else methodResult = method end
            result = "PASSED"
            self.counts.passed = self.counts.passed + 1
        else
            result = "FAILED"
            self.counts.failed = self.counts.failed + 1
        end
    end

    if not pcall(test, ...) then
        result = "ERROR"
        self.counts.error = self.counts.error + 1
    end

    table.insert(self.results, { desc = testDescription, result = result })
end

--- Test a method return a desired value
---@param testDescription string Description of the expected behavior
---@param expectedResult any The expected return value
---@param method function|any The method or value to test
---@vararg any
function UnitTestInstance:equalTo(testDescription, expectedResult, method, ...)
    if not enabled then return; end

    local result = "UNTESTED"
    local function test(...)
        local methodResult
        if type(method) == "function" then methodResult = method(...)
        else methodResult = method end
        if methodResult == expectedResult then
            result = "PASSED"
            self.counts.passed = self.counts.passed + 1
        else
            result = "FAILED"
            self.counts.failed = self.counts.failed + 1
        end
    end

    if not pcall(test, ...) then
        result = "ERROR"
        self.counts.error = self.counts.error + 1
    end

    table.insert(self.results, { desc = testDescription, result = result })
end

--- Test a method return a number greater than
---@param testDescription string Description of the expected behavior
---@param expectedResult number The expected return value
---@param method function|number The method or value to test
---@vararg any
function UnitTestInstance:greaterThan(testDescription, expectedResult, method, ...)
    if not enabled then return; end

    local result = "UNTESTED"
    local function test(...)
        local methodResult
        if type(method) == "function" then methodResult = method(...)
        else methodResult = method end
        if type(methodResult) == "number" and methodResult > expectedResult then
            result = "PASSED"
            self.counts.passed = self.counts.passed + 1
        else
            result = "FAILED"
            self.counts.failed = self.counts.failed + 1
        end
    end

    if not pcall(test, ...) then
        result = "ERROR"
        self.counts.error = self.counts.error + 1
    end

    table.insert(self.results, { desc = testDescription, result = result })
end

--- Test a method return a number lesser than
---@param testDescription string Description of the expected behavior
---@param expectedResult number The expected return value
---@param method function|number The method or value to test
---@vararg any
function UnitTestInstance:lesserThan(testDescription, expectedResult, method, ...)
    if not enabled then return; end

    local result = "UNTESTED"
    local function test(...)
        local methodResult
        if type(method) == "function" then methodResult = method(...)
        else methodResult = method end
        if type(methodResult) == "number" and methodResult < expectedResult then
            result = "PASSED"
            self.counts.passed = self.counts.passed + 1
        else
            result = "FAILED"
            self.counts.failed = self.counts.failed + 1
        end
    end

    if not pcall(test, ...) then
        result = "ERROR"
        self.counts.error = self.counts.error + 1
    end

    table.insert(self.results, { desc = testDescription, result = result })
end

--- Test a method return nil
---@param testDescription string Description of the expected behavior
---@param method function|any The method or value to test
---@vararg any
function UnitTestInstance:isNil(testDescription, method, ...)
    if not enabled then return; end

    local result = "UNTESTED"
    local function test(...)
        local methodResult
        if type(method) == "function" then methodResult = method(...)
        else methodResult = method end
        if type(methodResult) == type(nil) then
            result = "PASSED"
            self.counts.passed = self.counts.passed + 1
        else
            result = "FAILED"
            self.counts.failed = self.counts.failed + 1
        end
    end

    if not pcall(test, ...) then
        result = "ERROR"
        self.counts.error = self.counts.error + 1
    end

    table.insert(self.results, { desc = testDescription, result = result })
end

--- Test a method return not nil
---@param testDescription string Description of the expected behavior
---@param method function|any The method or value to test
---@vararg any
function UnitTestInstance:isNotNil(testDescription, method, ...)
    if not enabled then return; end

    local result = "UNTESTED"
    local function test(...)
        local methodResult
        if type(method) == "function" then methodResult = method(...)
        else methodResult = method end
        if type(methodResult) ~= type(nil) then
            result = "PASSED"
            self.counts.passed = self.counts.passed + 1
        else
            result = "FAILED"
            self.counts.failed = self.counts.failed + 1
        end
    end

    if not pcall(test, ...) then
        result = "ERROR"
        self.counts.error = self.counts.error + 1
    end

    table.insert(self.results, { desc = testDescription, result = result })
end

---@class UnitTest
local UnitTest = {}
UnitTest.Type = "UnitTest"

---@param name string The test name
---@return UnitTestInstance
function UnitTest.Start(name)
    if not enabled then return; end
    if type(name) ~= "string" then error("UnitTest Error: Unit test name must be a string!", 3) end
    if instances[name] then error("UnitTest Error: There is already a unit test with the name [" .. name .. "]!", 3) end
    instances[name] = UnitTestInstance:new(name)
    return instances[name]
end

---@param testInstance UnitTestInstance
function UnitTest.End(testInstance)
    if not enabled then return; end
    if type(testInstance) ~= "table" or getmetatable(testInstance) ~= UnitTestInstance then error("UnitTest Error: Invalid argument given into UnitTest.Run()!", 3) end

    local logWriter = getFileWriter("CAPI_UNIT_TEST.txt", true, true)
    logWriter:writeln("UnitTest [" .. tostring(testInstance.name) .. "] Starting...")
    logWriter:writeln("")
    for i=1, #testInstance.results do
        logWriter:writeln("#" .. i .. " " .. "[ " .. testInstance.results[i].result .. " ] " .. testInstance.results[i].desc)
    end
    logWriter:writeln("")
    logWriter:writeln("Passed: " .. testInstance.counts.passed .. "/" .. #testInstance.results)
    if testInstance.counts.failed > 0 then logWriter:writeln("Failed: " .. testInstance.counts.failed .. "/" .. #testInstance.results) end
    if testInstance.counts.error > 0 then logWriter:writeln("Errors: " .. testInstance.counts.error .. "/" .. #testInstance.results) end
    logWriter:writeln("")
    logWriter:writeln("UnitTest [" .. tostring(testInstance.name) .. "] completed!")
    logWriter:writeln("")
    logWriter:writeln("------------------------------------------------------")
    logWriter:writeln("")
    logWriter:close()
end

return UnitTest
