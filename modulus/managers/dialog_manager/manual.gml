/// ------------------------------------------------------------------
/// Instantiation, serialization and deserialization
/// ------------------------------------------------------------------



// The dialog manager system allows you to read/write data either as JSON arrays or structs by simply changing two macros
// Before reading any data, make sure you have set these options correctly



// 1. Creates an empty dialog manager assigning it a language
dialog_manager = dialog_manager_create("en");



// 2. Parses a JSON string passed as the first argument
//    Ideal when you already loaded / composed the data elsewhere for deserialization
dialog_manager = dialog_manager_create("en", "{...}");



// 3a. Same behavior as 2., but from a file path
//     The dialog manager will open, parse and close the file for you
dialog_manager = dialog_manager_create("en", "dialogs.json", /* is_file = */ true);



// 3b. Parses the contents of a file handle
//     You are responsible for opening & closing the file
var file = file_text_open_read("dialogs.json");
dialog_manager = dialog_manager_create("en", file, /* is_file = */ true);
file_text_close(file);



// 4. Serialization
var json = dialog_manager.serialize(/* prettify = */ true);



/// ------------------------------------------------------------------
/// Component creation
/// ------------------------------------------------------------------



// The dialog manager components will automatically create all the masks needed for the encoded values in the corresponding enumerators
// If you need to add more voices to these, you are free to do so where you notice a "// ..." in a list of items



// Add enum voices as needed (e.g., DIALOG.SPEAKER_CHARACTER_1, DIALOG.EMOTION_HAPPY, etc.)
var spk_system      = Dialog.speaker(DIALOG.SPEAKER_SYSTEM)
  , spk_narrator    = Dialog.speaker(DIALOG.SPEAKER_NARRATOR)
  , spk_character_1 = Dialog.speaker(DIALOG.SPEAKER_CHARACTER_1)
  , emt_none        = Dialog.emotion(DIALOG.EMOTION_NONE)
  , emt_happy       = Dialog.emotion(DIALOG.EMOTION_HAPPY)
  , fxtrigger_enter = DialogFX.trigger(DIALOG_FX.TRIGGER_ON_ENTER)
  , fxtrigger_leave = DialogFX.trigger(DIALOG_FX.TRIGGER_ON_LEAVE)
  // ... etc., recommended for readability and faster composition
;



// --------------------------------------------------
// Dialog FX - REGISTRATION
// --------------------------------------------------



// Custom FX functions can be registered globally so that they can be used throughout your dialog data
// Registered functions can be saved on either normal fx map, condition map or indexer map

// 1. Normal FX function registration
var custom_fx_function_index = DialogFX.register(
  function(argv) { /* Custom FX logic here (-> any) */ },
  DIALOG_FX.REGISTER_SETTING_FX_FUNC
);



// 2. FX condition function registration
var custom_fx_condition_function_index = DialogFX.register(
  function(argv) { /* Custom FX condition logic here (-> boolean) */ },
  DIALOG_FX.REGISTER_SETTING_FX_FUNC_CONDITION
);



// 3. FX indexing function registration
var custom_fx_indexing_function_index = DialogFX.register(
  function(argv) { /* Custom FX indexing logic here (-> integer) */ },
  DIALOG_FX.REGISTER_SETTING_FX_FUNC_INDEXER
);



// --------------------------------------------------
// Dialog FX - FLOW CONTROLS
// --------------------------------------------------



// 0. Flow option creation (oftentimes not needed directly)
var flow_option_absolute = dialog_fx_create_flow_option(
  DIALOG_MANAGER.POSITION_CODE_SCENE_FIRST,
  DIALOG_RUNNER.JUMP_SETTING_TYPE_ABSOLUTE,
  "Prompt text for absolute flow option",
  0
);

var flow_option_relative = dialog_fx_create_flow_option(
  +8,
  DIALOG_RUNNER.JUMP_SETTING_UNIT_SEQUENCE, // DIALOG_RUNNER.JUMP_SETTING_TYPE_RELATIVE is already encoded
  "Prompt text for relative flow option",
  0
);



// 1. Unconditional jump effect
var fx_jump_absolute = dialog_fx_create_jump(fxtrigger_leave, flow_option_absolute);
var fx_jump_relative = dialog_fx_create_jump(fxtrigger_enter, flow_option_relative);



// 2. Conditional jump effect
var fx_fallback = dialog_fx_create_fallback(
  fxtrigger_leave,
  flow_option_absolute
);



// 3a. Jump selection effect (no condition)
var fx_dispatch = dialog_fx_create_dispatch(
  fxtrigger_enter, [
    flow_option_absolute,
    flow_option_relative,
    // ...
  ],
  custom_fx_indexing_function_index
);



// 3b. Jump selection effect (with condition)
var fx_dispatch = dialog_fx_create_dispatch(
  fxtrigger_enter, [
    flow_option_absolute,
    flow_option_relative,
    // ...
  ],
  custom_fx_indexing_function_index,
  custom_fx_condition_function_index
);



// 4. Choice effect
var fx_choice = dialog_fx_create_choice([
  flow_option_absolute, flow_option_relative, // ...
]);



// --------------------------------------------------
// Dialog lines
// --------------------------------------------------



// 1a. Dialogs with absolute-indexed speakers
var dlg1 = dialog_create("Good morning, adventurer!", spk_narrator | emt_happy);
var dlg2 = dialog_create("The king wishes to see you immediately.", spk_narrator | emt_none);
var dlg3 = dialog_create("< Hurry to the castle before nightfall. >", spk_sys);



// 1b. Dialogs with relative-indexed speakers (indices match 2b.'s "speakers" parameter's)
var dlg1 = dialog_create("Good morning, adventurer!", 1 | emt_happy);
var dlg2 = dialog_create("The king wishes to see you immediately.", 1 | emt_none);
var dlg3 = dialog_create("< Hurry to the castle before nightfall. >", 0);



// 1c. Dialogs from flow resolution effects -> SIDE EFFECT: this will ADD/OVERWRITE the choices to the effect's option list
var fx_choice = dialog_fx_create_choice(fxtrigger_leave);

var dlg4 = dialog_create("Good to see you lock n'loaded, adventurer!", spk_character_1 | emt_happy, fx_choice).from(fx_choice, "Sir yes sir!", 0);
var dlg5 = dialog_create("You are quite the lazy one, adventurer...", spk_character_1 | emt_none, fx_choice).from(fx_choice, "I'm just tired...", 1);



// 2a. Dialog sequences (should be considered as minimal dialog loop points)
var seq1 = dialog_sequence_create([dlg1, dlg2, dlg3, dlg4, dlg5]);



// 2b. Dialog sequences with relatively indexed speakers
var seq1 = dialog_sequence_create([dlg1, dlg2, dlg3, dlg4, dlg5], /* settings_mask = */ 0, /* speakers = */ [spk_sys, spk_narrator]);



// 2c. If you notice that all dialogs in a sequence have been mapped to absolute-indexed speakers, you can remap them with relative values
//     and regenerate the speaker map for that specific sequence with this command (WILL PRODUCE SIDE EFFECTS ON ALL AFFECTED DIALOGS):
var map = sequence.rescript();



// 3. Dialog scenes (collections of sequences)
var scn1 = dialog_scene_create([seq1]);



// 4. Adding scenes to the dialog manager
dialog_manager.add([scn1]);



// --------------------------------------------------
// Data retrieval, decoding & encoding
// --------------------------------------------------



// 0a. Instantiate a dialog runner to cycle through the dialog manager data
dialog_runner = dialog_runner_create(dialog_manager);

// 0b. Clone the dialog runner
dialog_runner_clone = dialog_runner.clone();



// 1. Get current dialog, sequence or scene
var current_dialog = dialog_runner.dialog();
var current_sequence = dialog_runner.sequence();
var current_scene = dialog_runner.scene();



// 2. Get absolute dialog, sequence or scene (negative indices iterate backwards)
var absolute_dialog = dialog_runner.dialog(-10);
var absolute_sequence = dialog_runner.sequence(8);
var absolute_scene = dialog_runner.scene(2);



// 3a. Get relative dialog, sequence or scene from current position
var relative_dialog = dialog_runner.deltadialog(-10);
var relative_sequence = dialog_runner.deltasequence(+8);
var relative_scene = dialog_runner.deltascene(+2);
var relative_x = dialog_runner.delta(-1, DIALOG_RUNNER.JUMP_UNIT_SEQUENCE);



// 3b. Get relative dialog, sequence or scene from custom position
var relative_dialog_2 = dialog_runner.deltadialog(-10, DIALOG_MANAGER.POSITION_CODE_SCENE_MIDDLE);
var relative_sequence_2 = dialog_runner.deltasequence(+8, relative_sequence);
var relative_scene_2 = dialog_runner.deltascene(+2, relative_scene.position());
var relative_x_2 = dialog_runner.delta(-2, DIALOG_RUNNER.JUMP_UNIT_SCENE, relative_scene_2);



// 3c. Load dialog runner to custom position
dialog_runner.load(relative_x_2); // Will set the new position and status according to the new position



// 3d. Load dialog runner to custom position and executing effects
dialog_runner.load(relative_dialog, /* busy = */ true, /* argv = */ [/* ... */]);



// 4a. Decoding dialog data
var scene = dialog_runner.scene(2);

var scene_index = scene.index();              // Index in the dialog manager
var scene_is_last = scene.islast();           // Last scene
var scene_position = scene.position();
var scene_bg = scene.bg();                    // BG index data
var scene_bgm = scene.bgm();                  // BGM index data
var scene_bgs = scene.bgs();                  // BGS index data
var scene_tag = scene.tag();                  // Tag data
var sequence = scene.sequence(4);             // 4th sequence of referenced scene

var sequence_index = sequence.index();        // Index in the scene
var sequence_is_last = sequence.islast();     // Last of scene
var sequence_position = sequence.position();
var sequence_tag = sequence.tag();            // Tag data
var dialog = sequence.dialog(-3);             // 3rd-last dialog of referenced sequence

var dialog_index = dialog.index();            // Index in the sequence
var dialog_is_last = dialog.islast();         // Last of sequence
var dialog_position = dialog.position();
var dialog_speaker = dialog.speaker();        // Speaker index data
var dialog_emotion = dialog.emotion();        // Emotion index data
var dialog_anchor = dialog.anchor();          // Anchor index data
var dialog_textbox = dialog.textbox();        // Textbox index
var dialog_tag = dialog.tag();                // Tag data
var dialog_jump = dialog.jump();              // Jump to be executed or undefined
var dialog_fallback = dialog.fallback();      // Fallback to be executed or undefined
var dialog_choice = dialog.choice();          // Choice to be executed or undefined
var dialog_fx = dialog.fx(-1);                // Last fx listed in the referenced dialog

var fx_type = fx.type();                      // FX type index data
var fx_trigger = fx.trigger();                // FX trigger index data
var fx_signal = fx.signal();                  // FX signal data
var fx_tag = fx.tag();                        // FX tag data
var fx_options = fx.options();                // FX flow options (only if fx is of flowres type)
var fx_option = fx.option(-1);                // FX flow option (only if fx is of flowres type)
var fx_prompt = fx.prompt(2);                 // FX flow option prompt (only if fx is of flowres type)
var fx_metadata = fx.metadata(-3);            // FX flow option metadata (only if fx is of flowres type)
var fx_indexer = fx.indexer();                // FX flow option indexer (only if fx is of valid flowres type)
var fx_condition = fx.condition();            // FX flow option condition (only if fx is of valid flowres type)

// 4b. Advanced item filtering
// You can access the .container property inside the manager, scene, sequence and dialog to access more selection options, e.g:
// Returns (if existent) the 4th sequence with a tag option equal to DIALOG_SEQUENCE.TAG_FOR_SELECTION

var selected_sequence = scene.container.nth_of(4, function(sequence) {
  return sequence.tag() == DIALOG_SEQUENCE.TAG_FOR_SELECTION;
});



// 5. Encoding dialog data (passing positive integers to the same methods will encode the argument to the corresponding mask)

var enc_scene_bg = DialogScene.bg(4);         // Encodes the scene bg to the corresponding bitmask value
var enc_scene_bgm = DialogScene.bgm(4);       // Encodes the scene bgm to the corresponding bitmask value
var enc_scene_bgs = DialogScene.bgs(4);       // Encodes the scene bgs to the corresponding bitmask value
var enc_scene_tag = DialogScene.tag(4);       // Encodes the scene tag to the corresponding bitmask value

var enc_sequence_tag = DialogSequence.tag(4); // Encodes the sequence tag to the corresponding bitmask value

var enc_dialog_speaker = Dialog.speaker(4);   // Encodes the dialog speaker to the corresponding bitmask value
var enc_dialog_emotion = Dialog.emotion(4);   // Encodes the dialog emotion to the corresponding bitmask value
var enc_dialog_anchor = Dialog.anchor(4);     // Encodes the dialog anchor to the corresponding bitmask value
var enc_dialog_textbox = Dialog.textbox(4);   // Encodes the dialog textbox to the corresponding bitmask value
var enc_dialog_tag = Dialog.tag(4);           // Encodes the dialog tag to the corresponding bitmask value

var enc_fx_type = DialogFX.type(4);           // Encodes the dialog fx type to the corresponding bitmask value
var enc_fx_trigger = DialogFX.trigger(4);     // Encodes the dialog fx trigger to the corresponding bitmask value
var enc_fx_signal = DialogFX.signal(4);     // Encodes the dialog fx signal to the corresponding bitmask value
var enc_fx_tag = DialogFX.tag(4);             // Encodes the dialog fx tag to the corresponding bitmask value



// --------------------------------------------------
// Macros
// --------------------------------------------------



#macro __DIALOG_MANAGER_SERIALIZER_METHOD__         // Macro for choosing serialization method (JSON array / JSON struct). Must be <__array> or <__struct>
#macro __DIALOG_MANAGER_DESERIALIZER_METHOD__       // Macro for choosing deserialization method (JSON array / JSON struct). Must be <__from_array> or <__from_struct>



// --------------------------------------------------
// Constants
// --------------------------------------------------



/// Constant.DIALOG_RUNNER

DIALOG_RUNNER.STATUS_UNINITIALIZED                        // Activates if runner is uninitialized
DIALOG_RUNNER.STATUS_FIRST_DIALOG                         // Activates if position corresponds to the first dialog
DIALOG_RUNNER.STATUS_FIRST_SEQUENCE                       // Activates if position corresponds to the first sequence
DIALOG_RUNNER.STATUS_FIRST_SCENE                          // Activates if position corresponds to the first scene
DIALOG_RUNNER.STATUS_FIRST_OF_SEQUENCE                    // Activates if position corresponds to the first dialog of a sequence
DIALOG_RUNNER.STATUS_FIRST_OF_SCENE                       // Activates if position corresponds to the first sequence of a scene
DIALOG_RUNNER.STATUS_MIDDLE_OF_SEQUENCE                   // Activates if position corresponds to the middle dialog of a sequence
DIALOG_RUNNER.STATUS_MIDDLE_OF_SCENE                      // Activates if position corresponds to the middle sequence of a scene
DIALOG_RUNNER.STATUS_MIDDLE_SCENE                         // Activates if position corresponds to the middle scene
DIALOG_RUNNER.STATUS_LAST_DIALOG                          // Activates if position corresponds to the last dialog
DIALOG_RUNNER.STATUS_LAST_SEQUENCE                        // Activates if position corresponds to the last sequence
DIALOG_RUNNER.STATUS_LAST_SCENE                           // Activates if position corresponds to the last scene
DIALOG_RUNNER.STATUS_LAST_OF_SEQUENCE                     // Activates if position corresponds to the last dialog of a sequence
DIALOG_RUNNER.STATUS_LAST_OF_SCENE                        // Activates if position corresponds to the last sequence of a scene
DIALOG_RUNNER.STATUS_ADVANCED_DIALOG                      // Activates if a positive-shift dialog advancement is made
DIALOG_RUNNER.STATUS_ADVANCED_SEQUENCE                    // Activates if a positive-shift sequence advancement is made
DIALOG_RUNNER.STATUS_ADVANCED_SCENE                       // Activates if a positive-shift scene advancement is made
DIALOG_RUNNER.STATUS_RECEDED_DIALOG                       // Activates if a negative-shift dialog advancement is made
DIALOG_RUNNER.STATUS_RECEDED_SEQUENCE                     // Activates if a negative-shift sequence advancement is made
DIALOG_RUNNER.STATUS_RECEDED_SCENE                        // Activates if a negative-shift scene advancement is made
DIALOG_RUNNER.STATUS_MAINTAINED_DIALOG                    // Activates if a dialog advancement is avoided
DIALOG_RUNNER.STATUS_MAINTAINED_SEQUENCE                  // Activates if a sequence advancement is avoided
DIALOG_RUNNER.STATUS_MAINTAINED_SCENE                     // Activates if a scene advancement is avoided
DIALOG_RUNNER.STATUS_EXECUTED_JUMP                        // Activates if a jump effect is correctly executed
DIALOG_RUNNER.STATUS_EXECUTED_DISPATCH                    // Activates if a dispatch effect is correctly executed
DIALOG_RUNNER.STATUS_EXECUTED_FALLBACK                    // Activates if a fallback effect is correctly executed
DIALOG_RUNNER.STATUS_EXECUTED_CHOICE                      // Activates if a choice effect is correctly executed

DIALOG_RUNNER.JUMP_TYPE_ABSOLUTE                          // Defines a jump type index for absolute jumps. Not to use with option bitmasks.
DIALOG_RUNNER.JUMP_TYPE_RELATIVE                          // Defines a jump type index for relative jumps. Not to use with option bitmasks.
DIALOG_RUNNER.JUMP_UNIT_DIALOG                            // Defines a jump unit index for dialog units. Not to use with option bitmasks.
DIALOG_RUNNER.JUMP_UNIT_SEQUENCE                          // Defines a jump unit index for sequence units. Not to use with option bitmasks.
DIALOG_RUNNER.JUMP_UNIT_SCENE                             // Defines a jump unit index for scene units. Not to use with option bitmasks.

DIALOG_RUNNER.JUMP_SETTING_TYPE_ABSOLUTE                  // Encodes setting related to absolute jumps
DIALOG_RUNNER.JUMP_SETTING_TYPE_RELATIVE                  // Encodes setting related to relative jumps
DIALOG_RUNNER.JUMP_SETTING_UNIT_DIALOG                    // Encodes setting related to dialog unit jumps
DIALOG_RUNNER.JUMP_SETTING_UNIT_SEQUENCE                  // Encodes setting related to sequence unit jumps
DIALOG_RUNNER.JUMP_SETTING_UNIT_SCENE                     // Encodes setting related to scene unit jumps
DIALOG_RUNNER.JUMP_SETTING_CHOICE                         // Encodes setting related to choice jumps
DIALOG_RUNNER.JUMP_SETTING_BYPASS_FX_ON_ENTER             // Encodes setting related to the bypassing of on-enter triggered dialog fx
DIALOG_RUNNER.JUMP_SETTING_BYPASS_FX_ON_STAY              // Encodes setting related to the bypassing of on-stay triggered dialog fx
DIALOG_RUNNER.JUMP_SETTING_BYPASS_FX_ON_LEAVE             // Encodes setting related to the bypassing of on-leave triggered dialog fx
DIALOG_RUNNER.JUMP_SETTING_MAINTAIN_DIALOG                // Encodes setting related to the maintainment of current dialog entity
DIALOG_RUNNER.JUMP_SETTING_MAINTAIN_SEQUENCE              // Encodes setting related to the maintainment of current sequence entity
DIALOG_RUNNER.JUMP_SETTING_MAINTAIN_SCENE                 // Encodes setting related to the maintainment of current scene entity
DIALOG_RUNNER.JUMP_SETTING_EXEC_FX_ON_ENTER_IF_MAINTAINED // Encodes setting related to the execution of on-enter fx on dialog maintainment
DIALOG_RUNNER.JUMP_SETTING_EXEC_FX_ON_LEAVE_IF_MAINTAINED // Encodes setting related to the execution of on-leave fx on dialog maintainment

DIALOG_RUNNER.JUMP_INFO_MAINTAINED                        // Encodes info related to whether the jump was maintained or not

/// Constant.DIALOG_MANAGER

DIALOG_MANAGER.POSITION_CODE_SCENE_LAST                   // Position code for jumping to last scene
DIALOG_MANAGER.POSITION_CODE_SCENE_NEXT                   // Position code for jumping to next scene
DIALOG_MANAGER.POSITION_CODE_SCENE_END                    // Position code for jumping to end of scene (last sequence)
DIALOG_MANAGER.POSITION_CODE_SCENE_MIDDLE                 // Position code for jumping to middle of scene (middle sequence)
DIALOG_MANAGER.POSITION_CODE_SCENE_START                  // Position code for jumping to start of scene (first sequence)
DIALOG_MANAGER.POSITION_CODE_SCENE_PREVIOUS               // Position code for jumping to previous scene
DIALOG_MANAGER.POSITION_CODE_SCENE_FIRST                  // Position code for jumping to first scene
DIALOG_MANAGER.POSITION_CODE_SEQUENCE_LAST                // Position code for jumping to last sequence
DIALOG_MANAGER.POSITION_CODE_SEQUENCE_NEXT                // Position code for jumping to next sequence
DIALOG_MANAGER.POSITION_CODE_SEQUENCE_END                 // Position code for jumping to end of sequence (last dialog)
DIALOG_MANAGER.POSITION_CODE_SEQUENCE_MIDDLE              // Position code for jumping to middle of sequence (middle dialog)
DIALOG_MANAGER.POSITION_CODE_SEQUENCE_START               // Position code for jumping to start of sequence (first dialog)
DIALOG_MANAGER.POSITION_CODE_SEQUENCE_PREVIOUS            // Position code for jumping to previous sequence
DIALOG_MANAGER.POSITION_CODE_SEQUENCE_FIRST               // Position code for jumping to first sequence
DIALOG_MANAGER.POSITION_CODE_NONE                         // Position code for jumping to position 0

DIALOG_MANAGER.DIFF_LEVEL_SCENE                           // Level code for dialog scenes
DIALOG_MANAGER.DIFF_LEVEL_SEQUENCE                        // Level code for dialog sequences
DIALOG_MANAGER.DIFF_LEVEL_DIALOG                          // Level code for dialogs
DIALOG_MANAGER.DIFF_LEVEL_FX                              // Level code for dialog effects

DIALOG_MANAGER.DIFF_SEVERITY_OK                           // Integrity violation null severity
DIALOG_MANAGER.DIFF_SEVERITY_WARNING                      // Integrity violation warning severity (suspicious structural differences found)
DIALOG_MANAGER.DIFF_SEVERITY_ERROR                        // Integrity violation error severity (extreme structural differences found)

DIALOG_MANAGER.DIFF_ARG_TOLERANCE_INSERTIONS_MAX          // Diff algorithm tolerance for maximum insertion counts
DIALOG_MANAGER.DIFF_ARG_TOLERANCE_DELETIONS_MAX           // Diff algorithm tolerance for maximum deletion counts
DIALOG_MANAGER.DIFF_ARG_TOLERANCE_MOVES_MAX               // Diff algorithm tolerance for maximum move counts
DIALOG_MANAGER.DIFF_ARG_TOLERANCE_INSERTIONS_WARNING      // Diff algorithm tolerance for warning-raising insertion counts
DIALOG_MANAGER.DIFF_ARG_TOLERANCE_DELETIONS_WARNING       // Diff algorithm tolerance for warning-raising deletion counts
DIALOG_MANAGER.DIFF_ARG_TOLERANCE_MOVES_WARNING           // Diff algorithm tolerance for warning-raising moves counts
DIALOG_MANAGER.DIFF_ARG_TOLERANCE_COUNT                   // Diff algorithm tolerance argoment count

DIALOG_MANAGER.ERR_UNDEFINED_ERROR_TYPE                   // Error raised when error type is unknown
DIALOG_MANAGER.ERR_SERIALIZATION_FAILED                   // Error raised when serialization fails (invalid dialogical structure)
DIALOG_MANAGER.ERR_DESERIALIZATION_FAILED                 // Error raised when deserialization fails (error occurring when reading file)
DIALOG_MANAGER.ERR_PARSING_FAILED                         // Error raised when parsing fails (malformed deserialized data)
DIALOG_MANAGER.ERR_UNDEFINED_BACKREF_L1                   // Error raised when dialog linkable is missing parent element
DIALOG_MANAGER.ERR_UNDEFINED_BACKREF_L2                   // Error raised when dialog linkable is missing grandparent element
DIALOG_MANAGER.ERR_EMPTY_CONTAINER_OBJECT                 // Error raised when dialog manager contains an empty dialog linkable object
DIALOG_MANAGER.ERR_INVALID_POSITION                       // Error raised when access to position fails
DIALOG_MANAGER.ERR_INFINITE_JUMP_LOOP_DETECTED            // Error raised when dialog runner executes too many jumps
DIALOG_MANAGER.ERR_TEXT_OVERFLOW                          // Error raised when dialog text is potentially too long
DIALOG_MANAGER.ERR_MAX_FX_CAPACITY_REACHED                // Error raised when dialog fx map reaches max capacity
DIALOG_MANAGER.ERR_INFINITE_FX_LOOP_DETECTED              // Error raised when dialog runner executes too many effects

DIALOG_MANAGER.ERRCHECK_JUMP_INFINITE_LOOP_TRESHOLD       // Safety check for triggering panicking error if manager is unable to reach a stable position
DIALOG_MANAGER.ERRCHECK_FX_INFINITE_LOOP_TRESHOLD         // Safety check for triggering panicking error if manager is unable to resolve an effect cycle

/// Constant.DIALOG_FX

DIALOG_FX.REGISTER_SETTING_FX_FUNC                        // Registering setting for normal fx map
DIALOG_FX.REGISTER_SETTING_FX_FUNC_INDEXER                // Registering setting for indexer fx map
DIALOG_FX.REGISTER_SETTING_FX_FUNC_CONDITION              // Registering setting for condition fx map



// --------------------------------------------------
// Static properties
// --------------------------------------------------



// Struct.DialogRunner
DialogRunner.__CONSTRUCTOR_ARGC                   // Dialog runner constructor function argument count

// Struct.DialogManager
DialogManager.__CONSTRUCTOR_ARGC                  // Dialog manager constructor function argument count

// Struct.DialogScene
DialogScene.__CONSTRUCTOR_ARGC                    // Dialog scene constructor function argument count

// Struct.DialogSequence
DialogSequence.__CONSTRUCTOR_ARGC                 // Dialog sequence onstructor function argument count

// Struct.Dialog
Dialog.__CONSTRUCTOR_ARGC                         // Dialog constructor function argument count
Dialog.TEXT_WIDTH_MAX                             // Dialog text width max limit
Dialog.TEXT_WIDTH_FUNC                            // Dialog width-checking function

// Struct.DialogFX
DialogFX.__CONSTRUCTOR_ARGC                       // Dialog fx constructor function argument count



// --------------------------------------------------
// Instance properties
// --------------------------------------------------



// Struct.DialogRunner
dialog_runner.manager                             // Reference to dialog manager
dialog_runner.choice_index                        // Choice index for default choice indexer function
dialog_runner.status                              // Runner status (position states, per-frame execution states)
dialog_runner.position                            // Current cursor position
dialog_runner.seed                                // Randomized value (unused by the system, but can be worked on)
dialog_runner.history                             // List of previous positions (unused by the system, but can be worked on)
dialog_runner.vars                                // Custom dialog runner variable map, can be worked on (eg for custom effects).

// Struct.DialogManager
dialog_manager.data                               // Custom dialog manager data
dialog_manager.scenes                             // List of dialog scenes
dialog_manager.scene_count                        // Scene count

// Struct.DialogScene
dialog_scene.id                                   // Globally assigned scene id (first ID should start from 200_000_001 for readability)
dialog_scene.manager                              // Back-reference to dialog manager
dialog_scene.scene_idx                            // Relative index inside dialog manager
dialog_scene.sequences                            // List of dialog sequences
dialog_scene.sequence_count                       // Sequence count
dialog_scene.settings_mask                        // The scene's encoded options

// Struct.DialogSequence
dialog_sequence.id                                // Globally assigned sequence id (first ID should start from 100_000_001 for readability)
dialog_sequence.scene                             // Back-reference to dialog scene
dialog_sequence.sequence_idx                      // Relative index inside dialog scene
dialog_sequence.dialogs                           // List of dialogs
dialog_sequence.dialog_count                      // Dialog count
dialog_sequence.speakers                          // List of speakers (useful when speakers are dynamic)
dialog_sequence.settings_mask                     // The sequence's encoded options

// Struct.Dialog
dialog.id                                         // Globally assigned dialog id (first ID should start from 1 for readability)
dialog.sequence                                   // Back-reference to dialog sequence
dialog.dialog_idx                                 // Relative index inside dialog scene
dialog.text                                       // Dialog text
dialog.fx_map                                     // List of dialog effects
dialog.fx_count                                   // Dialog effects count
dialog.settings_mask                              // The dialog's encoded options

// Struct.DialogFX
dialog_fx.id                                      // Globally assigned dialog fx id (first ID should start from 300_000_001 for readability)
dialog_fx.argv                                    // Dialog fx argument values
dialog_fx.settings_mask                           // The dialog effect's encoded options



// --------------------------------------------------
// Dialog management & advancement
// --------------------------------------------------



// Depending on your game, it is recommended that you study how you are going to make use of the structure proposed, e.g.:
//
// - If you are making a visual novel:
//   - Scenes can group visual data (what the player sees) and you can program transitions between them
//   - Sequences can be used to break long dialogs in smaller topics, allowing you to easily debug your dialogs, and you can program pauses between them
// - If you are making an RPG:
//   - Scenes can just help you locate your sequences (being in particular zones, etc.)
//   - Sequences hold the dialogs for each interaction the player makes (NPC, item, etc.); when a sequence ends, the dialog textbox is no longer shown.
//
// The system I proposed takes care of managing the data and the branching logic in a linear way,
// but it is then up to the programmer to develop the interaction with this system



// Example 1: advancing dialogs when pressing Enter (linearly only)
var enter_key_pressed = keyboard_check_pressed(vk_enter);

dialog_runner.advance(enter_key_pressed);



// Example 2: advancing dialogs (generic solution with choices)
var enter_key_pressed = keyboard_check_pressed(vk_enter)
  , choice = dialog_runner.dialog().choice()
  , has_choice = choice != undefined
;

if (has_choice)
{
  var key_down = keyboard_check_pressed(vk_down)
    , key_up = keyboard_check_pressed(vk_up)
    , incr = vk_down - vk_up
  ;

  // Choice index is already initialized in dialog runner
  dialog_runner.choice_index = clamp(dialog_runner.choice_index + incr, 0, array_length(choice.options()) - 1);
}

dialog_runner.advance(
  enter_key_pressed,
  DIALOG_RUNNER.JUMP_SETTING_MAINTAIN_SEQUENCE
  | DIALOG_RUNNER.JUMP_SETTING_EXEC_FX_ON_LEAVE_IF_MAINTAINED
);



// Example 3: predicting dialog runner positions (returns dialog runner copy)
var enter_key_pressed = keyboard_check_pressed(vk_enter);

var next_dialog_data = dialog_runner.predict(vk_enter); // Same parameters as DialogRunner.advance()



// --------------------------------------------------
// Status checking
// --------------------------------------------------



// You may find useful to have values to use in a single frame to perform an operation or simply to keep track
// of a particular relative position of the current dialog.
//
// The dialog runner also includes a status member that has both flags toggled based on particular situations
// with positions (first/last dialog/sequence/scene, first/middle/last of sequence/scene, etc.) and frame-based
// operations, such as having advanced/receded dialogs/sequences/scenes or having executed jumps/dispathces/fallbacks/choices
//
// For that reason it is recommended that DialogRunner.advance() is called every frame the object should be active.



// 1. Position status flag
if (dialog_manager.status & DIALOG_MANAGER.STATUS_LAST_SCENE) {
  show_debug_message("Dialog cursor is currently in the last scene.");
}



// 2. Runtime status flag
if (dialog_runner.status & DIALOG_RUNNER.STATUS_EXECUTED_CHOICE) {
  show_debug_message("A choice has been executed this frame.");
}

if (dialog_runner.status & DIALOG_RUNNER.STATUS_MAINTAINED_SEQUENCE) {
  // E.g. hides textboxes
  is_active = false;
  exit;
}



// --------------------------------------------------
// Multilanguage support
// --------------------------------------------------

// The dialog management system also has a built-in functionality to check structural differences between two managers,
// allowing you to maintain integrity between two language versions, especially the bigger they become. You can use said
// method to retrieve a struct with all data about the differences, also specifying tolerance parameters to allow you to ignore
// minimal differences etc.

// 0. Create tolerance parameters (if none are created, the diff will signal as error any minimal difference found)
//    Each argument is an array of length DIALOG_MANAGER.DIFF_ARG_TOLERANCE_COUNT maximum. The arrays have the same formats for the levels, in order:
//    1. FX   ->   2. Dialog   ->   3. DialogSequence   ->   4. DialogScene
//    Use DIALOG_MANAGER.DIFF_ARG_TOLERANCE_* indices to correctly position your tolerance params if need be.
diff_tolerance_params = DialogManager.diff_tolerance_params_create(/* ... */);



// 1a. Compare two managers
diff_data = dialog_manager_master_language.diff(dialog_manager_secondary_language, diff_tolerance_params);

// 1b. Deserialize and compare two managers (data_strings, is_file, diff_tolerance_params)
diff_data_and_managers = DialogManager.diffstatic("en.json", "it.json", true, diff_tolerance_params);
diff_data_and_managers = DialogManager.diffstatic("{...}", "{...}", false, diff_tolerance_params);
