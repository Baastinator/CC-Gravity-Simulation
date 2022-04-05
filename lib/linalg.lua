local mathb = import("mathb")

local matrix = {
    identity = function(size)
        if (type(size) ~= "number" or size ~= math.floor(size)) then error("input needs to a number",2) end
        local m = mat(size,size)
        for i=1,size do
            m:set(i,i,1)
        end
        return m
    end,
    tostring = function(a)
        if (type(a) ~= "table" or a.type ~= "mat") then error("function needs to be called on a matrix",2) end
        local size = a:getSize()
        local str = ""
        for y=1,size.y do
            if (y > 1) then
                str = str.."\n"
            end
            for x=1,size.x do
                local val = mathb.round(a:get(x,y),5)
                local placeholder = ""
                for i=#tostring(val),8 do
                    placeholder = placeholder.." "
                end
                if (x > 1) then
                    str = str..","
                end
                str = str..val..placeholder
            end
        end
        return str
    end,
    add = function(a,b)
        if (type(a) ~= "table" or a.type ~= "mat") then error("fist input needs to be a matrix",2) end
        if (type(b) ~= "table" or b.type ~= "mat") then error("second input needs to be a matrix",2) end
        local size = a:getSize()
        local m = mat(size.x, size.y)
        for y=1,size.y do
            for x=1,size.x do
                m:set(x,y,a:get(x,y) + b:get(x,y))
            end
        end
        return m
    end,
    subtract = function(a,b)
        if (type(a) ~= "table" or a.type ~= "mat") then error("fist input needs to be a matrix",2) end
        if (type(b) ~= "table" or b.type ~= "mat") then error("second input needs to be a matrix",2) end
        local size = a:getSize()
        local m = mat(size.x, size.y)
        for y=1,size.y do
            for x=1,size.x do
                m:set(x,y,a:get(x,y) - b:get(x,y))
            end
        end
        return m
    end,
    transpose = function (a)
        if (type(a) ~= "table" or a.type ~= "mat") then error("function needs to be called on a matrix",2) end
        local size = a:getSize()
        local m = mat(size.x, size.y)
        for y=1,size.y do
            for x=1,size.x do
                m:set(x,y,a:get(y,x))
            end
        end
        return m
    end,
    multiply = function (a,b)
        if (type(a) == "table" and type(b) == "number") or (type(a) == "number" and type(b) == "table") then
            local A, B
            if (type(a) == table) then
                if (a.type ~= "mat") then error("bad types",2) end
                A = a
                B = b
            else
                A = b
                B = a
            end
            local size = A:getSize()
            local m = mat(size.x,size.y)
            -- debugLog({A=A,B=B,size=size},"matnummul")
            for y=1,size.y do
                for x=1,size.x do
                    m:set(x,y,A:get(x,y)*B)
                end
            end
            return m
        elseif (type(a) == "table" and type(b) == "table") then
            if (a.type ~= "mat" or b.type ~= "mat") then error("bad types",2) end
            local aSize = a:getSize()
            local bSize = b:getSize()
            local ay, ax = aSize.y, aSize.x
            local by, bx = bSize.y, bSize.x
            if (ax ~= by) then error("invalid size match",2) end
            local m = mat(bx,ay)
            for i=1,ay do
                for j=1,bx do
                    for k=1,by do
                        -- debugLog({m=m,a=a,b=b,i=i,k=k,<j=j},"matmatmul")
                        m:add(j,i,(a:get(k,i)*b:get(j,k)))
                    end
                end
            end
            return m
        else
            error("bad input",2)
        end
    end,
    set = function ( a, x, y, val )
        do --input validation
            if (type(a) ~= "table" or a.type ~= "mat") then error("setter needs to be executed on a matrix",2) end
            if (type(x) ~= "number" and x == math.floor(x)) then error("x position needs to be integer",2) end
            if (type(y) ~= "number" and y == math.floor(y)) then error("y position needs to be integer",2) end
            if (type(val) ~= "number") then error("input needs to be number",2) end
        end
        a[(y-1)*a:getSize().x+x] = val
    end,
    get = function ( a, x, y )
        do --input validation
            if (type(a) ~= "table" or a.type ~= "mat") then error("setter needs to be executed on a matrix",2) end
            if (type(x) ~= "number" and x == math.floor(x)) then error("x position needs to be integer",2) end
            if (type(y) ~= "number" and y == math.floor(y)) then error("y position needs to be integer",2) end
        end
        return a[(y-1)*a:getSize().x+x]
    end,
    singleAdd = function ( a, x, y, val )
        do --input validation
            if (type(a) ~= "table" or a.type ~= "mat") then error("setter needs to be executed on a matrix",2) end
            if (type(x) ~= "number" and x == math.floor(x)) then error("x position needs to be integer",2) end
            if (type(y) ~= "number" and y == math.floor(y)) then error("y position needs to be integer",2) end
            if (type(val) ~= "number") then error("input needs to be number",2) end
        end
        a:set(x,y,a:get(x,y)+val)
    end,
    getSize = function(a)
        if (type(a) ~= "table" or a.type ~= "mat") then error("function needs to be called on a matrix",2) end
        return {x=a.xSize,y=a.ySize}
    end,
    vecSet = function(a,y,val)
        do --input validation
            if (type(a) ~= "table" or a.type ~= "mat") then error("setter needs to be executed on a matrix",2) end
            if (type(y) ~= "number" and y == math.floor(y)) then error("position needs to be integer",2) end
            if (type(val) ~= "number") then error("input needs to be number",2) end
        end
        a:set(1,y,val)
    end,
    vecGet = function(a,y) 
        do --input validation
            if (type(a) ~= "table" or a.type ~= "mat") then error("setter needs to be executed on a matrix",2) end
            if (type(y) ~= "number" and y == math.floor(y)) then error("position needs to be integer",2) end
        end
        return a:get(1,y)
    end,
    vecAdd = function(a,y,val) 
        do --input validation
            if (type(a) ~= "table" or a.type ~= "mat") then error("setter needs to be executed on a matrix",2) end
            if (type(y) ~= "number" and y == math.floor(y)) then error("position needs to be integer",2) end
            if (type(val) ~= "number") then error("input needs to be number",2) end
        end
        a:add(1,y,val)
    end,
    fill = function(a, content)
        for i=1,#content do
            if (type(content[i]) ~= "number") then error("Content needs to be purely numbers",2) end
            a[i] = content[i]
        end
    end,
    determinant = function(a)
        local size = a:getSize()
        if (type(a) ~= "table" or a.type ~= "mat") then error("determinant needs to be called on a matrix",2) end
        if (size.x ~= size.y) then error("Invalid dimensions",2) end
        local det2x2 = function(a) 
            return a[1]*a[4]-a[2]*a[3]
        end
        local det3x3 = function(a)    
            local m1 = mat(2,2) 
            local m2 = mat(2,2)
            local m3 = mat(2,2)
            m1:fill({a:get(2,2),a:get(3,2),a:get(2,3),a:get(3,3)})
            m2:fill({a:get(1,2),a:get(3,2),a:get(1,3),a:get(3,3)})
            m3:fill({a:get(1,2),a:get(2,2),a:get(1,3),a:get(2,3)})
            return a:get(1,1) * m1:det() - a:get(2,1) * m2:det() + a:get(3,1) * m3:det()
        end
        local det4x4 = function(a)
            local m1 = mat(3,3)
            local m2 = mat(3,3)
            local m3 = mat(3,3)
            local m4 = mat(3,3)
            m1:fill({a:get(2,2),a:get(3,2),a:get(4,2),a:get(2,3),a:get(3,3),a:get(4,3),a:get(2,4),a:get(3,4),a:get(4,4)})
            m2:fill({a:get(1,2),a:get(3,2),a:get(4,2),a:get(1,3),a:get(3,3),a:get(4,3),a:get(1,4),a:get(3,4),a:get(4,4)})
            m3:fill({a:get(1,2),a:get(2,2),a:get(4,2),a:get(1,3),a:get(2,3),a:get(4,3),a:get(1,4),a:get(2,4),a:get(4,4)})
            m4:fill({a:get(1,2),a:get(2,2),a:get(3,2),a:get(1,3),a:get(2,3),a:get(3,3),a:get(1,4),a:get(2,4),a:get(3,4)})
            return a:get(1,1) * m1:det() - a:get(2,1) * m2:det() + a:get(3,1) * m3:det() - a:get(4,1) * m4:det()
        end
        size = size.x
        if (size == 2) then
            return det2x2(a)
        elseif (size == 3) then
            return det3x3(a)
        elseif (size == 4) then
            return det4x4(a)
        end
    end,
    pow = function(a,b)
        do --input validation
            if (type(a) ~= "table" or a.type ~= "mat") then error("function needs to be called on a matrix",2) end
            if (a.xSize ~= a.ySize) then error("base matrix must be square",2) end
            if (type(b) ~= "number") then error("power needs to be a number",2) end
            if (math.floor(b) ~= b or b < 0) then error("matpower: bad power",2) end
        end
        if (b == 0) then return (mat().identity(a.xSize)) end
        local product = a
        for i=1,b-1 do
            product = product * a
        end
        return product
    end,
    exp = function(a, it)
        if not it then it = 50 end
        if (type(a) ~= "table" or a.type ~= "mat") then error("function needs to be called on a matrix",2) end
        if (type(it) ~= "number") then error("iteration count needs to be a number",2) end
        if (math.floor(it) ~= it or it <= 0) then error("bad iteration count",2) end
        local sum = mat().identity(a.xSize)
        for i=1,it do
            local part = ((1/mathb.factorial(i)) * a:pow(i))
            sum = sum + part
        end
        return sum
    end,
    fakeln = function(a)
        if (type(a) ~= "table" or a.type ~= "mat") then error("function needs to be called on a matrix",2) end
        if not (a.xSize == 2 and a.ySize == 2 and a[1] == a[4] and a[2] == -a[3]) then
            error("bad input, please use complex form matrix",2)
        end
        local a = a[1]
        local b = -a[2]
        local r = math.sqrt(a*a+b*b)
        local t = math.atan2(b,a)
        local c = math.log(r)
        local d = t
        local m = mat(2,2)
        m:fill({c,-d,d,c})
        -- debugLog({a=a, b=b,r=r,t=t,c=c,d=d,m=m},"yeet")
        return m
    end,
    minus = function(a)
        if (type(a) ~= "table" or a.type ~= "mat") then error("function needs to be called on a matrix",2) end
        for i=1,a.xSize*a.ySize do
            a[i] = -a[i]
        end
        return a
    end,
    inverse = function(a)
        do --input validation
            if (type(a) ~= "table" or a.type ~= "mat") then error("function needs to be called on a matrix",2) end
            if (a.xSize ~= a.ySize) then error("MatInverse: Matrix needs to be square",2) end
            if (a:det() == 0) then error("MatInverse: determinant cannot be 0",2) end
        end
        if (a.xSize == 2) then
            local det = a:det()
            a:fill({a[4],-a[2],-a[3],a[1]})
            a = (1/det) * a
            return a
        end
    end,
    length = function(a)
        local sum = 0
        for i, v in ipairs(a) do
            sum = sum + (v*v)
        end
        return math.sqrt(sum)
    end
}

local MT = {
    __index = {
        identity = matrix.identity,
        transpose = matrix.transpose,
        set = matrix.set,
        tostring = matrix.tostring,
        get = matrix.get,
        add = matrix.singleAdd,
        getSize = matrix.getSize,
        vAdd = matrix.vecAdd,
        vGet = matrix.vecGet,
        vSet = matrix.vecSet,
        fill = matrix.fill,
        det = matrix.determinant,
        pow = matrix.pow,
        exp = matrix.exp,
        ln = matrix.fakeln,
        inverse = matrix.inverse,
        subtract = matrix.subtract,
        length = matrix.length
    },
    __tostring = matrix.tostring,
    __add = matrix.add,
    __sub = matrix.subtract,
    __mul = matrix.multiply,
    __unm = matrix.minus,
    __len = matrix.length
}

function mat(X,Y)
    if (X == nil and Y == nil) then return setmetatable({},MT) end
    local T = {}
    for i=1,X*Y do T[i] = 0 end
    T.type = "mat"
    T.xSize = X
    T.ySize = Y
    return setmetatable(T,MT)
end

function vec(input)
    local content = {}
    local size = 0
    if (type(input) == "table") then
        content = input
        size = #input
    elseif (type(input) == "number") then
        size = input
    else
        error("bad input",2)
    end 
    local v = mat(1,size)
    if (size == 4) then
        v.x = content[1]
        v.y = content[2]
        v.z = content[3]
        v.w = content[4]
    elseif (size == 3) then
        v.x = content[1]
        v.y = content[2]
        v.z = content[3]
    elseif (size == 2) then
        v.x = content[1]
        v.y = content[2]
    end
    for i, V in ipairs(content) do
        v[i] = V
    end
    return v
end