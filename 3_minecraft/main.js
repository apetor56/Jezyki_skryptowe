function makeWallGround (offsetXZ: number, hightOffset: number) {
    blocks.fill(
    DIORITE,
    world(posX - outerFloorSizeX - outerWallOffset + offsetXZ, posY - 1, offsetZ - outerWallOffset + offsetXZ),
    world(posX + outerFloorSizeX + outerWallOffset - offsetXZ, posY - 1 + wallHeight - hightOffset, offsetZ + outerWallOffset + outerFloorSizeZ - offsetXZ),
    FillOperation.Hollow
    )
    blocks.fill(
    AIR,
    world(posX - outerFloorSizeX - outerWallOffset + offsetXZ, posY + wallHeight - 1 - hightOffset, offsetZ - outerWallOffset + offsetXZ),
    world(posX + outerFloorSizeX + outerWallOffset - offsetXZ, posY + wallHeight - 1 - hightOffset, offsetZ + outerWallOffset + outerFloorSizeZ - offsetXZ),
    FillOperation.Replace
    )
}
function clearWorld () {
    for (let indeks = 0; indeks <= 50; indeks++) {
        blocks.fill(
        AIR,
        world(50, posY + indeks, 1),
        world(-50, posY + indeks, 80),
        FillOperation.Replace
        )
    }
    for (let indeks2 = 1; indeks2 <= 5; indeks2++) {
        blocks.fill(
        GRASS,
        world(posX - 50, posY - indeks2, posZ - 10),
        world(posX + 50, posY - indeks2, posZ + 90),
        FillOperation.Replace
        )
    }
}
function makeBrigde () {
    brigdeWidth = 3
    blocks.fill(
    PLANKS_SPRUCE,
    world(posX + brigdeWidth, posY - 1, offsetZ - outerWallOffset - fossOffset - 1),
    world(posX - brigdeWidth, posY - 1, offsetZ - outerWallOffset + edgeOffset),
    FillOperation.Replace
    )
    blocks.fill(
    PLANKS_DARK_OAK,
    world(posX + brigdeWidth, posY - 1, offsetZ - outerWallOffset - fossOffset - 1),
    world(posX + brigdeWidth, posY, offsetZ - outerWallOffset + edgeOffset),
    FillOperation.Replace
    )
    blocks.fill(
    PLANKS_DARK_OAK,
    world(posX - brigdeWidth, posY - 1, offsetZ - outerWallOffset - fossOffset - 1),
    world(posX - brigdeWidth, posY, offsetZ - outerWallOffset + edgeOffset),
    FillOperation.Replace
    )
}
function makeOuterFloor () {
    blocks.fill(
    OBSIDIAN,
    world(posX - outerFloorSizeX, posY - 1, offsetZ),
    world(posX + outerFloorSizeX, posY - 1, offsetZ + outerFloorSizeZ),
    FillOperation.Replace
    )
}
function makeFoss () {
    fossOffset = 9
    edgeOffset = 3
    blocks.replace(
    AIR,
    GRASS,
    world(posX + outerFloorSizeX + outerWallOffset + fossOffset, posY - 1, posZ + offsetZ - outerWallOffset - fossOffset),
    world(posX - outerFloorSizeX - outerWallOffset - fossOffset, posY - 4, posZ + offsetZ + outerFloorSizeZ + outerWallOffset + fossOffset)
    )
    blocks.replace(
    WATER,
    AIR,
    world(posX + outerFloorSizeX + outerWallOffset + fossOffset, posY - 1, posZ + offsetZ - outerWallOffset - fossOffset),
    world(posX - outerFloorSizeX - outerWallOffset - fossOffset, posY - 4, posZ + offsetZ + outerFloorSizeZ + outerWallOffset + fossOffset)
    )
    blocks.replace(
    BEDROCK,
    WATER,
    world(posX + outerFloorSizeX + outerWallOffset + edgeOffset, posY - 1, posZ + offsetZ - outerWallOffset - edgeOffset),
    world(posX - outerFloorSizeX - outerWallOffset - edgeOffset, posY - 4, posZ + offsetZ + outerFloorSizeZ + outerWallOffset + edgeOffset)
    )
    blocks.replace(
    AIR,
    WATER,
    world(posX + outerFloorSizeX + outerWallOffset + fossOffset, posY - 1, posZ + offsetZ - outerWallOffset - fossOffset),
    world(posX - outerFloorSizeX - outerWallOffset - fossOffset, posY - 1, posZ + offsetZ + outerFloorSizeZ + outerWallOffset + fossOffset)
    )
}
player.onChat("run", function () {
    posX = 0
    posY = -60
    posZ = 0
    offsetZ = 18
    outerFloorSizeX = 15
    outerFloorSizeZ = 35
    wallHeight = 16
    outerWallOffset = 4
    player.say(player.position())
    player.teleport(world(posX, posY, posZ))
    clearWorld()
    makeFoss()
    makeOuterWalls()
    makeWallGround(1, 2)
    makeWallGround(2, 2)
    makeInnerWalls(3, 1)
    makeWindows(2, 3)
    makeHut(6)
    makeOuterFloor()
    makeInnerFloor(2)
    makeWallHoles()
    makeBrigde()
})
function makeOuterWalls () {
    blocks.fill(
    STONE_BRICK_MONSTER_EGG,
    world(posX - outerFloorSizeX - outerWallOffset, posY - 1, offsetZ - outerWallOffset),
    world(posX + outerFloorSizeX + outerWallOffset, posY - 1 + wallHeight, offsetZ + outerWallOffset + outerFloorSizeZ),
    FillOperation.Hollow
    )
    blocks.fill(
    AIR,
    world(posX - outerFloorSizeX - outerWallOffset, posY + wallHeight - 1, offsetZ - outerWallOffset),
    world(posX + outerFloorSizeX + outerWallOffset, posY + wallHeight - 1, offsetZ + outerWallOffset + outerFloorSizeZ),
    FillOperation.Replace
    )
}
function makeInnerWalls (offsetXZ: number, hightOffset: number) {
    blocks.fill(
    STONE,
    world(posX - outerFloorSizeX - outerWallOffset + offsetXZ, posY - 1, offsetZ - outerWallOffset + offsetXZ),
    world(posX + outerFloorSizeX + outerWallOffset - offsetXZ, posY - 1 + wallHeight - hightOffset, offsetZ + outerWallOffset + outerFloorSizeZ - offsetXZ),
    FillOperation.Hollow
    )
    blocks.fill(
    AIR,
    world(posX - outerFloorSizeX - outerWallOffset + offsetXZ, posY + wallHeight - 1 - hightOffset, offsetZ - outerWallOffset + offsetXZ),
    world(posX + outerFloorSizeX + outerWallOffset - offsetXZ, posY + wallHeight - 1 - hightOffset, offsetZ + outerWallOffset + outerFloorSizeZ - offsetXZ),
    FillOperation.Replace
    )
}
function makeHut (offsetXZ: number) {
    blocks.fill(
    BEDROCK,
    world(posX - outerFloorSizeX + offsetXZ, posY - 1, offsetZ + offsetXZ),
    world(posX + outerFloorSizeX - offsetXZ, posY + wallHeight * 0.6, offsetZ + outerFloorSizeZ - offsetXZ),
    FillOperation.Hollow
    )
}
function makeInnerFloor (offsetXZ: number) {
    blocks.fill(
    COBBLESTONE,
    world(posX - outerFloorSizeX + offsetXZ, posY - 1, offsetZ + offsetXZ),
    world(posX + outerFloorSizeX - offsetXZ, posY - 1, offsetZ + outerFloorSizeZ - offsetXZ),
    FillOperation.Replace
    )
}
function makeWallHoles () {
    for (let indeks22 = 0; indeks22 <= outerFloorSizeZ + 2 * outerWallOffset; indeks22++) {
        if (indeks22 % 2 != 0) {
            blocks.place(AIR, world(outerFloorSizeX + outerWallOffset + posX, posY + wallHeight - 2, posZ + offsetZ - outerWallOffset + indeks22))
            blocks.place(AIR, world(posX - outerFloorSizeX - outerWallOffset, posY + wallHeight - 2, posZ + offsetZ - outerWallOffset + indeks22))
        }
    }
    for (let indeks222 = 0; indeks222 <= outerFloorSizeX * 2 + 2 * outerWallOffset; indeks222++) {
        if (indeks222 % 2 != 0) {
            blocks.place(AIR, world(posX + outerFloorSizeX + outerWallOffset - indeks222, posY + wallHeight - 2, posZ + offsetZ - outerWallOffset))
            blocks.place(AIR, world(posX + outerFloorSizeX + outerWallOffset - indeks222, posY + wallHeight - 2, posZ + offsetZ + outerWallOffset + outerFloorSizeZ))
        }
    }
}
function makeWindows (windowWidth: number, windowHeight: number) {
    blocks.fill(
    AIR,
    world(posX + outerFloorSizeX / 2, posY + wallHeight * 0.7, 0),
    world(posX + outerFloorSizeX / 2 + windowWidth, posY + wallHeight * 0.7 - windowHeight, outerFloorSizeZ * 2),
    FillOperation.Replace
    )
    blocks.fill(
    AIR,
    world(posX - outerFloorSizeX / 2, posY + wallHeight * 0.7, 0),
    world(posX - outerFloorSizeX / 2 - windowWidth, posY + wallHeight * 0.7 - windowHeight, outerFloorSizeZ * 2),
    FillOperation.Replace
    )
}
let edgeOffset = 0
let fossOffset = 0
let brigdeWidth = 0
let outerFloorSizeZ = 0
let wallHeight = 0
let offsetZ = 0
let outerWallOffset = 0
let outerFloorSizeX = 0
let posX = 0
let posY = 0
let posZ = 0
