SWEP.PrintName              = "Chair Thrower"
SWEP.Author                 = "The one"
SWEP.Instructions           = "Left mouse to fire a chair!"

SWEP.Spawnable              = true
SWEP.AdminOnly              = true

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.Weight			        = 5
SWEP.AutoSwitchTo		    = false
SWEP.AutoSwitchFrom		    = false

SWEP.Slot			        = 1
SWEP.SlotPos			    = 2
SWEP.DrawAmmo			    = false
SWEP.DrawCrosshair		    = true

SWEP.ViewModel			    = "models/weapons/v_pistol.mdl"
SWEP.WorldModel			    = "models/weapons/w_pistol.mdl"

local PrimShootSound    = Sound( "Metal.SawbladeStick" )
local SeconShootSound   = Sound( "Weapon_Pistol.Burst" )
local MelonSound        = Sound( "Weapon_StunStick.Melee_Hit" )

function SWEP:PrimaryAttack()

    self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )

    -- play the precached shoot sound
    self:EmitSound( PrimShootSound )

    self:ThrowChair( "models/props/cs_office/Chair_office.mdl", 10 )

end

function SWEP:SecondaryAttack()

	-- Note we don't call SetNextSecondaryFire here because it's not
	-- automatic and so we let them fire as fast as they can click.	

    -- play the precached shoot sound
    self:EmitSound( SeconShootSound )

    -- Call 'ThrowChair' on self with this model
	self:ThrowChair( "models/props_c17/FurnitureChair001a.mdl")
end

function SWEP:Reload()

    self:EmitSound( MelonSound )

    self:ThrowChair( "models/props_junk/watermelon01.mdl" )

end

-- custom chair firing functions
function SWEP:ThrowChair( model_file, amount )

    --
	-- If we're the client then this is as much as we want to do.
	-- We play the sound above on the client due to prediction.
	-- ( if we didn't they would feel a ping delay during multiplayer )
	--
    if ( CLIENT ) then return end

    -- if the amount is not set or a number assume to only fire once
    if ( type(amount) != "number" ) then
        amount = 0 -- set it to a number
    end

    for i=0, amount do
        local ent = ents.Create( "prop_physics" )

        -- always make sure that created entities are actually created
        if ( !IsValid( ent )) then return end

        ent:SetModel( model_file )

        local offset = Vector( i * 62 )
        ent:SetPos( (self.Owner:EyePos() + (self.Owner:GetAimVector() * offset)))
        ent:SetAngles( self.Owner:EyeAngles() )
        ent:Spawn()
    
        --
        -- Now get the physics object. Whenever we get a physics object
        -- we need to test to make sure its valid before using it.
        -- If it isn't then we'll remove the entity.
        --
        local phys = ent:GetPhysicsObject()
        if ( !IsValid( phys ) ) then ent:Remove() return end

        --
        -- Now we apply the force - so the chair actually throws instead 
        -- of just falling to the ground. You can play with this value here
        -- to adjust how fast we throw it.
        --
        local velocity = self.Owner:GetAimVector()
        velocity = velocity * 10000000000222222222222200000
       -- velocity = velocity + (VectorRand() * 10000000000000)
        phys:ApplyForceCenter( velocity )

        --
        -- Assuming we're playing in Sandbox mode we want to add this
        -- entity to the cleanup and undo lists. This is done like so.
        --
        cleanup.Add( self.Owner, "props", ent )
    
        undo.Create( "Thrown_Chair" )
            undo.AddEntity( ent )
            undo.SetPlayer( self.Owner )
        undo.Finish()

        -- remove objects after a timer
        timer.Simple(math.random(2, 6), function()

            if ( !IsValid(ent) ) then return end
            PrintMessage( HUD_PRINTCENTER, "Removing ent: " .. ent:GetModel() ) -- https://wiki.facepunch.com/gmod/Enums/HUD
            ent:Remove()

        end)
    end
end