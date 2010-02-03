#import "Util.h"
#import "Dungeon.h"
#import "LevelGen.h"
#import "Tile.h"

#pragma mark --hacks

@interface Dungeon ()
- (bool) setTile: (Tile*) tile X: (int) x Y: (int) y Z: (int) z;
- (bool) setTile: (Tile*) tile at: (Coord*) coord;
@end

#pragma mark --private

@interface LevelGen ()

+ (Dungeon*) makeOrcMines: (Dungeon*) dungeon;
+ (Dungeon*) putRubble: (Dungeon*) dungeon onZLevel: (int) z;
+ (Dungeon*) putBuildings: (Dungeon*) dungeon onZLevel: (int) z;

@end

#pragma mark --implementation

@implementation LevelGen

// blows up on assert if lowBound < highBound.
// negative lowBound works fine, I'm not sober enough to figure out a negative
// highBound that passes the assert just now, so shut up all of your head.  -Nate
+ (int) min: (int) lowBound max: (int) highBound {
	assert (lowBound < highBound);
	int range = highBound - lowBound + 1; // +1 is due to behavior of modulo
	return ((rand() % range) + lowBound);
}

#define BLDG_SIZE 12
+ (void) putBuildingIn: (Dungeon*) dungeon at: (Coord*) coord {
	int addX = [self min: -BLDG_SIZE / 4 max: BLDG_SIZE / 4];
	int addY = [self min: -BLDG_SIZE / 4 max: BLDG_SIZE / 4];

	int startX = coord.X + [self min: -BLDG_SIZE / 2 max: BLDG_SIZE / 2];
	int startY = coord.Y + [self min: -BLDG_SIZE / 2 max: BLDG_SIZE / 2];

	#define END_X (coord.X + BLDG_SIZE + addX)
	for (int x = startX; x < END_X; x++) {

		#define END_Y (startY + BLDG_SIZE + addY)
		for (int y = startY; y < END_Y; y++) {

			// walls or floors which would be placed over a wooden floor are instead ignored.  continue.
			Tile *existing = [dungeon tileAtX: x Y: y Z: coord.Z];
			if (existing.type == tileWoodFloor) continue;

			
			Tile *tile = [[Tile alloc] init];
			
			// check to see if we're inside the 1 tile thick perimeter (of walls)
			bool inRoomOnYAxis = false;
			if (y > startY && y < END_Y - 1) inRoomOnYAxis = true;
			bool inRoomOnXAxis = false;
			if (x > startX && x < END_X - 1) inRoomOnXAxis = true;

			// corner case.
			bool corner = (inRoomOnXAxis || inRoomOnYAxis)? false : true;
			tile.cornerWall = corner;	

			// place either a wall or a floor, overwriting what was there.
			if (inRoomOnXAxis && inRoomOnYAxis) {
				tile.type = tileWoodFloor;
			}
			else {
				tile.blockMove = true;
				tile.type = (existing.type == tileWoodFloor)? tileWoodFloor : tileWoodWall;  // i lost track of what this line does, gimme a break, I'm 13 beers in
			}

			Coord *curr = [Coord withX: x Y: y Z: coord.Z];
			[dungeon setTile: tile at: curr];

			
			// FIXME: implement the following.
			
			// If the walls of two buildings would be flush with one another, both walls are replaced with wooden floor.
			// leverage the 'corner' attribute for this.


			//Any non-corner wall has a 1 / 12 chance of being a crumbling (breakable) wall, a 1 / 12 chance of being a 
			//			broken (passable) wall, and a 1 / 12 chance of being a door.

		}
	}
}

+ (Dungeon*) putBuildings: (Dungeon*) dungeon onZLevel: (int) z {
	for (int LCV = 0; LCV < 50; LCV++) {
		int x = [self min: 0 max: MAP_DIMENSION - 1];
		int y = [self min: 0 max: MAP_DIMENSION - 1];
		Coord *coord = [Coord withX: x Y: y Z: z];

		[self putBuildingIn: dungeon at: coord];
	}
	return dungeon;
}

#pragma mark -

+ (void) putRubblePatchIn: (Dungeon*) dungeon at: (Coord*) coord tightly: (bool) tight {
	int reps = tight? 3 : 6;
	for (int LCV = 0; LCV < reps; LCV++) {
		Tile *tile = [[Tile alloc] init];
		tile.blockMove = true;
		tile.type = tileDirt;

		Coord *curr = [Coord withX: coord.X Y: coord.Y Z: coord.Z];
		int delta = tight? 2 : 4;

		curr.X += [self min: 0 max: delta] - delta / 2;
		curr.Y += [self min: 0 max: delta] - delta / 2;

		if (!tight) [self putRubblePatchIn: dungeon at: curr tightly: true];

		if (![dungeon tileAt: curr].blockMove) {
			[dungeon setTile: tile at: curr];
		}
	}
}

+ (Dungeon*) putRubble: (Dungeon*) dungeon onZLevel: (int) z {
	for (int LCV = 0; LCV < 200; LCV++) {
		int x = [self min: 0 max: MAP_DIMENSION - 1];
		int y = [self min: 0 max: MAP_DIMENSION - 1];

		[self putRubblePatchIn: dungeon at: [Coord withX: x Y: y Z: z] tightly: false];
	}
	return dungeon;
}

#pragma mark -

+ (Dungeon*) makeOrcMines: (Dungeon*) dungeon {
	[self putRubble: dungeon onZLevel: 0];
	return [self putBuildings: dungeon onZLevel: 0];
}

+ (Dungeon*) makeTown: (Dungeon*) dungeon {
	for (int XCV = 0; XCV < MAP_DIMENSION; XCV++) {
		for (int YCV = 0; YCV < MAP_DIMENSION; YCV++) {
//			bool validTile = [dungeon tileAtX:XCV Y:YCV Z:0]? true : false;
//			Tile *tile = [];
//			[dungeon setTile:  X:  Y:  Z: ];
		}
	}
	return dungeon;
}

#pragma mark -

+ (Dungeon*) make: (Dungeon*) dungeon intoType: (levelType) lvlType {
	srand(time(0));
	switch (lvlType) {
		case orcMines:
			dungeon = [self makeOrcMines: dungeon];
			break;
		case town:
			dungeon = [self makeTown: dungeon];
			break;
		default:
			DLog(@"invalid dungeon type");
			break;
	}
	return nil;
}

@end