-- ╔══════════════════════════════════════════╗
-- ║         Laced Notifier  V2               ║
-- ║   Steal a Brainrot  •  Auto Joiner       ║
-- ╚══════════════════════════════════════════╝

local HttpService     = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players         = game:GetService("Players")
local CoreGui         = game:GetService("CoreGui")
local TweenService    = game:GetService("TweenService")
local UIS             = game:GetService("UserInputService")

local WS_URL    = "wss://sabajxyz.up.railway.app"
local PLACE_ID  = 109983668079237
local SAVE_FILE = "LacedNotifierV2.json"

-- ─────────────────────────────────────────────
-- SCALE FACTOR (Detect mobile and scale down)
-- ─────────────────────────────────────────────
local function getScaleFactor()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local width = viewportSize.X
    
    -- Mobile detection: if screen width is small (typical mobile/tablet), scale down
    if width < 800 then
        return 0.65  -- 65% size for mobile
    else
        return 1.0   -- Full size for PC
    end
end

local SCALE = getScaleFactor()

-- ─────────────────────────────────────────────
-- BRAINROT LIST  (from Beebom, Jan 2026)
-- ─────────────────────────────────────────────
local ALL_BRAINROTS = {
    "Noobini Pizzanini","Lirili Larila","Tim Cheese","FluriFlura","Talpa Di Fero",
    "Svinina Bombardino","Pipi Kiwi","Racooni Jandelini","Pipi Corni","Noobini Santanini",
    "Trippi Troppi","Gangster Footera","Bandito Bobritto","Boneca Ambalabu",
    "Cacto Hipopotamo","Ta Ta Ta Ta Sahur","Tric Trac Baraboom","Pipi Avocado","Frogo Elfo",
    "Cappuccino Assassino","Brr Brr Patapim","Trulimero Trulicina","Bambini Crostini",
    "Bananita Dolphinita","Perochello Lemonchello","Brri Brri Bicus Dicus Bombicus",
    "Avocadini Guffo","Salamino Penguino","Ti Ti Ti Sahur","Penguin Tree","Penguino Cocosino",
    "Burbaloni Loliloli","Chimpazini Bananini","Ballerina Cappuccina","Chef Crabracadabra",
    "Lionel Cactuseli","Glorbo Fruttodrillo","Blueberrini Octopusini","Strawberelli Flamingelli",
    "Pandaccini Bananini","Cocosini Mama","Sigma Boy","Sigma Girl","Pi Pi Watermelon",
    "Chocco Bunny","Sealo Regalo",
    "Frigo Camelo","Orangutini Ananassini","Rhino Toasterino","Bombardiro Crocodilo",
    "Bombombini Gusini","Cavallo Virtuso","Gorillo Watermelondrillo","Avocadorilla",
    "Tob Tobi Tobi","Ganganzelli Trulala","Cachorrito Melonito","Elefanto Frigo",
    "Toiletto Focaccino","Te Te Te Sahur","Tracoducotulu Delapeladustuz","Lerulerulerule",
    "Jingle Jingle Sahur","Tree Tree Tree Sahur","Carloo","Spioniro Golubiro",
    "Zibra Zubra Zibralini","Tigrilini Watermelini","Carrotini Brainini","Bananito Bandito",
    "Coco Elefanto","Girafa Celestre","Gattatino Nyanino","Chihuanini Taconini","Matteo",
    "Tralalero Tralala","Espresso Signora","Odin Din Din Dun","Statutino Libertino",
    "Trenostruzzo Turbo 3000","Ballerino Lololo","Los Orcalitos","Dug dug dug",
    "Tralalita Tralala","Urubini Flamenguini","Los Bombinitos","Trigoligre Frutonni",
    "Orcalero Orcala","Bulbito Bandito Traktorito","Los Crocodillitos","Piccione Macchina",
    "Trippi Troppi Troppa Trippa","Los Tungtungtungcitos","Tukanno Bananno","Alessio",
    "Tipi Topi Taco","Extinct Ballerina","Capi Taco","Gattito Tacoto","Pakrahmatmamat",
    "Tractoro Dinosauro","Corn Corn Corn Sahur","Squalanana","Los Tipi Tacos",
    "Bombardini Tortinii","Pop pop Sahur","Ballerina Peppermintina","Yeti Claus",
    "Ginger Globo","Frio Ninja","Ginger Cisterna","Cacasito Satalito","Aquanaut",
    "Tartaruga Cisterna",
    "Las Sis","La Vacca Staturno Saturnita","Chimpanzini Spiderini","Extinct Tralalero",
    "Extinct Matteo","Los Tralaleritos","La Karkerkar Combinasion","Karker Sahur",
    "Las Tralaleritas","Job Job Job Sahur","Los Spyderrinis","Perrito Burrito",
    "Graipuss Medussi","Los Jobcitos","La Grande Combinasion","Tacorita Bicicleta",
    "Nuclearo Dinossauro","Los 67","Money Money Puggy","Chillin Chili","La Extinct Grande",
    "Los Tacoritas","Los Tortus","Tang Tang Kelentang","Garama and Madundung",
    "La Secret Combinasion","Torrtuginni Dragonfruitini","Pot Hotspot","To to to Sahur",
    "Las Vaquitas Saturnitas","Chicleteira Bicicleteira","Agarrini la Palini",
    "Mariachi Corazoni","Dragon Cannelloni","Los Combinasionas","La Cucaracha",
    "Karkerkar Kurkur","Los Hotspotsitos","La Sahur Combinasion","Quesadilla Crocodila",
    "Esok Sekolah","Los Matteos","Dul Dul Dul","Blackhole Goat","Nooo My Hotspot",
    "Sammyini Spyderini","Spaghetti Tualetti","67","Los Noo My Hotspotsitos",
    "Celularcini Viciosini","Tralaledon","Tictac Sahur","La Supreme Combinasion",
    "Ketupat Kepat","Ketchuru and Musturu","Burguro and Fryuro","Please my Present",
    "La Grande","La Vacca Prese Presente","Ho Ho Ho Sahur","Chicleteira Noelteira",
    "Cooki and Milki","La Jolly Grande","Capitano Moby","Cerberus",
    "Skibidi Toilet","Strawberry Elephant","Meowl",
}

-- ─────────────────────────────────────────────
-- CONFIG
-- ─────────────────────────────────────────────
local cfg = {
    autoJoin         = false,
    toastEnabled     = true,
    minMoneyIndex    = 1,
    retryIndex       = 2,
    whitelistEnabled = false,
    whitelist        = {},
}

local moneyOptions = {
    {label="None", value=0},
    {label="10M",  value=10000000},
    {label="20M",  value=20000000},
    {label="30M",  value=30000000},
    {label="40M",  value=40000000},
    {label="50M",  value=50000000},
    {label="100M", value=100000000},
}
local retryOptions = {1,3,5,10,20}

local function saveConfig()
    pcall(function()
        writefile(SAVE_FILE, HttpService:JSONEncode(cfg))
    end)
end

local function loadConfig()
    local ok, data = pcall(function()
        if isfile and isfile(SAVE_FILE) then
            return HttpService:JSONDecode(readfile(SAVE_FILE))
        end
    end)
    if ok and type(data) == "table" then
        for k,v in pairs(data) do cfg[k] = v end
    end
end
loadConfig()

-- ─────────────────────────────────────────────
-- SCALED DIMENSIONS
-- ─────────────────────────────────────────────
local function S(val)
    return math.floor(val * SCALE)
end

-- ─────────────────────────────────────────────
-- HELPERS
-- ─────────────────────────────────────────────
local function fmt(n)
    if n >= 1e9  then return string.format("$%.2fB", n/1e9)
    elseif n >= 1e6 then return string.format("$%.2fM", n/1e6)
    elseif n >= 1e3 then return string.format("$%.1fK", n/1e3)
    end
    return "$"..tostring(n)
end
local function ts() return os.date("%H:%M:%S") end

local function serverNameContainsWhitelisted(name)
    if not cfg.whitelistEnabled or #cfg.whitelist == 0 then return true end
    local lname = name:lower()
    for _, w in ipairs(cfg.whitelist) do
        if lname:find(w:lower(), 1, true) then return true end
    end
    return false
end

-- ─────────────────────────────────────────────
-- COLOURS
-- ─────────────────────────────────────────────
local C = {
    bg       = Color3.fromRGB(7,  6, 12),
    sidebar  = Color3.fromRGB(10,  8, 18),
    card     = Color3.fromRGB(14, 11, 22),
    deep     = Color3.fromRGB(9,   7, 16),
    stroke   = Color3.fromRGB(28, 20, 52),
    strokeHi = Color3.fromRGB(60, 42,110),
    a1       = Color3.fromRGB(108, 52,255),
    a2       = Color3.fromRGB( 52,118,255),
    a3       = Color3.fromRGB(178, 78,255),
    tPrim    = Color3.fromRGB(238,233,255),
    tSec     = Color3.fromRGB(108, 93,152),
    tMut     = Color3.fromRGB( 50, 42, 80),
    green    = Color3.fromRGB( 48,214,108),
    red      = Color3.fromRGB(255, 62, 72),
    yellow   = Color3.fromRGB(255,194, 48),
    gold     = Color3.fromRGB(255,198, 48),
    orange   = Color3.fromRGB(255,140, 50),
    rowHov   = Color3.fromRGB(18, 14, 30),
    logBg    = Color3.fromRGB(10,  8, 18),
}

-- ─────────────────────────────────────────────
-- CLEANUP & SCREEN GUI
-- ─────────────────────────────────────────────
if CoreGui:FindFirstChild("LacedV2") then
    CoreGui:FindFirstChild("LacedV2"):Destroy()
end

local SG = Instance.new("ScreenGui")
SG.Name = "LacedV2"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = CoreGui

-- ─────────────────────────────────────────────
-- TOAST SYSTEM
-- ─────────────────────────────────────────────
local toastSlot = 0
local function showToast(name, money, isGold)
    if not cfg.toastEnabled then return end
    toastSlot += 1
    local slot  = toastSlot
    local yOff  = S(-94) - (slot-1) * S(82)
    local col   = isGold and C.gold or C.green
    local bg    = isGold and Color3.fromRGB(22,17,5) or Color3.fromRGB(8,22,14)

    local T = Instance.new("Frame")
    T.Size = UDim2.new(0, S(292), 0, S(76))
    T.Position = UDim2.new(1, S(14), 1, yOff)
    T.BackgroundColor3 = bg
    T.BorderSizePixel = 0
    T.Parent = SG
    Instance.new("UICorner",T).CornerRadius = UDim.new(0, S(14))
    local sk = Instance.new("UIStroke"); sk.Color=col; sk.Thickness=1; sk.Parent=T

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, S(3), 1, S(-20)); bar.Position = UDim2.new(0, S(10), 0, S(10))
    bar.BackgroundColor3=col; bar.BorderSizePixel=0; bar.Parent=T
    Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)

    local function tl(txt,y,sz,font,tcol)
        local l=Instance.new("TextLabel")
        l.Text=txt; l.Size=UDim2.new(1, S(-28), 0, S(sz+2)); l.Position=UDim2.new(0, S(22), 0, S(y))
        l.BackgroundTransparency=1; l.TextColor3=tcol; l.TextSize=S(sz)
        l.Font=font; l.TextXAlignment=Enum.TextXAlignment.Left
        l.TextTruncate=Enum.TextTruncate.AtEnd; l.Parent=T
    end
    tl(isGold and "NEW SESSION PEAK" or "SERVER FOUND", 9,  9, Enum.Font.GothamBold, col)
    tl(name,                                            24, 13, Enum.Font.GothamBold, C.tPrim)
    tl(fmt(money),                                      42, 11, Enum.Font.Gotham,     C.tSec)

    local pbg=Instance.new("Frame"); pbg.Size=UDim2.new(1,0,0,S(2))
    pbg.Position=UDim2.new(0,0,1,S(-2)); pbg.BackgroundColor3=Color3.fromRGB(25,20,45)
    pbg.BorderSizePixel=0; pbg.Parent=T; Instance.new("UICorner",pbg).CornerRadius=UDim.new(1,0)
    local pf=Instance.new("Frame"); pf.Size=UDim2.new(1,0,1,0)
    pf.BackgroundColor3=col; pf.BorderSizePixel=0; pf.Parent=pbg
    Instance.new("UICorner",pf).CornerRadius=UDim.new(1,0)

    TweenService:Create(T,TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
        {Position=UDim2.new(1, S(-308), 1, yOff)}):Play()
    TweenService:Create(pf,TweenInfo.new(5,Enum.EasingStyle.Linear),
        {Size=UDim2.new(0,0,1,0)}):Play()

    task.delay(5,function()
        local out=TweenService:Create(T,TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.In),
            {Position=UDim2.new(1, S(14), 1, yOff)})
        out:Play(); out.Completed:Connect(function() T:Destroy(); toastSlot=math.max(0,toastSlot-1) end)
    end)
end

-- ─────────────────────────────────────────────
-- ROOT FRAME
-- ─────────────────────────────────────────────
local Root = Instance.new("Frame")
Root.Name="Root"; Root.Size=UDim2.new(0, S(760), 0, S(460))
Root.Position=UDim2.new(0.5, S(-380), 0.5, S(-230))
Root.BackgroundColor3=C.bg; Root.BorderSizePixel=0
Root.Active=true; Root.Draggable=true; Root.Parent=SG
Instance.new("UICorner",Root).CornerRadius=UDim.new(0, S(16))
local rootSk=Instance.new("UIStroke"); rootSk.Color=C.stroke; rootSk.Thickness=1; rootSk.Parent=Root

local topLine=Instance.new("Frame"); topLine.Size=UDim2.new(1, S(-32), 0, 1)
topLine.Position=UDim2.new(0, S(16), 0, 0); topLine.BackgroundColor3=C.a1
topLine.BorderSizePixel=0; topLine.Parent=Root
Instance.new("UICorner",topLine).CornerRadius=UDim.new(1,0)
local tg=Instance.new("UIGradient"); tg.Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,C.a3),
    ColorSequenceKeypoint.new(0.5,C.a1),
    ColorSequenceKeypoint.new(1,C.a2),
}); tg.Parent=topLine

-- ─────────────────────────────────────────────
-- MINI PILL  (minimized state)
-- ─────────────────────────────────────────────
local Pill = Instance.new("Frame")
Pill.Name="Pill"; Pill.Size=UDim2.new(0, S(220), 0, S(36))
Pill.Position=UDim2.new(0.5, S(-110), 0, S(14))
Pill.BackgroundColor3=C.card; Pill.BorderSizePixel=0
Pill.Visible=false; Pill.Active=true; Pill.Draggable=true; Pill.Parent=SG
Instance.new("UICorner",Pill).CornerRadius=UDim.new(1,0)
local pillSk=Instance.new("UIStroke"); pillSk.Color=C.a1; pillSk.Thickness=1; pillSk.Parent=Pill

local pillDot=Instance.new("Frame"); pillDot.Size=UDim2.new(0, S(8), 0, S(8))
pillDot.Position=UDim2.new(0, S(12), 0.5, S(-4)); pillDot.BackgroundColor3=C.red
pillDot.BorderSizePixel=0; pillDot.Parent=Pill
Instance.new("UICorner",pillDot).CornerRadius=UDim.new(1,0)

local pillText=Instance.new("TextLabel"); pillText.Text="Laced  ·  0 servers"
pillText.Size=UDim2.new(0, S(120), 1, 0); pillText.Position=UDim2.new(0, S(26), 0, 0)
pillText.BackgroundTransparency=1; pillText.TextColor3=C.tSec; pillText.TextSize=S(11)
pillText.Font=Enum.Font.GothamBold; pillText.TextXAlignment=Enum.TextXAlignment.Left
pillText.Parent=Pill

-- AJ toggle on pill
local pillAJTrack=Instance.new("Frame"); pillAJTrack.Size=UDim2.new(0, S(40), 0, S(20))
pillAJTrack.Position=UDim2.new(1, S(-88), 0.5, S(-10))
pillAJTrack.BackgroundColor3=cfg.autoJoin and C.a1 or Color3.fromRGB(26,20,46)
pillAJTrack.BorderSizePixel=0; pillAJTrack.Parent=Pill
Instance.new("UICorner",pillAJTrack).CornerRadius=UDim.new(1,0)

local pillAJThumb=Instance.new("Frame"); pillAJThumb.Size=UDim2.new(0, S(14), 0, S(14))
pillAJThumb.Position=cfg.autoJoin and UDim2.new(1, S(-17), 0.5, S(-7)) or UDim2.new(0, S(3), 0.5, S(-7))
pillAJThumb.BackgroundColor3=cfg.autoJoin and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,55,110)
pillAJThumb.BorderSizePixel=0; pillAJThumb.Parent=pillAJTrack
Instance.new("UICorner",pillAJThumb).CornerRadius=UDim.new(1,0)

local pillAJLabel=Instance.new("TextLabel"); pillAJLabel.Text="AJ"
pillAJLabel.Size=UDim2.new(0, S(20), 1, 0); pillAJLabel.Position=UDim2.new(1, S(-112), 0, 0)
pillAJLabel.BackgroundTransparency=1; pillAJLabel.TextColor3=C.tMut; pillAJLabel.TextSize=S(9)
pillAJLabel.Font=Enum.Font.GothamBold; pillAJLabel.Parent=Pill

local pillExpandBtn=Instance.new("TextButton"); pillExpandBtn.Size=UDim2.new(0, S(30), 0, S(20))
pillExpandBtn.Position=UDim2.new(1, S(-34), 0.5, S(-10))
pillExpandBtn.BackgroundColor3=Color3.fromRGB(18,13,32); pillExpandBtn.TextColor3=C.tSec
pillExpandBtn.TextSize=S(10); pillExpandBtn.Font=Enum.Font.GothamBold; pillExpandBtn.Text="↑"
pillExpandBtn.BorderSizePixel=0; pillExpandBtn.Parent=Pill
Instance.new("UICorner",pillExpandBtn).CornerRadius=UDim.new(0, S(6))

-- shared toggle function (declared after settAJTrack is built below)
local settAJTrack, settAJThumb
local function syncAJToggle(on)
    cfg.autoJoin=on
    local ti=TweenInfo.new(0.15,Enum.EasingStyle.Quad)
    local col=on and C.a1 or Color3.fromRGB(26,20,46)
    local pos=on and UDim2.new(1, S(-21), 0.5, S(-9)) or UDim2.new(0, S(3), 0.5, S(-9))
    local tc=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,55,110)
    local pillPos=on and UDim2.new(1, S(-17), 0.5, S(-7)) or UDim2.new(0, S(3), 0.5, S(-7))
    local pillTc=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,55,110)
    TweenService:Create(pillAJTrack,ti,{BackgroundColor3=col}):Play()
    TweenService:Create(pillAJThumb,ti,{Position=pillPos,BackgroundColor3=pillTc}):Play()
    if settAJTrack then
        TweenService:Create(settAJTrack,ti,{BackgroundColor3=col}):Play()
        TweenService:Create(settAJThumb,ti,{Position=pos,BackgroundColor3=tc}):Play()
    end
    saveConfig()
end

local pillAJBtn=Instance.new("TextButton"); pillAJBtn.Size=UDim2.new(1,0,1,0)
pillAJBtn.BackgroundTransparency=1; pillAJBtn.Text=""; pillAJBtn.Parent=pillAJTrack
pillAJBtn.MouseButton1Click:Connect(function() syncAJToggle(not cfg.autoJoin) end)

local minimized=false
local guiVisible=true

local function setMinimized(v)
    minimized=v; Root.Visible=not v; Pill.Visible=v
end

pillExpandBtn.MouseButton1Click:Connect(function() setMinimized(false) end)

UIS.InputBegan:Connect(function(inp,gpe)
    if gpe then return end
    if inp.KeyCode==Enum.KeyCode.RightShift then
        if minimized then setMinimized(false)
        else guiVisible=not guiVisible; Root.Visible=guiVisible end
    end
end)

-- ─────────────────────────────────────────────
-- SIDEBAR
-- ─────────────────────────────────────────────
local Sidebar=Instance.new("Frame"); Sidebar.Size=UDim2.new(0, S(145), 1, 0)
Sidebar.BackgroundColor3=C.sidebar; Sidebar.BorderSizePixel=0; Sidebar.Parent=Root
Instance.new("UICorner",Sidebar).CornerRadius=UDim.new(0, S(16))
local sfx=Instance.new("Frame"); sfx.Size=UDim2.new(0, S(16), 1, 0)
sfx.Position=UDim2.new(1, S(-16), 0, 0); sfx.BackgroundColor3=C.sidebar
sfx.BorderSizePixel=0; sfx.Parent=Sidebar

-- Logo
local logoF=Instance.new("Frame"); logoF.Size=UDim2.new(0, S(34), 0, S(34))
logoF.Position=UDim2.new(0.5, S(-17), 0, S(14)); logoF.BackgroundColor3=C.a1
logoF.BorderSizePixel=0; logoF.Parent=Sidebar
Instance.new("UICorner",logoF).CornerRadius=UDim.new(0, S(10))
local lg=Instance.new("UIGradient"); lg.Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,C.a3),ColorSequenceKeypoint.new(1,C.a2)
}); lg.Rotation=135; lg.Parent=logoF
local ll=Instance.new("TextLabel"); ll.Text="L"; ll.Size=UDim2.new(1,0,1,0)
ll.BackgroundTransparency=1; ll.TextColor3=Color3.fromRGB(255,255,255)
ll.TextSize=S(17); ll.Font=Enum.Font.GothamBold; ll.Parent=logoF

local bn=Instance.new("TextLabel"); bn.Text="LACED"
bn.Size=UDim2.new(1,0,0,S(13)); bn.Position=UDim2.new(0,0,0,S(52))
bn.BackgroundTransparency=1; bn.TextColor3=C.tPrim; bn.TextSize=S(10)
bn.Font=Enum.Font.GothamBold; bn.Parent=Sidebar

local sdiv=Instance.new("Frame"); sdiv.Size=UDim2.new(1, S(-20), 0, 1)
sdiv.Position=UDim2.new(0, S(10), 0, S(76)); sdiv.BackgroundColor3=C.stroke
sdiv.BorderSizePixel=0; sdiv.Parent=Sidebar

-- Tab list
local TabList=Instance.new("Frame"); TabList.Size=UDim2.new(1,0,1, S(-150))
TabList.Position=UDim2.new(0,0,0,S(84)); TabList.BackgroundTransparency=1; TabList.Parent=Sidebar
local tlo=Instance.new("UIListLayout"); tlo.Padding=UDim.new(0,S(3)); tlo.Parent=TabList
local tpad=Instance.new("UIPadding"); tpad.PaddingLeft=UDim.new(0,S(8))
tpad.PaddingRight=UDim.new(0,S(8)); tpad.Parent=TabList

local Content=Instance.new("Frame"); Content.Size=UDim2.new(1, S(-145), 1, 0)
Content.Position=UDim2.new(0, S(145), 0, 0); Content.BackgroundTransparency=1
Content.ClipsDescendants=true; Content.Parent=Root

local Pages={}; local TabBtns={}

local function makePage(name)
    local f=Instance.new("Frame"); f.Name=name; f.Size=UDim2.new(1,0,1,0)
    f.BackgroundTransparency=1; f.Visible=false; f.Parent=Content
    Pages[name]=f; return f
end

local function switchTab(name)
    for n,p in pairs(Pages) do p.Visible=(n==name) end
    for n,b in pairs(TabBtns) do
        local on=(n==name)
        b.BackgroundColor3=on and Color3.fromRGB(20,15,36) or C.sidebar
        b.TextColor3=on and C.tPrim or C.tSec
        local ind=b:FindFirstChild("Ind")
        if ind then ind.BackgroundTransparency=on and 0 or 1 end
    end
end

local tabDefs={
    {name="Dashboard", icon="◈"},
    {name="Log",       icon="≡"},
    {name="Whitelist", icon="⊞"},
    {name="Settings",  icon="⊙"},
}

for _,t in ipairs(tabDefs) do
    local b=Instance.new("TextButton"); b.Name=t.name
    b.Text="  "..t.icon.."  "..t.name; b.Size=UDim2.new(1,0,0,S(36))
    b.BackgroundColor3=C.sidebar; b.TextColor3=C.tSec; b.TextSize=S(12)
    b.Font=Enum.Font.GothamBold; b.TextXAlignment=Enum.TextXAlignment.Left
    b.BorderSizePixel=0; b.Parent=TabList
    Instance.new("UICorner",b).CornerRadius=UDim.new(0, S(9))
    local ind=Instance.new("Frame"); ind.Name="Ind"; ind.Size=UDim2.new(0, S(3), 0.55, 0)
    ind.Position=UDim2.new(0, S(1), 0.225, 0); ind.BackgroundColor3=C.a1
    ind.BorderSizePixel=0; ind.BackgroundTransparency=1; ind.Parent=b
    Instance.new("UICorner",ind).CornerRadius=UDim.new(1,0)
    TabBtns[t.name]=b; makePage(t.name)
    b.MouseButton1Click:Connect(function() switchTab(t.name) end)
end

-- Bottom sidebar buttons
local function sideBtnF(text,y,bg,tc)
    local b=Instance.new("TextButton"); b.Text=text
    b.Size=UDim2.new(1, S(-16), 0, S(28)); b.Position=UDim2.new(0, S(8), 1, S(y))
    b.BackgroundColor3=bg; b.TextColor3=tc; b.TextSize=S(11)
    b.Font=Enum.Font.GothamBold; b.BorderSizePixel=0; b.Parent=Sidebar
    Instance.new("UICorner",b).CornerRadius=UDim.new(0, S(8)); return b
end
local saveBtn  = sideBtnF("Save Config",  -94, Color3.fromRGB(12,20,36), C.a2)
local minBtn   = sideBtnF("Minimize",     -62, Color3.fromRGB(18,14,30), C.tSec)
local closeBtn = sideBtnF("Close",        -28, Color3.fromRGB(36,10,16), Color3.fromRGB(180,75,85))

saveBtn.MouseButton1Click:Connect(function()
    saveConfig()
    saveBtn.Text="Saved ✓"
    saveBtn.TextColor3=C.green
    task.delay(2,function()
        saveBtn.Text="Save Config"
        saveBtn.TextColor3=C.a2
    end)
end)
minBtn.MouseButton1Click:Connect(function() setMinimized(true) end)
closeBtn.MouseButton1Click:Connect(function()
    if wsConnection then pcall(function() wsConnection:Close() end) end
    SG:Destroy()
end)

-- ─────────────────────────────────────────────
-- UI HELPERS
-- ─────────────────────────────────────────────
local function card(parent,x,y,w,h)
    local f=Instance.new("Frame"); f.Size=UDim2.new(0, S(w), 0, S(h))
    f.Position=UDim2.new(0, S(x), 0, S(y)); f.BackgroundColor3=C.card
    f.BorderSizePixel=0; f.Parent=parent
    Instance.new("UICorner",f).CornerRadius=UDim.new(0, S(11))
    local s=Instance.new("UIStroke"); s.Color=C.stroke; s.Thickness=1; s.Parent=f
    return f,s
end

local function lbl(parent,text,x,y,w,h,sz,font,col,align)
    local l=Instance.new("TextLabel"); l.Text=text
    l.Size=UDim2.new(0, S(w), 0, S(h)); l.Position=UDim2.new(0, S(x), 0, S(y))
    l.BackgroundTransparency=1; l.TextColor3=col or C.tSec
    l.TextSize=S(sz or 11); l.Font=font or Enum.Font.Gotham
    l.TextXAlignment=align or Enum.TextXAlignment.Left; l.Parent=parent; return l
end

local function mkToggle(parent,x,y,initVal,onChange)
    local on=initVal
    local track=Instance.new("Frame"); track.Size=UDim2.new(0, S(44), 0, S(24))
    track.Position=UDim2.new(1, S(x), 0, S(y))
    track.BackgroundColor3=on and C.a1 or Color3.fromRGB(26,20,46)
    track.BorderSizePixel=0; track.Parent=parent
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
    local thumb=Instance.new("Frame"); thumb.Size=UDim2.new(0, S(18), 0, S(18))
    thumb.Position=on and UDim2.new(1, S(-21), 0.5, S(-9)) or UDim2.new(0, S(3), 0.5, S(-9))
    thumb.BackgroundColor3=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,55,110)
    thumb.BorderSizePixel=0; thumb.Parent=track
    Instance.new("UICorner",thumb).CornerRadius=UDim.new(1,0)
    local tbtn=Instance.new("TextButton"); tbtn.Size=UDim2.new(1,0,1,0)
    tbtn.BackgroundTransparency=1; tbtn.Text=""; tbtn.Parent=track
    local ti=TweenInfo.new(0.15,Enum.EasingStyle.Quad)
    tbtn.MouseButton1Click:Connect(function()
        on=not on
        TweenService:Create(track,ti,{BackgroundColor3=on and C.a1 or Color3.fromRGB(26,20,46)}):Play()
        TweenService:Create(thumb,ti,{
            Position=on and UDim2.new(1, S(-21), 0.5, S(-9)) or UDim2.new(0, S(3), 0.5, S(-9)),
            BackgroundColor3=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,55,110)
        }):Play()
        if onChange then onChange(on) end
    end)
    return track,thumb
end

-- ─────────────────────────────────────────────
-- SHARED STATE REFS
-- ─────────────────────────────────────────────
local wsConnection
local statDotRef,statTextRef
local statCounts={seen=0,joined=0,skipped=0}
local statNumRefs={}
local lastNameRef,lastMetaRef,peakNameRef,peakMoneyRef
local peakMoney=0
local selectedRetries=cfg.retryIndex

local function setStatus(text,col)
    if statTextRef then statTextRef.Text=text end
    if statDotRef  then statDotRef.BackgroundColor3=col end
    pillDot.BackgroundColor3=col
end

local function bumpStat(k)
    statCounts[k]+=1
    if statNumRefs[k] then statNumRefs[k].Text=tostring(statCounts[k]) end
    pillText.Text="Laced  ·  "..statCounts.seen.." servers"
end

-- ══════════════════════════════════════════════
-- DASHBOARD PAGE
-- ══════════════════════════════════════════════
local dash=Pages["Dashboard"]
local CW=610

lbl(dash,"Dashboard",16,12,300,22,16,Enum.Font.GothamBold,C.tPrim)
lbl(dash,"Live server monitoring",16,32,300,13,10,Enum.Font.Gotham,C.tMut)

-- Status card
local sc=card(dash,16,54,CW,52)
local dot=Instance.new("Frame"); dot.Size=UDim2.new(0, S(9), 0, S(9))
dot.Position=UDim2.new(0, S(14), 0.5, S(-4)); dot.BackgroundColor3=C.red
dot.BorderSizePixel=0; dot.Parent=sc
Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
statDotRef=dot
lbl(sc,"CONNECTION",30,8,160,11,9,Enum.Font.GothamBold,C.tMut)
statTextRef=lbl(sc,"Disconnected",30,24,280,16,13,Enum.Font.GothamBold,C.tPrim)

-- Stats row
local colW=math.floor((CW-48)/3)
local statDefs={{key="seen",label="SEEN",col=C.a2},{key="joined",label="JOINED",col=C.green},{key="skipped",label="SKIPPED",col=C.tSec}}
for i,s in ipairs(statDefs) do
    local sc2=card(dash,16+(i-1)*(colW+8),116,colW,62)
    statNumRefs[s.key]=lbl(sc2,"0",0,8,colW,28,20,Enum.Font.GothamBold,s.col,Enum.TextXAlignment.Center)
    lbl(sc2,s.label,0,40,colW,12,9,Enum.Font.GothamBold,C.tMut,Enum.TextXAlignment.Center)
end

-- Last server + peak row
local hw=math.floor((CW-24)/2)
local lc=card(dash,16,190,hw,68)
lbl(lc,"LAST SERVER",14,8,200,11,9,Enum.Font.GothamBold,C.tMut)
lastNameRef=lbl(lc,"Waiting...",14,22,hw-28,18,13,Enum.Font.GothamBold,C.tPrim)
lastMetaRef=lbl(lc,"",14,44,hw-28,13,10,Enum.Font.Gotham,C.tSec)

local pc=card(dash,hw+24,190,hw,68)
lbl(pc,"SESSION PEAK",14,8,200,11,9,Enum.Font.GothamBold,C.tMut)
peakNameRef=lbl(pc,"—",14,22,hw-110,18,13,Enum.Font.GothamBold,C.gold)
peakMoneyRef=lbl(pc,"—",14,44,hw-28,13,10,Enum.Font.Gotham,C.tSec)

-- Whitelist indicator on dashboard
local wlIndicator=card(dash,16,272,CW,36)
local wlDot2=Instance.new("Frame"); wlDot2.Size=UDim2.new(0, S(8), 0, S(8))
wlDot2.Position=UDim2.new(0, S(14), 0.5, S(-4)); wlDot2.BackgroundColor3=C.tMut
wlDot2.BorderSizePixel=0; wlDot2.Parent=wlIndicator
Instance.new("UICorner",wlDot2).CornerRadius=UDim.new(1,0)
local wlStatusLbl=lbl(wlIndicator,"Whitelist: OFF — joining all servers",30,0,500,36,11,Enum.Font.GothamBold,C.tSec)

local function updateWLIndicator()
    if cfg.whitelistEnabled and #cfg.whitelist>0 then
        wlDot2.BackgroundColor3=C.green
        wlStatusLbl.Text="Whitelist: ON — "..#cfg.whitelist.." brainrot(s) selected"
        wlStatusLbl.TextColor3=C.green
    elseif cfg.whitelistEnabled and #cfg.whitelist==0 then
        wlDot2.BackgroundColor3=C.yellow
        wlStatusLbl.Text="Whitelist: ON — no brainrots selected (joining all)"
        wlStatusLbl.TextColor3=C.yellow
    else
        wlDot2.BackgroundColor3=C.tMut
        wlStatusLbl.Text="Whitelist: OFF — joining all servers"
        wlStatusLbl.TextColor3=C.tSec
    end
end
updateWLIndicator()

-- ══════════════════════════════════════════════
-- LOG PAGE
-- ══════════════════════════════════════════════
local logPage=Pages["Log"]
lbl(logPage,"Server Log",16,12,300,22,16,Enum.Font.GothamBold,C.tPrim)
lbl(logPage,"Inline Join / Spam buttons on each server row",16,32,400,13,10,Enum.Font.Gotham,C.tMut)

-- Retry selector
lbl(logPage,"RETRIES",380,14,60,11,9,Enum.Font.GothamBold,C.tMut)
local retryRow=Instance.new("Frame"); retryRow.Size=UDim2.new(0, S(180), 0, S(24))
retryRow.Position=UDim2.new(0, S(380), 0, S(26)); retryRow.BackgroundTransparency=1; retryRow.Parent=logPage
local rrl=Instance.new("UIListLayout"); rrl.FillDirection=Enum.FillDirection.Horizontal
rrl.Padding=UDim.new(0, S(5)); rrl.VerticalAlignment=Enum.VerticalAlignment.Center; rrl.Parent=retryRow

local retryBtns={}
local function refreshRetryBtns()
    for i,b in ipairs(retryBtns) do
        local on=(i==selectedRetries)
        b.BackgroundColor3=on and C.a1 or Color3.fromRGB(18,13,32)
        b.TextColor3=on and C.tPrim or C.tSec
    end
    cfg.retryIndex=selectedRetries
end

for i,v in ipairs(retryOptions) do
    local b=Instance.new("TextButton"); b.Text=v.."x"; b.Size=UDim2.new(0, S(32), 0, S(22))
    b.BackgroundColor3=Color3.fromRGB(18,13,32); b.TextColor3=C.tSec; b.TextSize=S(10)
    b.Font=Enum.Font.GothamBold; b.BorderSizePixel=0; b.Parent=retryRow
    Instance.new("UICorner",b).CornerRadius=UDim.new(0, S(7))
    table.insert(retryBtns,b)
    b.MouseButton1Click:Connect(function() selectedRetries=i; refreshRetryBtns() end)
end
refreshRetryBtns()

local clearBtn=Instance.new("TextButton"); clearBtn.Text="Clear"
clearBtn.Size=UDim2.new(0, S(46), 0, S(22)); clearBtn.Position=UDim2.new(1, S(-62), 0, S(26))
clearBtn.BackgroundColor3=Color3.fromRGB(20,14,32); clearBtn.TextColor3=C.tSec
clearBtn.TextSize=S(10); clearBtn.Font=Enum.Font.GothamBold; clearBtn.BorderSizePixel=0
clearBtn.Parent=logPage; Instance.new("UICorner",clearBtn).CornerRadius=UDim.new(0, S(7))

local scroll=Instance.new("ScrollingFrame"); scroll.Size=UDim2.new(1, S(-32), 1, S(-56))
scroll.Position=UDim2.new(0, S(16), 0, S(52)); scroll.BackgroundColor3=C.logBg
scroll.BorderSizePixel=0; scroll.ScrollBarThickness=2; scroll.ScrollBarImageColor3=C.a1
scroll.CanvasSize=UDim2.new(0,0,0,0); scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
scroll.Parent=logPage
Instance.new("UICorner",scroll).CornerRadius=UDim.new(0, S(11))
local ssk=Instance.new("UIStroke"); ssk.Color=C.stroke; ssk.Thickness=1; ssk.Parent=scroll
Instance.new("UIListLayout",scroll).Padding=UDim.new(0,1)
local lpad=Instance.new("UIPadding"); lpad.PaddingTop=UDim.new(0,S(4)); lpad.Parent=scroll

local function addLog(msg,col,sub,jobId)
    col=col or C.tSec
    local hasJob=jobId and jobId~=""

    local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,S(36))
    row.BackgroundColor3=C.logBg; row.BorderSizePixel=0; row.Parent=scroll

    local rowHitbox=Instance.new("TextButton"); rowHitbox.Size=UDim2.new(1,0,1,0)
    rowHitbox.BackgroundTransparency=1; rowHitbox.Text=""; rowHitbox.ZIndex=1; rowHitbox.Parent=row
    rowHitbox.MouseEnter:Connect(function()
        TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.rowHov}):Play()
    end)
    rowHitbox.MouseLeave:Connect(function()
        TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.logBg}):Play()
    end)

    local time=Instance.new("TextLabel"); time.Text=ts()
    time.Size=UDim2.new(0, S(56), 1, 0); time.Position=UDim2.new(0, S(8), 0, 0)
    time.BackgroundTransparency=1; time.TextColor3=C.tMut; time.TextSize=S(9)
    time.Font=Enum.Font.Gotham; time.ZIndex=2; time.Parent=row

    local btnW=hasJob and S(162) or 0
    local txt=Instance.new("TextLabel"); txt.Text=msg
    txt.Size=UDim2.new(1, -(S(68)+btnW), 1, 0); txt.Position=UDim2.new(0, S(66), 0, 0)
    txt.BackgroundTransparency=1; txt.TextColor3=col; txt.TextSize=S(11)
    txt.Font=sub and Enum.Font.Gotham or Enum.Font.GothamBold
    txt.TextTruncate=Enum.TextTruncate.AtEnd; txt.TextXAlignment=Enum.TextXAlignment.Left
    txt.ZIndex=2; txt.Parent=row

    local div=Instance.new("Frame"); div.Size=UDim2.new(1,0,0,1)
    div.Position=UDim2.new(0,0,1,-1); div.BackgroundColor3=C.stroke
    div.BorderSizePixel=0; div.ZIndex=2; div.Parent=row

    if hasJob then
        -- Join button
        local jb=Instance.new("TextButton"); jb.Text="Join"
        jb.Size=UDim2.new(0, S(52), 0, S(22)); jb.Position=UDim2.new(1, S(-164), 0.5, S(-11))
        jb.BackgroundColor3=C.a1; jb.TextColor3=Color3.fromRGB(255,255,255)
        jb.TextSize=S(10); jb.Font=Enum.Font.GothamBold; jb.BorderSizePixel=0
        jb.ZIndex=3; jb.Parent=row
        Instance.new("UICorner",jb).CornerRadius=UDim.new(0, S(7))
        local jg=Instance.new("UIGradient"); jg.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,C.a3),ColorSequenceKeypoint.new(1,C.a1)
        }); jg.Rotation=90; jg.Parent=jb

        jb.MouseButton1Click:Connect(function()
            jb.Text="..."
            task.delay(0.4,function()
                pcall(function()
                    TeleportService:TeleportToPlaceInstance(PLACE_ID,jobId,Players.LocalPlayer)
                end)
                jb.Text="Sent"; jb.BackgroundColor3=C.green
            end)
        end)

        -- Spam button
        local spamming=false
        local sb=Instance.new("TextButton")
        sb.Text=retryOptions[selectedRetries].."x Spam"
        sb.Size=UDim2.new(0, S(80), 0, S(22)); sb.Position=UDim2.new(1, S(-104), 0.5, S(-11))
        sb.BackgroundColor3=Color3.fromRGB(18,13,32); sb.TextColor3=C.orange
        sb.TextSize=S(10); sb.Font=Enum.Font.GothamBold; sb.BorderSizePixel=0
        sb.ZIndex=3; sb.Parent=row
        Instance.new("UICorner",sb).CornerRadius=UDim.new(0, S(7))
        local ssk2=Instance.new("UIStroke"); ssk2.Color=C.orange; ssk2.Thickness=1; ssk2.Parent=sb

        local stopB=Instance.new("TextButton"); stopB.Text="Stop"
        stopB.Size=UDim2.new(0, S(36), 0, S(22)); stopB.Position=UDim2.new(1, S(-40), 0.5, S(-11))
        stopB.BackgroundColor3=Color3.fromRGB(36,10,16); stopB.TextColor3=C.red
        stopB.TextSize=S(10); stopB.Font=Enum.Font.GothamBold; stopB.BorderSizePixel=0
        stopB.Visible=false; stopB.ZIndex=3; stopB.Parent=row
        Instance.new("UICorner",stopB).CornerRadius=UDim.new(0, S(7))
        local stopSk=Instance.new("UIStroke"); stopSk.Color=C.red; stopSk.Thickness=1; stopSk.Parent=stopB

        sb.MouseButton1Click:Connect(function()
            if spamming then return end
            spamming=true; stopB.Visible=true
            local ret=retryOptions[selectedRetries]
            task.spawn(function()
                for i=1,ret do
                    if not spamming then break end
                    sb.Text=i.."/"..ret
                    pcall(function()
                        TeleportService:TeleportToPlaceInstance(PLACE_ID,jobId,Players.LocalPlayer)
                    end)
                    task.wait(0.8)
                end
                spamming=false; stopB.Visible=false
                sb.Text="Done"; sb.TextColor3=C.green
            end)
        end)

        stopB.MouseButton1Click:Connect(function()
            spamming=false; stopB.Visible=false
            sb.Text=retryOptions[selectedRetries].."x Spam"; sb.TextColor3=C.orange
        end)
    end

    task.defer(function() scroll.CanvasPosition=Vector2.new(0,math.huge) end)
end

clearBtn.MouseButton1Click:Connect(function()
    for _,c in ipairs(scroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
end)

-- ══════════════════════════════════════════════
-- WHITELIST PAGE
-- ══════════════════════════════════════════════
local wlPage=Pages["Whitelist"]
lbl(wlPage,"Whitelist",16,12,300,22,16,Enum.Font.GothamBold,C.tPrim)
lbl(wlPage,"Only auto-join servers containing selected brainrots",16,32,500,13,10,Enum.Font.Gotham,C.tMut)

-- Toggle row
local wlToggleCard=card(wlPage,16,54,CW,44)
lbl(wlToggleCard,"ENABLE WHITELIST",14,8,260,11,9,Enum.Font.GothamBold,C.tMut)
lbl(wlToggleCard,"When ON, only joins servers with whitelisted brainrots",14,22,360,14,11,Enum.Font.Gotham,C.tSec)
mkToggle(wlToggleCard,-58,10,cfg.whitelistEnabled,function(v)
    cfg.whitelistEnabled=v; saveConfig(); updateWLIndicator()
end)

-- Search box
local searchBG=Instance.new("Frame"); searchBG.Size=UDim2.new(0, S(CW), 0, S(30))
searchBG.Position=UDim2.new(0, S(16), 0, S(108)); searchBG.BackgroundColor3=C.deep
searchBG.BorderSizePixel=0; searchBG.Parent=wlPage
Instance.new("UICorner",searchBG).CornerRadius=UDim.new(0, S(8))
local searchSk=Instance.new("UIStroke"); searchSk.Color=C.stroke; searchSk.Thickness=1; searchSk.Parent=searchBG

local searchBox=Instance.new("TextBox"); searchBox.Size=UDim2.new(1, S(-12), 1, 0)
searchBox.Position=UDim2.new(0, S(8), 0, 0); searchBox.BackgroundTransparency=1
searchBox.TextColor3=C.tPrim; searchBox.PlaceholderText="Search brainrots..."
searchBox.PlaceholderColor3=C.tMut; searchBox.TextSize=S(11); searchBox.Font=Enum.Font.Gotham
searchBox.TextXAlignment=Enum.TextXAlignment.Left; searchBox.ClearTextOnFocus=false
searchBox.Parent=searchBG
searchBox.Focused:Connect(function()
    TweenService:Create(searchSk,TweenInfo.new(0.15),{Color=C.a1}):Play()
end)
searchBox.FocusLost:Connect(function()
    TweenService:Create(searchSk,TweenInfo.new(0.15),{Color=C.stroke}):Play()
end)

-- Selected count label
local selCountLbl=lbl(wlPage,"0 selected",CW-80,112,80,14,10,Enum.Font.GothamBold,C.tMut,Enum.TextXAlignment.Right)

local function updateSelCount()
    local n=#cfg.whitelist
    selCountLbl.Text=n.." selected"
    selCountLbl.TextColor3=n>0 and C.green or C.tMut
    updateWLIndicator()
end

-- Clear selection button
local clrSelBtn=Instance.new("TextButton"); clrSelBtn.Text="Clear All"
clrSelBtn.Size=UDim2.new(0, S(70), 0, S(22)); clrSelBtn.Position=UDim2.new(1, S(-90), 0, S(108))
clrSelBtn.BackgroundColor3=Color3.fromRGB(20,14,32); clrSelBtn.TextColor3=C.tSec
clrSelBtn.TextSize=S(10); clrSelBtn.Font=Enum.Font.GothamBold; clrSelBtn.BorderSizePixel=0
clrSelBtn.Parent=wlPage; Instance.new("UICorner",clrSelBtn).CornerRadius=UDim.new(0, S(7))

-- Brainrot grid scroll
local wlScroll=Instance.new("ScrollingFrame"); wlScroll.Size=UDim2.new(1, S(-32), 1, S(-148))
wlScroll.Position=UDim2.new(0, S(16), 0, S(146)); wlScroll.BackgroundColor3=C.deep
wlScroll.BorderSizePixel=0; wlScroll.ScrollBarThickness=2; wlScroll.ScrollBarImageColor3=C.a1
wlScroll.CanvasSize=UDim2.new(0,0,0,0); wlScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
wlScroll.Parent=wlPage
Instance.new("UICorner",wlScroll).CornerRadius=UDim.new(0, S(10))
local wlSk2=Instance.new("UIStroke"); wlSk2.Color=C.stroke; wlSk2.Thickness=1; wlSk2.Parent=wlScroll

local wlGrid=Instance.new("Frame"); wlGrid.Size=UDim2.new(1, S(-12), 0, 0)
wlGrid.Position=UDim2.new(0, S(6), 0, S(6)); wlGrid.BackgroundTransparency=1
wlGrid.AutomaticSize=Enum.AutomaticSize.Y; wlGrid.Parent=wlScroll

local wlLayout=Instance.new("UIGridLayout"); wlLayout.CellSize=UDim2.new(0, S(190), 0, S(28))
wlLayout.CellPadding=UDim2.new(0, S(6), 0, S(4)); wlLayout.Parent=wlGrid

local wlBtnRefs={}

local function isWhitelisted(name)
    for _,w in ipairs(cfg.whitelist) do
        if w==name then return true end
    end
    return false
end

local function toggleWhitelist(name)
    local found=false
    for i,w in ipairs(cfg.whitelist) do
        if w==name then table.remove(cfg.whitelist,i); found=true; break end
    end
    if not found then table.insert(cfg.whitelist,name) end
    saveConfig(); updateSelCount()
end

local function refreshWLButtons(filter)
    filter=(filter or ""):lower()
    for _,child in ipairs(wlGrid:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _,name in ipairs(ALL_BRAINROTS) do
        if filter=="" or name:lower():find(filter,1,true) then
            local sel=isWhitelisted(name)
            local b=Instance.new("TextButton"); b.Text=name
            b.Size=UDim2.new(0, S(190), 0, S(28))
            b.BackgroundColor3=sel and C.a1 or Color3.fromRGB(16,12,26)
            b.TextColor3=sel and Color3.fromRGB(255,255,255) or C.tSec
            b.TextSize=S(10); b.Font=Enum.Font.GothamBold; b.BorderSizePixel=0
            b.TextTruncate=Enum.TextTruncate.AtEnd; b.Parent=wlGrid
            Instance.new("UICorner",b).CornerRadius=UDim.new(0, S(7))
            if not sel then
                local bsk=Instance.new("UIStroke"); bsk.Color=C.stroke; bsk.Thickness=1; bsk.Parent=b
            end
            b.MouseButton1Click:Connect(function()
                toggleWhitelist(name)
                local nowSel=isWhitelisted(name)
                b.BackgroundColor3=nowSel and C.a1 or Color3.fromRGB(16,12,26)
                b.TextColor3=nowSel and Color3.fromRGB(255,255,255) or C.tSec
            end)
            wlBtnRefs[name]=b
        end
    end
end

refreshWLButtons()
updateSelCount()

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    refreshWLButtons(searchBox.Text)
end)

clrSelBtn.MouseButton1Click:Connect(function()
    cfg.whitelist={}; saveConfig(); updateSelCount(); refreshWLButtons(searchBox.Text)
end)

-- ══════════════════════════════════════════════
-- SETTINGS PAGE
-- ══════════════════════════════════════════════
local sett=Pages["Settings"]
lbl(sett,"Settings",16,12,300,22,16,Enum.Font.GothamBold,C.tPrim)
lbl(sett,"Configure your notifier",16,32,300,13,10,Enum.Font.Gotham,C.tMut)

local function settCard(y,h) return card(sett,16,y,CW,h) end

-- Auto join
local ac=settCard(54,52)
lbl(ac,"AUTO JOIN",14,8,200,11,9,Enum.Font.GothamBold,C.tMut)
lbl(ac,"Automatically teleport when a qualifying server is found",14,24,380,13,11,Enum.Font.Gotham,C.tSec)
settAJTrack,settAJThumb=mkToggle(ac,-58,14,cfg.autoJoin,function(v) syncAJToggle(v) end)

-- Toast
local tc=settCard(116,52)
lbl(tc,"TOAST NOTIFICATIONS",14,8,200,11,9,Enum.Font.GothamBold,C.tMut)
lbl(tc,"Slide-in popup when a matching server is detected",14,24,380,13,11,Enum.Font.Gotham,C.tSec)
mkToggle(tc,-58,14,cfg.toastEnabled,function(v) cfg.toastEnabled=v; saveConfig() end)

-- Min money
local mc=settCard(178,84)
lbl(mc,"MINIMUM MONEY",14,8,200,11,9,Enum.Font.GothamBold,C.tMut)

local monRow=Instance.new("Frame"); monRow.Size=UDim2.new(1, S(-16), 0, S(30))
monRow.Position=UDim2.new(0, S(8), 0, S(24)); monRow.BackgroundTransparency=1; monRow.Parent=mc
local mrl=Instance.new("UIListLayout"); mrl.FillDirection=Enum.FillDirection.Horizontal
mrl.Padding=UDim.new(0, S(6)); mrl.VerticalAlignment=Enum.VerticalAlignment.Center; mrl.Parent=monRow

local moneyBtns={}
local activeFilterLbl

local function refreshMoneyBtns()
    for i,b in ipairs(moneyBtns) do
        local on=(i==cfg.minMoneyIndex)
        b.BackgroundColor3=on and C.a1 or Color3.fromRGB(18,13,32)
        b.TextColor3=on and C.tPrim or C.tSec
    end
    if activeFilterLbl then
        activeFilterLbl.Text="Active: "..moneyOptions[cfg.minMoneyIndex].label
    end
    saveConfig()
end

for i,opt in ipairs(moneyOptions) do
    local b=Instance.new("TextButton"); b.Text=opt.label; b.Size=UDim2.new(0, S(56), 0, S(28))
    b.BackgroundColor3=Color3.fromRGB(18,13,32); b.TextColor3=C.tSec; b.TextSize=S(10)
    b.Font=Enum.Font.GothamBold; b.BorderSizePixel=0; b.Parent=monRow
    Instance.new("UICorner",b).CornerRadius=UDim.new(0, S(8))
    table.insert(moneyBtns,b)
    b.MouseButton1Click:Connect(function() cfg.minMoneyIndex=i; refreshMoneyBtns() end)
end
activeFilterLbl=lbl(mc,"Active: "..moneyOptions[cfg.minMoneyIndex].label,14,62,200,13,10,Enum.Font.Gotham,C.tMut)
refreshMoneyBtns()

lbl(sett,"RightShift — toggle GUI visibility",16,274,300,13,10,Enum.Font.Gotham,C.tMut)
lbl(sett,"Config saves to LacedNotifierV2.json in your executor folder",16,290,500,13,10,Enum.Font.Gotham,C.tMut)

-- ══════════════════════════════════════════════
-- WEBSOCKET
-- ══════════════════════════════════════════════
local function connectWS()
    setStatus("Connecting...",C.yellow)
    addLog("Connecting to WebSocket...",C.yellow,true)

    local ok,ws=pcall(function() return WebSocket.connect(WS_URL) end)
    if not ok or not ws then
        setStatus("Failed",C.red)
        addLog("Connection failed. Retrying in 5s.",C.red,true)
        task.delay(5,connectWS); return
    end

    wsConnection=ws
    setStatus("Connected",C.green)
    addLog("Connected.",C.green,true)

    ws.OnMessage:Connect(function(raw)
        local cleaned=raw
        if type(cleaned)=="string" then
            if cleaned:sub(1,2)=="b'" or cleaned:sub(1,2)=='b"' then
                cleaned=cleaned:sub(3,-2)
            end
            cleaned=cleaned:gsub("\\x(%x%x)",function(h)
                return string.char(tonumber(h,16))
            end)
        end

        local ok2,data=pcall(function() return HttpService:JSONDecode(cleaned) end)
        if not ok2 or type(data)~="table" then return end

        local name    = tostring(data.name    or "Unknown")
        local players = tonumber(data.players) or 0
        local maxpl   = tonumber(data.maxplayers) or 0
        local money   = tonumber(data.money)  or 0
        local jobId   = tostring(data.jobid   or "")

        if jobId=="" then return end

        -- Whitelist check
        if not serverNameContainsWhitelisted(name) then return end

        local monStr=fmt(money)
        local line=string.format("%s  |  %d/%d  |  %s",name,players,maxpl,monStr)
        local isNew=money>peakMoney

        if isNew then
            peakMoney=money
            if peakNameRef  then peakNameRef.Text=name   end
            if peakMoneyRef then peakMoneyRef.Text=monStr end
        end

        bumpStat("seen")
        if lastNameRef then lastNameRef.Text=name end
        if lastMetaRef then lastMetaRef.Text=string.format("%d/%d players  ·  %s",players,maxpl,monStr) end

        local minVal=moneyOptions[cfg.minMoneyIndex].value
        if money>=minVal then
            addLog(line,isNew and C.gold or C.green,false,jobId)
            showToast(name,money,isNew)
            if cfg.autoJoin then
                bumpStat("joined")
                task.delay(0.5,function()
                    pcall(function()
                        TeleportService:TeleportToPlaceInstance(PLACE_ID,jobId,Players.LocalPlayer)
                    end)
                end)
            end
        else
            bumpStat("skipped")
            addLog(line,C.tMut,true)
        end
    end)

    ws.OnClose:Connect(function()
        setStatus("Disconnected",C.red)
        addLog("Disconnected. Reconnecting in 3s.",C.red,true)
        wsConnection=nil; task.delay(3,connectWS)
    end)
end

switchTab("Dashboard")
connectWS()
