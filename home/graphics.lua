-- imports

local Grid = import("grid")
local draw = import("draw")
import("linalg")
--import("vec2")

-- globals

local res = {}
local tres = {}
local key
local debugMode = false
local gameLoop = true
local FPS = 60
local framesElapsed = 0
local particles = {}
local scale = 1
local gravConstant = 6.67e-11

-- side functions

local function userInput()
    local event, is_held
    while true do
---@diagnostic disable-next-line: undefined-field
        event, key, is_held = os.pullEvent("key")
        if key == keys.space then
            gameLoop = false
        end
        event, is_held = nil, nil
    end
end

local function setVertices()
    local a = {}
    -- local mult = 5
    -- local yRange = 12.5
    -- local xRange = 12.5
    -- for x=-5,5,mult do
    --     for y = -5, 5,mult do
    --         table.insert(a,vec({x+0.1,y+0.1}))
    --     end
    -- end
    a = {
        vec({0,10}),
        vec({0,0}),
        vec({0,-50}),
        vec({-70,50}),
        vec({-300,40}),
    }
    particles = a
end

-- main functions

local function Init()
    tres.x, tres.y = term.getSize(1)
    res.x = math.floor(tres.x / draw.PixelSize)
    res.y = math.floor(tres.y / draw.PixelSize)
    Grid.init(res.x,res.y)
    term.clear()
    term.setGraphicsMode(1)
    draw.setPalette()
    term.drawPixels(0,0,1,tres.x,tres.y)
end

local bodies = {
    {
        mass = 1e8,
        velocity = vec({
            0.25,
            0,
        })
    },
    {
        mass = 1e10,
        velocity = vec({
            0,0
        })
    },
    {
        mass = 1e8,
        velocity = vec({
            -0.12,
            0,
        })
    },
    {
        mass = 1e10,
        velocity = vec({
            0.1,
            -0.04,
        })
    },
    {
        mass = 1e11,
        velocity = vec({
            3,
            -0.3,
        })
    }
}

local function Start()
    setVertices()
    -- setBodies()
end

local gd = {}

local function Update()
    local bodyCount = 5
    local timeScale = 100
    local dt = 1/100

    for i=1,bodyCount do
        gd["r"..i] = particles[i]
    end

    for i=1,bodyCount do
        for j=1,bodyCount do
            if (i~=j) then
                gd["r"..i.."_"..j] = gd["r"..j] - gd["r"..i]
            end
        end
    end

    for i=1,bodyCount do
        for j=1,bodyCount do
            if (i~=j) then
                -- debugLog({gd=gd, j=j, i=i,bodies = bodies},"GD")
                gd['a'..i.."_"..j] =
                (timeScale*dt) * ( 
                        (gravConstant * 
                        bodies[j].mass / 
                        gd['r'..i.."_"..j]:length()^3)
                        * gd['r'..i.."_"..j] 
                    )
            end
        end
    end

    for i=1,bodyCount do
        local sum = vec({0,0})
        for j=1,bodyCount do
            if (i~=j) then
                sum = sum + gd['a'..i.."_"..j]
            end
        end
        bodies[i].velocity = bodies[i].velocity + (timeScale * dt * sum)
        particles[i] = particles[i] + bodies[i].velocity
    end
end
 
local function Render()
    scale = 2.5
    for i, v in ipairs(particles) do
        Grid.SetlightLevel(math.floor((v[1]*scale)+res.x/2),math.floor((v[2]*scale)+res.y/2),1)
    end
    draw.drawFromArray2D(0,0,Grid)
end

local function Closing()
    term.clear()
    term.setGraphicsMode(0)
    draw.resetPalette()
    if debugMode then
    else
        term.clear()
        term.setCursorPos(1,1)
    end
end

-- main structure

local function main()
    Init()
    Start()
    while gameLoop do
        Grid.init(res.x,res.y)
        Update()
        Render()
        sleep(1/FPS)
        framesElapsed = framesElapsed + 1;
    end
    Closing()
end

-- execution

parallel.waitForAny(main,userInput)
