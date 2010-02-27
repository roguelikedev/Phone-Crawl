#import <Foundation/Foundation.h>
#import "Util.h"

#define ITEM_NO_SPELL -1
#define ERR_NO_MANA -2
#define ERR_RESIST -3
#define SPELL_NO_DAMAGE -4
#define CAST_ERR -5

#define NUM_PC_SPELLS 50
#define NUM_DMG_SPELLS 25
#define NUM_WAND_SPELLS NUM_DMG_SPELLS
#define NUM_COND_SPELLS 25

#define ITEM_BOOK_SPELL_ID 0 // 0
#define ITEM_HEAL_SPELL_ID ITEM_BOOK_SPELL_ID + 1 //0 + 1 = 1
#define ITEM_MANA_SPELL_ID ITEM_HEAL_SPELL_ID + 5 //1 + 5 = 6
#define START_PC_SPELLS ITEM_MANA_SPELL_ID + 5 //6 + 5 = 11
#define START_WAND_SPELLS START_PC_SPELLS + NUM_PC_SPELLS // 11 + 50 = 61

typedef enum {DAMAGE, CONDITION, ITEM} spellType;
typedef enum {SELF,SINGLE} targetType;

NSMutableArray *spell_list;

@class Creature;
@interface Spell : NSObject {
	NSString *name;
	spellType spell_type; //Hurt or Help
	targetType target_type; //Self, one target, all in range
	elemType elem_type; //Elemental type of damage or buff
	int mana_cost;
	int damage;
	int range;
	int spell_level; //Minor,Lesser, (unnamed regular), Major, Superior
	int spell_id; //Index in spell_list array of the spell
	SEL spell_fn;
	int required_turn_points;
	//IMP spell_fn;
}

+ (void) fill_spell_list;

+ (int) cast_id: (int) in_spell_id caster: (Creature *) caster target: (Creature *) target;
- (int) cast: (Creature *) caster target: (Creature *) target;

- (id) initWithInfo: (NSString *) in_name spell_type: (spellType) in_spell_type target_type: (targetType) in_target_type elem_type: (elemType) in_elem_type
		  mana_cost: (int) in_mana_cost damage: (int) in_damage range: (int) in_range spell_level: (int) in_spell_level spell_id: (int) in_spell_id
		   spell_fn: (SEL) in_spell_fn turn_points: (int) in_turn_points;

- (BOOL) Resist_Check: (Creature *) caster target: (Creature *) target;

//Specialized spell functions

- (int) detr_spell: (Creature *) caster target: (Creature *) target;
- (int) heal_potion: (Creature *) caster target: (Creature *) target;
- (int) mana_potion: (Creature *) caster target: (Creature *) target;
- (int) scroll: (Creature *) caster target: (Creature *) target;
- (int) haste: (Creature *) caster target: (Creature *) target;
- (int) freeze: (Creature *) caster target: (Creature *) target;
- (int) purge: (Creature *) caster target: (Creature *) target;
- (int) taint: (Creature *) caster target: (Creature *) target;
- (int) confusion: (Creature *) caster target: (Creature *) target;


@property (readonly) int range;
@property (readonly) NSString * name;
@property (readonly) targetType target_type;
@property (readonly) int spell_id;
@property (readonly) int required_turn_points;

@end
