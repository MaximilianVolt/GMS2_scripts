/// ------------------------------------------------------------------
/// Instantiation, serialization and deserialization
/// ------------------------------------------------------------------



// The dialog manager system allows you to read/write data either as JSON arrays or structs by simply changing two macros
// Before reading any data, make sure you have set these options correctly



// 1. Creates an empty dialog manager
dialog_manager = dialog_manager_create();



// 2. Parses a JSON string passed as the first argument
//    Ideal when you already loaded / composed the data elsewhere for deserialization
dialog_manager = dialog_manager_create("[]");



// 3a. Same behavior as 2., but from a file path
//     The dialog manager will open, parse and close the file for you
dialog_manager = dialog_manager_create("dialogs.json", /* is_file = */ true);



// 3b. Parses the contents of a file handle
//     You are responsible for opening & closing the file
var file = file_text_open_read("dialogs.json");
dialog_manager = dialog_manager_create(file, /* is_file = */ true);
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
  DIALOG_FX.REGISTER_FX_FUNC
);



// 2. FX condition function registration
var custom_fx_condition_function_index = DialogFX.register(
  function(argv) { /* Custom FX condition logic here (-> boolean) */ },
  DIALOG_FX.REGISTER_FX_FUNC_CONDITION
);



// 3. FX indexing function registration
var custom_fx_indexing_function_index = DialogFX.register(
  function(argv) { /* Custom FX indexing logic here (-> integer) */ },
  DIALOG_FX.REGISTER_FX_FUNC_INDEXER
);



// --------------------------------------------------
// Dialog FX - FLOW CONTROLS
// --------------------------------------------------



// 0. Flow option creation (oftentimes not needed directly)
var flow_option_absolute = dialog_fx_create_flow_option(
  DIALOG_MANAGER.POSITION_CODE_SCENE_FIRST,
  DIALOG_RUNNER.MASK_JUMP_SETTING_TYPE_ABSOLUTE,
  "Prompt text for absolute flow option",
  0
);

var flow_option_relative = dialog_fx_create_flow_option(
  DIALOG_MANAGER.POSITION_CODE_SCENE_FIRST,
  DIALOG_RUNNER.MASK_JUMP_SETTING_TYPE_RELATIVE | DIALOG_RUNNER.MASK_JUMP_SETTING_UNIT_SEQUENCE,
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
var dlg5 = dialog_create("You truly are lazy, adventurer...", spk_character_1 | emt_none, fx_choice).from(fx_choice, "I'm just tired...", 1);



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



// 0. Instantiate a dialog runner to cycle through the dialog manager data
dialog_runner = dialog_runner_create(dialog_manager);



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
var relative_x = dialog_runner.delta(-1, DIALOG_MANAGER.JUMP_UNIT_SEQUENCE);



// 3b. Get relative dialog, sequence or scene from custom position
var relative_dialog_2 = dialog_runner.deltadialog(-10, DIALOG_MANAGER.POSITION_CODE_SCENE_MIDDLE);
var relative_sequence_2 = dialog_runner.deltasequence(+8, relative_sequence);
var relative_scene_2 = dialog_runner.deltascene(+2, relative_scene.position());
var relative_x_2 = dialog_runner.delta(-2, DIALOG_MANAGER.JUMP_UNIT_SCENE, relative_scene_2);



// 3c. Load dialog runner to custom position
dialog_runner.load(relative_x_2); // Will set the new position and status according to the new position



// 3d. Load dialog runner to custom position and executing effects
dialog_runner.load(relative_dialog, /* busy = */ true, /* argv = */ [/* ... */]);



// 4. Decoding dialog data
var scene = dialog_runner.scene(2);

var scene_index = scene.index();             // Index in the dialog manager
var scene_is_last = scene.islast();          // Last scene
var scene_position = scene.position();
var scene_bg = scene.bg();                   // BG index data
var scene_bgm = scene.bgm();                 // BGM index data
var scene_bgs = scene.bgs();                 // BGS index data
var scene_tag = scene.tag();                 // Tag data
var sequence = scene.sequence(4);            // 4th sequence of referenced scene

var sequence_index = sequence.index();       // Index in the scene
var sequence_is_last = sequence.islast();    // Last of scene
var sequence_position = sequence.position();
var sequence_tag = sequence.tag();           // Tag data
var dialog = sequence.dialog(-3);            // 3rd-last dialog of referenced sequence

var dialog_index = dialog.index();           // Index in the sequence
var dialog_is_last = dialog.islast();        // Last of sequence
var dialog_position = dialog.position();
var dialog_speaker = dialog.speaker();       // Speaker index data
var dialog_emotion = dialog.emotion();       // Emotion index data
var dialog_anchor = dialog.anchor();         // Anchor index data
var dialog_textbox = dialog.textbox();       // Textbox index
var dialog_tag = dialog.tag();               // Tag data
var dialog_jump = dialog.jump();             // Jump to be executed or undefined
var dialog_fallback = dialog.fallback();     // Fallback to be executed or undefined 
var dialog_choice = dialog.choice();         // Choice to be executed or undefined
var dialog_fx = dialog.fx(-1);               // Last fx listed in the referenced dialog

var fx_type = fx.type();                     // FX type index data
var fx_trigger = fx.trigger();               // FX trigger index data



// 5. Encoding dialog data (passing positive integers to the same methods will encode the argument to the corresponding mask)

var enc_scene_bg = DialogScene.bg(4);
var enc_scene_bgm = DialogScene.bgm(4);
var enc_scene_bgs = DialogScene.bgs(4);
var enc_scene_tag = DialogScene.tag(4);

var enc_sequence_tag = DialogSequence.tag(4);

var enc_dialog_speaker = Dialog.speaker(4);
var enc_dialog_emotion = Dialog.emotion(4);
var enc_dialog_anchor = Dialog.anchor(4);
var enc_dialog_textbox = Dialog.textbox(4);
var enc_dialog_tag = Dialog.tag(4);

var enc_fx_type = DialogFX.type(4);
var enc_fx_trigger = DialogFX.trigger(4);



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

dialog_runner.advance(enter_key_pressed, has_choice * DIALOG_RUNNER.FLAG_JUMP_SETTING_CHOICE);



// Example 3: forecasting dialog runner positions (returns dialog runner copy)
var enter_key_pressed = keyboard_check_pressed(vk_enter);

var next_dialog_data = dialog_runner.forecast(vk_enter); // Same parameters as DialogRunner.advance()



// --------------------------------------------------
// Status checking
// --------------------------------------------------



// You may find useful to have values to use in a single frame to perform an operation or simply to keep track
// of a particular relative position of the current dialog.
//
// The dialog runner also includes a status member that has both flags toggled based on particular situations
// with positions (first/last dialog/sequence/scene, first/middle/last of sequence/scene, etc.) and frame-based
// operations, such as having advanced/receded dialogs/sequences/scenes or having executed jumps/fallbacks/choices



// 1. Position status flag
if (advance_key && dialog_runner.status & DIALOG_RUNNER.FLAG_STATUS_LAST_OF_SEQUENCE) {
  // E.g. hides textboxes
  is_active = false;
  exit;
}



// 2. Runtime status flag
if (dialog_runner.status & DIALOG_RUNNER.FLAG_STATUS_EXECUTED_CHOICE) {
  show_debug_message("A choice has been executed this frame.");
}
