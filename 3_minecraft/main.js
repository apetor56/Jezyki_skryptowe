let sizeX = 0
let sizeY = 0
let sizeZ = 0
function makeFloor (sizeX: number, sizeZ: number) {
    builder.teleportTo(posCamera(0, -1, 5))
    builder.mark()
    builder.shift(sizeZ, -1, sizeX)
    builder.fill(PLANKS_BIRCH)
    builder.teleportTo(posCamera(0, -1, 5))
    builder.shift(5, 0, 5)
    builder.mark()
    builder.shift(sizeZ - 10, 0, sizeX - 10)
    builder.fill(POLISHED_ANDESITE)
}
function makeWalls3 (sizeX: number, sizeY: number, sizeZ: number) {
    builder.teleportTo(posCamera(0, -1, 5))
    builder.shift(-2, 1, -2)
    builder.mark()
    builder.shift(sizeZ + 4, sizeY + 1, sizeX + 4)
    builder.fill(POLISHED_ANDESITE)
    builder.teleportTo(posCamera(0, 0, 5))
    builder.mark()
    builder.shift(sizeZ - 0, sizeY + 1, sizeX - 0)
    builder.fill(AIR)
}
player.onChat("run", function () {
    sizeX += 18
    sizeY += 7
    sizeZ += 28
    makeWalls3(sizeX, sizeY, sizeZ)
    makeFloor(sizeX, sizeZ)
    makeWalls(sizeX, sizeY, sizeZ)
    makeWalls2(sizeX, sizeY, sizeZ)
})
function makeWalls2 (sizeX: number, sizeY: number, sizeZ: number) {
    builder.teleportTo(posCamera(0, -1, 5))
    builder.shift(0, 1, 0)
    builder.mark()
    builder.shift(sizeZ + 0, sizeY - 1, sizeX + 0)
    builder.fill(STONE)
    builder.teleportTo(posCamera(0, 0, 5))
    builder.shift(2, 0, 2)
    builder.mark()
    builder.shift(sizeZ - 4, sizeY, sizeX - 4)
    builder.fill(AIR)
}
function makeWalls (sizeX: number, sizeY: number, sizeZ: number) {
    builder.teleportTo(posCamera(0, -1, 5))
    builder.shift(-2, 1, -2)
    builder.mark()
    builder.shift(sizeZ + 4, sizeY, sizeX + 4)
    builder.fill(STONE_BRICK_MONSTER_EGG)
    builder.teleportTo(posCamera(0, 0, 5))
    builder.mark()
    builder.shift(sizeZ - 0, sizeY, sizeX - 0)
    builder.fill(AIR)
}
