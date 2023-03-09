if SERVER then
    resource.AddFile("models/gnome_grenade/gnome_grenade.mdl")
    resource.AddFile("materials/models/gnome_grenade/gnome_grenade.vmt")
    resource.AddFile("materials/vgui/ttt/icon_gnome_grenade.vtf")
    resource.AddFile("materials/vgui/ttt/icon_gnome_grenade.vmt")
    resource.AddFile("materials/entities/weapon_gnome_grenade.png")
    resource.AddFile("sound/weapons/gnome_grenade/gg_woohoohoo.wav")
    resource.AddFile("sound/weapons/gnome_grenade/gg_whmoc.wav")
    resource.AddFile("sound/weapons/gnome_grenade/gg_woo.wav")
    resource.AddFile("sound/weapons/gnome_grenade/gg_wah.wav")
    resource.AddFile("sound/weapons/gnome_grenade/gg_iag.wav")
    resource.AddFile("sound/weapons/gnome_grenade/gg_ybg.wav")
end

sound.Add( 
{
    name = "Gnome Grenade.Deploy1",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 80,
    pitch = {100, 100},
    sound = "weapons/gnome_grenade/gg_woohoohoo.wav"
})

sound.Add( 
{
    name = "Gnome Grenade.Deploy2",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 80,
    pitch = {100, 100},
    sound = "weapons/gnome_grenade/gg_whmoc.wav"
})

sound.Add( 
{
    name = "Gnome Grenade.Throw1",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 80,
    pitch = {100, 100},
    sound = "weapons/gnome_grenade/gg_woo.wav"
})

sound.Add( 
{
    name = "Gnome Grenade.Throw2",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 100,
    pitch = {100, 100},
    sound = "weapons/gnome_grenade/gg_wah.wav"
})

sound.Add( 
{
    name = "Gnome Grenade.Throw3",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 100,
    pitch = {100, 100},
    sound = "weapons/gnome_grenade/gg_iag.wav"
})

sound.Add( 
{
    name = "Gnome Grenade.Explode",
    channel = CHAN_WEAPON,
    volume = 0.8,
    level = 80,
    pitch = {100, 120},
    sound = "weapons/gnome_grenade/gg_ybg.wav"
})