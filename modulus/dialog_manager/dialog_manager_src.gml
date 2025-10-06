/**
 * @desc Dialog management system.
 * @author @MaximilianVolt
 * @version 0.8
 */



#macro __DIALOG_MANAGER_ENCODING_METHOD__ __struct      // Must be <__struct> or <__array>
#macro __DIALOG_MANAGER_DECODING_METHOD__ __from_struct // Must be <__from_struct> or <__from_array>



// Edit as needed

/**
 * @desc `FLAG_*` flags refer to various info stored in a bitfield.
 * @desc `__BITMASK_*` options are used to manage bitmasks and should not be referenced directly.
 */

enum DIALOG_MANAGER
{
  // Status info
  FLAG_STATUS_UNINITIALIZED,
  FLAG_STATUS_FIRST_DIALOG,
  FLAG_STATUS_FIRST_SEQUENCE,
  FLAG_STATUS_FIRST_SCENE,
  FLAG_STATUS_FIRST_OF_SEQUENCE,
  FLAG_STATUS_FIRST_OF_SCENE,
  FLAG_STATUS_LAST_DIALOG,
  FLAG_STATUS_LAST_SEQUENCE,
  FLAG_STATUS_LAST_SCENE,
  FLAG_STATUS_LAST_OF_SEQUENCE,
  FLAG_STATUS_LAST_OF_SCENE,
  __BITMASK_STATUS_NO_AUTORESET_COUNT,
  FLAG_STATUS_ADVANCED_DIALOG = DIALOG_MANAGER.__BITMASK_STATUS_NO_AUTORESET_COUNT,
  FLAG_STATUS_ADVANCED_SEQUENCE,
  FLAG_STATUS_ADVANCED_SCENE,
  FLAG_STATUS_RECEDED_DIALOG,
  FLAG_STATUS_RECEDED_SEQUENCE,
  FLAG_STATUS_RECEDED_SCENE,
  FLAG_STATUS_EXECUTED_JUMP,
  FLAG_STATUS_EXECUTED_FALLBACK,
  FLAG_STATUS_EXECUTED_CHOICE,
  FLAG_STATUS_COUNT,

  // Jump info
  __FLAG_INDEX_CHOICE = 1,
  
  // Masks (should not edit)
  __BITMASK_STATUS_AUTORESET_COUNT = DIALOG_MANAGER.FLAG_STATUS_COUNT - DIALOG_MANAGER.__BITMASK_STATUS_NO_AUTORESET_COUNT,
  __BITMASK_STATUS_NO_AUTORESET_MASK = (1 << DIALOG_MANAGER.__BITMASK_STATUS_NO_AUTORESET_COUNT) - 1,
  __BITMASK_STATUS_AUTORESET_MASK = ((1 << DIALOG_MANAGER.__BITMASK_STATUS_AUTORESET_COUNT) - 1) << DIALOG_MANAGER.__BITMASK_STATUS_NO_AUTORESET_COUNT,
  __BITMASK_STATUS_MASK = (1 << DIALOG_MANAGER.FLAG_STATUS_COUNT) - 1,
  FLAG_CHOICE = 1 << DIALOG_MANAGER.__FLAG_INDEX_CHOICE,
}



// Edit as needed

/**
 * @desc Contains all useful information about a dialog scene.
 * @desc `TAG_*` options refer to the scene type for categorization (useful for filtering).
 * @desc `BG_*` options refer to the background index.
 * @desc `BGM_*` options refer to the background music index.
 * @desc `BGS_*` flags refer to the background sound index.
 * @desc `__BITMASK_*` options are used to manage bitmasks and should not be referenced directly.
 */

enum DIALOG_SCENE
{
  // Scene bg
  BG_NONE = 0,
    // ...
  BG_COUNT,
  BG_DEFAULT = DIALOG_SCENE.BG_NONE,

  // Scene bgm
  BGM_NONE = 0,
    // ...
  BGM_COUNT,
  BGM_DEFAULT = DIALOG_SCENE.BGM_NONE,

  // Scene bgs
  BGS_NONE = 0,
    // ...
  BGS_COUNT,
  BGS_DEFAULT = DIALOG_SCENE.BGS_NONE,

  // Scene tags
  TAG_NONE = 0,
    // ...
  TAG_COUNT,
  TAG_DEFAULT = DIALOG_SCENE.TAG_NONE,

  // Masks (should not edit)
  __BITMASK_BG_SHIFT = 0,
  __BITMASK_BG_BITS = 7,
  __BITMASK_BG_MASK = ((1 << DIALOG_SCENE.__BITMASK_BG_BITS) - 1) << DIALOG_SCENE.__BITMASK_BG_SHIFT,
  __BITMASK_BGM_SHIFT = DIALOG_SCENE.__BITMASK_BG_SHIFT + DIALOG_SCENE.__BITMASK_BG_BITS,
  __BITMASK_BGM_BITS = 8,
  __BITMASK_BGM_MASK = ((1 << DIALOG_SCENE.__BITMASK_BGM_BITS) - 1) << DIALOG_SCENE.__BITMASK_BGM_SHIFT,
  __BITMASK_BGS_SHIFT = DIALOG_SCENE.__BITMASK_BGM_SHIFT + DIALOG_SCENE.__BITMASK_BGM_BITS,
  __BITMASK_BGS_BITS = 6,
  __BITMASK_BGS_MASK = ((1 << DIALOG_SCENE.__BITMASK_BGS_BITS) - 1) << DIALOG_SCENE.__BITMASK_BGS_SHIFT,
  __BITMASK_TAG_SHIFT = DIALOG_SCENE.__BITMASK_BGS_SHIFT + DIALOG_SCENE.__BITMASK_BGS_BITS,
  __BITMASK_TAG_BITS = 5,
  __BITMASK_TAG_MASK = ((1 << DIALOG_SCENE.__BITMASK_TAG_BITS) - 1) << DIALOG_SCENE.__BITMASK_TAG_SHIFT,
}



// Edit as needed

/**
 * @desc Contains all useful information about a dialog sequence.
 * @desc `TAG_*` options refer to the sequence type for categorization (useful for filtering).
 * @desc `__BITMASK_*` options are used to manage bitmasks and should not be referenced directly.
 */

enum DIALOG_SEQUENCE
{
  // Sequence tags
  TAG_NONE = 0,
    // ...
  TAG_COUNT,
  TAG_DEFAULT = DIALOG_SEQUENCE.TAG_NONE,

  // Masks (should not edit)
  __BITMASK_TAG_SHIFT = 0,
  __BITMASK_TAG_BITS = 5,
  __BITMASK_TAG_MASK = ((1 << DIALOG_SEQUENCE.__BITMASK_TAG_BITS) - 1) << DIALOG_SEQUENCE.__BITMASK_TAG_SHIFT,
}



// Edit as needed

/**
 * @desc Contains all useful information about a dialog.
 * @desc `SPEAKER_*` options refer to the speakers (actors).
 * @desc `EMOTION_*` options refer to the emotions (frames or expressions).
 * @desc `ANCHOR_*` options refer to the dialog box positioning.
 * @desc `TEXTBOX_*` options refer to the dialog box style.
 * @desc `TAG_*` options refer to the dialog type for categorization (useful for filtering).
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

  // Dialog tags
  TAG_NONE = 0,
    // ...
  TAG_COUNT,
  TAG_DEFAULT = DIALOG.TAG_NONE,

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
  __BITMASK_EMOTION_SHIFT = DIALOG.__BITMASK_SPEAKER_SHIFT + DIALOG.__BITMASK_SPEAKER_BITS,
  __BITMASK_EMOTION_BITS = 6,
  __BITMASK_EMOTION_MASK = ((1 << DIALOG.__BITMASK_EMOTION_BITS) - 1) << DIALOG.__BITMASK_EMOTION_SHIFT,
  __BITMASK_ANCHOR_SHIFT = DIALOG.__BITMASK_EMOTION_SHIFT + DIALOG.__BITMASK_EMOTION_BITS,
  __BITMASK_ANCHOR_BITS = 4,
  __BITMASK_ANCHOR_MASK = ((1 << DIALOG.__BITMASK_ANCHOR_BITS) - 1) << DIALOG.__BITMASK_ANCHOR_SHIFT,
  __BITMASK_TEXTBOX_SHIFT = DIALOG.__BITMASK_ANCHOR_SHIFT + DIALOG.__BITMASK_ANCHOR_BITS,
  __BITMASK_TEXTBOX_BITS = 4,
  __BITMASK_TEXTBOX_MASK = ((1 << DIALOG.__BITMASK_TEXTBOX_BITS) - 1) << DIALOG.__BITMASK_TEXTBOX_SHIFT,
  __BITMASK_TAG_SHIFT = DIALOG.__BITMASK_TEXTBOX_SHIFT + DIALOG.__BITMASK_TEXTBOX_BITS,
  __BITMASK_TAG_BITS = 5,
  __BITMASK_TAG_MASK = ((1 << DIALOG.__BITMASK_TAG_BITS) - 1) << DIALOG.__BITMASK_TAG_SHIFT,
  __BITMASK_POSITION_DIALOG_SHIFT = 0,
  __BITMASK_POSITION_DIALOG_BITS = 12,
  __BITMASK_POSITION_DIALOG_MASK = ((1 << DIALOG.__BITMASK_POSITION_DIALOG_BITS) - 1) << DIALOG.__BITMASK_POSITION_DIALOG_SHIFT,
  __BITMASK_POSITION_SEQUENCE_SHIFT = DIALOG.__BITMASK_POSITION_DIALOG_SHIFT + DIALOG.__BITMASK_POSITION_DIALOG_BITS,
  __BITMASK_POSITION_SEQUENCE_BITS = 9,
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
  TYPE_CHOICE,
  TYPE_STATE_MODIFY,
  TYPE_TEXT,
  TYPE_IMAGE,
  TYPE_VIDEO,
  TYPE_BGM,
  TYPE_BGS,
  TYPE_SFX,
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

  // Jump FX conditions
  FALLBACK_CONDITION_FALSE = 0,
  FALLBACK_CONDITION_TRUE,
    // ...
  FALLBACK_CONDITION_COUNT,

  // Choice flag
  CHOICE_INDEX_UNSELECTED = -1,
  CHOICE_CONDITION_COUNT = -DIALOG_FX.CHOICE_INDEX_UNSELECTED,

  // FX arg positions
  ARG_JUMP_DESTINATION = 0,
  ARG_JUMP_CONDITION = 1,
  ARG_CHOICE_LIST = 1,
  ARG_SUBARG_CHOICE_PROMPT = 0,
  ARG_SUBARG_CHOICE_DESTINATION = 1,

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
 * @param {String|Id.TextFile} data_string The data to parse.
 * @param {Bool} is_file Specifies whether `data_string` is a file (`true`) or not (`false`).
 * @returns {Struct.DialogManager}
 */

function DialogManager(data_string, is_file) constructor
{
  static CONSTRUCTOR_ARGC = argument_count;



  /**
   * @desc Executes the inconditional jump effect.
   * @param {Struct.DialogManager} manager The reference to the dialog manager.
   * @param {Array<Any>} argv The arguments to pass to the fx function.
   * @returns {Struct.Dialog}
   */

  static __fx_jump = function(manager, argv)
  {
    return manager.__jump(manager.__resolve_position(argv[DIALOG_FX.ARG_JUMP_DESTINATION]));
  }



  /**
   * @desc Executes the conditional jump effect.
   * @param {Struct.DialogManager} manager The reference to the dialog manager.
   * @param {Array<Any>} argv The arguments to pass to the fx function.
   * @returns {Struct.Dialog}
   */

  static __fx_fallback = function(manager, argv)
  {
    var position = manager.position;

    if (manager.condition_map[argv[DIALOG_FX.ARG_JUMP_CONDITION]](manager, argv))
    {
      manager.position = manager.__resolve_position(argv[DIALOG_FX.ARG_JUMP_DESTINATION]);
      manager.status |= __flag(DIALOG_MANAGER.FLAG_STATUS_EXECUTED_FALLBACK);
    }

    return manager.__get_dialog_position(position);
  }



  /**
   * @desc Executes the multi-option jump effect.
   * @param {Struct.DialogManager} manager The reference to the dialog manager.
   * @param {Array<Any>} argv The arguments to pass to the fx function.
   * @returns {Struct.Dialog}
   */

  static __fx_choice = function(manager, argv)
  {
    var choice_index = argv[DIALOG_FX.ARG_JUMP_DESTINATION];

    if (choice_index != DIALOG_FX.CHOICE_INDEX_UNSELECTED)
    {
      manager.status |= __flag(DIALOG_MANAGER.FLAG_STATUS_EXECUTED_CHOICE);
      return manager.__get_dialog_position(manager.__resolve_position(argv[DIALOG_FX.ARG_CHOICE_LIST].argv[choice_index][DIALOG_FX.ARG_SUBARG_CHOICE_DESTINATION]));
    }

    return manager.__get_dialog();
  }



  /**
   * @desc Returns a scene given the scene index.
   * @param {Real} [scene_idx] The scene index. Defaults to current scene.
   * @returns {Struct.DialogScene}
   */

  static __get_scene = function(scene_idx = __decode_scene_idx(self.position))
  {
    return self.scenes[scene_idx];
  }



  /**
   * @desc Returns a scene given its absolute position in order as a number.
   * @param {Real} [scene_number] The number of the scene. Defaults to `0`. Negative indices will iterate backwards.
   * @returns {Struct.DialogScene}
   */

  static __get_scene_absolute = function(scene_number = 0)
  {
    return abs(scene_number) < self.scene_count
      ? (self.scenes[scene_number ? scene_number : self.scene_count - scene_number])
      : undefined
    ;
  }



  /**
   * @desc Returns a list of all scenes matching a tag.
   * @param {Constant.DIALOG_SCENE|Real} [tag] The tag to filter the scenes with. Defaults to `DIALOG_SCENE.TAG_DEFAULT`.
   * @returns {Array<Struct.DialogScene>}
   */

  static __get_scenes_by_tag = function(tag = DIALOG_SCENE.TAG_DEFAULT)
  {
    var scenes = [];

    for (var i = 0; i < self.scene_count; ++i)
      if (self.scenes[i].__decode_tag() == tag)
        array_push(scenes, self.scenes[i]);

    return scenes;
  }



  /**
   * @desc Returns a scene given the scene and sequence indeces.
   * @param {Real} [sequence_idx] The sequence index. Defaults to current sequence.
   * @param {Real} [scene_idx] The scene index. Defaults to current scene.
   * @returns {Struct.DialogSequence}
   */

  static __get_sequence = function(sequence_idx = __decode_sequence_idx(self.position), scene_idx = __decode_scene_idx(self.position))
  {
    return __get_scene(scene_idx).sequences[sequence_idx];
  }



  /**
   * @desc Returns a sequence given its absolute position in order as a number.
   * @param {Real} [sequence_number] The number of the sequence. Defaults to `0`. Negative indices will iterate backwards.
   * @returns {Struct.DialogSequence|undefined}
   */

  static __get_sequence_absolute = function(sequence_number = 0)
  {
    var iter_negative = (sequence_number < 0)
      , iter_dir = iter_negative ? -1 : 1
      , scene_start = self.scene_count * iter_negative
      , scene_end = self.scene_count * !iter_negative
      , scene
    ;

    sequence_number = abs(sequence_number);

    for (var i = scene_start; sequence_number && i != scene_end; i += iter_dir)
    {
      scene = self.scenes[i];

      if (sequence_number < scene.sequence_count)
      {
        return scene.sequences[
          iter_negative 
            ? scene.sequence_count - sequence_number
            : sequence_number
        ];
      }

      sequence_number -= scene.sequence_count;
    }

    return undefined;
  }



  /**
   * @desc Returns a dialog given the scene, sequence and dialog indeces.
   * @param {Real} [dialog_idx] The dialog index. Defaults to current dialog.
   * @param {Real} [sequence_idx] The sequence index. Defaults to current sequence.
   * @param {Real} [scene_idx] The scene index. Defaults to current scene.
   * @returns {Struct.Dialog}
   */

  static __get_dialog = function(dialog_idx = __decode_dialog_idx(self.position), sequence_idx = __decode_sequence_idx(self.position), scene_idx = __decode_scene_idx(self.position))
  {
    return __get_sequence(sequence_idx, scene_idx).dialogs[dialog_idx];
  }



  /**
   * @desc Returns a dialog given its absolute position in order as a number.
   * @param {Real} [dialog_number] The number of the sequence. Defaults to `0`. Negative indices will iterate backwards.
   * @returns {Struct.Dialog|undefined}
   */

  static __get_dialog_absolute = function(dialog_number = 0)
  {
    var iter_negative = (dialog_number < 0)
      , iter_dir = iter_negative ? -1 : 1
      , scene_start = self.scene_count * iter_negative
      , scene_end = self.scene_count * !iter_negative
      , sequence_start
      , sequence_end
      , scene
      , sequence
    ;

    dialog_number = abs(dialog_number);

    for (var i = scene_start; dialog_number && i != scene_end; i += iter_dir)
    {
      scene = self.scenes[i];
      sequence_start = scene.sequence_count * iter_negative;
      sequence_end = scene.sequence_count * !iter_negative;

      for (var j = sequence_start; dialog_number && j != sequence_end; j += iter_dir)
      {
        sequence = scene.sequences[j];

        if (dialog_number < sequence.dialog_count)
        {
          return sequence.dialogs[
            iter_negative
              ? sequence.dialog_count - dialog_number
              : dialog_number
          ];
        }

        dialog_number -= sequence.dialog_count;
      }
    }

    return undefined;
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
    scene.manager = self;
    scene.scene_idx = self.scene_count++;

    array_push(self.scenes, scene);

    return __advance(0, __flag(DIALOG_MANAGER.FLAG_STATUS_UNINITIALIZED));
  }



  /**
   * @desc Appends new scenes to the scene list.
   * @param {Array<Struct.DialogScene>} scenes The new scenes to add.
   * @returns {Struct.DialogManager}
   */

  static __add_scenes = function(scenes)
  {
    var scene_count = array_length(scenes);

    for (var i = 0; i < scene_count; scenes[i++].manager = self)
      scenes[i].scene_idx = self.scene_count + i;

    self.scenes = array_concat(self.scenes, scenes);
    self.scene_count += scene_count;

    return __advance(0, __flag(DIALOG_MANAGER.FLAG_STATUS_UNINITIALIZED));
  }



  /**
   * @desc Inserts a scene in the scene list at a given index.
   * @param {Struct.DialogScene} scene The new scene to add.
   * @param {Real} [index] The index where to add the new scene. Defaults to last index.
   * @returns {Struct.DialogManager}
   */

  static __insert_scene = function(scene, index = self.scene_count)
  {
    for (var i = index; i < self.scene_count; ++i)
      ++self.scenes[i].scene_idx;

    scene.scene_idx = index;
    scene.manager = self;
    ++scene_count;

    array_insert(self.scenes, index, scene);

    return __advance(0, __flag(DIALOG_MANAGER.FLAG_STATUS_UNINITIALIZED));
  }



  /**
   * @desc Inserts scenes in the scene list at a given index.
   * @param {Array<Struct.DialogScene>} scenes The new scenes to add.
   * @param {Real} [index] The index where to add the new scenes. Defaults to last index.
   * @returns {Struct.DialogManager}
   */

  static __insert_scenes = function(scenes, index = self.scene_count)
  {
    var scene_count = array_length(scenes);

    for (var i = index; i < self.scene_count; ++i)
      scenes[i].scene_idx += scene_count;

    for (var i = 0; i < scene_count; scenes[i++].manager = self)
      array_insert(self.scenes, index + i, scenes[i]);

    self.scene_count += scene_count;

    return __advance(0, __flag(DIALOG_MANAGER.FLAG_STATUS_UNINITIALIZED));
  }



  /**
   * @desc Appends a new sequence to the sequence list of a selected scene.
   * @param {Struct.DialogSequence} sequence The new sequence to add.
   * @param {Real} [scene_idx] The scene index. Defaults to current scene.
   * @returns {Struct.DialogManager}
   */

  static __add_sequence = function(sequence, scene_idx = __decode_scene_idx(self.position))
  {
    __get_scene(scene_idx).__add_sequence(sequence);

    return __advance(0, __flag(DIALOG_MANAGER.FLAG_STATUS_UNINITIALIZED));
  }



  /**
   * @desc Appends new sequences to the sequence list of a selected scene.
   * @param {Array<Struct.DialogSequence>} sequences The new sequences to add.
   * @param {Real} [scene_idx] The scene index. Defaults to current scene.
   * @returns {Struct.DialogManager}
   */

  static __add_sequences = function(sequences, scene_idx = __decode_scene_idx(self.position))
  {
    __get_scene(scene_idx).__add_sequences(sequences);

    return __advance(0, __flag(DIALOG_MANAGER.FLAG_STATUS_UNINITIALIZED));
  }



  /**
   * @desc Appends a new dialog to the dialog list of a selected sequence.
   * @param {Struct.Dialog} dialog The new dialog to add.
   * @param {Real} [sequence_idx] The sequence index. Defaults to current sequence.
   * @param {Real} [scene_idx] The scene index. Defaults to current scene.
   * @returns {Struct.DialogManager}
   */

  static __add_dialog = function(dialog, sequence_idx = __decode_sequence_idx(self.position), scene_idx = __decode_scene_idx(self.position))
  {
    __get_sequence(scene_idx, sequence_idx).__add_dialog(dialog);

    return __advance(0, __flag(DIALOG_MANAGER.FLAG_STATUS_UNINITIALIZED));
  }



  /**
   * @desc Appends new dialogs to the dialog list of a selected sequence.
   * @param {Array<Struct.Dialog>} dialogs The new dialogs to add.
   * @param {Real} [sequence_idx] The sequence index. Defaults to current sequence.
   * @param {Real} [scene_idx] The scene index. Defaults to current scene.
   * @returns {Struct.DialogManager}
   */

  static __add_dialogs = function(dialogs, sequence_idx = __decode_sequence_idx(self.position), scene_idx = __decode_scene_idx(self.position))
  {
    __get_sequence(scene_idx, sequence_idx).__add_dialogs(dialogs);

    return __advance(0, __flag(DIALOG_MANAGER.FLAG_STATUS_UNINITIALIZED));
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
   * @desc Encode a scene position given an index.
   * @param {Real} scene_idx The scene index to encode.
   * @returns {Real}
   */

  static __encode_scene_idx = function(scene_idx)
  {
    return scene_idx << DIALOG.__BITMASK_POSITION_SCENE_SHIFT & DIALOG.__BITMASK_POSITION_SCENE_MASK;
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
   * @desc Encodes a dialog position given an index.
   * @param {Real} dialog_idx The dialog index to encode.
   * @returns {Real}
   */

  static __encode_dialog_idx = function(dialog_idx)
  {
    return dialog_idx << DIALOG.__BITMASK_POSITION_DIALOG_SHIFT & DIALOG.__BITMASK_POSITION_DIALOG_MASK;
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
   * @param {Real} [position] The position to decode. Defaults to current position.
   * @returns {Real}
   */

  static __decode_scene_idx = function(position = self.position)
  {
    return (position & DIALOG.__BITMASK_POSITION_SCENE_MASK) >> DIALOG.__BITMASK_POSITION_SCENE_SHIFT;
  }



  /**
   * @desc Returns the sequence index given a position.
   * @param {Real} [position] The position to decode. Defaults to current position.
   * @returns {Real}
   */

  static __decode_sequence_idx = function(position = self.position)
  {
    return (position & DIALOG.__BITMASK_POSITION_SEQUENCE_MASK) >> DIALOG.__BITMASK_POSITION_SEQUENCE_SHIFT;
  }



  /**
   * @desc Returns the dialog index given a position.
   * @param {Real} [position] The position to decode. Defaults to current position.
   * @returns {Real}
   */

  static __decode_dialog_idx = function(position = self.position)
  {
    return (position & DIALOG.__BITMASK_POSITION_DIALOG_MASK) >> DIALOG.__BITMASK_POSITION_DIALOG_SHIFT;
  }



  /**
   * @desc Sets the position to match a given scene's index.
   * @param {Struct.DialogScene} scene The scene to jump to.
   * @param {Array} [argv] The arguments to pass to eventual fallback effects.
   * @returns {Struct.Dialog}
   */

  static __jump_to_scene = function(scene, argv = undefined)
  {
    return __jump(scene, argv);
  }



  /**
   * @desc Sets the position to match a given sequence's index.
   * @param {Struct.DialogSequence} sequence The sequence to jump to.
   * @param {Array} [argv] The arguments to pass to eventual fallback effects.
   * @returns {Struct.Dialog}
   */

  static __jump_to_sequence = function(sequence, argv = undefined)
  {
    return __jump(sequence, argv);
  }



  /**
   * @desc Sets the position to match a given dialog's index.
   * @param {Struct.Dialog} dialog The dialog to jump to.
   * @param {Array} [argv] The arguments to pass to eventual fallback effects.
   * @returns {Struct.Dialog}
   */

  static __jump_to_dialog = function(dialog, argv = undefined)
  {
    return __jump(dialog, argv);
  }



  /**
   * @desc Sets the position to match a given one.
   * @param {Real|Constant.DIALOG|Struct.DialogLinkable} [position] The position to jump to. Defaults to current position.
   * @param {Array} [argv] The arguments to pass to eventual fallback effects.
   * @returns {Struct.Dialog}
   */

  static __jump = function(position = self.position, argv = undefined)
  {
    if (is_instanceof(position, DialogLinkable))
      position = position.__get_position();

    var current_dialog = __get_dialog_position(self.position)
      , target_dialog = __get_dialog_position(position)
    ;

    current_dialog.__fx_execute_all_of(function(fx) {
      return fx.__decode_fx_trigger() == DIALOG_FX.TRIGGER_ON_END;
    });

    var fallback_fx = target_dialog.__get_fallback(argv);

    if (fallback_fx)
      return __jump(__resolve_position(fallback_fx.argv[DIALOG_FX.ARG_JUMP_DESTINATION]), argv);

    target_dialog.__fx_execute_all_of(function(fx) {
      return fx.__decode_fx_trigger() == DIALOG_FX.TRIGGER_ON_START;
    });

    self.position = target_dialog.__get_position();

    return target_dialog;
  }



  /**
   * Evaluates a given position to determine the destination of a jump.
   * @param {Real|Constant.DIALOG|Struct.DialogLinkable} [position] The position to resolve. Defaults to current position.
   * @returns {Real}
   */

  static __resolve_position = function(position = self.position)
  {
    if (is_instanceof(position, DialogLinkable))
      return position.__get_position();

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
   * @desc Performs a jump to a certain dialog given its position as argument.
   * @param {Real} [position] The position where to jump. Default to current position.
   * @param {Array} [argv] The arguments to pass to eventual fallback effects.
   * @param {Real} [mask] The jump info.
   * @returns {Struct.Dialog}
   */

  static __next = function(position = self.position, argv = undefined, mask = 0)
  {
    if (__mask_check(DIALOG_MANAGER.FLAG_CHOICE, mask))
      return __jump(__fx_choice(self, argv), argv);

    var jump_fx = __get_dialog().__get_jump();

    if (jump_fx)
    {
      position = __resolve_position(jump_fx.argv[DIALOG_FX.ARG_JUMP_DESTINATION]);
      self.status |= __flag(DIALOG_MANAGER.FLAG_STATUS_EXECUTED_JUMP);
    }

    return __jump(position, argv);
  }



  /**
   * @desc Makes the dialog manager advance a given number of dialogs.
   * @param {Real} [idx_shift] The number of dialogs to advance of. Defaults to `1`.
   * @param {Constant.DIALOG_MANAGER|Real} [flags] The settings mask for the jump.
   * @param {Any|Array<Any>} [argv] The argument(s) to pass to eventual dialog effects.
   * @returns {Struct.DialogManager}
   */

  static __advance = function(idx_shift = 1, flags = 0, argv = undefined)
  {
    self.status &= ~(
      idx_shift != 0
        ? DIALOG_MANAGER.__BITMASK_STATUS_MASK
        : DIALOG_MANAGER.__BITMASK_STATUS_AUTORESET_MASK
    );

    if (
      idx_shift == 0 && !__flag_check(DIALOG_MANAGER.FLAG_STATUS_UNINITIALIZED, flags)
      || !self.scene_count
    )
      return self;

    var next_scene_idx = __decode_scene_idx()
      , next_scene = __get_scene(next_scene_idx)
      , next_sequence_idx = __decode_sequence_idx()
      , next_sequence = __get_sequence(next_sequence_idx, next_scene_idx)
      , next_dialog_idx = __decode_dialog_idx()
      , shift_sign = sign(idx_shift)
      , sequence_diff = 0
      , scene_diff = 0
    ;

    if (__mask_check(DIALOG_MANAGER.FLAG_CHOICE, flags))
    {
      argv = [is_array(argv) ? argv[0] : argv, __get_dialog().__get_choice()];
      idx_shift = 0;
    }
    else
    {
      var _wrap = function(val, low, high) {
        var diff = high - low;
        return ((val - low) % diff + diff) % diff + low;
      };
  
      var _in_range = function(val, low, high) {
        return val >= low && val < high;
      }
  
      if (!_in_range(next_dialog_idx + idx_shift, 0, next_sequence.dialog_count))
      {
        var dialog_diff = shift_sign ? next_dialog_idx + 1 : next_sequence.dialog_count - next_dialog_idx;
        next_dialog_idx = shift_sign ? -1 : next_sequence.dialog_count;
        idx_shift += dialog_diff * shift_sign;
  
        while (!_in_range(next_dialog_idx + idx_shift, 0, next_sequence.dialog_count))
        {
          idx_shift -= next_sequence.dialog_count * shift_sign;
          next_sequence_idx += shift_sign;
          sequence_diff += shift_sign;
  
          if (!_in_range(next_sequence_idx, 0, next_scene.sequence_count)) {
            next_scene_idx = _wrap(next_scene_idx + shift_sign, 0, self.scene_count);
            next_scene = __get_scene(next_scene_idx);
            scene_diff += shift_sign;
            next_sequence_idx = shift_sign ? 0 : next_scene.sequence_count - 1;
          }
  
          next_sequence = __get_sequence(next_sequence_idx, next_scene_idx);
          next_dialog_idx = shift_sign ? -1 : next_sequence.dialog_count;
        }
      }
  
      next_dialog_idx += idx_shift;
    }

    var position = __encode_position(next_scene_idx, next_sequence_idx, next_dialog_idx)
      , target_position = __next(position, argv, flags).__get_position()
      , target_scene_idx = __decode_scene_idx(target_position)
      , target_sequence_idx = __decode_sequence_idx(target_position)
      , target_dialog_idx = __decode_dialog_idx(target_position)
      , target_sequence_count = __get_scene(target_scene_idx).sequence_count
      , target_dialog_count = __get_sequence(target_sequence_idx).dialog_count
      , is_last_scene = target_scene_idx == self.scene_count - 1
      , is_last_of_scene = target_sequence_idx == target_sequence_count - 1
      , is_last_of_sequence = target_dialog_idx == target_dialog_count - 1
      , is_last_sequence = is_last_scene && is_last_of_scene
    ;

    self.status |=
        __flag(DIALOG_MANAGER.FLAG_STATUS_FIRST_DIALOG     , target_position == 0                                        )
      | __flag(DIALOG_MANAGER.FLAG_STATUS_FIRST_SEQUENCE   , target_position < 1 << DIALOG.__BITMASK_POSITION_DIALOG_BITS)
      | __flag(DIALOG_MANAGER.FLAG_STATUS_FIRST_SCENE      , target_scene_idx == 0                                       )
      | __flag(DIALOG_MANAGER.FLAG_STATUS_FIRST_OF_SEQUENCE, target_dialog_idx == 0                                      )
      | __flag(DIALOG_MANAGER.FLAG_STATUS_FIRST_OF_SCENE   , target_sequence_idx == 0                                    )
      | __flag(DIALOG_MANAGER.FLAG_STATUS_LAST_DIALOG      , is_last_sequence && is_last_of_sequence                     )
      | __flag(DIALOG_MANAGER.FLAG_STATUS_LAST_SEQUENCE    , is_last_sequence                                            )
      | __flag(DIALOG_MANAGER.FLAG_STATUS_LAST_SCENE       , is_last_scene                                               )
      | __flag(DIALOG_MANAGER.FLAG_STATUS_LAST_OF_SEQUENCE , is_last_of_sequence                                         )
      | __flag(DIALOG_MANAGER.FLAG_STATUS_LAST_OF_SCENE    , is_last_of_scene                                            )
      | __flag(DIALOG_MANAGER.FLAG_STATUS_ADVANCED_DIALOG  , idx_shift > 0                                               )
      | __flag(DIALOG_MANAGER.FLAG_STATUS_ADVANCED_SEQUENCE, sequence_diff > 0                                           )
      | __flag(DIALOG_MANAGER.FLAG_STATUS_ADVANCED_SCENE   , scene_diff > 0                                              )
      | __flag(DIALOG_MANAGER.FLAG_STATUS_RECEDED_DIALOG   , idx_shift < 0                                               )
      | __flag(DIALOG_MANAGER.FLAG_STATUS_RECEDED_SEQUENCE , sequence_diff < 0                                           )
      | __flag(DIALOG_MANAGER.FLAG_STATUS_RECEDED_SCENE    , scene_diff < 0                                              )
    ;

    return self;
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
   * @param {String|Id.TextFile} [data_string] The data string to parse.
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

    return __parse(json_parse(data_string)).__advance(0, false);
  }



  /**
   * @desc Converts an array of raw data into an array of `DialogScene` objects.
   * @param {Array<Struct>} scenes The parsed scenes to convert and add.
   * @returns {Struct.DialogManager}
   */

  static __parse = function(scenes)
  {
    self.scenes = array_map(scenes, function(scene) {
      return DialogScene.__DIALOG_MANAGER_DECODING_METHOD__(scene);
    });

    return __update_scenes();
  }



  /**
   * @desc Updates the scene indeces.
   * @returns {Struct.DialogManager}
   */

  static __update_scenes = function()
  {
    self.scene_count = array_length(self.scenes);

    for (var i = self.scene_count - 1; i; self.scenes[i--].manager = self)
      self.scenes[i].scene_idx = i;

    return self;
  }



  /**
   * @desc Encodes a flag.
   * @param {Real} flag The index of the flag to encode.
   * @param {Bool} [cond] The condition to activate the flag.
   * @returns {Real}
   */

  static __flag = function(flag, cond = true)
  {
    return cond << flag;
  }



  /**
   * @desc Checks if a status flag is active.
   * @param {Real} flag The flag to check.
   * @param {Real} [field] The field to check.
   * @returns {Bool|Real}
   */

  static __flag_check = function(flag, field = self.status)
  {
    return field >> flag & 1;
  }



  /**
   * @desc Checks if a status mask is fully active.
   * @param {Real} mask The mask to check.
   * @param {Real} [field] The field to check.
   * @returns {Bool|Real}
   */

  static __mask_check = function(mask, field = self.status)
  {
    return (field & mask) == mask;
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
    self.status = 0;

    return self;
  }



  /**
   * @desc Maps all dialog data of an array, given the bitmask info.
   * @param {Real} size The size of the array.
   * @param {Real} shift The bitmask shift.
   * @param {Real} mask The bitmask to and (`&`) with.
   * @returns {Array<Real>}
   */

  var __map_manager_data = function(size, shift, mask)
  {
    var array = array_create(size);

    for (var i = 0; i < size; ++i)
      array[i] = i << shift & mask;

    return array;
  }



  static fx_map = [
    /* Make and add functions to index here */
    function(manager, argv) { },
    function(manager, argv) { return manager.__fx_jump(manager, argv); },
    function(manager, argv) { return manager.__fx_fallback(manager, argv); },
    function(manager, argv) { return manager.__fx_choice(manager, argv); },
  ];

  static condition_map = [
    /* Make and add condition functions to index here */
    function(manager, argv) { return false; },
    function(manager, argv) { return true; },
  ];



  self.data = {
    dialog_fx_types      : __map_manager_data(DIALOG_FX.TYPE_COUNT     , DIALOG_FX.__BITMASK_TYPE_SHIFT     , DIALOG_FX.__BITMASK_TYPE_MASK     ),
    dialog_fx_triggers   : __map_manager_data(DIALOG_FX.TRIGGER_COUNT  , DIALOG_FX.__BITMASK_TRIGGER_SHIFT  , DIALOG_FX.__BITMASK_TRIGGER_MASK  ),
    dialog_speakers      : __map_manager_data(DIALOG.SPEAKER_COUNT     , DIALOG.__BITMASK_SPEAKER_SHIFT     , DIALOG.__BITMASK_SPEAKER_MASK     ),
    dialog_emotions      : __map_manager_data(DIALOG.EMOTION_COUNT     , DIALOG.__BITMASK_EMOTION_SHIFT     , DIALOG.__BITMASK_EMOTION_MASK     ),
    dialog_anchors       : __map_manager_data(DIALOG.ANCHOR_COUNT      , DIALOG.__BITMASK_ANCHOR_SHIFT      , DIALOG.__BITMASK_ANCHOR_MASK      ),
    dialog_textboxes     : __map_manager_data(DIALOG.TEXTBOX_COUNT     , DIALOG.__BITMASK_TEXTBOX_SHIFT     , DIALOG.__BITMASK_TEXTBOX_MASK     ),
    dialog_tags          : __map_manager_data(DIALOG.TAG_COUNT         , DIALOG.__BITMASK_TAG_SHIFT         , DIALOG.__BITMASK_TAG_MASK         ),
    dialog_sequence_tags : __map_manager_data(DIALOG_SEQUENCE.TAG_COUNT, DIALOG_SEQUENCE.__BITMASK_TAG_SHIFT, DIALOG_SEQUENCE.__BITMASK_TAG_MASK),
    dialog_scene_bg      : __map_manager_data(DIALOG_SCENE.BG_COUNT    , DIALOG_SCENE.__BITMASK_BG_SHIFT    , DIALOG_SCENE.__BITMASK_BG_MASK    ),
    dialog_scene_bgm     : __map_manager_data(DIALOG_SCENE.BGM_COUNT   , DIALOG_SCENE.__BITMASK_BGM_SHIFT   , DIALOG_SCENE.__BITMASK_BGM_MASK   ),
    dialog_scene_bgs     : __map_manager_data(DIALOG_SCENE.BGS_COUNT   , DIALOG_SCENE.__BITMASK_BGS_SHIFT   , DIALOG_SCENE.__BITMASK_BGS_MASK   ),
    dialog_scene_tags    : __map_manager_data(DIALOG_SCENE.TAG_COUNT   , DIALOG_SCENE.__BITMASK_TAG_SHIFT   , DIALOG_SCENE.__BITMASK_TAG_MASK   ),
  };

  self.status = 0;
  self.position = 0;
  self.scene_count = 0;
  self.scenes = [];

  __deserialize(data_string, is_file).__advance(0, __flag(DIALOG_MANAGER.FLAG_STATUS_UNINITIALIZED));
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
 * @param {Array<Struct.DialogSequence>} sequences The array of `DialogSequence` of the scene.
 * @param {Real} settings_mask The scene settings.
 * @returns {Struct.DialogScene}
 */

function DialogScene(sequences, settings_mask) : DialogLinkable() constructor
{
  static CONSTRUCTOR_ARGC = argument_count;
  static scene_id = 0;

  self.manager = undefined;
  self.scene_idx = 0;
  self.scene_id = scene_id++;
  self.sequences = [];
  self.settings_mask = settings_mask;
  self.sequence_count = 0;



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
   * @desc Encodes the scene bg as a bitmask fragment.
   * @param {Constant.DIALOG_SCENE|Real} [bg] The bg identifier.
   * @returns {Real}
   */

  static __encode_bg = function(bg = DIALOG_SCENE.BG_DEFAULT)
  {
    return bg << DIALOG_SCENE.__BITMASK_BG_SHIFT & DIALOG_SCENE.__BITMASK_BG_MASK;
  }



  /**
   * @desc Encodes the scene bgm as a bitmask fragment.
   * @param {Constant.DIALOG_SCENE|Real} [bgm] The bgm identifier.
   * @returns {Real}
   */

  static __encode_bgm = function(bgm = DIALOG_SCENE.BGM_DEFAULT)
  {
    return bgm << DIALOG_SCENE.__BITMASK_BGM_SHIFT & DIALOG_SCENE.__BITMASK_BGM_MASK;
  }



  /**
   * @desc Encodes the scene bgs as a bitmask fragment.
   * @param {Constant.DIALOG_SCENE|Real} [bgs] The bgs identifier.
   * @returns {Real}
   */

  static __encode_bgs = function(bgs = DIALOG_SCENE.BGS_DEFAULT)
  {
    return bgs << DIALOG_SCENE.__BITMASK_BGS_SHIFT & DIALOG_SCENE.__BITMASK_BGS_MASK;
  }



  /**
   * @desc Encodes the scene tag as a bitmask fragment.
   * @param {Constant.DIALOG_SCENE|Real} [tag] The tag identifier.
   * @returns {Real}
   */

  static __encode_tag = function(tag = DIALOG_SCENE.TAG_DEFAULT)
  {
    return tag << DIALOG_SCENE.__BITMASK_TAG_SHIFT & DIALOG_SCENE.__BITMASK_TAG_MASK;
  }



  /**
   * @desc Extracts the scene bg from a settings bitmask.
   * @param {Constant.DIALOG_SCENE|Real} [settings_mask] The settings bitmask. Defaults to the scene's current mask.
   * @returns {Real}
   */

  static __decode_bg = function(settings_mask = self.settings_mask)
  {
    return (settings_mask & DIALOG_SCENE.__BITMASK_BG_MASK) >> DIALOG_SCENE.__BITMASK_BG_SHIFT;
  }



  /**
   * @desc Extracts the scene bgm from a settings bitmask.
   * @param {Constant.DIALOG_SCENE|Real} [settings_mask] The settings bitmask. Defaults to the scene's current mask.
   * @returns {Real}
   */

  static __decode_bgm = function(settings_mask = self.settings_mask)
  {
    return (settings_mask & DIALOG_SCENE.__BITMASK_BGM_MASK) >> DIALOG_SCENE.__BITMASK_BGM_SHIFT;
  }



  /**
   * @desc Extracts the scene bgs from a settings bitmask.
   * @param {Constant.DIALOG_SCENE|Real} [settings_mask] The settings bitmask. Defaults to the scene's current mask.
   * @returns {Real}
   */

  static __decode_bgs = function(settings_mask = self.settings_mask)
  {
    return (settings_mask & DIALOG_SCENE.__BITMASK_BGS_MASK) >> DIALOG_SCENE.__BITMASK_BGS_SHIFT;
  }



  /**
   * @desc Extracts the scene tag from a settings bitmask.
   * @param {Constant.DIALOG_SCENE|Real} [settings_mask] The settings bitmask. Defaults to the scene's current mask.
   * @returns {Real}
   */

  static __decode_tag = function(settings_mask = self.settings_mask)
  {
    return (settings_mask & DIALOG_SCENE.__BITMASK_TAG_MASK) >> DIALOG_SCENE.__BITMASK_TAG_SHIFT;
  }



  /**
   * @desc Serialises the scene into a compact array.
   * @returns {Array<Any>}
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
   * @param {Array<Any>} data The array payload.
   * @returns {Struct.DialogScene}
   */

  static __from_array = function(data)
  {
    return new DialogScene(
      array_map(data[1], function(sequence) {
        return DialogSequence.__DIALOG_MANAGER_DECODING_METHOD__(sequence);
      }),
      data[2]
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
      data.settings_mask
    )
    .__override_id(data.scene_id)
    .__update_sequences();
  }



  /**
   * @desc Returns a list of all sequences matching a tag.
   * @param {Constant.DIALOG_SEQUENCE|Real} [tag] The tag to filter the sequences with. Defaults to `DIALOG_SEQUENCE.TAG_DEFAULT`.
   * @returns {Array<Struct.DialogSequence>}
   */

  static __get_sequences_by_tag = function(tag = DIALOG_SEQUENCE.TAG_DEFAULT)
  {
    var sequences = [];

    for (var i = 0; i < self.sequence_count; ++i)
      if (self.sequences[i].__decode_tag() == tag)
        array_push(sequences, self.sequences[i]);

    return sequences;
  }



  /**
   * @desc Appends a sequence to the scene's sequence list.
   * @param {Struct.DialogSequence} sequence The new sequence to add.
   * @returns {Struct.DialogScene}
   */

  static __add_sequence = function(sequence)
  {
    sequence.scene = self;
    sequence.sequence_idx = self.sequence_count++;

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
    var sequence_count = array_length(sequences);

    for (var i = 0; i < sequence_count; sequences[i++].scene = self)
      sequences[i].sequence_idx = self.sequence_count + i;

    self.sequences = array_concat(self.sequences, sequences);
    self.sequence_count += sequence_count;

    return self;
  }



  /**
   * @desc Inserts a sequence in the scene list at a given index.
   * @param {Struct.DialogSequence} sequence The new sequence to add.
   * @param {Real} [index] The index where to add the new sequence. Defaults to last index.
   * @returns {Struct.DialogScene}
   */

  static __insert_sequence = function(sequence, index = self.sequence_count)
  {
    sequence.scene = self;
    sequence.sequence_idx = index;

    for (var i = index; i < self.sequence_count; ++i)
      ++self.sequences[i].sequence_idx;

    array_insert(self.sequences, index, sequence);

    ++self.sequence_count;

    return self;
  }



  /**
   * @desc Inserts sequences in the scene list at a given index.
   * @param {Array<Struct.DialogSequence>} sequences The new sequences to add.
   * @param {Real} [index] The index where to add the new sequences. Defaults to last index.
   * @returns {Struct.DialogScene}
   */

  static __insert_sequences = function(sequences, index = self.sequence_count)
  {
    var sequence_count = array_length(sequences);

    for (var i = index; i < self.sequence_count; --i)
      self.sequences[i].sequence_idx += sequence_count;

    for (var i = 0; i < sequence_count; sequences[i++].scene = self)
    {
      sequences[i].sequence_idx = index + i;
      array_insert(self.sequences, index + i, sequences[i]);
    }

    self.sequence_count += sequence_count;

    return self;
  }



  /**
   * @desc Renumbers every sequence to match its array position and refreshes the back-link to this scene.
   * @returns {Struct.DialogScene}
   */

  static __update_sequences = function()
  {
    for (var i = 0; i < self.sequence_count; self.sequences[i++].scene = self)
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
 * @param {Array<Struct.Dialog>} dialogs The array of `Dialog` of the sequence.
 * @param {Constant.DIALOG_SEQUENCE} settings_mask The sequence info.
 * @param {Array<Real>} speaker_map The indexes of the speakers.
 * @returns {Struct.DialogSequence}
 */

function DialogSequence(dialogs, settings_mask, speaker_map) : DialogLinkable() constructor
{
  static CONSTRUCTOR_ARGC = argument_count;
  static sequence_id = 0;

  self.scene = undefined;
  self.speaker_map = speaker_map;
  self.sequence_id = sequence_id++;
  self.settings_mask = settings_mask;
  self.sequence_idx = 0;
  self.dialog_count = 0;
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
   * @desc Encodes the sequence tag as a bitmask fragment.
   * @param {Constant.DIALOG_SEQUENCE|Real} [tag] The tag identifier.
   * @returns {Real}
   */

  static __encode_tag = function(tag = DIALOG_SEQUENCE.TAG_DEFAULT)
  {
    return tag << DIALOG_SEQUENCE.__BITMASK_TAG_SHIFT & DIALOG_SEQUENCE.__BITMASK_TAG_MASK;
  }



  /**
   * @desc Extracts the sequence tag from a settings bitmask.
   * @param {Constant.DIALOG_SEQUENCE|Real} [settings_mask] The settings bitmask. Defaults to the sequence's current mask.
   * @returns {Real}
   */

  static __decode_tag = function(settings_mask = self.settings_mask)
  {
    return (settings_mask & DIALOG_SEQUENCE.__BITMASK_TAG_MASK) >> DIALOG_SEQUENCE.__BITMASK_TAG_SHIFT;
  }



  /**
   * @desc Serialises the sequence into a compact array.
   * @returns {Array<Any>}
   */

  static __array = function()
  {
    return [
      int64(sequence_id),
      int64(settings_mask),
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
      settings_mask: int64(settings_mask),
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
      data[2],
      data[3]
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
      data.settings_mask,
      data.speaker_map
    )
    .__override_id(data.sequence_id)
    .__update_dialogs();
  }



  /**
   * @desc Returns a list of all dialogs matching a tag.
   * @param {Constant.DIALOG|Real} [tag] The tag to filter the dialogs with. Defaults to `DIALOG.TAG_DEFAULT`.
   * @returns {Array<Struct.Dialog>}
   */

  static __get_dialogs_by_tag = function(tag = DIALOG.TAG_DEFAULT)
  {
    var dialogs = [];

    for (var i = 0; i < self.dialog_count; ++i)
      if (self.dialogs[i].__decode_tag() == tag)
        array_push(dialogs, self.dialogs[i]);

    return dialogs;
  }



  /**
   * @desc Appends a dialog to the sequence's dialog list.
   * @param {Struct.Dialog} dialog The new dialog to add.
   * @returns {Struct.DialogSequence}
   */

  static __add_dialog = function(dialog)
  {
    dialog.sequence = self;
    dialog.dialog_idx = self.dialog_count++;

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

    for (var i = 0; i < dialog_count; dialogs[i++].sequence = self)
      dialogs[i].dialog_idx = self.dialog_count + i;

    self.dialogs = array_concat(self.dialogs, dialogs);
    self.dialog_count += dialog_count;

    return self;
  }



  /**
   * @desc Inserts a dialog into the sequence list at a given index.
   * @param {Struct.Dialog} dialog The new dialog to insert.
   * @param {Real} [index] The index where to insert the new dialog. Defaults to last index.
   * @returns {Struct.DialogSequence}
   */

  static __insert_dialog = function(dialog, index = self.dialog_count)
  {
    dialog.sequence = self;
    dialog.dialog_idx = index;

    for (var i = index; i < self.dialog_count; ++i)
      ++self.dialogs[i].dialog_idx;

    array_insert(self.dialogs, index, dialog);

    ++self.dialog_count;

    return self;
  }



  /**
   * @desc Inserts dialogs into the sequence list at a given index.
   * @param {Array<Struct.Dialog>} dialogs The new dialogs to insert.
   * @param {Real} [index] The index where to insert the new dialogs. Defaults to last index.
   * @returns {Struct.DialogSequence}
   */

  static __insert_dialogs = function(dialogs, index = self.dialog_count)
  {
    var dialog_count = array_length(dialogs);

    for (var i = index; i < self.dialog_count; ++i)
      self.dialogs[i].dialog_idx += dialog_count;

    for (var i = 0; i < dialog_count; dialogs[i++].sequence = self)
    {
      array_insert(self.dialogs, index + i, dialogs[i]);
      dialogs[i].dialog_idx = index + i;
    }

    self.dialog_count += dialog_count;

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
    for (var i = 0; i < self.dialog_count; self.dialogs[i++].sequence = self)
      self.dialogs[i].dialog_idx = i;

    return self;
  }



  /**
   * @desc Creates a map of the dialog speakers and readapts the ones in the dialog to match the relative map index.
   * @returns {Struct.DialogSequence}
   */

  static __map_speakers = function()
  {
    self.speaker_map = [];

    var map = {}
      , count = 0
    ;

    for (var i = 0; i < self.dialog_count; ++i)
    {
      var dialog = self.dialogs[i];

      if (!struct_exists(map, dialog.speaker_id))
      {
        struct_set(map, dialog.speaker_id, count);
        self.speaker_map[count++] = dialog.speaker_id;
      }

      dialog.speaker_id = struct_get(map, dialog.speaker_id);
    }

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
   * @param {String} data_string The JSON payload.
   * @returns {Struct.DialogSequence}
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
 * @param {String} text The text message of the dialog.
 * @param {Constant.DIALOG|Real} settings_mask The dialog info.
 * @param {Array<Struct.DialogFX>} fx_map The array of `DialogFX` to apply.
 * @returns {Struct.Dialog}
 */

function Dialog(text, settings_mask, fx_map) : DialogLinkable() constructor
{
  static CONSTRUCTOR_ARGC = argument_count;

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
   * @param {Constant.DIALOG|Real} [speaker_id] Optional speaker identifier.
   * @param {Constant.DIALOG|Real} [emotion_id] Optional emotion identifier.
   * @param {Constant.DIALOG|Real} [anchor_id] Optional anchor point identifier.
   * @param {Constant.DIALOG|Real} [textbox_id] Optional textbox identifier.
   * @returns {Real}
   */

  static __encode_settings = function(speaker_id = DIALOG.SPEAKER_NONE, emotion_id = DIALOG.EMOTION_DEFAULT, anchor_id = DIALOG.ANCHOR_DEFAULT, textbox_id = DIALOG.TEXTBOX_DEFAULT)
  {
    return __encode_textbox_id(textbox_id) | __encode_anchor_id(anchor_id) | __encode_emotion_id(emotion_id) | __encode_speaker_id(speaker_id);
  }



  /**
   * @desc Encodes only the speaker ID as a bitmask fragment.
   * @param {Constant.DIALOG|Real} speaker_id The speaker identifier.
   * @returns {Real}
   */

  static __encode_speaker_id = function(speaker_id)
  {
    return speaker_id << DIALOG.__BITMASK_SPEAKER_SHIFT & DIALOG.__BITMASK_SPEAKER_MASK;
  }



  /**
   * @desc Encodes only the speaker ID as a bitmask fragment.
   * @param {Constant.DIALOG|Real} emotion_id The emotion identifier.
   * @returns {Real}
   */

  static __encode_emotion_id = function(emotion_id)
  {
    return emotion_id << DIALOG.__BITMASK_EMOTION_SHIFT & DIALOG.__BITMASK_EMOTION_MASK;
  }



  /**
   * @desc Encodes only the anchor ID as a bitmask fragment.
   * @param {Constant.DIALOG|Real} anchor_id The anchor identifier.
   * @returns {Real}
   */

  static __encode_anchor_id = function(anchor_id)
  {
    return anchor_id << DIALOG.__BITMASK_ANCHOR_SHIFT & DIALOG.__BITMASK_ANCHOR_MASK;
  }



  /**
   * @desc Encodes only the textbox ID as a bitmask fragment.
   * @param {Constant.DIALOG|Real} textbox_id The textbox identifier.
   * @returns {Real}
   */

  static __encode_textbox_id = function(textbox_id)
  {
    return textbox_id << DIALOG.__BITMASK_TEXTBOX_SHIFT & DIALOG.__BITMASK_TEXTBOX_MASK;
  }



  /*
   * @desc Encodes the dialog tag as a bitmask fragment.
   * @param {Constant.DIALOG|Real} [tag] The tag identifier.
   * @returns {Real}
   */

  static __encode_tag = function(tag = DIALOG.TAG_DEFAULT)
  {
    return tag << DIALOG.__BITMASK_TAG_SHIFT & DIALOG.__BITMASK_TAG_MASK;
  }



  /**
   * @desc Extracts the dialog tag from a settings bitmask.
   * @param {Constant.DIALOG|Real} [settings_mask] The settings bitmask. Defaults to the dialog's current mask.
   * @returns {Real}
   */

  static __decode_tag = function(settings_mask = self.settings_mask)
  {
    return (settings_mask & DIALOG.__BITMASK_TAG_MASK) >> DIALOG.__BITMASK_TAG_SHIFT;
  }



  /**
   * @desc Extracts the speaker ID from a settings bitmask.
   * @param {Constant.DIALOG|Real} [settings_mask] The settings bitmask. Defaults to the dialog's current mask.
   * @returns {Real}
   */

  static __decode_speaker_id = function(settings_mask = self.settings_mask)
  {
    return (settings_mask & DIALOG.__BITMASK_SPEAKER_MASK) >> DIALOG.__BITMASK_SPEAKER_SHIFT;
  }



  /**
   * @desc Extracts the emotion ID from a settings bitmask.
   * @param {Constant.DIALOG|Real} [settings_mask] The settings bitmask. Defaults to the dialog's current mask.
   * @returns {Real}
   */

  static __decode_emotion_id = function(settings_mask = self.settings_mask)
  {
    return (settings_mask & DIALOG.__BITMASK_EMOTION_MASK) >> DIALOG.__BITMASK_EMOTION_SHIFT;
  }



  /**
   * @desc Extracts the anchor ID from a settings bitmask.
   * @param {Constant.DIALOG|Real} [settings_mask] The settings bitmask. Defaults to the dialog's current mask.
   * @returns {Real}
   */

  static __decode_anchor_id = function(settings_mask = self.settings_mask)
  {
    return (settings_mask & DIALOG.__BITMASK_ANCHOR_MASK) >> DIALOG.__BITMASK_ANCHOR_SHIFT;
  }



  /**
   * @desc Extracts the textbox ID from a settings bitmask.
   * @param {Constant.DIALOG|Real} [settings_mask] The settings bitmask. Defaults to the dialog's current mask.
   * @returns {Real}
   */

  static __decode_textbox_id = function(settings_mask = self.settings_mask)
  {
    return (settings_mask & DIALOG.__BITMASK_TEXTBOX_MASK) >> DIALOG.__BITMASK_TEXTBOX_SHIFT;
  }



  /**
   * @desc Serialises the dialog into a compact array.
   * @returns {Array<Any>}
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
   * @param {Array<Any>} data The array payload.
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
   * @desc Retrieves the assigned manager object.
   * @returns {Struct.DialogManager}
   */

  static __get_manager = function()
  {
    return self.sequence.scene.manager;
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
   * @returns {Struct.DialogFX|undefined}
   */

  static __get_jump = function()
  {
    for (var i = array_length(self.fx_map) - 1; i >= 0; --i)
      if (self.fx_map[i].__decode_fx_type() == DIALOG_FX.TYPE_JUMP)
        return self.fx_map[i];

    return undefined;
  }



  /**
   * @desc Returns the first fallback FX that evaluates truthfully, if any.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the effect.
   * @returns {Struct.DialogFX|undefined}
   */

  static __get_fallback = function(argv = undefined)
  {
    var fx_count = array_length(self.fx_map);

    for (var i = 0; i < fx_count; ++i)
      if (self.fx_map[i].__decode_fx_type() == DIALOG_FX.TYPE_FALLBACK && self.fx_map[i].__exec(__get_manager(), argv))
        return self.fx_map[i];

    return undefined;
  }



  /**
   * @desc Returns the first choice FX, if any.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the effect.
   * @returns {Struct.DialogFX|undefined}
   */

  static __get_choice = function(argv = undefined)
  {
    var fx_count = array_length(self.fx_map);

    for (var i = 0; i < fx_count; ++i)
      if (self.fx_map[i].__decode_fx_type() == DIALOG_FX.TYPE_CHOICE)
        return self.fx_map[i];

    return undefined;
  }



  /**
   * @desc Checks whether the specified `Dialog` object contains `DialogFX` objects matching a specified criteria.
   * @param {Function} [filter_fn] The predicate to test against each FX. Defaults to `true`.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the effects.
   * @returns {Bool}
   */

  static __fx_has_of = function(filter_fn = function(fx, argv) { return true; }, argv = undefined)
  {
    for (var i = array_length(self.fx_map) - 1; i >= 0; --i)
      if (filter_fn(self.fx_map[i], argv))
        return true;

    return false;
  }



  /**
   * @desc Retrieves all dialog FX which match a filter.
   * @param {Function} [filter_fn] The predicate to test against each FX. Defaults to `true`.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the effects.
   * @returns {Array<Struct.DialogFX>}
   */

  static __fx_get_all_of = function(filter_fn = function(fx, argv = undefined) { return true; }, argv = undefined)
  {
    var filtered = [];
    var fx_count = array_length(self.fx_map);

    for (var i = 0; i < fx_count; ++i)
      if (filter_fn(self.fx_map[i], argv))
        array_push(filtered, self.fx_map[i]);

    return filtered;
  }



  /**
   * @desc Executes all dialog FX which match a filter.
   * @param {Function} [filter_fn] The predicate to test against each FX. Defaults to `true`.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the effects.
   * @returns {Struct.Dialog}
   */

  static __fx_execute_all_of = function(filter_fn = function(fx, argv) { return true; }, argv = undefined)
  {
    var fx_count = array_length(self.fx_map);

    for (var i = 0; i < fx_count; ++i)
      if (filter_fn(self.fx_map[i], argv))
        self.fx_map[i].__exec(__get_manager(), argv);

    return self;
  }

  
  
  /**
   * @desc Links the specified dialog to a given choice fx.
   * @param {Struct.DialogFX} fx The effect to link the dialog to.
   * @param {String} prompt The choice's option text.
   * @param {Real} [index] The specific index where to insert the new option in the choice list. Defaults to list length.
   * @returns {Struct.Dialog}
   */

  static __fx_from_choice = function(fx, prompt, index = array_length(fx.argv))
  {
    array_insert(fx.argv, index, [prompt, self]);

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
 * @param {Constant.DIALOG_FX|Real} settings_mask The effect info.
 * @param {Array<Any>} argv The arguments of the mapped effect function.
 * @param {Function} func The function to add to the dialog manager (NOT SERIALIZED).
 * @returns {Struct.DialogFX}
 */

function DialogFX(settings_mask, argv, func) constructor
{
  static CONSTRUCTOR_ARGC = argument_count;

  self.settings_mask = settings_mask;
  self.argv = argv;



  /**
   * @desc Combines FX type and trigger into a single bitmask.
   * @param {Constant.DIALOG_FX|Real} type The effect type.
   * @param {Constant.DIALOG_FX|Real} trigger The effect trigger condition.
   * @returns {Real}
   */

  static __encode_settings = function(type, trigger)
  {
    return __encode_fx_trigger(trigger) | __encode_fx_type(type);
  }



  /**
   * @desc Encodes only the FX type as a bitmask fragment.
   * @param {Constant.DIALOG_FX|Real} type The effect type.
   * @returns {Real}
   */

  static __encode_fx_type = function(type)
  {
    return type << DIALOG_FX.__BITMASK_TYPE_SHIFT & DIALOG_FX.__BITMASK_TYPE_MASK;
  }



  /**
   * @desc Encodes only the FX trigger as a bitmask fragment.
   * @param {Constant.DIALOG_FX|Real} trigger The trigger condition.
   * @returns {Real}
   */

  static __encode_fx_trigger = function(trigger)
  {
    return trigger << DIALOG_FX.__BITMASK_TRIGGER_SHIFT & DIALOG_FX.__BITMASK_TRIGGER_MASK;
  }



  /**
   * @desc Extracts the FX type from a settings bitmask.
   * @param {Constant.DIALOG_FX|Real} [settings_mask] Optional override bitmask. Defaults to this FX's mask.
   * @returns {Real}
   */

  static __decode_fx_type = function(settings_mask = self.settings_mask)
  {
    return (settings_mask & DIALOG_FX.__BITMASK_TYPE_MASK) >> DIALOG_FX.__BITMASK_TYPE_SHIFT;
  }



  /**
   * @desc Extracts the FX trigger from a settings bitmask.
   * @param {Constant.DIALOG_FX|Real} [settings_mask] Optional override bitmask. Defaults to this FX's mask.
   * @returns {Real}
   */

  static __decode_fx_trigger = function(settings_mask = self.settings_mask)
  {
    return (settings_mask & DIALOG_FX.__BITMASK_TRIGGER_MASK) >> DIALOG_FX.__BITMASK_TRIGGER_SHIFT;
  }



  /**
   * @desc Serialises the FX into a compact array.
   * @returns {Array<Any>}
   */

  static __array = function()
  {
    return [
      int64(settings_mask),
      __resolve_recursive(argv)
    ];
  }



  /**
   * @desc Serialises the FX into a plain struct.
   * @returns {Struct}
   */

  static __struct = function()
  {
    return {
      settings_mask: int64(self.settings_mask),
      argv: __resolve_recursive(self.argv)
    };
  }



  /**
   * @desc Deserialises an FX from an array produced by {@link __array}.
   * @param {Array<Any>} data The array payload.
   * @returns {Struct.DialogFX}
   */

  static __from_array = function(data)
  {
    return new DialogFX(data[0], data[1], undefined);
  }



  /**
   * @desc Deserialises an FX from a struct produced by {@link __struct}.
   * @param {Struct} data The struct payload.
   * @returns {Struct.DialogFX}
   */

  static __from_struct = function(data)
  {
    return new DialogFX(data.settings_mask, data.argv, undefined);
  }



  /**
   * @desc Executes the FX using the global dialog manager's registered handlers.
   * @param {Struct.DialogManager} dialog_manager The referenced dialog manager.
   * @param {Array<Any>} [argv] The arguments to pass to the effect.
   * @returns {Any}
   */

  static __exec = function(dialog_manager, argv = self.argv)
  {
    return dialog_manager.fx_map[__decode_fx_type()](dialog_manager, argv);
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



  if (func)
  {
    var type = __decode_fx_type(settings_mask);

    if (type >= array_length(DialogManager.fx_map))
      DialogManager.fx_map[type] = func;
    else if (
      type == DIALOG_FX.TYPE_FALLBACK
      && (argv[DIALOG_FX.ARG_JUMP_CONDITION] ?? 0) >= array_length(DialogManager.condition_map)
    )
      DialogManager.condition_map[type] = func; 
  }



  // Recursive argument serializer function
  function __resolve_recursive(arg) {
    return is_array(arg)
      ? array_map(arg, __resolve_recursive)
      : (is_instanceof(arg, DialogLinkable)
        ? arg.__get_position()
        : arg
      )
    ;
  }
}
