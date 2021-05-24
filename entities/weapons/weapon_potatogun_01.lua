AddCSLuaFile()

SWEP.Author                 = "Rebelion"
SWEP.Base                   = "weapon_base"
SWEP.PrintName              = "Potato Gun"
SWEP.Instructions           = [[
    Left-Click: Does this.
    Right-Click: Does that.]]

SWEP.ViewModel              = "models/weapons/c_potatogun_01.mdl"
SWEP.ViewModelFlip          = false
SWEP.UseHands               = true
SWEP.WorldModel             = "models/weapons/w_357.mdl"
SWEP.SetHoldType            = "pistol"

SWEP.Weight                 = 3
SWEP.AutoSwitchTo           = true
SWEP.AutoSwitchFrom         = false

SWEP.Slot                   = 2
SWEP.SlotPos                = 0

SWEP.DrawAmmo               = false
SWEP.DrawCrosshair          = true

SWEP.Spawnable              = true
SWEP.AdminSpawnable         = true

SWEP.Primary.ClipSize       = 34
SWEP.Primary.Default        = 400
SWEP.Primary.Ammo           = "SMG1"
SWEP.Primary.Automatic      = true
SWEP.Primary.Recoil         = 0.1
SWEP.Primary.Damage         = 24
SWEP.Primary.NumShots       = 1
SWEP.Primary.Spread         = 0.05
SWEP.Primary.Cone           = 0
SWEP.Primary.Delay          = 0.1

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Automatic    = false

SWEP.ShouldDropOnDie        = true

local PrimaryShootSound = Sound( "effects/round_start_01.wav" )
local SecondaryShootSound = Sound( "Cardboard.ImpactSoft" )

function SWEP:Initialize()
    self:SetHoldType( "smg" )
end

function SWEP:PrimaryAttack()
    if ( not self:CanPrimaryAttack() ) then
        return
    end

    local ply = self:GetOwner()

    self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

    ply:LagCompensation( true )

    local Bullet = {}
        Bullet.Num          = self.Primary.NumShots
        Bullet.Src          = ply:GetShootPos()
        Bullet.Dir          = ply:GetAimVector()
        Bullet.Spread       = Vector( self.Primary.Spread, self.Primary.Spread, 0 )
        Bullet.Tracer       = 1
        Bullet.Damage       = self.Primary.Damage
        Bullet.AmmoType     = self.Primary.Ammo

    
    self:FireBullets( Bullet )
    
    self:ShootEffects()

    self:EmitSound( PrimaryShootSound, 75, math.random(25, 400)  )
    self.BaseClass.ShootEffects( self ) 
    self:TakePrimaryAmmo( 1 )
    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

    ply:LagCompensation( false )

end

function SWEP:SecondaryAttack()

    self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    self:EmitSound( SecondaryShootSound )

    self:ThrowChair( "models/props_junk/watermelon01.mdl" )

end

-- custom chair firing functions
function SWEP:ThrowChair( model_file )

    --
	-- If we're the client then this is as much as we want to do.
	-- We play the sound above on the client due to prediction.
	-- ( if we didn't they would feel a ping delay during multiplayer )
	--
    if ( CLIENT ) then return end

    local ent = ents.Create( "prop_physics" )

    -- always make sure that created entities are actually created
    if ( !IsValid( ent )) then return end

    ent:SetModel( model_file )

    local offset = 16.0
    ent:SetPos( (self.Owner:EyePos() + (self.Owner:GetAimVector() * offset)))
    ent:SetAngles( self.Owner:EyeAngles() )
    ent:Spawn()

    local phys = ent:GetPhysicsObject()
    if ( !IsValid( phys ) ) then ent:Remove() return end

    local velocity = self.Owner:GetAimVector()
    phys:ApplyForceCenter( velocity * 10000 )

    -- remove objects after a timer
    timer.Simple(math.random(4, 8), function()

        if ( !IsValid(ent) ) then return end
        ent:Remove()

    end)
end

function SWEP:ShouldDropOnDie()
    return true
end