//
//  Critter.h
//  Phone-Crawl
//
//  Created by Austin Kelley on 3/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Util.h"

@class Critter;
@class Item;
@class Spell;
@class Skill;
@class Coord;
@class Npc;

#define STAT_MAX 100
#define STAT_MIN 0


typedef enum {
	NO_CONDITION  = 0,
	BURNED        = 1,
	CHILLED		  = 2,
	HASTENED	  = 4,
	POISONED	  = 8,
	CURSED		  = 16,
	FIRE_HASTE    = 32, //Fire turn-speed buff
	COLD_SLOW     = 64, //Cold turn-speed debuff
	WEAKENED      = 128, //Max health debuff
	CONFUSION     = 256  //Messes with AI calls
} conditionType;

typedef struct {
	int hp;
	int sp;
	int mp;
} CritterStats;

typedef struct {
	Coord *moveLocation;
	Item *itemForUse;
	Spell *spellToCast;
	Skill *skillToUse;
	Critter *critterForAction;
} ActionTargets;

typedef struct {
	Item *lhand;
	Item *rhand;
	Item *chest;
	Item *head;
} EquippedItems;

typedef struct {
	int *skills;
	int *spells;
} Abilities;

typedef struct {
	int fire;
	int frost;
	int shock;
	int dark;
	int poison;
	int armor;
} DefenseStats;

@interface Critter : NSObject 
{
	NSString *stringName;
	NSString *stringIcon; //filename of critter's picture
	
	Coord *location;
	
	int conditionBitSet; //All current effects on critter
	
	EquippedItems equipment; //List of items that determine critter's stats
	ActionTargets target;
	
	CritterStats current;
	CritterStats max;
	
	DefenseStats defense;
	
	Abilities abilities; //Stores critter's ability to use each spell and skill
	
	NSMutableArray *inventory;
	NSMutableArray *cachedPath;
	int money;
	
	int experience;
	int level;
	int abilityPoints; //Gained each level, used for adding or upgrading spells and skills
	int deathPenalty; //High score penalty added for each death during gameplay
	int turnPoints;   //Number of turn points available
	int turnSpeed;    //Number of turn points gained every turn
	
	BOOL alive;
	BOOL inBattle;
	@private
	CritterStats real;
	
	BOOL npc;
	Npc *dialog;
}


//getter / setter methods
@property (nonatomic, retain) NSString *stringName;
@property (nonatomic, retain) NSString *stringIcon;

@property (nonatomic, getter = isAlive) BOOL alive;
@property (nonatomic) BOOL inBattle;
@property (nonatomic, readonly) int level;
@property (nonatomic) int abilityPoints;
@property (nonatomic) int turnPoints;
@property (nonatomic) int money;
@property (nonatomic) int deathPenalty;
@property (nonatomic) int turnSpeed;

@property (nonatomic, retain) NSMutableArray *cachedPath;

@property (nonatomic) ActionTargets target;
@property (nonatomic) EquippedItems equipment;
@property (nonatomic) CritterStats current;
@property (nonatomic) CritterStats max;
@property (nonatomic) DefenseStats defense;
@property (nonatomic) Abilities abilities;

@property (nonatomic, retain) Coord *location;

@property (assign) BOOL npc;
@property (retain) Npc *dialog;

- (id) initWithLevel:(int)lvl;

- (void) gainCondition:(conditionType)cond;
- (void) loseCondition:(conditionType)cond;
- (void) loseAllConditions;

- (void) gainExperience:(int) exp;
- (void) incrementTurnPoints;

- (void) takeDamage:(int)amount;
- (void) gainHealth:(int)amount;
- (BOOL) spendMana:(int)amount;
- (void) gainMana:(int)amount;
- (void) regenShield;

- (void) resetStats;

//Item added to inventory
- (void) gainItem:(Item*)it;

//Item removed from inventory
- (void) loseItem:(Item*)it;

//Item equipped, stats added to current player stats
- (void) equipItem:(Item*)it;

//Item unequipped, stats removed from current player stats
- (void) dequipItem:(Item*)it;
- (BOOL) hasItemEquipped:(Item*)it;

// Get damage values from equipped weapons
- (float) getPhysDamage;
- (float) getElemDamage;

- (void) think:(Critter*)player;

- (BOOL) hasActionToTake;
- (BOOL) hasMoveToMake;

- (NSString*) useSkill;
- (NSString*) useSpell;
- (NSString*) useItem;
- (void) moveToTarget;

- (NSMutableArray*) inventoryItems;

// Set actions to be used when critter's turn is taken
- (void) setItemToUse:(Item*) it;
- (void) setMoveTarget:(Coord*) loc;
- (void) setSkillToUse:(Skill*) skill;
- (void) setSpellToUse:(Spell*) spell;

//Determine player's score upon death
- (int) score;

@end


