AddCSLuaFile()

SWEP.Author                 = "HolyWireMod"
SWEP.Base                   = "weapon_base"
SWEP.PrintName              = "Vampiric Crowbar"
SWEP.Instructions           = [[
    Left-Click: Whack-A-Player/NPC.
    Right-Click: Does that.]]

SWEP.ViewModel              = "models/weapons/c_crowbar.mdl"
SWEP.ViewModelFlip          = false
SWEP.UseHands               = true
SWEP.WorldModel             = "models/weapons/w_crowbar.mdl"
SWEP.SetHoldType            = "melee"

SWEP.Weight                 = 5
SWEP.AutoSwitchTo           = true
SWEP.AutoSwitchFrom         = false

SWEP.Slot                   = 0
SWEP.SlotPos                = 0

SWEP.DrawAmmo               = false
SWEP.DrawCrosshair          = false

SWEP.Spawnable              = true
SWEP.AdminSpawnable         = true

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Ammo           = "none"
SWEP.Primary.Automatic      = false

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Automatic    = false

SWEP.ShouldDropOnDie        = true

local SwingSound = Sound( "Weapon_Crowbar.single" )
local HitSound = Sound ( "Weapon_Crowbar.Melee_Hit" )

function SWEP:Initialize()
    self:SetWeaponHoldType( "melee" )
end

function SWEP:PrimaryAttack()
    if ( CLIENT ) then return end

    local ply = self:GetOwner()

    ply:LagCompensation(true)

    local shootpos = ply:GetShootPos()
    local endshootpos = shootpos + ply:GetAimVector() * 70
    local tmin = Vector( 1, 1, 1 ) * -10
    local tmax = Vector( 1, 1, 1 ) * 10

    local tr = util.TraceHull({
        start = shootpos,
        endpos = endshootpos,
        filter = ply,
        mask = MASK_SHOT_HULL,
        mins, tmin,
        max = tmax } )

    if ( not IsValid( tr.Entity ) ) then 
        tr = util.TraceLine({
            start = shootpos,
            endpos = endshootpos,
            filter = ply,
            mask = MESK_SHOT_HULL } )
    end

    local ent = tr.Entity

    if ( IsValid( ent ) && ( ent:IsPlayer() || ent:IsNPC() ) && ent:Team() != ply:Team() ) then

        self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
        ply:SetAnimation( PLAYER_ATTACK1 )

        ply:EmitSound( HitSound )
        ent:SetHealth( ent:Health() - 25)
        if (ent:Health() < 1) then
            ent:Kill()
        end

        ply:SetHealth( math.Clamp( ply:Health() + 10, 1, ply:GetMaxHealth() ) )

    elseif ( !IsValid( ent ) ) then

        self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
        ply:SetAnimation( PLAYER_ATTACK1 )

        ply:EmitSound( SwingSound )

    end

    self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() + 0.1 )

    ply:LagCompensation(false)

end

function SWEP:CanSecondaryAttack()
    return false
end