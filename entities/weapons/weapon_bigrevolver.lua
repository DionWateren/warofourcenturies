AddCSLuaFile()

SWEP.Author                 = "Rebelion"
SWEP.Base                   = "weapon_base"
SWEP.PrintName              = "Big Automatic Revolver"
SWEP.Instructions           = [[
    Left-Click: Does this.
    Right-Click: Does that.]]

SWEP.ViewModel              = "models/weapons/c_357.mdl"
SWEP.ViewModelFlip          = false
SWEP.UseHands               = true
SWEP.WorldModel             = "models/weapons/w_357.mdl"
SWEP.SetHoldType            = "pistol"

SWEP.Weight                 = 225
SWEP.AutoSwitchTo           = true
SWEP.AutoSwitchFrom         = false

SWEP.Slot                   = 1
SWEP.SlotPos                = 0

SWEP.DrawAmmo               = true
SWEP.DrawCrosshair          = true

SWEP.Spawnable              = true
SWEP.AdminSpawnable         = true

SWEP.Primary.ClipSize       = 20004
SWEP.Primary.Default        = 24
SWEP.Primary.Ammo           = "357"
SWEP.Primary.Automatic      = true
SWEP.Primary.Recoil         = 1
SWEP.Primary.Damage         = 10
SWEP.Primary.NumShots       = 10000
SWEP.Primary.Spread         = 0.6
SWEP.Primary.Cone           = 0
SWEP.Primary.Delay          = 0.01

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Automatic    = false

SWEP.ShouldDropOnDie        = true

local ShootSound = Sound("Weapon_357.single")

function SWEP:Initialize()
    self:SetHoldType( "pistol" )
end

function SWEP:PrimaryAttack()
    if ( not self:CanPrimaryAttack() ) then return end

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

function SWEP:SecondaryAttack()
    if ( not self:CanSecondaryAttack() ) then return end

    if (SERVER) then
        for i=0, 1 do
            for x=0, 0 do
                local ent = ents.Create( "rpg_missile" )
                ent:SetModel( "models/props_junk/watermelon01.mdl" )

                -- always make sure that created entities are actually created
                if ( !IsValid( ent )) then return end

                local offset = Vector( 62, 100 + x * 202, 100 + i * 202 )
                ent:SetPos( (self.Owner:EyePos() + (self.Owner:GetAimVector() * offset)))
                
                ent:SetAngles(self.Owner:EyeAngles())

                ent:SetSaveValue( "m_flDamage", 200 )

                ent:Spawn()
                ent:Activate()
                ent:SetOwner( self.Owner )
            end
        end 
    end 

end

function SWEP:CanSecondaryAttack()
    return true
end

function SWEP:ShouldDropOnDie()
    return true
end