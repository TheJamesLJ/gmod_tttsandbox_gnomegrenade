AddCSLuaFile()

ENT.Type = "anim"
ENT.Model = Model("models/gnome_grenade/gnome_grenade.mdl")
ENT.gg_ybg_played = false

AccessorFunc(ENT, "thrower", "Thrower")
AccessorFunc(ENT, "radius", "Radius", FORCE_NUMBER)
AccessorFunc(ENT, "dmg", "Dmg", FORCE_NUMBER)

CreateConVar("gnome_grenade_detonate_timer", 4, {FCVAR_ARCHIVE,FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE}, "Specify how long the Gnome Grenade will take to explode once thrown. Min: 1 - Max: 10 - Default: 4", 1, 10)
CreateConVar("gnome_grenade_explosion_radius", 600, {FCVAR_ARCHIVE,FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE}, "Specify the damage radius of the Gnome Grenade when exploding. Min: 100 - Max: 1000 - Default: 600", 100, 1000)
CreateConVar("gnome_grenade_explosion_damage", 250, {FCVAR_ARCHIVE,FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE}, "Specify the damage the Gnome Grenade will cause on explosion. Min: 25 - Max: 500 - Default: 250", 25, 500)

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "ExplodeTime")
    self:NetworkVar("Float", 1, "GnomedTime")
end

function ENT:Initialize()
    self:SetRadius(GetConVar("gnome_grenade_explosion_radius"):GetInt())
    self:SetDmg(GetConVar("gnome_grenade_explosion_damage"):GetInt())

    self:SetModel(self.Model)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_BBOX)
    self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

    self.Entity:EmitSound("Gnome Grenade.Throw" .. math.random(1,3))

    if SERVER then
        self:SetExplodeTime(0)
        self:SetGnomedTime(0)
        self:SetDetonateTimer(GetConVar("gnome_grenade_detonate_timer"):GetInt())
    end
end

function ENT:SetDetonateTimer(length)
    self:SetDetonateExact(CurTime() + length)
    self:SetGnomedTime(CurTime() + (length - 2))
end
 
function ENT:SetDetonateExact(t)
    self:SetExplodeTime(t or CurTime())
end

function ENT:Explode(tr)
    if SERVER then
        self:SetNoDraw(true)
        self:SetSolid(SOLID_NONE)

        -- pull out of the surface
        if tr.Fraction != 1.0 then
            self:SetPos(tr.HitPos + tr.HitNormal * 0.6)
        end

        local pos = self:GetPos()

        local effect = EffectData()
        effect:SetStart(pos)
        effect:SetOrigin(pos)
        effect:SetScale(self:GetRadius() * 0.4)
        effect:SetRadius(self:GetRadius())
        effect:SetMagnitude(self.dmg)

        if tr.Fraction != 1.0 then
            effect:SetNormal(tr.HitNormal)
        end

        util.Effect("Explosion", effect, true, true)
        util.Effect("cball_explode", effect, true, true)
        util.BlastDamage(self, self:GetThrower(), pos, self:GetRadius(), self:GetDmg())

        self:SetDetonateExact(0)

        self:Remove()
    else
        local spos = self:GetPos()
        local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
        util.Decal("SmallScorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)      

        self:SetDetonateExact(0)
    end
end
 
function ENT:Think()
    local etime = self:GetExplodeTime() or 0
    local ybgtime = self:GetGnomedTime() or 0

    if SERVER then
        if ybgtime != 0 and ybgtime < CurTime() then
            if !self.gg_ybg_played then
                self.gg_ybg_played = true
                self.Entity:EmitSound("Gnome Grenade.Explode")
            end
        end
    end

    if etime != 0 and etime < CurTime() then
        -- if thrower disconnects before grenade explodes, just don't explode
        if SERVER and (not IsValid(self:GetThrower())) then
            self:Remove()
            etime = 0
            return
        end

        -- find the ground if it's near and pass it to the explosion
        local spos = self:GetPos()
        local tr = util.TraceLine({start=spos, endpos=spos + Vector(0,0,-32), mask=MASK_SHOT_HULL, filter=self.thrower})

        local success, err = pcall(self.Explode, self, tr)
        if not success then
            -- prevent effect spam on Lua error
            self:Remove()
            ErrorNoHalt("ERROR CAUGHT: gnome_grenade: " .. err .. "\n")
        end
    end
end