#import "Tile.h"
typedef enum {
	town, orcMines, morlockTunnels, crypts, undergroundForest, abyss
} levelType;


@class Coord;		// defined in Util
@class Tile;


#pragma mark -

@interface Dungeon : NSObject {
	Coord *playerLocation;
}

- (Dungeon*) initWithType: (levelType) lvlType;
- (Tile*) tileAtX: (int) x Y: (int) y Z: (int) z;
- (Tile*) tileAt: (Coord*) coord;
- (Coord*) coordOfTile: (Tile*) tile;

+ (Dungeon*) loadDungeonFromFile:(NSString*)filename;

@property (nonatomic, retain) Coord *playerLocation;

@end
