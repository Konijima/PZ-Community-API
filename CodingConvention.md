# Coding Convention
**This is the convention that we agreed to use on this project.**  
*This is not yet fixed, it may change if we see fit until the first release.*  
  
  

### LUA FILE RETURN
_**Not everything is global**, your file can return an object and be required into a variable where it is needed._
```lua
local obj = {}
function obj.DoSomething() end
return obj
```

### GLOBAL
```lua
GLOBAL_VAR = "" -- UpperCase
function GlobalFunc() end -- PascalCase
```
  
### LOCAL
```lua
local someVariable = "" -- camelCase
local function someFunction() end -- camelCase
```
  
### OBJECT
```lua
local MyObject = {} -- PascalCase
function MyObject.StaticMethod() end -- PascalCase 
function MyObject:instanceMethod() end -- camelCase
```
  
### PARAMETERS
```lua
local function func(requiredParam) end -- camelCase
local function func(_optionalParam) end -- camelCase prefixed with underscore
```
  
### MULTI PARAMETERS
*Separate parameters with a space after the comma.*
```lua
-- Wrong
function(param1,param2)
-- Good
function(param1, param2)
```
  
### ANNOTATIONS
```lua
---@class MyClass Description of the class
local MyClass = {}

--- Short description of the usage of this method
---@param param1 string   Description of this parameter
---@return string
function MyClass:setName(param1)
    return param1
end
```
*View [Emmylua docs](https://emmylua.github.io/) for more information about annotations.*

  
