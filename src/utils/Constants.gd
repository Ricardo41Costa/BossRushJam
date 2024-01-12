extends Node

const PLAYER_GROUP = "PLAYER_GROUP"
const ENEMY_GROUP = "ENEMY_GROUP"
const PROP_GROUP = "PROP_GROUP"
const ACTOR_GROUP = "ACTOR_GROUP"
const DIALOG_UI_GROUP = "DIALOG_UI_GROUP"
const HEALTH_UI_GROUP = "HEALTH_UI_GROUP"

const ANIM_RESET = "RESET"
const ANIM_TPOSE = "Tpose"
const ANIM_IDLE = "Idle"
const ANIM_CROUCH_IDLE = "CrouchIdle"
const ANIM_CROUCH = "Crouch"
const ANIM_WALK = "Walk"
const ANIM_RUN = "Run"
const ANIM_SPOOK = "Spook"
const ANIM_DEATH = "Death"
const ANIM_DROWN = "Drown"
const ANIM_HURT = "Hurt"
const ANIM_JUMP = "Jump"
const ANIM_SNEAK = "Sneak"
const ANIM_FALL = "Fall"
const ANIM_CONFUSE = "Confuse"
const ANIM_STUN = "Stun"
const ANIM_ATTACK_1 = "Attack1"
const ANIM_ATTACK_2 = "Attack2"
const ANIM_ATTACK_3 = "Attack3"
const ANIM_ATTACK_RETURN_1 = "AttackReturn1"
const ANIM_ATTACK_RETURN_2 = "AttackReturn2"
const ANIM_ATTACK_RETURN_3 = "AttackReturn3"
const ANIM_EXTRAS_INTEROGATION = "show_interogation"
const ANIM_EXTRAS_EXCLAMATION = "show_exclamation"
const ANIM_EXTRAS_CONFUSE = "show_confuse"
const ANIM_OPEN_EYE = "open_eye"
const ANIM_CLOSE_EYE = "close_eye"
const ANIM_FADE_IN = "fade_in"
const ANIM_FADE_OUT = "fade_out"
const ANIM_DEFAULT = "default"
const ANIM_DISSOLVE = "Dissolve"
const ANIM_COMPLETE_FINISH = "complete_finish"
const ANIM_INCOMPLETE_FINISH = "incomplete_finish"

#actor states
enum {
	IDLE,
	ROAM,
	SPOTTED,
	SCARED,
	CONFUSE,
	LOOKING,
	STUN,
	AGRO,
	ATTACK,
	HURT,
	DEATH,
}
