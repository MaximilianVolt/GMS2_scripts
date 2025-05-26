/**
 * @desc Dialog management system.
 * @author @MaximilianVolt
 * @version 0.6
 */



#macro __DIALOG_MANAGER_ENCODING_METHOD__ __struct      // Must be <__struct> or <__array>
#macro __DIALOG_MANAGER_DECODING_METHOD__ __from_struct // Must be <__from_struct> or <__from_array>



// Edit as needed

/**
 * @desc Contains all useful information about a dialog scene.
 */

enum DIALOG_SCENE
{

}



// Edit as needed

/**
 * @desc Contains all useful information about a dialog.
 * @desc `SPEAKER_*` options refer to the speakers (actors).
 * @desc `EMOTION_*` options refer to the emotions (frames or expressions).
 * @desc `ANCHOR_*` options refer to the dialog box positioning.
 * @desc `TEXTBOX_*` options refer to the dialog box style.
 * @desc `POSITION_CODE_*` options refer to relative dialog positioning encodings.
 * @desc `__BITMASK_*` options are used to manage bitmasks and should not be referenced directly.
 */

enum DIALOG
{
  // Speakers
  SPEAKER_NONE = 0,
  SPEAKER_SYSTEM,
  SPEAKER_NARRATOR,
    // ...
  SPEAKER_COUNT,
  SPEAKER_DEFAULT = DIALOG.SPEAKER_NONE,

  // Emotions
  EMOTION_NONE = 0,
    // ...
  EMOTION_COUNT,
  EMOTION_DEFAULT = DIALOG.EMOTION_NONE,

  // Anchors
  ANCHOR_BOTTOM = 0,
  ANCHOR_CENTER,
  ANCHOR_TOP,
    // ...
  ANCHOR_COUNT,
  ANCHOR_DEFAULT = DIALOG.ANCHOR_BOTTOM,

  // Textbox types
  TEXTBOX_NONE = 0,
    // ...
  TEXTBOX_COUNT,
  TEXTBOX_DEFAULT = DIALOG.TEXTBOX_NONE,

  // Positioning codes (should not edit)
  POSITION_CODE_NONE = -5,
  POSITION_CODE_SCENE_END,
  POSITION_CODE_SCENE_RESTART,
  POSITION_CODE_SEQUENCE_END,
  POSITION_CODE_SEQUENCE_RESTART,
  POSITION_CODE_COUNT = -DIALOG.POSITION_CODE_NONE,

  // Positioning masks (should not edit)
  __BITMASK_SPEAKER_SHIFT = 0,
  __BITMASK_SPEAKER_BITS = 8,
  __BITMASK_SPEAKER_MASK = ((1 << DIALOG.__BITMASK_SPEAKER_BITS) - 1) << DIALOG.__BITMASK_SPEAKER_SHIFT,
  __BITMASK_POSITION_DIALOG_SHIFT = 0,
  __BITMASK_POSITION_DIALOG_BITS = 13,
  __BITMASK_POSITION_DIALOG_MASK = ((1 << DIALOG.__BITMASK_POSITION_DIALOG_BITS) - 1) << DIALOG.__BITMASK_POSITION_DIALOG_SHIFT,
  __BITMASK_EMOTION_SHIFT = DIALOG.__BITMASK_SPEAKER_SHIFT + DIALOG.__BITMASK_SPEAKER_BITS,
  __BITMASK_EMOTION_BITS = 6,
  __BITMASK_EMOTION_MASK = ((1 << DIALOG.__BITMASK_EMOTION_BITS) - 1) << DIALOG.__BITMASK_EMOTION_SHIFT,
  __BITMASK_ANCHOR_SHIFT = DIALOG.__BITMASK_EMOTION_SHIFT + DIALOG.__BITMASK_EMOTION_BITS,
  __BITMASK_ANCHOR_BITS = 4,
  __BITMASK_ANCHOR_MASK = ((1 << DIALOG.__BITMASK_ANCHOR_BITS) - 1) << DIALOG.__BITMASK_ANCHOR_SHIFT,
  __BITMASK_TEXTBOX_SHIFT = DIALOG.__BITMASK_ANCHOR_SHIFT + DIALOG.__BITMASK_ANCHOR_BITS,
  __BITMASK_TEXTBOX_BITS = 4,
  __BITMASK_TEXTBOX_MASK = ((1 << DIALOG.__BITMASK_TEXTBOX_BITS) - 1) << DIALOG.__BITMASK_TEXTBOX_SHIFT,
  __BITMASK_POSITION_SEQUENCE_SHIFT = DIALOG.__BITMASK_POSITION_DIALOG_SHIFT + DIALOG.__BITMASK_POSITION_DIALOG_BITS,
  __BITMASK_POSITION_SEQUENCE_BITS = 8,
  __BITMASK_POSITION_SEQUENCE_MASK = ((1 << DIALOG.__BITMASK_POSITION_SEQUENCE_BITS) - 1) << DIALOG.__BITMASK_POSITION_SEQUENCE_SHIFT,
  __BITMASK_POSITION_SCENE_SHIFT = DIALOG.__BITMASK_POSITION_SEQUENCE_SHIFT + DIALOG.__BITMASK_POSITION_SEQUENCE_BITS,
  __BITMASK_POSITION_SCENE_BITS = 10,
  __BITMASK_POSITION_SCENE_MASK = ((1 << DIALOG.__BITMASK_POSITION_SCENE_BITS) - 1) << DIALOG.__BITMASK_POSITION_SCENE_SHIFT,
}



// Edit as needed

/**
 * @desc Contains all the useful information about a dialog effect.
 * @desc `TYPE_*` options refer to the effect type.
 * @desc `TRIGGER_*` options refer to the effect trigger type.
 * @desc `FALLBACK_CONDITION_*` options refer to the conditions of fallback effects.
 * @desc `ARG_*` options refer to the positions of the arguments passed to the effects.
 * @desc `__BITMASK_*` options are used to manage bitmasks and should not be referenced directly.
 */

enum DIALOG_FX
{
  // FX types
  TYPE_ANY = 0,
  TYPE_JUMP,
  TYPE_FALLBACK,
  TYPE_STATE_MODIFY,
    // ...
  TYPE_COUNT,
  TYPE_DEFAULT = DIALOG_FX.TYPE_ANY,

  // FX triggers
  TRIGGER_AUTO = 0,
  TRIGGER_ON_START,
  TRIGGER_ON_CUSTOM,
  TRIGGER_ON_END,
  TRIGGER_NONE,
    // ...
  TRIGGER_COUNT,
  TRIGGER_DEFAULT = DIALOG_FX.TRIGGER_AUTO,

  // Fallback FX conditions
  FALLBACK_CONDITION_FALSE = 0,
  FALLBACK_CONDITION_TRUE,

  // FX arg positions
  ARG_JUMP_DESTINATION = 0,
  ARG_JUMP_CONDITION = 1,

  // Masks (should not be edited)
  __BITMASK_TYPE_SHIFT = 0,
  __BITMASK_TYPE_BITS = 5,
  __BITMASK_TYPE_MASK = ((1 << DIALOG_FX.__BITMASK_TYPE_BITS) - 1) << DIALOG_FX.__BITMASK_TYPE_SHIFT,
  __BITMASK_TRIGGER_SHIFT = DIALOG_FX.__BITMASK_TYPE_SHIFT + DIALOG_FX.__BITMASK_TYPE_BITS,
  __BITMASK_TRIGGER_BITS = 3,
  __BITMASK_TRIGGER_MASK = ((1 << DIALOG_FX.__BITMASK_TRIGGER_BITS) - 1) << DIALOG_FX.__BITMASK_TRIGGER_SHIFT,
}












// ----------------------------------------------------------------------------












/**
 * @desc `DialogManager` constructor.
 * @param {String | Id.TextFile} data_string The data to parse.
 * @param {Bool} is_file Specifies whether `data_string` is a file (`true`) or not (`false`).
 * @param {Struct} contractor The struct, instance or object where to assign the properties.
 * @returns {Struct.DialogManager}
 */

function DialogManager(data_string, is_file, contractor) constructor
{
  /**
   * @desc Executes the inconditional jump effect.
   * @param {Array<Any>} argv The arguments to pass to the fx function.
   * @returns {Struct.Dialog}
   */

  static __fx_jump = function(argv)
  {
    with (global.dialog_manager)
      return __jump(__resolve_position(argv[DIALOG_FX.ARG_JUMP_DESTINATION]));
  }



  /**
   * @desc Executes the conditional jump effect.
   * @param {Array<Any>} argv The arguments to pass to the fx function.
   * @returns {Struct.Dialog}
   */

  static __fx_fallback = function(argv)
  {
    with (global.dialog_manager)
      return condition_map[argv[DIALOG_FX.ARG_JUMP_CONDITION]](argv)
        ? __get_dialog_position(__resolve_position(argv[DIALOG_FX.ARG_JUMP_DESTINATION]))
        : __get_dialog()
      ;
  }



  /**
   * @desc Any `false` condition.
   * @returns {Bool}
   */

  static __condition_false = function()
  {
    return false;
  }



  /**
   * @desc Any `true` condition.
   * @returns {Bool}
   */

  static __condition_true = function()
  {
    return true;
  }



  /**
   * @desc Returns a scene given the scene index.
   * @param {Real} [scene_id] The scene index. Defaults to current scene.
   * @returns {Struct.DialogScene}
   */

  static __get_scene = function(scene_idx = __decode_scene_idx(self.position))
  {
    return self.scenes[scene_idx];
  }



  /**
   * @desc Returns a scene given the scene and sequence indeces.
   * @param {Real} [scene_idx] The scene index. Defaults to current scene.
   * @param {Real} [sequence_idx] The sequence index. Defaults to current sequence.
   * @returns {Struct.DialogSequence}
   */

  static __get_sequence = function(sequence_idx = __decode_sequence_idx(self.position), scene_idx = __decode_scene_idx(self.position))
  {
    return __get_scene(scene_idx).sequences[sequence_idx];
  }



  /**
   * @desc Returns a dialog given the scene, sequence and dialog indeces.
   * @param {Real} [scene_idx] The scene index. Defaults to current scene.
   * @param {Real} [sequence_idx] The sequence index. Defaults to current sequence.
   * @param {Real} [dialog_idx] The dialog index. Defaults to current dialog.
   * @returns {Struct.Dialog}
   */

  static __get_dialog = function(dialog_idx = __decode_dialog_idx(self.position), sequence_idx = __decode_sequence_idx(self.position), scene_idx = __decode_scene_idx(self.position))
  {
    return __get_sequence(sequence_idx, scene_idx).dialogs[dialog_idx];
  }



  /**
   * @desc Returns a dialog given an encoded position.
   * @param {Real} [position] The encoded position. Defaults to current position.
   * @returns {Struct.Dialog}
   */

  static __get_dialog_position = function(position = self.position)
  {
    return __get_dialog(__decode_dialog_idx(position), __decode_sequence_idx(position), __decode_scene_idx(position));
  }



  /**
   * @desc Sets the position to match a given scene index.
   * @param {Real} [scene_idx] The new scene index. Defaults to `0`.
   */

  static __set_scene_idx = function(scene_idx = 0)
  {
    self.position = __set_mask_region(DIALOG.__BITMASK_POSITION_SCENE_SHIFT, DIALOG.__BITMASK_POSITION_SCENE_BITS, scene_idx);
  }



  /**
   * @desc Sets the position to match a given sequence index.
   * @param {Real} [sequence_idx] The new sequence index. Defaults to `0`.
   */

  static __set_sequence_idx = function(sequence_idx = 0)
  {
    self.position = __set_mask_region(DIALOG.__BITMASK_POSITION_SEQUENCE_SHIFT, DIALOG.__BITMASK_POSITION_SEQUENCE_BITS, sequence_idx);
  }



  /**
   * @desc Sets the position to match a given dialog index.
   * @param {Real} [dialog_idx] The new dialog index. Defaults to `0`.
   */

  static __set_dialog_idx = function(dialog_idx = 0)
  {
    self.position = __set_mask_region(DIALOG.__BITMASK_POSITION_DIALOG_SHIFT, DIALOG.__BITMASK_POSITION_DIALOG_BITS, dialog_idx);
  }



  /**
   * @desc Sets the position to a given one.
   * @param {Real} [scene_idx] The new scene index. Defaults to `0`.
   * @param {Real} [sequence_idx] The new sequence index. Defaults to `0`.
   * @param {Real} [dialog_idx] The new dialog index. Defaults to `0`.
   */

  static __set_position = function(scene_idx = 0, sequence_idx = 0, dialog_idx = 0)
  {
    self.position = __encode_position(scene_idx, sequence_idx, dialog_idx);
  }



  /**
   * @desc Appends a new scene to the scene list.
   * @param {Struct.DialogScene} scene The new scene to add.
   * @returns {Struct.DialogManager}
   */

  static __add_scene = function(scene)
  {
    scene.scene_idx = self.scene_count++;

    array_push(self.scenes, scene);

    return self;
  }



  /**
   * @desc Appends new scenes to the scene list.
   * @param {Array<Struct.DialogScene>} scenes The new scenes to add.
   * @returns {Struct.DialogManager}
   */

  static __add_scenes = function(scenes)
  {
    var new_scene_count = array_length(scenes);

    for (var i = 0; i < new_scene_count; ++i)
      scenes[i].scene_idx = self.scene_count + i;

    self.scenes = array_concat(self.scenes, scenes);
    self.scene_count += new_scene_count;

    return self;
  }



  /**
   * @desc Inserts a scene in the scene list at a given index.
   * @param {Struct.DialogScene} scene The new scene to add.
   * @param {Real} [index] The index where to add the new scene. Defaults to last index.
   * @returns {Struct.DialogManager}
   */

  static __insert_scene = function(scene, index = array_length(self.scenes))
  {
    for (var i = index; i < scene_count; ++i)
      ++self.scenes[i].scene_idx;

    scene.scene_idx = index;
    ++scene_count;

    array_insert(self.scenes, index, scene);

    return self;
  }



  /**
   * @desc Inserts scenes in the scene list at a given index.
   * @param {Array<Struct.DialogScene>} scenes The new scenes to add.
   * @param {Real} [index] The index where to add the new scenes. Defaults to last index.
   * @returns {Struct.DialogManager}
   */

  static __insert_scenes = function(scenes, index = array_length(self.scenes))
  {
    var new_scene_count = array_length(scenes);

    for (var i = index; i < scene_count; ++i)
      scenes[i].scene_idx += new_scene_count;

    for (var i = 0; i < new_scene_count; ++i)
      array_insert(self.scenes, index + i, scenes[i]);

    self.scene_count += new_scene_count;

    return self;
  }



  /**
   * @desc Appends a new sequence to the sequence list of a selected scene.
   * @param {Struct.DialogSequence} sequence The new sequence to add.
   * @param {Real} [scene_idx] The scene index. Defaults to current scene.
   * @returns {Struct.DialogManager}
   */

  static __add_sequence = function(sequence, scene_idx = __get_scene_idx(self.position))
  {
    __get_scene(scene_idx).__add_sequence(sequence);

    return self;
  }



  /**
   * @desc Appends new sequences to the sequence list of a selected scene.
   * @param {Array<Struct.DialogSequence>} sequences The new sequences to add.
   * @param {Real} [scene_idx] The scene index. Defaults to current scene.
   * @returns {Struct.DialogManager}
   */

  static __add_sequences = function(sequences, scene_idx = __get_scene_idx(self.position))
  {
    __get_scene(scene_idx).__add_sequences(sequences);

    return self;
  }



  /**
   * @desc Appends a new dialog to the dialog list of a selected sequence.
   * @param {Struct.Dialog} dialog The new dialog to add.
   * @param {Real} [scene_idx] The scene index. Defaults to current scene.
   * @param {Real} [sequence_idx] The sequence index. Defaults to current sequence.
   * @returns {Struct.DialogManager}
   */

  static __add_dialog = function(dialog, sequence_idx = __get_sequence_idx(self.position), scene_idx = __get_scene_idx(self.position))
  {
    __get_sequence(scene_idx, sequence_idx).__add_dialog(dialog);

    return self;
  }



  /**
   * @desc Appends new dialogs to the dialog list of a selected sequence.
   * @param {Array<Struct.Dialog>} dialogs The new dialogs to add.
   * @param {Real} [scene_idx] The scene index. Defaults to current scene.
   * @param {Real} [sequence_idx] The sequence index. Defaults to current sequence.
   * @returns {Struct.DialogManager}
   */

  static __add_dialogs = function(dialogs, sequence_idx = __get_sequence_idx(self.position), scene_idx = __get_scene_idx(self.position))
  {
    __get_sequence(scene_idx, sequence_idx).__add_dialogs(dialogs);

    return self;
  }



  /**
   * @desc Encodes a position given the specified indices.
   * @param {Real} scene_idx The scene index to encode.
   * @param {Real} sequence_idx The sequence index to encode.
   * @param {Real} dialog_idx The dialog index to encode.
   * @returns {Real}
   */

  static __encode_position = function(scene_idx, sequence_idx, dialog_idx)
  {
    return __encode_scene_idx(scene_idx) | __encode_sequence_idx(sequence_idx) | __encode_dialog_idx(dialog_idx);
  }



  /**
   * @desc Encodes a dialog position given an index.
   * @param {Real} dialog_idx The dialog index to encode.
   * @returns {Real}
   */

  static __encode_dialog_idx = function(dialog_idx)
  {
    return dialog_idx << DIALOG.__BITMASK_POSITION_DIALOG_SHIFT & DIALOG.__BITMASK_POSITION_DIALOG_MASK;
  }



  /**
   * @desc Encodes a sequence position given an index.
   * @param {Real} sequence_idx The sequence index to encode.
   * @returns {Real}
   */

  static __encode_sequence_idx = function(sequence_idx)
  {
    return sequence_idx << DIALOG.__BITMASK_POSITION_SEQUENCE_SHIFT & DIALOG.__BITMASK_POSITION_SEQUENCE_MASK;
  }



  /**
   * @desc Encode a scene position given an index.
   * @param {Real} scene_idx The scene index to encode.
   * @returns {Real}
   */

  static __encode_scene_idx = function(scene_idx)
  {
    return scene_idx << DIALOG.__BITMASK_POSITION_SCENE_SHIFT & DIALOG.__BITMASK_POSITION_SCENE_MASK;
  }



  /**
   * @desc Decodes a specified partition of a bitmask.
   * @param {Real} shift The left shift of the region's LSB.
   * @param {Real} bits The number of bits of the region.
   * @param {Real} [bitfield] The bitfield to retrieve the data from. Defaults to current position.
   */

  static __get_mask_region = function(shift, bits, bitfield = self.position)
  {
    return bitfield >> shift & ((1 << bits) - 1);
  }



  /**
   * @desc Encodes a specified partition of a bitmask.
   * @param {Real} shift The left shift of the region's LSB.
   * @param {Real} bits The number of bits of the region.
   * @param {Real} [mask] The value to set to the region.
   * @param {Real} [bitfield] The bitfield to retrieve the data from. Defaults to current position.
  */

  static __set_mask_region = function(shift, bits, mask = 0, bitfield = self.position)
  {
    return bitfield & ~(((1 << bits) - 1) << shift) | mask << shift;
  }



  /**
   * @desc Returns the scene index given a position.
   * @param {Real} position The position to decode. Defaults to current position.
   * @returns {Real}
   */

  static __decode_scene_idx = function(position = self.position)
  {
    return (position & DIALOG.__BITMASK_POSITION_SCENE_MASK) >> DIALOG.__BITMASK_POSITION_SCENE_SHIFT;
  }



  /**
   * @desc Returns the sequence index given a position.
   * @param {Real} position The position to decode. Defaults to current position.
   * @returns {Real}
   */

  static __decode_sequence_idx = function(position = self.position)
  {
    return (position & DIALOG.__BITMASK_POSITION_SEQUENCE_MASK) >> DIALOG.__BITMASK_POSITION_SEQUENCE_SHIFT;
  }



  /**
   * @desc Returns the dialog index given a position.
   * @param {Real} position The position to decode. Defaults to current position.
   * @returns {Real}
   */

  static __decode_dialog_idx = function(position = self.position)
  {
    return (position & DIALOG.__BITMASK_POSITION_DIALOG_MASK) >> DIALOG.__BITMASK_POSITION_DIALOG_SHIFT;
  }



  /**
   * @desc Sets the position to match a given scene's index.
   * @param {Struct.DialogScene} scene The scene to jump to.
   */

  static __jump_to_scene = function(scene)
  {
    __set_position(scene.scene_idx, 0, 0);
  }



  /**
   * @desc Sets the position to match a given sequence's index.
   * @param {Struct.DialogSequence} sequence The sequence to jump to.
   */

  static __jump_to_sequence = function(sequence)
  {
    var scene = sequence.scene;

    __set_position(scene.scene_idx, sequence.sequence_idx, 0);
  }



  /**
   * @desc Sets the position to match a given dialog's index.
   * @param {Struct.Dialog} dialog The dialog to jump to.
   */

  static __jump_to_dialog = function(dialog)
  {
    var sequence = dialog.sequence
      , scene = sequence.scene
    ;

    __set_position(scene.scene_idx, sequence.sequence_idx, dialog.dialog_idx);
  }



  /**
   * @desc Sets the position to match a given one.
   * @param {Real | Constant.Dialog} position The position to jump to. Defaults to current position.
   * @returns {Struct.Dialog}
   */

  static __jump = function(position = self.position)
  {
    var current_dialog = __get_dialog_position(self.position)
      , target_dialog = __get_dialog_position(position)
    ;

    current_dialog.__fx_execute_all_of(function(fx) {
      return fx.__decode_fx_trigger() == DIALOG_FX.TRIGGER_ON_END;
    });

    var fallback_fx = target_dialog.__get_fallback();

    if (fallback_fx)
      return __jump(__resolve_position(fallback_fx.argv[DIALOG_FX.ARG_JUMP_DESTINATION]));

    target_dialog.__fx_execute_all_of(function(fx) {
      return fx.__decode_fx_trigger() == DIALOG_FX.TRIGGER_ON_START;
    });

    self.position = target_dialog.__get_position();

    return target_dialog;
  }



  /**
   * Evaluates a given position to determine the destination of a jump.
   * @param {Real | Constant.Dialog} [position] The position to resolve. Defaults to current position.
   * @returns {Real}
   */

  static __resolve_position = function(position = self.position)
  {
    var scene_idx = __decode_scene_idx(self.position)
      , sequence_idx = __decode_sequence_idx(self.position)
    ;

    switch (position)
    {
      case DIALOG.POSITION_CODE_SCENE_END:
        return __encode_position(scene_idx + 1, 0, 0);
      case DIALOG.POSITION_CODE_SCENE_RESTART:
        return __encode_position(scene_idx, 0, 0);
      case DIALOG.POSITION_CODE_SEQUENCE_END:
        return __encode_position(scene_idx, sequence_idx + 1, 0);
      case DIALOG.POSITION_CODE_SEQUENCE_RESTART:
        return __encode_position(scene_idx, sequence_idx, 0);
    }

    return position ?? 0;
  }



  /**
   * @desc Makes the dialog manager advance a given number of dialogs.
   * @param {Real} [idx_shift] The number of dialogs to advance of. Defaults to `1`.
   * @returns {Struct.Dialog}
   */

  static __next = function(idx_shift = 1)
  {
    var jump_fx = __get_dialog().__get_jump();

    if (jump_fx)
      return __jump(__resolve_position(jump_fx.argv[DIALOG_FX.ARG_JUMP_DESTINATION]));

    var current_scene = __get_scene();
    var current_sequence = __get_sequence();
    var scene_count = array_length(self.scenes);
    var sequence_count = array_length(current_scene.sequences);
    var dialog_count = array_length(current_sequence.dialogs);

    var next_dialog_idx = __decode_dialog_idx(self.position) + idx_shift
      , next_sequence_idx = __decode_sequence_idx(self.position)
      , next_scene_idx = __decode_scene_idx(self.position)
    ;

    var reset_dialog = next_dialog_idx < dialog_count;
    next_dialog_idx *= reset_dialog;
    next_sequence_idx += !reset_dialog;

    var reset_sequence = next_sequence_idx < sequence_count;
    next_sequence_idx *= reset_sequence;
    next_scene_idx += !reset_sequence;

    next_scene_idx *= next_scene_idx < scene_count;

    return __jump(__encode_position(next_scene_idx, next_sequence_idx, next_dialog_idx));
  }



  /**
   * @desc Converts all the dialog manager data to a JSON string.
   * @param {Bool} [prettify] Specifies whether the output should be prettified (`true`) or not (`false`). Defaults to `false`.
   * @returns {String}
   */

  static __serialize = function(prettify = false)
  {
    return json_stringify(
      array_map(self.scenes, function(scene) {
        return scene.__DIALOG_MANAGER_ENCODING_METHOD__();
      }),
      prettify
    );
  }



  /**
   * @desc Parses a string loading all the data in the dialog manager.
   * @param {String | Id.TextFile} [data_string] The data string to parse.
   * @param {Bool} [is_file] Specifies whether the data string is a file name to read from (`true`) or not (`false`). Defaults to `false`.
   * @returns {Struct.DialogManager}
   */

  static __deserialize = function(data_string = "", is_file = false)
  {
    if (is_file)
    {
      var file = data_string
        , autoclose = !is_numeric(file)
      ;

      if (autoclose)
        file = file_text_open_read(file);

      if (!file)
        return self;

      for (data_string = ""; !file_text_eof(file); file_text_readln(file))
        data_string += file_text_read_string(file);

      if (autoclose)
        file_text_close(file);
    }

    if (data_string == "")
      return self;

    var data = json_parse(data_string);

    self.scenes = array_map(data, function(scene) {
      return DialogScene.__DIALOG_MANAGER_DECODING_METHOD__(scene);
    });

    return self;
  }



  /**
   * @desc Resets the state of the manager.
   * @returns {Struct.DialogManager}
   */

  static __reset_parser_state = function()
  {
    self.scenes = [];
    self.scene_count = 0;
    DialogScene.scene_id = 0;
    DialogSequence.sequence_id = 0;

    self.position = 0;

    return self;
  }



  static fx_map = [
    /* Make and add functions to index here */
    function(argv) { },
    function(argv) { return global.dialog_manager.__fx_jump(argv); },
    function(argv) { return global.dialog_manager.__fx_fallback(argv); },
  ];

  static condition_map = [
    /* Make and add condition functions to index here */
    function(argv) { return false; },
    function(argv) { return true; },
  ];



  self.status = 0;
  self.position = 0;
  self.scene_count = 0;
  self.scenes = [];

  __deserialize(data_string, is_file);

  global.dialog_manager = self;
  contractor.dialog_speakers = array_create(DIALOG.SPEAKER_COUNT);
  contractor.dialog_emotions = array_create(DIALOG.EMOTION_COUNT);
  contractor.dialog_anchors = array_create(DIALOG.ANCHOR_COUNT);
  contractor.dialog_textboxes = array_create(DIALOG.TEXTBOX_COUNT);
  contractor.dialog_fx_types = array_create(DIALOG_FX.TYPE_COUNT);
  contractor.dialog_fx_triggers = array_create(DIALOG_FX.TRIGGER_COUNT);

  for (var i = 0; i < DIALOG.SPEAKER_COUNT; ++i)
    contractor.dialog_speakers[i] = i << DIALOG.__BITMASK_SPEAKER_SHIFT & DIALOG.__BITMASK_SPEAKER_MASK;

  for (var i = 0; i < DIALOG.EMOTION_COUNT; ++i)
    contractor.dialog_emotions[i] = i << DIALOG.__BITMASK_EMOTION_SHIFT & DIALOG.__BITMASK_EMOTION_MASK;

  for (var i = 0; i < DIALOG.ANCHOR_COUNT; ++i)
    contractor.dialog_anchors[i] = i << DIALOG.__BITMASK_ANCHOR_SHIFT & DIALOG.__BITMASK_ANCHOR_MASK;

  for (var i = 0; i < DIALOG.TEXTBOX_COUNT; ++i)
    contractor.dialog_textboxes[i] = i << DIALOG.__BITMASK_TEXTBOX_SHIFT & DIALOG.__BITMASK_TEXTBOX_MASK;

  for (var i = 0; i < DIALOG_FX.TYPE_COUNT; ++i)
    contractor.dialog_fx_types[i] = i << DIALOG_FX.__BITMASK_TYPE_SHIFT & DIALOG_FX.__BITMASK_TYPE_MASK;

  for (var i = 0; i < DIALOG_FX.TRIGGER_COUNT; ++i)
    contractor.dialog_fx_triggers[i] = i << DIALOG_FX.__BITMASK_TRIGGER_SHIFT & DIALOG_FX.__BITMASK_TRIGGER_MASK;
}












// ----------------------------------------------------------------------------












/**
 * @desc `DialogLinkable` constructor. Used to generalize dialog components' types.
 * @returns {Struct.DialogLinkable}
 */

function DialogLinkable() constructor {}












// ----------------------------------------------------------------------------












/**
 * `DialogScene` constructor.
 * @param {Array<Struct.DialogSequence>} [sequences] - The array of `DialogSequence` of the scene.
 * @param {Real} [settings_mask] - The scene settings.
 * @returns {Struct.DialogScene}
 */

function DialogScene(sequences, settings_mask) : DialogLinkable() constructor
{
  static scene_id = 0;

  self.scene_idx = 0;
  self.scene_id = scene_id++;
  self.sequences = [];
  self.settings_mask = settings_mask;



  /**
   * @desc Overrides this scene's unique ID with a custom one.
   * @param {Real} override_scene_id The new scene-identifier to force-set.
   * @returns {Struct.DialogScene}
   */

  static __override_id = function(override_scene_id)
  {
    self.scene_id = override_scene_id;
    --DialogScene.scene_id;

    return self;
  }



  /**
   * @desc Serialises the scene into a compact array.
   * @returns {Array}
   */

  static __array = function()
  {
    return [
      int64(scene_id),
      array_map(sequences, function(sequence) {
        return sequence.__DIALOG_MANAGER_ENCODING_METHOD__();
      }),
      int64(settings_mask),
    ];
  }



  /**
   * @desc Serialises the scene into a plain struct.
   * @returns {Struct}
   */

  static __struct = function()
  {
    return {
      scene_id: int64(scene_id),
      sequences: array_map(sequences, function(sequence) {
        return sequence.__DIALOG_MANAGER_ENCODING_METHOD__();
      }),
      settings_mask: int64(settings_mask),
    };
  }



  /**
   * @desc Deserializes a scene from an array produced by {@link __array}.
   * @param {Array} data The array payload.
   * @returns {Struct.DialogScene}
   */

  static __from_array = function(data)
  {
    return new DialogScene(
      array_map(data[1], function(sequence) {
        return DialogSequence.__DIALOG_MANAGER_DECODING_METHOD__(sequence);
      }),
      data[2],
    )
    .__override_id(data[0])
    .__update_sequences();
  }



  /**
   * @desc Deserializes a scene from a struct produced by {@link __struct}.
   * @param {Struct} data The struct payload.
   * @returns {Struct.DialogScene}
   */

  static __from_struct = function(data)
  {
    return new DialogScene(
      array_map(data.sequences, function(sequence) {
        return DialogSequence.__DIALOG_MANAGER_DECODING_METHOD__(sequence);
      }),
      data.settings_mask,
    )
    .__override_id(data.scene_id)
    .__update_sequences();
  }



  /**
   * @desc Appends a sequence to the scene's sequence list.
   * @param {Struct.DialogSequence} sequence The new sequence to add.
   * @returns {Struct.DialogScene}
   */

  static __add_sequence = function(sequence)
  {
    sequence.sequence_idx = array_length(self.sequences);
    sequence.scene = self;

    array_push(self.sequences, sequence);

    return self;
  }



  /**
   * @desc Appends new sequences to the scene's sequence list.
   * @param {Array<Struct.DialogSequence>} sequences The new sequences to add.
   * @returns {Struct.DialogScene}
   */

  static __add_sequences = function(sequences)
  {
    var sequence_count = array_length(self.sequences);

    for (var i = array_length(sequences) - 1; i >= 0; --i)
    {
      sequences[i].sequence_idx = sequence_count + i;
      sequences[i].scene = self;
    }

    self.sequences = array_concat(self.sequences, sequences);

    return self;
  }



  /**
   * @desc Inserts a sequence in the scene list at a given index.
   * @param {Struct.DialogSequence} sequence The new sequence to add.
   * @param {Real} [index] The index where to add the new sequence. Defaults to last index.
   * @returns {Struct.DialogScene}
   */

  static __insert_sequence = function(sequence, index = array_length(self.sequences))
  {
    sequence.sequence_idx = index;
    sequence.scene = self;

    for (var i = array_length(self.sequences) - 1; i >= index; --i)
      ++self.sequences[i].sequence_idx;

    array_insert(self.sequences, index, sequence);

    return self;
  }



  /**
   * @desc Inserts sequences in the scene list at a given index.
   * @param {Array<Struct.DialogSequence>} sequences The new sequences to add.
   * @param {Real} [index] The index where to add the new sequences. Defaults to last index.
   * @returns {Struct.DialogScene}
   */

  static __insert_sequences = function(sequences, index = array_length(self.sequences))
  {
    var sequence_count = array_length(self.sequences);
    var new_sequence_count = array_length(sequences);

    for (var i = sequence_count - 1; i >= index; --i)
      ++self.sequences[i].sequence_idx;

    for (var i = 0; i < new_sequence_count; ++i)
    {
      sequences[i].scene = self;
      sequences[i].sequence_idx = index + i;
      array_insert(self.sequences, index + i, sequences[i]);
    }

    return self;
  }



  /**
   * @desc Renumbers every sequence to match its array position and refreshes the back-link to this scene.
   * @returns {Struct.DialogScene}
   */

  static __update_sequences = function()
  {
    for (var i = array_length(self.sequences) - 1; i >= 0; self.sequences[i--].scene = self)
      self.sequences[i].sequence_idx = i;

    return self;
  }



  /**
   * @desc Retrieves the scene's global position.
   * @returns {Real}
   */

  static __get_position = function()
  {
    return DialogManager.__encode_position(self.scene_idx, 0, 0);
  }



  /**
   * @desc Creates a map of the dialog speakers and readapts the ones in the dialog to match the relative map index.
   * @returns {Void}
   */

  static __map_speakers = function()
  {
    self.speaker_map = [];

    var map = {}
      , count = 0
    ;

    for (var i = array_length(self.dialogs) - 1; i >= 0; --i)
    {
      var dialog = self.dialogs[i];

      if (!struct_exists(map, dialog.speaker_id))
      {
        struct_set(map, dialog.speaker_id, count);
        self.speaker_map[count++] = dialog.speaker_id;
      }

      dialog.speaker_id = struct_get(map, dialog.speaker_id);
    }
  }



  /**
   * @desc Serialises the scene to JSON.
   * @param {Bool} [prettify] Whether the string should have line breaks/indentation (`true`) or not (`false`).
   * @returns {String}
   */

  static __serialize = function(prettify = false)
  {
    return json_stringify(__DIALOG_MANAGER_ENCODING_METHOD__(), prettify);
  }



  /**
   * @desc Deserialises a JSON string produced by {@link __serialize}.
   * @param {String} data_string The JSON payload.
   * @returns {Struct.DialogScene}
   */

  static __deserialize = function(data_string)
  {
    var data = json_parse(data_string);
    return __DIALOG_MANAGER_DECODING_METHOD__(data).__update_sequences();
  }



  __add_sequences(sequences);
}












// ----------------------------------------------------------------------------












/**
 * `DialogSequence` constructor.
 * @param {Array<Struct.Dialog>} [dialogs] - The array of `Dialog` of the sequence.
 * @param {Array<Real>} [speaker_map] - The indexes of the speakers.
 * @returns {Struct.DialogSequence}
 */

function DialogSequence(dialogs, speaker_map) : DialogLinkable() constructor
{
  static sequence_id = 0;

  self.scene = undefined;
  self.sequence_id = sequence_id++;
  self.speaker_map = speaker_map;
  self.sequence_idx = 0;
  self.dialogs = [];



  /**
   * @desc Overrides this sequence's unique ID with a custom one.
   * @param {Real} override_sequence_id The new sequence-identifier to force-set.
   * @returns {Struct.DialogSequence}
   */

  static __override_id = function(override_sequence_id)
  {
    self.sequence_id = override_sequence_id;
    --DialogSequence.sequence_id;

    return self;
  }



  /**
   * @desc Serialises the sequence into a compact array.
   * @returns {Array}
   */

  static __array = function()
  {
    return [
      int64(sequence_id),
      array_map(dialogs, function(dialog) {
        return dialog.__DIALOG_MANAGER_ENCODING_METHOD__();
      }),
      array_map(speaker_map, function(speaker) {
        return int64(speaker);
      })
    ];
  }



  /**
   * @desc Serialises the sequence into a plain struct.
   * @returns {Struct}
   */

  static __struct = function()
  {
    return {
      sequence_id: int64(sequence_id),
      dialogs: array_map(dialogs, function(dialog) {
        return dialog.__DIALOG_MANAGER_ENCODING_METHOD__();
      }),
      speaker_map: array_map(speaker_map, function(speaker) {
        return int64(speaker);
      })
    };
  }



  /**
   * @desc Deserialises a sequence from an array produced by {@link __array}.
   * @param {Array} data The array payload.
   * @returns {Struct.DialogSequence}
   */

  static __from_array = function(data)
  {
    return new DialogSequence(
      array_map(data[1], function(dialog) {
        return Dialog.__DIALOG_MANAGER_DECODING_METHOD__(dialog);
      }),
      data[2]
    )
    .__override_id(data[0])
    .__update_dialogs();
  }



  /**
   * @desc Deserialises a sequence from a struct produced by {@link __struct}.
   * @param {Struct} data The struct payload.
   * @returns {Struct.DialogSequence}
   */

  static __from_struct = function(data)
  {
    return new DialogSequence(
      array_map(data.dialogs, function(dialog) {
        return Dialog.__DIALOG_MANAGER_DECODING_METHOD__(dialog);
      }),
      data.speaker_map
    )
    .__override_id(data.sequence_id)
    .__update_dialogs();
  }




  /**
   * @desc Appends a dialog to the sequence's dialog list.
   * @param {Struct.Dialog} dialog The new dialog to add.
   * @returns {Struct.DialogSequence}
   */

  static __add_dialog = function(dialog)
  {
    dialog.sequence = self;
    dialog.dialog_idx = array_length(self.dialogs);

    array_push(self.dialogs, dialog);

    return self;
  }



  /**
   * @desc Appends new dialogs to the sequence's dialog list.
   * @param {Array<Struct.Dialog>} dialogs The new dialogs to add.
   * @returns {Struct.DialogSequence}
   */

  static __add_dialogs = function(dialogs)
  {
    var dialog_count = array_length(dialogs);

    for (var i = dialog_count - 1; i >= 0; dialogs[i--].sequence = self)
      dialogs[i].dialog_idx = i;

    self.dialogs = array_concat(self.dialogs, dialogs);

    return self;
  }



  /**
   * @desc Inserts a dialog into the sequence list at a given index.
   * @param {Struct.Dialog} dialog The new dialog to insert.
   * @param {Real} [index] The index where to insert the new dialog. Defaults to last index.
   * @returns {Struct.DialogSequence}
   */

  static __insert_dialog = function(dialog, index = array_length(self.dialogs))
  {
    dialog.sequence = self;
    dialog.dialog_idx = index;

    for (var i = array_length(self.dialogs) - 1; i >= index; --i)
      ++self.dialogs[i].dialog_idx;

    array_insert(self.dialogs, index, dialog);

    return self;
  }



  /**
   * @desc Inserts dialogs into the sequence list at a given index.
   * @param {Array<Struct.Dialog>} dialogs The new dialogs to insert.
   * @param {Real} [index] The index where to insert the new dialogs. Defaults to last index.
   * @returns {Struct.DialogSequence}
   */

  static __insert_dialogs = function(dialogs, index = array_length(self.dialogs))
  {
    var new_dialog_count = array_length(dialogs);

    for (var i = array_length(self.dialogs) - 1; i >= index; --i)
      self.dialogs[i].position += new_dialog_count;

    for (var i = 0; i < new_dialog_count; dialogs[i++].sequence = self)
    {
      array_insert(self.dialogs, index + i, dialogs[i]);
      dialogs[i].dialog_idx = index + i;
    }

    return self;
  }



  /**
   * @desc Retrieves the sequence's global position.
   * @returns {Real}
   */

  static __get_position = function()
  {
    var scene = self.scene;

    return DialogManager.__encode_position(scene.scene_idx, self.sequence_idx, 0);
  }



  /**
   * @desc Renumbers every dialog to match its array position and refreshes the back-link to this sequence.
   * @returns {Struct.DialogSequence}
   */

  static __update_dialogs = function()
  {
    for (var i = array_length(self.dialogs) - 1; i >= 0; self.dialogs[i--].sequence = self)
      self.dialogs[i].dialog_idx = i;

    return self;
  }



  /**
   * @desc Serialises the sequence to JSON.
   * @param {Bool} [prettify] Whether the string should have line breaks/indentation (`true`) or not (`false`).
   * @returns {String}
   */

  static __serialize = function(prettify = false)
  {
    return json_stringify(__DIALOG_MANAGER_ENCODING_METHOD__(), prettify);
  }



  /**
   * @desc Serialises the sequence to JSON.
   * @param {Bool} [prettify] Whether the string should have line breaks/indentation (`true`) or not (`false`).
   * @returns {String}
   */

  static __deserialize = function(data_string)
  {
    var data = json_parse(data_string);
    return __DIALOG_MANAGER_DECODING_METHOD__(data).__update_dialogs();
  }



  __add_dialogs(dialogs);
}












// ----------------------------------------------------------------------------
















/**
 * `Dialog` constructor.
 * @param {String} text - The text message of the dialog.
 * @param {Constant.DIALOG} [settings_mask] - The dialog info.
 * @param {Array<Struct.DialogFX>} [fx_map] - The array of `DialogFX` to apply.
 * @returns {Struct.Dialog}
 */

function Dialog(text, settings_mask, fx_map) : DialogLinkable() constructor
{
  self.dialog_idx = 0;
  self.sequence = undefined;
  self.text = text;
  self.settings_mask = settings_mask;
  self.fx_map = fx_map;

  array_sort(self.fx_map, function(f1, f2) {
    return f1.type != f2.type
      ? f1.type - f2.type
      : f1.trigger - f2.trigger
    ;
  });



  /**
   * @desc Combines all dialog visual settings into a single bitmask.
   * @param {Constant.DIALOG} [speaker_id] Optional speaker identifier.
   * @param {Constant.DIALOG} [emotion_id] Optional emotion identifier.
   * @param {Constant.DIALOG} [anchor_id] Optional anchor point identifier.
   * @param {Constant.DIALOG} [textbox_id] Optional textbox identifier.
   * @returns {Real}
   */

  static __encode_settings = function(speaker_id = DIALOG.SPEAKER_NONE, emotion_id = DIALOG.EMOTION_DEFAULT, anchor_id = DIALOG.ANCHOR_DEFAULT, textbox_id = DIALOG.TEXTBOX_DEFAULT)
  {
    return __encode_textbox_id(textbox_id) | __encode_anchor_id(anchor_id) | __encode_emotion_id(emotion_id) | __encode_speaker_id(speaker_id);
  }



  /**
   * @desc Encodes only the speaker ID as a bitmask fragment.
   * @param {Constant.DIALOG} speaker_id The speaker identifier.
   * @returns {Real}
   */

  static __encode_speaker_id = function(speaker_id)
  {
    return speaker_id << DIALOG.__BITMASK_SPEAKER_SHIFT & DIALOG.__BITMASK_SPEAKER_MASK;
  }



  /**
   * @desc Encodes only the speaker ID as a bitmask fragment.
   * @param {Constant.DIALOG} speaker_id The speaker identifier.
   * @returns {Real}
   */

  static __encode_emotion_id = function(emotion_id)
  {
    return emotion_id << DIALOG.__BITMASK_EMOTION_SHIFT & DIALOG.__BITMASK_EMOTION_MASK;
  }



  /**
   * @desc Encodes only the anchor ID as a bitmask fragment.
   * @param {Constant.DIALOG} anchor_id The anchor identifier.
   * @returns {Real}
   */

  static __encode_anchor_id = function(anchor_id)
  {
    return anchor_id << DIALOG.__BITMASK_ANCHOR_SHIFT & DIALOG.__BITMASK_ANCHOR_MASK;
  }



  /**
   * @desc Encodes only the textbox ID as a bitmask fragment.
   * @param {Constant.DIALOG} textbox_id The textbox identifier.
   * @returns {Real}
   */

  static __encode_textbox_id = function(textbox_id)
  {
    return textbox_id << DIALOG.__BITMASK_TEXTBOX_SHIFT & DIALOG.__BITMASK_TEXTBOX_MASK;
  }



  /**
   * @desc Extracts the speaker ID from a settings bitmask.
   * @param {Real} settings_mask The settings bitmask. Defaults to the dialog's current mask.
   * @returns {Constant.DIALOG}
   */

  static __decode_speaker_id = function(settings_mask = self.settings_mask)
  {
    return (settings_mask & DIALOG.__BITMASK_SPEAKER_MASK) >> DIALOG.__BITMASK_SPEAKER_SHIFT;
  }



  /**
   * @desc Extracts the emotion ID from a settings bitmask.
   * @param {Real} settings_mask The settings bitmask. Defaults to the dialog's current mask.
   * @returns {Constant.DIALOG}
   */

  static __decode_emotion_id = function(settings_mask = self.settings_mask)
  {
    return (settings_mask & DIALOG.__BITMASK_EMOTION_MASK) >> DIALOG.__BITMASK_EMOTION_SHIFT;
  }



  /**
   * @desc Extracts the anchor ID from a settings bitmask.
   * @param {Real} settings_mask The settings bitmask. Defaults to the dialog's current mask.
   * @returns {Constant.DIALOG}
   */

  static __decode_anchor_id = function(settings_mask = self.settings_mask)
  {
    return (settings_mask & DIALOG.__BITMASK_ANCHOR_MASK) >> DIALOG.__BITMASK_ANCHOR_SHIFT;
  }



  /**
   * @desc Extracts the textbox ID from a settings bitmask.
   * @param {Real} settings_mask The settings bitmask. Defaults to the dialog's current mask.
   * @returns {Constant.DIALOG}
   */

  static __decode_textbox_id = function(settings_mask = self.settings_mask)
  {
    return (settings_mask & DIALOG.__BITMASK_TEXTBOX_MASK) >> DIALOG.__BITMASK_TEXTBOX_SHIFT;
  }



  /**
   * @desc Serialises the dialog into a compact array.
   * @returns {Array}
   */

  static __array = function()
  {
    return [
      text,
      int64(settings_mask),
      array_map(fx_map, function(fx) {
        return fx.__DIALOG_MANAGER_ENCODING_METHOD__();
      })
    ];
  }



  /**
   * @desc Serialises the dialog into a plain struct.
   * @returns {Struct}
   */

  static __struct = function()
  {
    return {
      text,
      settings_mask: int64(settings_mask),
      fx_map: array_map(fx_map, function(fx) {
        return fx.__DIALOG_MANAGER_ENCODING_METHOD__();
      })
    };
  }



  /**
   * @desc Deserialises a dialog from an array produced by {@link __array}.
   * @param {Array} data The array payload.
   * @returns {Struct.Dialog}
   */

  static __from_array = function(data)
  {
    return new Dialog(
      data[0],
      data[1],
      array_map(data[2], function(fx) {
        return DialogFX.__DIALOG_MANAGER_DECODING_METHOD__(fx);
      })
    );
  }



  /**
   * @desc Deserialises a dialog from a struct produced by {@link __struct}.
   * @param {Struct} data The struct payload.
   * @returns {Struct.Dialog}
   */

  static __from_struct = function(data)
  {
    return new Dialog(
      data.text,
      data.settings_mask,
      array_map(data.fx_map, function(fx) {
        return DialogFX.__DIALOG_MANAGER_DECODING_METHOD__(fx);
      })
    );
  }



  /**
   * @desc Retrieves the dialog's global position.
   * @returns {Real}
   */

  static __get_position = function()
  {
    var sequence = self.sequence
      , scene = sequence.scene
    ;

    return DialogManager.__encode_position(scene.scene_idx, sequence.sequence_idx, self.dialog_idx);
  }



  /**
   * @desc Returns the final jump FX in this dialog, if one exists.
   * @returns {Struct.DialogFX}
   */

  static __get_jump = function()
  {
    for (var i = array_length(self.fx_map) - 1; i >= 0; --i)
      if (fx_map[i].__decode_fx_type() == DIALOG_FX.TYPE_JUMP)
        return self.fx_map[i];

    return undefined;
  }



  /**
   * @desc Returns the first fallback FX that evaluates truthfully, if any.
   * @param {Array} [argv] The arguments to pass to the effect.
   * @returns {Struct.DialogFX}
   */

  static __get_fallback = function(argv = undefined)
  {
    var fx_count = array_length(self.fx_map);

    for (var i = 0; i < fx_count; ++i)
      if (fx_map[i].__decode_fx_type() == DIALOG_FX.TYPE_FALLBACK && fx_map[i].__exec(argv))
        return fx_map[i];

    return undefined;
  }



  /**
   * @desc Executes all dialog FX which match a filter.
   * @param {Function} [filter_fn] The predicate to test against each FX. Defaults to "always true".
   * @param {Array} [argv] The arguments to pass to the effect.
   * @returns {Struct.Dialog}
   */

  static __fx_execute_all_of = function(filter_fn = function(fx) { return true; }, argv = undefined)
  {
    var fx_count = array_length(self.fx_map);

    for (var i = 0; i < fx_count; ++i)
      if (filter_fn(fx_map[i]))
        fx_map[i].__exec(argv);

    return self;
  }



  /**
   * @desc Serialises the dialog to JSON.
   * @param {Bool} [prettify] Whether the string should have line breaks/indentation (`true`) or not (`false`).
   * @returns {String}
   */

  static __serialize = function(prettify = false)
  {
    return json_stringify(__DIALOG_MANAGER_ENCODING_METHOD__(), prettify);
  }



  /**
   * @desc Deserialises a JSON string produced by {@link __serialize}.
   * @param {String} data_string The JSON payload.
   * @returns {Struct.Dialog}
   */

  static __deserialize = function(data_string)
  {
    var data = json_parse(data_string);
    return __DIALOG_MANAGER_DECODING_METHOD__(data);
  }
}












// ----------------------------------------------------------------------------












/**
 * `DialogFX` constructor.
 * @param {DIALOG_FX | Real} [settings_mask] - The effect info.
 * @param {Array<Any>} [argv] - The arguments of the mapped effect function.
 * @param {Function} [func] - The function to add to the dialog manager (NOT SERIALIZED).
 * @returns {Struct.DialogFX}
 */

function DialogFX(settings_mask, argv, func) constructor
{
  self.settings_mask = settings_mask;
  self.argv = argv;



  /**
   * @desc Combines FX type and trigger into a single bitmask.
   * @param {Constant.DIALOG_FX} type The effect type.
   * @param {Constant.DIALOG_FX} trigger The effect trigger condition.
   * @returns {Real}
   */

  static __encode_settings = function(type, trigger)
  {
    return __encode_fx_trigger(trigger) | __encode_fx_type(type);
  }



  /**
   * @desc Encodes only the FX type as a bitmask fragment.
   * @param {Constant.DIALOG_FX} type The effect type.
   * @returns {Real}
   */

  static __encode_fx_type = function(type)
  {
    return type << DIALOG_FX.__BITMASK_TYPE_SHIFT & DIALOG_FX.__BITMASK_TYPE_MASK;
  }



  /**
   * @desc Encodes only the FX trigger as a bitmask fragment.
   * @param {Constant.DIALOG_FX} trigger The trigger condition.
   * @returns {Real}
   */

  static __encode_fx_trigger = function(trigger)
  {
    return trigger << DIALOG_FX.__BITMASK_TRIGGER_SHIFT & DIALOG_FX.__BITMASK_TRIGGER_MASK;
  }



  /**
   * @desc Extracts the FX type from a settings bitmask.
   * @param {Real} [settings_mask] Optional override bitmask. Defaults to this FX's mask.
   * @returns {Constant.DIALOG_FX}
   */

  static __decode_fx_type = function(settings_mask = self.settings_mask)
  {
    return (settings_mask & DIALOG_FX.__BITMASK_TYPE_MASK) >> DIALOG_FX.__BITMASK_TYPE_SHIFT;
  }



  /**
   * @desc Extracts the FX trigger from a settings bitmask.
   * @param {Real} [settings_mask] Optional override bitmask. Defaults to this FX's mask.
   * @returns {Constant.DIALOG_FX}
   */

  static __decode_fx_trigger = function(settings_mask = self.settings_mask)
  {
    return (settings_mask & DIALOG_FX.__BITMASK_TRIGGER_MASK) >> DIALOG_FX.__BITMASK_TRIGGER_SHIFT;
  }



  /**
   * @desc Serialises the FX into a compact array.
   * @returns {Array}
   */

  static __array = function()
  {
    return [
      int64(settings_mask),
      array_map(argv, function(arg) {
        return is_instanceof(arg, DialogLinkable)
          ? arg.__get_position()
          : arg
        ;
      })
    ];
  }



  /**
   * @desc Serialises the FX into a plain struct.
   * @returns {Struct}
   */

  static __struct = function()
  {
    return {
      settings_mask: int64(settings_mask),
      argv: array_map(argv, function(arg) {
        return is_instanceof(arg, DialogLinkable)
          ? arg.__get_position()
          : arg
        ;
      })
    };
  }



  /**
   * @desc Deserialises an FX from an array produced by {@link __array}.
   * @param {Array} data The array payload.
   * @returns {Struct.DialogFX}
   */

  static __from_array = function(data)
  {
    return new DialogFX(data[0], data[1]);
  }



  /**
   * @desc Deserialises an FX from a struct produced by {@link __struct}.
   * @param {Struct} data The struct payload.
   * @returns {Struct.DialogFX}
   */

  static __from_struct = function(data)
  {
    return new DialogFX(
      data.settings_mask,
      data.argv
    );
  }



  /**
   * @desc Executes the FX using the global dialog manager's registered handlers.
   * @param {Array} [argv] The arguments to pass to the effect.
   * @returns {Any}
   */

  static __exec = function(argv = self.argv)
  {
    return global.dialog_manager.fx_map[__decode_fx_type()](argv);
  }



  /**
   * @desc Serialises the FX to a JSON string.
   * @param {Bool} [prettify] Whether the string should be pretty-printed.
   * @returns {String}
   */

  static __serialize = function(prettify = false)
  {
    return json_stringify(__DIALOG_MANAGER_ENCODING_METHOD__(), prettify);
  }



  /**
   * @desc Deserialises a JSON string produced by {@link __serialize}.
   * @param {String} data_string The JSON payload.
   * @returns {Struct.DialogFX}
   */

  static __deserialize = function(data_string)
  {
    var data = json_parse(data_string);
    return __DIALOG_MANAGER_DECODING_METHOD__(data);
  }



  if (!func)
    return;

  var type = __decode_fx_type(settings_mask);

  if (type >= array_length(DialogManager.fx_map))
    DialogManager.fx_map[type] = func;
  else if (
    type == DIALOG_FX.TYPE_FALLBACK
    && argv[DIALOG_FX.ARG_JUMP_CONDITION] >= array_length(DialogManager.condition_map)
  )
    DialogManager.condition_map[type] = func;
}
