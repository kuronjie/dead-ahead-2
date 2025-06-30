--!nonstrict
--[[
  Notes *added in github so nobody questions*
	- Made by @vietnamricefarmerz / @_kuronjie

	- Yes I will use Moonwave docs format for function comments sybau sygau stfu syfm
	- Read the function comments
	- Put the torpedo instance inside FilterDescendantInstances inside an OverlapParams instance since the module does not do it for you; it is designed to be as compact and performant as possible
	  remove the self.Running stuff entirely if you want micro optimizations
	- speed is NOT in studs
		- 100 speed is about 1 sps displacement

	- before questioning what the fuck a builtin roblox function does please search it up
	- i am swearing in here because it makes me a better programmer and i dont get banned if its not visible to the client

	- PUT IN SERVERSTORAGE PUT IN SERVERSTORAGE PUT IN SERVERSTORAGE PUT IN SERVERSTORAGE PUT IN SERVERSTORAGE PUT IN SERVERSTORAGE PUT IN SERVERSTORAGE PUT IN SERVERSTORAGE PUT IN SERVERSTORAGE PUT IN SERVERSTORAGE

	next questin
	how tf u even require this?

	local this = (path.to.referenceTorp)
	local Torpmodule = (path.to.Torpedomodule)

	local params = OverlapParams.new()
	OverlapParams.FilterType = Enum.RaycastFilterType.Exclude
	OverlapParams.FilterDescendantInstances = {this} -- add more parts if needed

	local torpedo = Torpmodule.new(this, damage, speed, range, params)
	torpedo:resume()
]]
local TorpedoModule = {}
TorpedoModule.__index = TorpedoModule

local RunService = game:GetService("RunService")

type Torpedo = {
	Inst: BasePart,
	Damage: number,
	Speed: number,
	Range: number,
	Filter: OverlapParams,
	
	Origin: Vector3,
	Travelled: number,
	deltaTime: number,
	Start: number,
}

--[=[
	Creates a new torpedo instance
	
	@param inst BasePart -- the part to reference the torpedo model
	@param damage number -- damage dealt when touched also i have not scripted this yet
	@param speed number -- speed of the torp
	@param range number -- maximum range of the torp
	@param filter OverlapParams -- FFS put the torpedo reference in FiltrdDsecndantInstances the module does NOT DO IT FOR YOU
	@return torp -- returns the torp instance

	AAAAAAAAAAAAHHHHHHHHHHHHHHHHHH
]=]
function TorpedoModule.new(inst: BasePart, damage: number, speed: number, range: number, filter: OverlapParams): Torpedo
	local this: Torpedo = {
		Inst = inst,
		Damage = damage,
		Speed = speed,
		Range = range,
		Filter = filter,
		
		Origin = inst.Position,
		Travelled = 0,
		deltaTime = 0,
		lastUpdate = os.clock(),
	}
	
	return setmetatable(this, TorpedoModule)
end

--[=[
	Continuously calls self.update every Heartbeat
]=]
function TorpedoModule:resume(): ()
	if self.Running then 
		return 
	end
	self.Running = true

	self.Connection = RunService.Heartbeat:ConnectParallel(function()
		self:update()
	end)
end

--[=[
	Wtf do you need ts for 🥀💔
]=]
function TorpedoModule:pause(): ()
	self.Running = false
	
	if self.Connection then
		self.Connection:Disconnect()
		self.Connection = nil
	end
end

@native
--[=[
	Updates to the next frame, use function self.resume to continuously call
]=]
function TorpedoModule:update(): ()
	local now = os.clock()
	self.deltaTime = now - self.lastUpdate
	self.lastUpdate = now
	
	now = nil
	
	task.synchronize()
	-- make upvector lookvector or rightvector if needed
	self.Inst.Position += self.Inst.CFrame.UpVector * self.Speed * self.deltaTime -- this shit took me ages to figure out why tf its accelerating instead of going at a sconstant pace

	task.desynchronize()
	self.Travelled = vector.magnitude(self.Origin - self.Inst.Position)
	if self.Travelled >= self.Range then
		task.synchronize()
		if self.Connection then
			self.Connection:Disconnect()
			self.Connection = nil
		end
		
		self.Inst:Destroy()
		
		table.clear(self)
		self = nil
		return
	end

	-- i confess, i have not actually tested this properly
	if workspace:GetPartBoundsInBox(self.Inst.CFrame, self.Inst.Size, self.Filter)[1] then
		task.synchronize()
		if self.Connection then
			self.Connection:Disconnect()
			self.Connection = nil
		end
		
		self.Inst:Destroy()
		
		table.clear(self)
		self = nil
		return
	end
end

return TorpedoModule
