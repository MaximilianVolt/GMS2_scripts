/// ------------------------------------------------------------------
/// Instantiation
/// ------------------------------------------------------------------

// 1. Creates an empty dialog manager.
//    Stored in the global scope by default.
global.dialog_manager = dialog_manager_create();



// 2. Parses a JSON string passed as the first argument.
//    Ideal when you already loaded / composed the data elsewhere.
global.dialog_manager = dialog_manager_create("[]");



// 3a. Same as above but passing the filename directly.
//     The dialog manager will open, parse and close the file for you.
global.dialog_manager = dialog_manager_create("dialogs.json", true);

// 3b. Parses the contents of a file handle.
//    You are responsible for opening & closing the file.
var file = file_text_open_read("dialogs.json");
global.dialog_manager = dialog_manager_create(file, /* is_file = */ true);
file_text_close(file);



// 4. Bind the manager to the calling object instead of global.
//    Useful to delegate the dialog manager to other objects.
var dialog_manager = dialog_manager_create(undefined, undefined, object_index);





/// ------------------------------------------------------------------
/// Component Creation – Building a Tiny Conversation
/// ------------------------------------------------------------------

// Optional lookup tables. Recommended for autocompletion suggestions.
// Use enum keys as array indeces
dialog_speakers    = [];
dialog_emotions    = [];
dialog_anchors     = [];
dialog_fx_types    = [];
dialog_fx_triggers = [];

// Manager instantiation should come after lookups definitions to avoid overwrite.
dialog_manager = dialog_manager_create();

// --------------------------------------------------
// FX helpers
// --------------------------------------------------

var fxtype_jump = dialog_fx_types[DIALOG_FX.TYPE_JUMP];
var fxtype_fallback = dialog_fx_types[DIALOG_FX.TYPE_FALLBACK];
var fxtrigger_end = dialog_fx_triggers[DIALOG_FX.TRIGGER_ON_END];

var fx_sfx_bell   = dialog_fx_create(0, ["bell_ring.wav"]);
var fx_text_shake = dialog_fx_create(0, ["shake"]);

// Jump back to start of the scene as soon as the line ends.
var fx_scene_loop = dialog_fx_create(
  fxtype_jump | fxtrigger_end,
  [DIALOG.POSITION_CODE_SCENE_RESTART]
);

// Jump back to start of the scene when line ends, randomly.
var fn_random_condition_idx = 2;

var fx_scene_loop_cond = dialog_fx_create(
  fxtype_fallback | fxtrigger_end,
  [DIALOG.POSITION_CODE_SCENE_RESTART, fn_random_condition_idx, .5],
  function(argv) {
    return argv[2] < random(1);
  }
);

// --------------------------------------------------
// Dialog lines
// --------------------------------------------------

var spk_narrator = dialog_speakers[DIALOG.SPEAKER_NARRATOR];
var spk_sys = dialog_speakers[DIALOG.SPEAKER_SYSTEM];
var anch_center = dialog_anchors[DIALOG.ANCHOR_CENTER];

var dlg1 = dialog_create(
  "Good morning, adventurer!",
  spk_narrator | anch_center,
  [fx_scene_loop_cond]
);
var dlg2 = dialog_create("The king wishes to see you immediately.", spk_narrator, [fx_sfx_bell]);
var dlg3 = dialog_create("< Hurry to the castle before nightfall. >", spk_sys);

// --------------------------------------------------
// Sequence (minimal dialog list loop point)
// --------------------------------------------------

var seq_intro = dialog_sequence_create(
  [dlg1, dlg2, dlg3],
  [DIALOG.SPEAKER_NARRATOR, DIALOG.SPEAKER_SYSTEM]
);

// --------------------------------------------------
// Scene (a collection of sequences)
// --------------------------------------------------

// Tip: helper functions will automatically convert data to array where needed.
var scene_intro = dialog_scene_create(seq_intro);

dialog_manager_add(global.dialog_manager, scene_intro);

// Alternatively (methods do NOT apply conversions):
// global.dialog_manager.__add_scene(scene_intro);
// global.dialog_manager.__add_scenes([scene_intro]);



/// ------------------------------------------------------------------
/// Serialization
/// ------------------------------------------------------------------

var json_pretty = dialog_manager_serialize(global.dialog_manager, true);

show_debug_message(json_pretty);





/// ------------------------------------------------------------------
/// Quick‑Reference Cheat‑Sheet
/// ------------------------------------------------------------------
// dialog_manager_create(data_string = "", is_file = false, contractor = global)
// dialog_manager_add(dialog_manager, dialog_linkable = [])
// dialog_manager_serialize(dialog_manager, prettify = false)
// dialog_manager_deserialize(data_string)
//
// dialog_scene_create(sequences = [], settings_mask = 0)
//
// dialog_sequence_create(dialogs = [], speaker_map = [])
//
// dialog_create(text = "", settings_mask = 0, fx_map = [])
//
// dialog_fx_create(settings_mask = 0, args = [], func = undefined)
