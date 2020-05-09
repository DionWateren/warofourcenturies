AddCSLuaFile()

SWEP.Author                 = "Nido"
SWEP.Base                   = "weapon_base"
SWEP.PrintName              = "Weird SMG"
SWEP.Instructions           = [[
    Left-Click: Does this.
    Right-Click: Does that.]]

SWEP.ViewModel              = "models/weapons/c_smg1.mdl"
SWEP.ViewModelFlip          = false
SWEP.UseHands               = true
SWEP.WorldModel             = "models/weapons/w_smg1.mdl"
SWEP.SetHoldType            = "smg"

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

local ShootSound = Sound( "effects/fire_slow_0.mp3" )

function SWEP:Initialize()
    self:SetHoldType( "smg" )
end

function SWEP:PrimaryAttack()
    if ( not self:CanPrimaryAttack() ) then
        return
    end

    local ply = self:GetOwner()

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

    self:EmitSound( ShootSound )
    self.BaseClass.ShootEffects( self ) 
    self:TakePrimaryAmmo( 1 )
    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

    ply:LagCompensation( false )

end

function SWEP:CanSecondaryAttack()
    return false
end

function SWEP:ShouldDropOnDie()
    return true
end