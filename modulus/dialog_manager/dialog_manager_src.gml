/**
 * @desc A lightweight, bitmask-focused dialog management system.
 * @link https://github.com/MaximilianVolt/GMS2_scripts/tree/main/modulus/dialog_manager
 * @author @MaximilianVolt
 * @version 0.9.0
 */

#macro __DIALOG_MANAGER_SERIALIZING_METHOD__   __struct      // Must be <__struct> or <__array>
#macro __DIALOG_MANAGER_DESERIALIZING_METHOD__ __from_struct // Must be <__from_struct> or <__from_array>



// Do not edit

/**
 * @desc `POSITION_CODE_*` options refer to relative dialog positioning encodings.
 * @desc `__BITMASK_*` options are used to manage bitmasks and should not be referenced directly.
 * @desc `FLAG_*` flags refer to various info stored in a bitfield.
 * @desc `JUMP_*` options refer to jump effect settings.
 * @desc `MASK_JUMP_*` options refer to jump effect settings masks and can be used to encode settings.
 * @desc `ERR_*` options refer to error codes and can be used to check error types.
 */

enum DIALOG_MANAGER
{
  // Positioning codes (should not edit)
  POSITION_CODE_NONE = -15,
  POSITION_CODE_SCENE_LAST,
  POSITION_CODE_SCENE_NEXT,
  POSITION_CODE_SCENE_END,
  POSITION_CODE_SCENE_MIDDLE,
  POSITION_CODE_SCENE_START,
  POSITION_CODE_SCENE_PREVIOUS,
  POSITION_CODE_SCENE_FIRST,
  POSITION_CODE_SEQUENCE_LAST,
  POSITION_CODE_SEQUENCE_NEXT,
  POSITION_CODE_SEQUENCE_END,
  POSITION_CODE_SEQUENCE_MIDDLE,
  POSITION_CODE_SEQUENCE_START,
  POSITION_CODE_SEQUENCE_PREVIOUS,
  POSITION_CODE_SEQUENCE_FIRST,
  POSITION_CODE_COUNT = -DIALOG_MANAGER.POSITION_CODE_NONE,

  // Status info (indexes)
  __BITMASK_FLAG_STATUS_INDEX_UNINITIALIZED = 0,
  __BITMASK_FLAG_STATUS_INDEX_FIRST_DIALOG,
  __BITMASK_FLAG_STATUS_INDEX_FIRST_SEQUENCE,
  __BITMASK_FLAG_STATUS_INDEX_FIRST_SCENE,
  __BITMASK_FLAG_STATUS_INDEX_FIRST_OF_SEQUENCE,
  __BITMASK_FLAG_STATUS_INDEX_FIRST_OF_SCENE,
  __BITMASK_FLAG_STATUS_INDEX_MIDDLE_OF_SEQUENCE,
  __BITMASK_FLAG_STATUS_INDEX_MIDDLE_OF_SCENE,
  __BITMASK_FLAG_STATUS_INDEX_MIDDLE_SCENE,
  __BITMASK_FLAG_STATUS_INDEX_LAST_DIALOG,
  __BITMASK_FLAG_STATUS_INDEX_LAST_SEQUENCE,
  __BITMASK_FLAG_STATUS_INDEX_LAST_SCENE,
  __BITMASK_FLAG_STATUS_INDEX_LAST_OF_SEQUENCE,
  __BITMASK_FLAG_STATUS_INDEX_LAST_OF_SCENE,
  __BITMASK_STATUS_NO_AUTORESET_COUNT,
  __BITMASK_FLAG_STATUS_INDEX_ADVANCED_DIALOG = DIALOG_MANAGER.__BITMASK_STATUS_NO_AUTORESET_COUNT,
  __BITMASK_FLAG_STATUS_INDEX_ADVANCED_SEQUENCE,
  __BITMASK_FLAG_STATUS_INDEX_ADVANCED_SCENE,
  __BITMASK_FLAG_STATUS_INDEX_RECEDED_DIALOG,
  __BITMASK_FLAG_STATUS_INDEX_RECEDED_SEQUENCE,
  __BITMASK_FLAG_STATUS_INDEX_RECEDED_SCENE,
  __BITMASK_FLAG_STATUS_INDEX_EXECUTED_JUMP,
  __BITMASK_FLAG_STATUS_INDEX_EXECUTED_FALLBACK,
  __BITMASK_FLAG_STATUS_INDEX_EXECUTED_CHOICE,
  FLAG_STATUS_COUNT,

  // Status info (values)
  FLAG_STATUS_UNINITIALIZED      = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_UNINITIALIZED,
  FLAG_STATUS_FIRST_DIALOG       = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_FIRST_DIALOG,
  FLAG_STATUS_FIRST_SEQUENCE     = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_FIRST_SEQUENCE,
  FLAG_STATUS_FIRST_SCENE        = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_FIRST_SCENE,
  FLAG_STATUS_FIRST_OF_SEQUENCE  = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_FIRST_OF_SEQUENCE,
  FLAG_STATUS_FIRST_OF_SCENE     = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_FIRST_OF_SCENE,
  FLAG_STATUS_MIDDLE_OF_SEQUENCE = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_MIDDLE_OF_SEQUENCE,
  FLAG_STATUS_MIDDLE_OF_SCENE    = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_MIDDLE_OF_SCENE,
  FLAG_STATUS_MIDDLE_SCENE       = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_MIDDLE_SCENE,
  FLAG_STATUS_LAST_DIALOG        = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_LAST_DIALOG,
  FLAG_STATUS_LAST_SEQUENCE      = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_LAST_SEQUENCE,
  FLAG_STATUS_LAST_SCENE         = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_LAST_SCENE,
  FLAG_STATUS_LAST_OF_SEQUENCE   = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_LAST_OF_SEQUENCE,
  FLAG_STATUS_LAST_OF_SCENE      = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_LAST_OF_SCENE,
  FLAG_STATUS_ADVANCED_DIALOG    = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_ADVANCED_DIALOG,
  FLAG_STATUS_ADVANCED_SEQUENCE  = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_ADVANCED_SEQUENCE,
  FLAG_STATUS_ADVANCED_SCENE     = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_ADVANCED_SCENE,
  FLAG_STATUS_RECEDED_DIALOG     = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_RECEDED_DIALOG,
  FLAG_STATUS_RECEDED_SEQUENCE   = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_RECEDED_SEQUENCE,
  FLAG_STATUS_RECEDED_SCENE      = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_RECEDED_SCENE,
  FLAG_STATUS_EXECUTED_JUMP      = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_EXECUTED_JUMP,
  FLAG_STATUS_EXECUTED_FALLBACK  = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_EXECUTED_FALLBACK,
  FLAG_STATUS_EXECUTED_CHOICE    = 1 << DIALOG_MANAGER.__BITMASK_FLAG_STATUS_INDEX_EXECUTED_CHOICE,

  // Masks
  __BITMASK_STATUS_AUTORESET_COUNT = DIALOG_MANAGER.FLAG_STATUS_COUNT - DIALOG_MANAGER.__BITMASK_STATUS_NO_AUTORESET_COUNT,
  __BITMASK_STATUS_NO_AUTORESET_MASK = (1 << DIALOG_MANAGER.__BITMASK_STATUS_NO_AUTORESET_COUNT) - 1,
  __BITMASK_STATUS_AUTORESET_MASK = ((1 << DIALOG_MANAGER.__BITMASK_STATUS_AUTORESET_COUNT) - 1) << DIALOG_MANAGER.__BITMASK_STATUS_NO_AUTORESET_COUNT,
  __BITMASK_STATUS_MASK = (1 << DIALOG_MANAGER.FLAG_STATUS_COUNT) - 1,

  // Jump options
  JUMP_TYPE_ABSOLUTE = 0,
  JUMP_TYPE_RELATIVE,
  __BITMASK_JUMP_TYPE_SHIFT = 0,
  __BITMASK_JUMP_TYPE_BITS = 1,
  __BITMASK_JUMP_TYPE_MASK = ((1 << DIALOG_MANAGER.__BITMASK_JUMP_TYPE_BITS) - 1) << DIALOG_MANAGER.__BITMASK_JUMP_TYPE_SHIFT,
  MASK_JUMP_TYPE_ABSOLUTE = DIALOG_MANAGER.JUMP_TYPE_ABSOLUTE << DIALOG_MANAGER.__BITMASK_JUMP_TYPE_SHIFT,
  MASK_JUMP_TYPE_RELATIVE = DIALOG_MANAGER.JUMP_TYPE_RELATIVE << DIALOG_MANAGER.__BITMASK_JUMP_TYPE_SHIFT,
  JUMP_UNIT_DIALOG = 0,
  JUMP_UNIT_SEQUENCE,
  JUMP_UNIT_SCENE,
  __BITMASK_JUMP_UNIT_SHIFT = DIALOG_MANAGER.__BITMASK_JUMP_TYPE_SHIFT + DIALOG_MANAGER.__BITMASK_JUMP_TYPE_BITS,
  __BITMASK_JUMP_UNIT_BITS = 2,
  __BITMASK_JUMP_UNIT_MASK = ((1 << DIALOG_MANAGER.__BITMASK_JUMP_UNIT_BITS) - 1) << DIALOG_MANAGER.__BITMASK_JUMP_UNIT_SHIFT,
  MASK_JUMP_UNIT_DIALOG = DIALOG_MANAGER.JUMP_UNIT_DIALOG << DIALOG_MANAGER.__BITMASK_JUMP_UNIT_SHIFT | DIALOG_MANAGER.MASK_JUMP_TYPE_RELATIVE,
  MASK_JUMP_UNIT_SEQUENCE = DIALOG_MANAGER.JUMP_UNIT_SEQUENCE << DIALOG_MANAGER.__BITMASK_JUMP_UNIT_SHIFT | DIALOG_MANAGER.MASK_JUMP_TYPE_RELATIVE,
  MASK_JUMP_UNIT_SCENE = DIALOG_MANAGER.JUMP_UNIT_SCENE << DIALOG_MANAGER.__BITMASK_JUMP_UNIT_SHIFT | DIALOG_MANAGER.MASK_JUMP_TYPE_RELATIVE,
  __BITMASK_JUMP_CHOICE_SHIFT = DIALOG_MANAGER.__BITMASK_JUMP_UNIT_SHIFT + DIALOG_MANAGER.__BITMASK_JUMP_UNIT_BITS,
  __BITMASK_JUMP_CHOICE_BITS = 1,
  MASK_JUMP_CHOICE = ((1 << DIALOG_MANAGER.__BITMASK_JUMP_CHOICE_BITS) - 1) << DIALOG_MANAGER.__BITMASK_JUMP_CHOICE_SHIFT,

  // Error codes
  ERR_UNDEFINED_ERROR_TYPE = 0,
  ERR_SERIALIZATION_FAILED,
  ERR_DESERIALIZATION_FAILED,
  ERR_PARSING_FAILED,
  ERR_UNDEFINED_BACKREF_L1,
  ERR_UNDEFINED_BACKREF_L2,
  ERR_EMPTY_CONTAINER_OBJECT,
  ERR_INVALID_POSITION,
  ERR_INFINITE_LOOP_DETECTED,
  ERR_COUNT,

  // Error checks
  ERR_CHECK_INFINITE_LOOP_TRESHOLD = 32,
}



// Edit as needed

/**
 * @desc Contains all useful information about a dialog scene.
 * @desc `BG_*` options refer to the background index.
 * @desc `BGM_*` options refer to the background music index.
 * @desc `BGS_*` flags refer to the background sound index.
 * @desc `TAG_*` options refer to the scene type for categorization (useful for filtering).
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
 * @desc `FALLBACK_*` options refer to the conditions of fallback effects.
 * @desc `CHOICE_*` options refer to particular values for choice effects.
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
  TYPE_STATE_MODIFIER,
  TYPE_TEXT_PARSE,
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
  TRIGGER_ON_ENTER,
  TRIGGER_ON_CUSTOM,
  TRIGGER_ON_LEAVE,
  TRIGGER_NONE,
    // ...
  TRIGGER_COUNT,
  TRIGGER_DEFAULT = DIALOG_FX.TRIGGER_AUTO,

  // Fallback FX conditions
  FALLBACK_CONDITION_FALSE = 0,
  FALLBACK_CONDITION_TRUE,
    // ...
  FALLBACK_CONDITION_COUNT,

  // Choice flag
  CHOICE_INDEX_UNSELECTED = -1,
  CHOICE_CONDITION_COUNT = -DIALOG_FX.CHOICE_INDEX_UNSELECTED,

  // FX arg positions
  ARG_JUMP_DATA = 0,
  ARG_JUMP_DATA_POSITION = 0,
  ARG_JUMP_DATA_OPTIONS,
  ARG_JUMP_DATA_COUNT,
  ARG_FALLBACK_CONDITION = 1,
  ARG_CHOICE_INDEX = 1,
  ARG_SUBARG_CHOICE_PROMPT = 1,

  // Masks (should not be edited)
  __BITMASK_TYPE_SHIFT = 0,
  __BITMASK_TYPE_BITS = 6,
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



  var __map_manager_data = function(size, shift, mask)
  {
    var array = array_create(size);

    for (var i = 0; i < size; ++i)
      array[i] = i << shift & mask;

    return array;
  }

  self.data = {
    dialog_scene_bg      : __map_manager_data(DIALOG_SCENE.BG_COUNT    , DIALOG_SCENE.__BITMASK_BG_SHIFT    , DIALOG_SCENE.__BITMASK_BG_MASK    ),
    dialog_scene_bgm     : __map_manager_data(DIALOG_SCENE.BGM_COUNT   , DIALOG_SCENE.__BITMASK_BGM_SHIFT   , DIALOG_SCENE.__BITMASK_BGM_MASK   ),
    dialog_scene_bgs     : __map_manager_data(DIALOG_SCENE.BGS_COUNT   , DIALOG_SCENE.__BITMASK_BGS_SHIFT   , DIALOG_SCENE.__BITMASK_BGS_MASK   ),
    dialog_scene_tags    : __map_manager_data(DIALOG_SCENE.TAG_COUNT   , DIALOG_SCENE.__BITMASK_TAG_SHIFT   , DIALOG_SCENE.__BITMASK_TAG_MASK   ),
    dialog_sequence_tags : __map_manager_data(DIALOG_SEQUENCE.TAG_COUNT, DIALOG_SEQUENCE.__BITMASK_TAG_SHIFT, DIALOG_SEQUENCE.__BITMASK_TAG_MASK),
    dialog_speakers      : __map_manager_data(DIALOG.SPEAKER_COUNT     , DIALOG.__BITMASK_SPEAKER_SHIFT     , DIALOG.__BITMASK_SPEAKER_MASK     ),
    dialog_emotions      : __map_manager_data(DIALOG.EMOTION_COUNT     , DIALOG.__BITMASK_EMOTION_SHIFT     , DIALOG.__BITMASK_EMOTION_MASK     ),
    dialog_anchors       : __map_manager_data(DIALOG.ANCHOR_COUNT      , DIALOG.__BITMASK_ANCHOR_SHIFT      , DIALOG.__BITMASK_ANCHOR_MASK      ),
    dialog_textboxes     : __map_manager_data(DIALOG.TEXTBOX_COUNT     , DIALOG.__BITMASK_TEXTBOX_SHIFT     , DIALOG.__BITMASK_TEXTBOX_MASK     ),
    dialog_tags          : __map_manager_data(DIALOG.TAG_COUNT         , DIALOG.__BITMASK_TAG_SHIFT         , DIALOG.__BITMASK_TAG_MASK         ),
    dialog_fx_types      : __map_manager_data(DIALOG_FX.TYPE_COUNT     , DIALOG_FX.__BITMASK_TYPE_SHIFT     , DIALOG_FX.__BITMASK_TYPE_MASK     ),
    dialog_fx_triggers   : __map_manager_data(DIALOG_FX.TRIGGER_COUNT  , DIALOG_FX.__BITMASK_TRIGGER_SHIFT  , DIALOG_FX.__BITMASK_TRIGGER_MASK  ),
  };

  self.scene_count = 0;
  self.scenes = [];
  self.position = 0;
  self.status = 0;
  self.jumps = -1;



  /**
   * @desc Error message function.
   * @param {Real} type The error type.
   * @param {Any|Array<Any>} [argv] The arguments for the message.
   */

  static ERROR = function(type, argv = [])
  {
    if (type < 0 || type >= DIALOG_MANAGER.ERR_COUNT)
    {
      argv = [type];
      type = DIALOG_MANAGER.ERR_UNDEFINED_ERROR_TYPE;
    }

    if (!is_array(argv))
      argv = [argv];

    var msg = string_ext([
        "UNKNOWN ERROR TYPE: {0}",
        "SERIALIZATION FAILED - INVALID DATA:\nENSURE PRESENCE OF ALL REFERENCED \{Struct.{0}\} OBJECTS",
        "DESERIALIZATION FAILED - A PROBLEM OCCURRED WHILE OPENING FILE <{0}>:\nENSURE INTEGRITY OF FILE NAME/PATH OR FILE HANDLE",
        "PARSING FAILED - INVALID DATA: ENSURE INTEGRITY OF SERIALIZED DATA",
        "POSITION RESOLUTION FAILED FROM \{Struct.{0}\} - UNDEFINED \{Struct.{1}\} CONTAINER OBJECT:\nENSURE EXISTENCE OF BACK-REFERENCE AND AVOIDAL OF USAGE OF variable_clone()'d RECURSIVE COMPONENT REFERENCES (\{Struct.{2}\}, \{Struct.{3}\}) AS VALID OBJECTS.\n\nSTRUCTURE INFO: {4}",
        "POSITION RESOLUTION FAILED FROM \{Struct.{0}\} - UNDEFINED \{Struct.{1}\} CONTAINER OBJECT:\nENSURE EXISTENCE OF BACK-REFERENCE AND AVOIDAL OF USAGE OF variable_clone()'d RECURSIVE COMPONENT REFERENCES (\{Struct.{2}\}, \{Struct.{3}\}) AS VALID OBJECTS.\n\nSTRUCTURE INFO: {4}\n\nCONTAINER STRUCTURE INFO: {5}",
        "USED CONTAINER OBJECT OF TYPE \{Struct.{0}\} SHOULD NOT BE EMPTY",
        "INVALID POSITION - INDEX OUT OF BOUNDS: ERROR WHILE ATTEMPTING ACCESS TO:\n< SCENE {0} | SEQUENCE {1} | DIALOG {2} >",
        "INFINITE LOOP DETECTED - ITERATION {0}: ENSURE JUMP EFFECTS DO NOT POINT TO LOOPING LOCATIONS\n\nCRASH POSITION DATA: {1}",
      ][type],
      argv
    );

    return $"\n\n\n{msg}\n\n";
  }



  /**
   * @desc Changes the dialog manager position to the given one. [CHAINABLE]
   * @param {Real|Constant.DialogManager|Struct.DialogLinkable} [position] The position to load.
   * @param {Bool} [lazy] Whether the dialog manager should avoid executing jumps normally with effects (`true`) or not (`false`).
   * @param {Array} [argv] The arguments to pass to eventual fallback effects (only if `lazy` is `false`).
   * @returns {Struct.DialogManager}
   */

  static load = function(position = self.position, lazy = true, argv = [])
  {
    self.status = 0;

    if (lazy)
      self.position = __resolve_position(position);
    else
      __jump(position, argv);

    self.status |= __status();

    return self;
  }



  /**
   * @desc Retrieves a scene given an index. Negative indices will iterate backwards. Throws DIALOG_MANAGER.ERR_INVALID_POSITION if out of bounds.
   * @param {Real} [scene_idx] The index of the scene to get.
   * @returns {Struct.DialogScene}
   */

  static scene = function(scene_idx = __decode_scene_idx(self.position))
  {
    try {
      return self.scenes[scene_idx + self.scene_count * (scene_idx < 0)];
    }
    catch (ex) {
      throw DialogManager.ERROR(DIALOG_MANAGER.ERR_INVALID_POSITION, [scene_idx, 0, 0]);
    }
  }



  /**
   * @desc Retrieves a sequence given an index. Negative indices will iterate backwards. Throws DIALOG_MANAGER.ERR_INVALID_POSITION if out of bounds.
   * @param {Real} [sequence_idx] The index of the sequence to get.
   * @param {Real} [scene_idx] The index of the scene to get the sequence from.
   * @returns {Struct.DialogSequence}
   */

  static sequence = function(sequence_idx = undefined, scene_idx = undefined)
  {
    if (scene_idx == undefined && sequence_idx != undefined)
      return __get_sequence_relative(sequence_idx, 0);

    if (scene_idx != undefined && sequence_idx == undefined)
      sequence_idx = 0;

    sequence_idx ??= __decode_sequence_idx(self.position);

    var scene = self.scene(scene_idx ?? __decode_scene_idx(self.position));

    try {
      return scene.sequence(sequence_idx);
    }
    catch (ex) {
      throw DialogManager.ERROR(DIALOG_MANAGER.ERR_INVALID_POSITION, [scene_idx, sequence_idx, 0]);
    }
  }



  /**
   * @desc Retrieves a dialog given an index. Negative indices will iterate backwards. Throws DIALOG_MANAGER.ERR_INVALID_POSITION if out of bounds.
   * @param {Real} [dialog_idx] The index of the dialog to get.
   * @param {Real} [sequence_idx] The index of the sequence to get the dialog from.
   * @param {Real} [scene_idx] The index of the scene to get the sequence from.
   * @returns {Struct.Dialog}
   */

  static dialog = function(dialog_idx = undefined, sequence_idx = undefined, scene_idx = undefined)
  {
    var u = (scene_idx == undefined) + (sequence_idx == undefined) + (dialog_idx == undefined);

    if (u == 2 && dialog_idx != undefined)
      return __get_dialog_relative(dialog_idx, 0);

    if (u && u < 3)
    {
      scene_idx ??= 0;
      sequence_idx ??= 0;
      dialog_idx ??= 0;
    }

    scene_idx ??= __decode_scene_idx(self.position);
    sequence_idx ??= __decode_sequence_idx(self.position);
    dialog_idx ??= __decode_dialog_idx(self.position);

    try {
      return self.sequence(sequence_idx, scene_idx).dialog(dialog_idx);
    }
    catch (ex) {
      throw DialogManager.ERROR(DIALOG_MANAGER.ERR_INVALID_POSITION, [scene_idx, sequence_idx, dialog_idx]);
    }
  }



  /**
   * @desc Retrieves a scene given a relative index. Negative indices will iterate backwards.
   * @param {Real} [scene_shift] The relative index shift of the scene. Defaults to `0`.
   * @param {Real|Struct.DialogLinkable} [start_position] The starting position of the iteration. Defaults to the current one.
   * @returns {Struct.DialogScene}
   */

  static deltascene = function(scene_shift = 0, start_position = self.position)
  {
    return __get_scene_relative(scene_shift, __resolve_position(start_position));
  }



  /**
   * @desc Retrieves a sequence given a relative index. Negative indices will iterate backwards.
   * @param {Real} [sequence_shift] The relative index shift of the sequence. Defaults to `0`.
   * @param {Real|Struct.DialogLinkable} [start_position] The starting position of the iteration. Defaults to the current one.
   * @returns {Struct.DialogSequence}
   */

  static deltasequence = function(sequence_shift = 0, start_position = self.position)
  {
    return __get_sequence_relative(sequence_shift, __resolve_position(start_position));
  }



  /**
   * @desc Retrieves a dialog given a relative index. Negative indices will iterate backwards.
   * @param {Real} [dialog_shift] The relative index shift of the dialog. Defaults to `0`.
   * @param {Real|Struct.DialogLinkable} [start_position] The starting position of the iteration. Defaults to the current one.
   * @returns {Struct.Dialog}
   */

  static deltadialog = function(dialog_shift = 0, start_position = self.position)
  {
    return __get_dialog_relative(dialog_shift, __resolve_position(start_position));
  }



  /**
   * @desc Resolves a position given a shift and unit.
   * @param {Real} [shift] The shift to apply.
   * @param {Constant.DIALOG_MANAGER|Real} [unit] The unit of the shift.
   * @param {Real|Struct.DialogLinkable} [start_position] The starting position of the iteration. Defaults to the current one.
   * @returns {Struct.DialogLinkable}
   */

  static delta = function(shift = 0, unit = DIALOG_MANAGER.JUMP_UNIT_DIALOG, start_position = self.position)
  {
    return __resolve_position_relative(shift, __encode_jump_option_unit(unit), __resolve_position(start_position));
  }



  /**
   * @desc Inserts scenes in the scene list at a given index. Throws DIALOG_MANAGER.ERR_EMPTY_CONTAINER_OBJECT if any scene is empty. [CHAINABLE]
   * @param {Struct.DialogScene|Array<Struct.DialogScene>} scenes The new scenes to add.
   * @param {Real} [index] The index where to add the new scenes. Defaults to last index.
   * @returns {Struct.DialogManager}
   */

  static add = function(scenes, index = self.scene_count)
  {
    if (!is_array(scenes))
      scenes = [scenes];

    var scene_count = array_length(scenes);

    for (var i = index; i < self.scene_count; ++i)
      self.scenes[i].scene_idx += scene_count;

    for (var i = 0; i < scene_count; ++i)
    {
      var scene = scenes[i];

      if (!scene.sequence_count) {
        throw DialogManager.ERROR(DIALOG_MANAGER.ERR_EMPTY_CONTAINER_OBJECT, [nameof(DialogScene)]);
      }

      scene.manager = self;
      scene.scene_idx = index + i;
      array_insert(self.scenes, index + i, scene);
    }

    self.scene_count += scene_count;

    return self.advance(0, DIALOG_MANAGER.FLAG_STATUS_UNINITIALIZED);
  }



  /**
   * @desc Makes the dialog manager advance of a specified shift. Produces side effects on dialog manager position and/or status. [CHAINABLE]
   * @param {Real} [shift] The number of units to advance of. Defaults to `1`.
   * @param {Constant.DIALOG_MANAGER|Real} [jump_options] The settings mask for the jump.
   * @param {Any|Array<Any>} [argv] The argument(s) to pass to eventual dialog effects.
   * @param {Constant.DIALOG_MANAGER|Real|Struct.DialogLinkable} [prev_position] The starting position of the advancement. Defaults to the current one.
   * @returns {Struct.DialogManager}
   */

  static advance = function(shift = 1, jump_options = 0, argv = undefined, prev_position = self.position)
  {
    self.status &= ~(
      shift != 0
        ? DIALOG_MANAGER.__BITMASK_STATUS_MASK
        : DIALOG_MANAGER.__BITMASK_STATUS_AUTORESET_MASK
    );

    if (
      shift == 0 && !(jump_options & DIALOG_MANAGER.FLAG_STATUS_UNINITIALIZED)
      || !self.scene_count
    )
      return self;

    if (jump_options & DIALOG_MANAGER.MASK_JUMP_CHOICE)
      shift = 0;

    var shift_sign = sign(shift)
      , current_scene_idx = __decode_scene_idx(prev_position)
      , current_sequence_idx = __decode_sequence_idx(prev_position)
      , target_position = __next(
          __resolve_position(shift, jump_options | DIALOG_MANAGER.MASK_JUMP_TYPE_RELATIVE, prev_position),
          jump_options | DIALOG_MANAGER.MASK_JUMP_TYPE_RELATIVE,
          prev_position,
          argv
        ).position()
    ;

    self.position = target_position;
    self.status |= __status(
      target_position,
      shift_sign * (current_scene_idx != __decode_scene_idx(target_position)),
      shift_sign * (current_sequence_idx != __decode_sequence_idx(target_position)),
      shift
    );

    return self;
  }



  /**
   * @desc Simulates advancing the dialog manager without state modifications. Temporarily modifies position and status to compute the result to then reset them to their previous values.
   * @param {Real} [shift] The number of units to advance of. Defaults to `1`.
   * @param {Constant.DIALOG_MANAGER|Real} [jump_options] The settings mask for the jump.
   * @param {Any|Array<Any>} [argv] The argument(s) to pass to eventual dialog effects.
   * @param {Constant.DIALOG_MANAGER|Real|Struct.DialogLinkable} [start_position] The starting position of the forecast. Defaults to the current one.
   * @returns {Struct} { dialog: Struct.Dialog, status: Real }
   */

  static forecast = function(shift = 1, jump_options = 0, argv = undefined, start_position = self.position)
  {
    var prev_position = self.position
      , prev_status = self.status
    ;

    self.advance(shift, jump_options, argv, start_position);

    var result = {
      dialog: __get_dialog_from_position(self.position),
      status: self.status,
    };

    self.position = prev_position;
    self.status = prev_status;

    return result;
  }



  /**
   * @desc Converts all the dialog manager data to a JSON string. Throws DIALOG_MANAGER.ERR_SERIALIZATION_FAILED if serialization fails.
   * @param {Bool} [prettify] Specifies whether the output should be prettified (`true`) or not (`false`). Defaults to `false`.
   * @returns {String}
   */

  static serialize = function(prettify = false)
  {
    try {
      return json_stringify(
        array_map(self.scenes, function(scene) {
          return scene.__DIALOG_MANAGER_SERIALIZING_METHOD__();
        }),
        prettify
      );
    }
    catch (ex) {
      throw DialogManager.ERROR(DIALOG_MANAGER.ERR_SERIALIZATION_FAILED, [nameof(DialogLinkable)]);
    }
  }



  /**
   * @desc Parses a string loading all the data in the dialog manager. Throws DIALOG_MANAGER.ERR_DESERIALIZATION_FAILED if deserialization fails. [CHAINABLE]
   * @param {String|Id.TextFile} [data_string] The data string to parse.
   * @param {Bool} [is_file] Specifies whether the data string is a file name to read from (`true`) or not (`false`). Defaults to `false`.
   * @returns {Struct.DialogManager}
   */

  static deserialize = function(data_string = "", is_file = false)
  {
    if (is_file)
    {
      var file = data_string
        , filename = data_string
        , autoclose = !is_numeric(file)
      ;

      try {
        if (autoclose)
          file = file_text_open_read(filename);

        for (data_string = ""; !file_text_eof(file); file_text_readln(file))
          data_string += file_text_read_string(file);

        if (autoclose)
          file_text_close(file);
      }
      catch (ex) {
        throw DialogManager.ERROR(DIALOG_MANAGER.ERR_DESERIALIZATION_FAILED, [filename]);
      }
    }

    if (data_string == "")
      return self;

    return self.parse(json_parse(data_string)).advance(0, DIALOG_MANAGER.FLAG_STATUS_UNINITIALIZED);
  }



  /**
   * @desc Converts an array of raw data into an array of `DialogScene` objects. Throws DIALOG_MANAGER.ERR_PARSING_FAILED if parsing fails. [CHAINABLE]
   * @param {Array<Struct>} scenes The parsed scenes to convert and add.
   * @returns {Struct.DialogManager}
   */

  static parse = function(scenes)
  {
    try {
      self.scenes = array_map(scenes, function(scene) {
        return DialogScene.__DIALOG_MANAGER_DESERIALIZING_METHOD__(scene);
      });
    }
    catch (ex) {
      throw DialogManager.ERROR(DIALOG_MANAGER.ERR_PARSING_FAILED);
    }

    return __update_scenes();
  }



  /**
   * @desc Updates the scene indices. [CHAINABLE]
   * @returns {Struct.DialogManager}
   */

  static __update_scenes = function()
  {
    self.scene_count = array_length(self.scenes);

    for (var i = 0; i < self.scene_count; ++i) {
      var scene = self.scenes[i];
      scene.manager = self;
      scene.scene_idx = i;
    }

    return self;
  }



  /**
   * @desc Returns a scene given its relative index from a position.
   * @param {Real} [scene_shift] The relative index shift of the scene. Defaults to `0`. Negative indices will iterate backwards.
   * @param {Real} [start_position] The position where to start the iteration. Defaults to current position.
   * @returns {Struct.DialogScene}
   */

  static __get_scene_relative = function(scene_shift = 0, start_position = self.position)
  {
    return self.scene((__decode_scene_idx(start_position) + scene_shift) % self.scene_count);
  }



  /**
   * @desc Returns a sequence given its relative index from a position.
   * @param {Real} [sequence_shift] The relative index shift of the sequence. Defaults to `0`. Negative indices will iterate backwards.
   * @param {Real} [start_position] The position where to start the iteration. Defaults to current position.
   * @returns {Struct.DialogSequence}
   */

  static __get_sequence_relative = function(sequence_shift = 0, start_position = self.position)
  {
    var next_scene_idx = __decode_scene_idx(start_position)
      , next_scene = self.scene(next_scene_idx)
      , next_sequence_idx = __decode_sequence_idx(start_position)
      , shift_sign = sign(sequence_shift)
      , _in_range = function(val, min, max) {
        return val >= min && val < max;
      }
    ;

    if (_in_range(next_sequence_idx + sequence_shift, 0, next_scene.sequence_count))
      return self.sequence(next_sequence_idx + sequence_shift, next_scene_idx);

    var sequence_diff = shift_sign ? next_sequence_idx + 1 : next_scene.sequence_count - next_sequence_idx;
    next_sequence_idx = shift_sign ? -1 : next_scene.sequence_count;
    sequence_shift += sequence_diff * shift_sign;

    while (!_in_range(next_sequence_idx + sequence_shift, 0, next_scene.sequence_count))
    {
      sequence_shift -= next_scene.sequence_count * shift_sign;
      next_scene_idx = __index_wrap(next_scene_idx + shift_sign, 0, self.scene_count);
      next_scene = self.scene(next_scene_idx);
      next_sequence_idx = shift_sign ? -1 : next_scene.sequence_count;
    }

    return self.sequence(next_sequence_idx + sequence_shift, next_scene_idx);
  }



  /**
   * @desc Returns a dialog given its relative index from a position.
   * @param {Real} [dialog_shift] The relative index shift of the dialog. Defaults to `0`. Negative indices will iterate backwards.
   * @param {Real} [start_position] The position where to start the iteration. Defaults to current position.
   * @returns {Struct.Dialog}
   */

  static __get_dialog_relative = function(dialog_shift = 0, start_position = self.position)
  {
    var next_scene_idx = __decode_scene_idx(start_position)
      , next_scene = self.scene(next_scene_idx)
      , next_sequence_idx = __decode_sequence_idx(start_position)
      , next_sequence = self.sequence(next_sequence_idx, next_scene_idx)
      , next_dialog_idx = __decode_dialog_idx(start_position)
      , shift_sign = sign(dialog_shift)
      , _in_range = function(val, low, high) {
        return val >= low && val < high;
      }
    ;

    if (_in_range(next_dialog_idx + dialog_shift, 0, next_sequence.dialog_count))
      return self.dialog(next_dialog_idx + dialog_shift, next_sequence_idx, next_scene_idx);

    var dialog_diff = shift_sign ? next_dialog_idx + 1 : next_sequence.dialog_count - next_dialog_idx;
    next_dialog_idx = shift_sign ? -1 : next_sequence.dialog_count;
    dialog_shift += dialog_diff * shift_sign;

    while (!_in_range(next_dialog_idx + dialog_shift, 0, next_sequence.dialog_count))
    {
      dialog_shift -= next_sequence.dialog_count * shift_sign;
      next_sequence_idx += shift_sign;

      if (!_in_range(next_sequence_idx, 0, next_scene.sequence_count)) {
        next_scene_idx = __index_wrap(next_scene_idx + shift_sign, 0, self.scene_count);
        next_scene = self.scene(next_scene_idx);
        next_sequence_idx = shift_sign ? 0 : next_scene.sequence_count - 1;
      }

      next_sequence = self.sequence(next_sequence_idx, next_scene_idx);
      next_dialog_idx = shift_sign ? -1 : next_sequence.dialog_count;
    }

    return self.dialog(next_dialog_idx + dialog_shift, next_sequence_idx, next_scene_idx);
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
      if (self.scenes[i].tag() == tag)
        array_push(scenes, self.scenes[i]);

    return scenes;
  }



  /**
   * @desc Returns a dialog given an encoded position.
   * @param {Real} [position] The encoded position. Defaults to current position.
   * @returns {Struct.Dialog}
   */

  static __get_dialog_from_position = function(position = self.position)
  {
    return self.dialog(__decode_dialog_idx(position), __decode_sequence_idx(position), __decode_scene_idx(position));
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
   * @desc Encodes jump options into a position.
   * @param {Constant.DIALOG_MANAGER} jump_type The jump type to encode.
   * @param {Constant.DIALOG_MANAGER} jump_unit The jump unit to encode.
   * @returns {Real}
   */

  static __encode_jump_options = function(jump_type, jump_unit)
  {
    return __encode_jump_option_type(jump_type) | __encode_jump_option_unit(jump_unit);
  }



  /**
   * @desc Encodes a jump type into a position.
   * @param {Constant.DIALOG_MANAGER} jump_type The jump type to encode.
   * @returns {Real}
   */

  static __encode_jump_option_type = function(jump_type)
  {
    return jump_type << DIALOG_MANAGER.__BITMASK_JUMP_TYPE_SHIFT & DIALOG_MANAGER.__BITMASK_JUMP_TYPE_MASK;
  }



  /**
   * @desc Encodes a jump unit into a position.
   * @param {Constant.DIALOG_MANAGER} jump_unit The jump unit to encode.
   * @returns {Real}
   */

  static __encode_jump_option_unit = function(jump_unit)
  {
    return jump_unit << DIALOG_MANAGER.__BITMASK_JUMP_UNIT_SHIFT & DIALOG_MANAGER.__BITMASK_JUMP_UNIT_MASK;
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
   * @desc Returns the jump unit given a jump settings bitfield.
   * @param {Real} [jump_options] The jump options decode from.
   * @returns {Constant.DIALOG_MANAGER|Real}
   */

  static __decode_jump_option_type = function(jump_options)
  {
    return (jump_options & DIALOG_MANAGER.__BITMASK_JUMP_TYPE_MASK) >> DIALOG_MANAGER.__BITMASK_JUMP_TYPE_SHIFT;
  }



  /**
   * @desc Returns the jump unit given a jump setting bitfield.
   * @param {Real} [jump_options] The jump options to decode from.
   * @returns {Constant.DIALOG_MANAGER|Real}
   */

  static __decode_jump_option_unit = function(jump_options)
  {
    return (jump_options & DIALOG_MANAGER.__BITMASK_JUMP_UNIT_MASK) >> DIALOG_MANAGER.__BITMASK_JUMP_UNIT_SHIFT;
  }



  /**
   * @desc Wraps an index in the given range.
   * @param {Real} idx The index to wrap.
   * @param {Real} idx_min The lower bound of the wrap range.
   * @param {Real} idx_max The upper bound of the wrap range.
   * @returns {Real}
   */

  static __index_wrap = function(idx, idx_min, idx_max)
  {
    var diff = idx_max - idx_min;
    return ((idx - idx_min) % diff + diff) % diff + idx_min;
  }



  /**
   * @desc Performs a jump to a certain dialog given its position as argument.
   * @param {Real} [position] The position where to jump. Default to current position.
   * @param {Real} [jump_options] The jump info.
   * @param {Real|Constant.DIALOG_MANAGER|Struct.DialogLinkable} [prev_position] The last stacked absolute position. Defaults to current position.
   * @param {Array} [argv] The arguments to pass to eventual fallback effects.
   * @returns {Struct.Dialog}
   */

  static __next = function(position = self.position, jump_options = 0, prev_position = self.position, argv = undefined)
  {
    self.jumps = -1;

    var dialog = __get_dialog_from_position(__resolve_position(prev_position))
      , choice = dialog.choice()
    ;

    if (choice && jump_options & DIALOG_MANAGER.MASK_JUMP_CHOICE)
      position = choice.__exec([choice.argv, is_array(argv) ? argv[0] : argv], dialog);

    return __jump(position, argv, 0, prev_position);
  }



  /**
   * @desc Resolves all effects and moves the dialog manager on the specified target position. Throws DIALOG_MANAGER.ERR_INFINITE_LOOP_DETECTED if an infinite loop is detected.
   * @param {Real|Constant.DIALOG_MANAGER|Struct.DialogLinkable} [next_position] The position to jump to. Defaults to current position.
   * @param {Array} [argv] The arguments to pass to eventual fallback effects.
   * @param {Constant.DIALOG_MANAGER|Real} [jump_options] The options of jump to perform.
   * @param {Real|Constant.DIALOG_MANAGER|Struct.DialogLinkable} [prev_position] The last stacked absolute position. Defaults to current position.
   * @returns {Struct.Dialog}
   */

  static __jump = function(next_position = self.position, argv = undefined, jump_options = 0, prev_position = self.position)
  {
    prev_position = __resolve_position(prev_position);
    next_position = __resolve_position(next_position, jump_options, prev_position);

    var current_dialog = __get_dialog_from_position(prev_position)
      , target_dialog = __get_dialog_from_position(next_position)
    ;

    if (++self.jumps > DIALOG_MANAGER.ERR_CHECK_INFINITE_LOOP_TRESHOLD)
      throw DialogManager.ERROR(DIALOG_MANAGER.ERR_INFINITE_LOOP_DETECTED, [self.jumps, current_dialog.__struct()]);

    current_dialog.__fx_execute_all_of(function(fx) {
      return fx.trigger() == DIALOG_FX.TRIGGER_ON_LEAVE;
    });

    if (!target_dialog.choice())
    {
      var fx = target_dialog.jump() ?? target_dialog.fallback(argv);

      if (fx && prev_position == next_position)
        throw DialogManager.ERROR(DIALOG_MANAGER.ERR_INFINITE_LOOP_DETECTED, [self.jumps, target_dialog.__struct()]);
      else if (fx)
        return __jump(fx.__exec(undefined, target_dialog), argv, 0, next_position);
    }

    target_dialog.__fx_execute_all_of(function(fx) {
      return fx.trigger() == DIALOG_FX.TRIGGER_ON_ENTER;
    });

    return target_dialog;
  }



  /**
   * Evaluates a given position to determine the destination of a jump. Throws DIALOG_MANAGER.ERR_INVALID_POSITION if the resolved position is out of bounds.
   * @param {Real|Constant.DIALOG_MANAGER|Struct.DialogLinkable} [position] The position to resolve. Defaults to current position.
   * @param {Constant.DIALOG_MANAGER|Real} [jump_options] The options of the jump to perform.
   * @param {Real|Constant.DIALOG_MANAGER|Struct.DialogLinkable} [prev_position] The last stacked absolute position. Defaults to current position.
   * @returns {Real}
   */

  static __resolve_position = function(position = self.position, jump_options = 0, prev_position = self.position)
  {
    if (is_instanceof(prev_position, DialogLinkable))
      prev_position = prev_position.position();

    if (__decode_jump_option_type(jump_options) == DIALOG_MANAGER.JUMP_TYPE_RELATIVE)
      position = __resolve_position_relative(position, jump_options, prev_position);

    if (is_instanceof(position, DialogLinkable))
      return position.position();

    var sequence_idx = __decode_sequence_idx(prev_position)
      , scene_idx = __decode_scene_idx(prev_position)
      , sequence = self.sequence(sequence_idx, scene_idx)
      , scene = self.scene(scene_idx)
    ;

    switch (position)
    {
      case DIALOG_MANAGER.POSITION_CODE_SCENE_FIRST:
      case DIALOG_MANAGER.POSITION_CODE_SEQUENCE_FIRST:
        return __encode_position(0, 0, 0);
      case DIALOG_MANAGER.POSITION_CODE_SCENE_LAST:
        return __encode_position(self.scene_count - 1, 0, 0);
      case DIALOG_MANAGER.POSITION_CODE_SCENE_NEXT:
        return __encode_position((scene_idx + 1) % self.scene_count, 0, 0);
      case DIALOG_MANAGER.POSITION_CODE_SCENE_END:
        return __encode_position(scene_idx, scene.sequence_count - 1, 0);
      case DIALOG_MANAGER.POSITION_CODE_SCENE_MIDDLE:
        return __encode_position(scene_idx, scene.sequence_count >> 1, 0);
      case DIALOG_MANAGER.POSITION_CODE_SCENE_START:
        return __encode_position(scene_idx, 0, 0);
      case DIALOG_MANAGER.POSITION_CODE_SCENE_PREVIOUS:
        return __encode_position((scene_idx + self.scene_count - 1) % self.scene_count, 0, 0);
      case DIALOG_MANAGER.POSITION_CODE_SEQUENCE_LAST:
        return __encode_position(self.scene_count - 1, self.scenes[self.scene_count - 1].sequence_count - 1, 0);
      case DIALOG_MANAGER.POSITION_CODE_SEQUENCE_NEXT:
        return __get_sequence_relative(1, prev_position).position();
      case DIALOG_MANAGER.POSITION_CODE_SEQUENCE_END:
        return __encode_position(scene_idx, sequence_idx, sequence.dialog_count - 1);
      case DIALOG_MANAGER.POSITION_CODE_SEQUENCE_MIDDLE:
        return __encode_position(scene_idx, sequence_idx, sequence.dialog_count >> 1);
      case DIALOG_MANAGER.POSITION_CODE_SEQUENCE_START:
        return __encode_position(scene_idx, sequence_idx, 0);
      case DIALOG_MANAGER.POSITION_CODE_SEQUENCE_PREVIOUS:
        return __get_sequence_relative(-1, prev_position).position();
    }

    var dialog_idx = __decode_dialog_idx(position);

    sequence_idx = __decode_sequence_idx(position);
    scene_idx = __decode_scene_idx(position);

    if (
      scene_idx >= self.scene_count
      || sequence_idx >= self.scene(scene_idx).sequence_count
      || dialog_idx >= self.sequence(sequence_idx, scene_idx).dialog_count
    ) {
      throw DialogManager.ERROR(DIALOG_MANAGER.ERR_INVALID_POSITION, [
        scene_idx, sequence_idx, dialog_idx
      ]);
    }

    return position ?? 0;
  }



  /**
   * @desc Evaluates a given position to determine the destination of a relative jump.
   * @param {Real|Constant.DIALOG_MANAGER|Struct.DialogLinkable} [position] The position to resolve. Defaults to current position.
   * @param {Constant.DIALOG_MANAGER|Real} [jump_options] The options of the jump to perform.
   * @param {Real|Constant.DIALOG_MANAGER|Struct.DialogLinkable} [prev_position] The last stacked absolute position. Defaults to current position.
   * @returns {Struct.DialogLinkable}
   */

  static __resolve_position_relative = function(position = self.position, jump_options = 0, prev_position = self.position)
  {
    if (is_instanceof(prev_position, DialogLinkable))
      prev_position = prev_position.position();

    switch (__decode_jump_option_unit(jump_options))
    {
      case DIALOG_MANAGER.JUMP_UNIT_SCENE:
        return __get_scene_relative(position, prev_position);
      case DIALOG_MANAGER.JUMP_UNIT_SEQUENCE:
        return __get_sequence_relative(position, prev_position);
      case DIALOG_MANAGER.JUMP_UNIT_DIALOG:
        return __get_dialog_relative(position, prev_position);
    }

    return position;
  }



  /*
   * @desc Updates the dialog manager's status.
   * @param {Real} [target_position] The position to check.
   * @param {Real} [scene_diff] The signed amount of scenes traveled from the previous position.
   * @param {Real} [sequence_diff] The signed amount of sequences traveled from the previous position.
   * @param {Real} [dialog_diff] The signed amount of dialogs traveled from the previous position.
   * @returns {Real}
   */

  static __status = function(target_position = self.position, scene_diff = 0, sequence_diff = 0, dialog_diff = 0)
  {
    var target_scene_idx = __decode_scene_idx(target_position)
      , target_sequence_idx = __decode_sequence_idx(target_position)
      , target_dialog_idx = __decode_dialog_idx(target_position)
      , target_sequence_count = self.scene(target_scene_idx).sequence_count
      , target_dialog_count = self.sequence(target_sequence_idx).dialog_count
      , is_last_scene = target_scene_idx == self.scene_count - 1
      , is_last_of_scene = target_sequence_idx == target_sequence_count - 1
      , is_last_of_sequence = target_dialog_idx == target_dialog_count - 1
      , is_last_sequence = is_last_scene && is_last_of_scene
    ;

    return DIALOG_MANAGER.FLAG_STATUS_FIRST_DIALOG    * (target_position == 0                                        )
      | DIALOG_MANAGER.FLAG_STATUS_FIRST_SEQUENCE     * (target_position < 1 << DIALOG.__BITMASK_POSITION_DIALOG_BITS)
      | DIALOG_MANAGER.FLAG_STATUS_FIRST_SCENE        * (target_scene_idx == 0                                       )
      | DIALOG_MANAGER.FLAG_STATUS_FIRST_OF_SEQUENCE  * (target_dialog_idx == 0                                      )
      | DIALOG_MANAGER.FLAG_STATUS_FIRST_OF_SCENE     * (target_sequence_idx == 0                                    )
      | DIALOG_MANAGER.FLAG_STATUS_MIDDLE_OF_SEQUENCE * (target_dialog_idx == target_dialog_count >> 1               )
      | DIALOG_MANAGER.FLAG_STATUS_MIDDLE_OF_SCENE    * (target_sequence_idx == target_sequence_count >> 1           )
      | DIALOG_MANAGER.FLAG_STATUS_MIDDLE_SCENE       * (target_scene_idx == self.scene_count >> 1                   )
      | DIALOG_MANAGER.FLAG_STATUS_LAST_DIALOG        * (is_last_sequence && is_last_of_sequence                     )
      | DIALOG_MANAGER.FLAG_STATUS_LAST_SEQUENCE      * (is_last_sequence                                            )
      | DIALOG_MANAGER.FLAG_STATUS_LAST_SCENE         * (is_last_scene                                               )
      | DIALOG_MANAGER.FLAG_STATUS_LAST_OF_SEQUENCE   * (is_last_of_sequence                                         )
      | DIALOG_MANAGER.FLAG_STATUS_LAST_OF_SCENE      * (is_last_of_scene                                            )
      | DIALOG_MANAGER.FLAG_STATUS_ADVANCED_DIALOG    * (dialog_diff > 0                                             )
      | DIALOG_MANAGER.FLAG_STATUS_ADVANCED_SEQUENCE  * (sequence_diff > 0                                           )
      | DIALOG_MANAGER.FLAG_STATUS_ADVANCED_SCENE     * (scene_diff > 0                                              )
      | DIALOG_MANAGER.FLAG_STATUS_RECEDED_DIALOG     * (dialog_diff < 0                                             )
      | DIALOG_MANAGER.FLAG_STATUS_RECEDED_SEQUENCE   * (sequence_diff < 0                                           )
      | DIALOG_MANAGER.FLAG_STATUS_RECEDED_SCENE      * (scene_diff < 0                                              )
    ;
  }



  /**
   * @desc Resets the state of the manager. [CHAINABLE]
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
    self.jumps = -1;

    return self;
  }



  self.deserialize(data_string, is_file).advance(0, DIALOG_MANAGER.FLAG_STATUS_UNINITIALIZED);
}












// ----------------------------------------------------------------------------












/**
 * @desc `DialogLinkable` constructor. Used to generalize dialog components' types.
 * @returns {Struct.DialogLinkable}
 */

function DialogLinkable(settings_mask) constructor
{
  static CONSTRUCTOR_ARGC = argument_count;

  self.settings_mask = settings_mask;
}












// ----------------------------------------------------------------------------












/**
 * `DialogScene` constructor.
 * @param {Array<Struct.DialogSequence>} sequences The array of `DialogSequence` of the scene.
 * @param {Constant.DIALOG_SCENE|Real} settings_mask The scene settings.
 * @returns {Struct.DialogScene}
 */

function DialogScene(sequences, settings_mask) : DialogLinkable(settings_mask) constructor
{
  static CONSTRUCTOR_ARGC = argument_count;
  static scene_id = 0;

  self.manager = undefined;
  self.scene_idx = 0;
  self.scene_id = scene_id++;
  self.sequences = [];
  self.sequence_count = 0;



  /**
   * @desc Overrides this scene's unique ID with a custom one. [CHAINABLE]
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
   * @desc Returns the current/encoded scene index.
   * @param {Real} [scene_idx] The scene index to encode.
   * @returns {Real}
   */

  static index = function(scene_idx = undefined)
  {
    return scene_idx != undefined
      ? DialogManager.__encode_scene_idx(scene_idx)
      : self.scene_idx
    ;
  }



  /**
   * @desc Returns the number of scenes in the selected scene's pool.
   * @returns {Real}
   */

  static poolcount = function()
  {
    return self.manager.scene_count;
  }



  /**
   * @desc Returns whether the scene idx is the last of the containing manager's.
   * @returns {Bool}
   */

  static islast = function()
  {
    return self.scene_idx == self.manager.scene_count - 1;
  }



  /**
   * @desc Retrieves the scene's global position.
   * @returns {Real}
   */

  static position = function()
  {
    return DialogManager.__encode_position(self.scene_idx, 0, 0);
  }



  /**
   * @desc Encodes/decodes the scene bg as a bitmask fragment.
   * @param {Constant.DIALOG_SCENE|Real} [bg_mask] The bg identifier.
   * @returns {Real}
   */

  static bg = function(bg_mask = undefined)
  {
    return bg_mask == undefined
      ? (self.settings_mask & DIALOG_SCENE.__BITMASK_BG_MASK) >> DIALOG_SCENE.__BITMASK_BG_SHIFT
      : bg_mask << DIALOG_SCENE.__BITMASK_BG_SHIFT & DIALOG_SCENE.__BITMASK_BG_MASK
    ;
  }



  /**
   * @desc Encodes/decodes the scene bgm as a bitmask fragment.
   * @param {Constant.DIALOG_SCENE|Real} [bgm_mask] The bgm identifier.
   * @returns {Real}
   */

  static bgm = function(bgm_mask = undefined)
  {
    return bgm_mask == undefined
      ? (self.settings_mask & DIALOG_SCENE.__BITMASK_BGM_MASK) >> DIALOG_SCENE.__BITMASK_BGM_SHIFT
      : bgm_mask << DIALOG_SCENE.__BITMASK_BGM_SHIFT & DIALOG_SCENE.__BITMASK_BGM_MASK
    ;
  }



  /**
   * @desc Encodes/decodes the scene bgs as a bitmask fragment.
   * @param {Constant.DIALOG_SCENE|Real} [bgs_mask] The bgs identifier.
   * @returns {Real}
   */

  static bgs = function(bgs_mask = undefined)
  {
    return bgs_mask == undefined
      ? (self.settings_mask & DIALOG_SCENE.__BITMASK_BGS_MASK) >> DIALOG_SCENE.__BITMASK_BGS_SHIFT
      : bgs_mask << DIALOG_SCENE.__BITMASK_BGS_SHIFT & DIALOG_SCENE.__BITMASK_BGS_MASK
    ;
  }



  /**
   * @desc Encodes/decodes the scene tag as a bitmask fragment.
   * @param {Constant.DIALOG_SCENE|Real} [tag_mask] The tag identifier.
   * @returns {Real}
   */

  static tag = function(tag_mask = undefined)
  {
    return tag_mask == undefined
      ? (self.settings_mask & DIALOG_SCENE.__BITMASK_TAG_MASK) >> DIALOG_SCENE.__BITMASK_TAG_SHIFT
      : tag_mask << DIALOG_SCENE.__BITMASK_TAG_SHIFT & DIALOG_SCENE.__BITMASK_TAG_MASK
    ;
  }



  /**
   * @desc Retrieves a sequence given an index. Negative indices will iterate backwards.
   * @param {Real} [sequence_idx] The index of the sequence to get.
   * @returns {Struct.DialogSequence}
   */

  static sequence = function(sequence_idx)
  {
    return self.sequences[sequence_idx + self.sequence_count * (sequence_idx < 0)];
  }



  /**
   * @desc Inserts sequences in the scene list at a given index. Throws DIALOG_MANAGER.ERR_EMPTY_CONTAINER_OBJECT if any of the sequences is empty. [CHAINABLE]
   * @param {Struct.DialogSequence|Array<Struct.DialogSequence>} sequences The new sequences to add.
   * @param {Real} [index] The index where to add the new sequences. Defaults to last index.
   * @returns {Struct.DialogScene}
   */

  static add = function(sequences, index = self.sequence_count)
  {
    if (!is_array(sequences))
      sequences = [sequences];

    var sequence_count = array_length(sequences);

    for (var i = index; i < self.sequence_count; ++i)
      self.sequences[i].sequence_idx += sequence_count;

    for (var i = 0; i < sequence_count; ++i)
    {
      var sequence = sequences[i];

      if (!sequence.dialog_count) {
        throw DialogManager.ERROR(DIALOG_MANAGER.ERR_EMPTY_CONTAINER_OBJECT, [nameof(DialogSequence)]);
      }

      sequence.scene = self;
      sequence.sequence_idx = index + i;
      array_insert(self.sequences, index + i, sequence);
    }

    self.sequence_count += sequence_count;

    return self;
  }



  /**
   * @desc Renumbers every sequence to match its array position and refreshes the back-link to this scene. [CHAINABLE]
   * @returns {Struct.DialogScene}
   */

  static __update_sequences = function()
  {
    self.sequence_count = array_length(self.sequences);

    for (var i = 0; i < self.sequence_count; ++i) {
      var sequence = self.sequences[i];
      sequence.sequence_idx = i;
      sequence.scene = self;
    }

    return self;
  }



  /**
   * @desc Retrieves the assigned manager object.
   * @returns {Struct.DialogManager}
   */

  static __get_manager = function()
  {
    return self.manager;
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
      if (self.sequences[i].tag() == tag)
        array_push(sequences, self.sequences[i]);

    return sequences;
  }



  /**
   * @desc Serialises the scene into a compact array.
   * @returns {Array<Any>}
   */

  static __array = function()
  {
    return [
      int64(self.scene_id),
      array_map(self.sequences, function(sequence) {
        return sequence.__DIALOG_MANAGER_SERIALIZING_METHOD__();
      }),
      int64(self.settings_mask),
    ];
  }



  /**
   * @desc Serialises the scene into a plain struct.
   * @returns {Struct}
   */

  static __struct = function()
  {
    return {
      scene_id: int64(self.scene_id),
      sequences: array_map(self.sequences, function(sequence) {
        return sequence.__DIALOG_MANAGER_SERIALIZING_METHOD__();
      }),
      settings_mask: int64(self.settings_mask),
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
        return DialogSequence.__DIALOG_MANAGER_DESERIALIZING_METHOD__(sequence);
      }),
      data[2]
    )
    .__override_id(data[0]);
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
        return DialogSequence.__DIALOG_MANAGER_DESERIALIZING_METHOD__(sequence);
      }),
      data.settings_mask
    )
    .__override_id(data.scene_id);
  }



  /**
   * @desc Serialises the scene to JSON.
   * @param {Bool} [prettify] Whether the string should have line breaks/indentation (`true`) or not (`false`).
   * @returns {String}
   */

  static __serialize = function(prettify = false)
  {
    return json_stringify(__DIALOG_MANAGER_SERIALIZING_METHOD__(), prettify);
  }



  /**
   * @desc Deserialises a JSON string produced by {@link __serialize}.
   * @param {String} data_string The JSON payload.
   * @returns {Struct.DialogScene}
   */

  static __deserialize = function(data_string)
  {
    var data = json_parse(data_string);
    return __DIALOG_MANAGER_DESERIALIZING_METHOD__(data).__update_sequences();
  }



  add(sequences);
}












// ----------------------------------------------------------------------------












/**
 * `DialogSequence` constructor.
 * @param {Array<Struct.Dialog>} dialogs The array of `Dialog` of the sequence.
 * @param {Constant.DIALOG_SEQUENCE|Real} settings_mask The sequence info.
 * @param {Array<Real>} speakers The indices of the speakers.
 * @returns {Struct.DialogSequence}
 */

function DialogSequence(dialogs, settings_mask, speakers) : DialogLinkable(settings_mask) constructor
{
  static CONSTRUCTOR_ARGC = argument_count;
  static sequence_id = 0;

  self.scene = undefined;
  self.speakers = speakers;
  self.sequence_id = sequence_id++;
  self.sequence_idx = 0;
  self.dialog_count = 0;
  self.dialogs = [];



  /**
   * @desc Overrides this sequence's unique ID with a custom one. [CHAINABLE]
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
   * @desc Returns the current/encoded sequence index.
   * @param {Real} [sequence_idx] The sequence index to encode.
   * @returns {Real}
   */

  static index = function(sequence_idx = undefined)
  {
    return sequence_idx != undefined
      ? DialogManager.__encode_sequence_idx(sequence_idx)
      : self.sequence_idx
    ;
  }



  /**
   * @desc Returns the number of sequences in the selected sequence's pool.
   * @returns {Real}
   */

  static poolcount = function()
  {
    return self.scene.sequence_count;
  }



  /**
   * @desc Returns whether the sequence idx is the last of the containing scene's.
   * @returns {Bool}
   */

  static islast = function()
  {
    return self.sequence_idx == self.scene.sequence_count - 1;
  }



  /**
   * @desc Retrieves the sequence's global position. Throws DIALOG_MANAGER.ERR_UNDEFINED_BACKREF_L1 if the back-reference to the scene is undefined.
   * @returns {Real}
   */

  static position = function()
  {
    var scene = self.scene;

    if (!scene) {
      throw DialogManager.ERROR(DIALOG_MANAGER.ERR_UNDEFINED_BACKREF_L1, [
        nameof(DialogSequence), nameof(DialogScene), nameof(DialogLinkable), nameof(DialogFX), __struct()
      ]);
    }

    return DialogManager.__encode_position(self.scene.scene_idx, self.sequence_idx, 0);
  }



  /**
   * @desc Encodes/decodes the sequence tag as a bitmask fragment.
   * @param {Constant.DIALOG_SEQUENCE|Real} [tag_mask] The tag identifier.
   * @returns {Real}
   */

  static tag = function(tag_mask = undefined)
  {
    return tag_mask == undefined
      ? (self.settings_mask & DIALOG_SEQUENCE.__BITMASK_TAG_MASK) >> DIALOG_SEQUENCE.__BITMASK_TAG_SHIFT
      : tag_mask << DIALOG_SEQUENCE.__BITMASK_TAG_SHIFT & DIALOG_SEQUENCE.__BITMASK_TAG_MASK
    ;
  }



  /**
   * @desc Retrieves a dialog given an index. Negative indices will iterate backwards.
   * @param {Real} [dialog_idx] The index of the dialog to get.
   * @returns {Struct.Dialog}
   */

  static dialog = function(dialog_idx)
  {
    return self.dialogs[dialog_idx + self.dialog_count * (dialog_idx < 0)];
  }



  /**
   * @desc Inserts dialogs into the sequence list at a given index. [CHAINABLE]
   * @param {Struct.Dialog|Array<Struct.Dialog>} dialogs The new dialogs to insert.
   * @param {Real} [index] The index where to insert the new dialogs. Defaults to last index.
   * @returns {Struct.DialogSequence}
   */

  static add = function(dialogs, index = self.dialog_count)
  {
    if (!is_array(dialogs))
      dialogs = [dialogs];

    var dialog_count = array_length(dialogs);

    for (var i = index; i < self.dialog_count; ++i)
      self.dialogs[i].dialog_idx += dialog_count;

    for (var i = 0; i < dialog_count; ++i)
    {
      var dialog = dialogs[i];

      dialog.sequence = self;
      dialog.dialog_idx = index + i;
      array_insert(self.dialogs, index + i, dialog);
    }

    self.dialog_count += dialog_count;

    return self;
  }



  /**
   * @desc Creates a map of the dialog speakers and, as side effect, modifies the ones in the sequence's dialog to match the new relative map index.
   * @returns {Struct}
   */

  static rescript = function()
  {
    self.speakers = [];

    var map = {}
      , count = 0
    ;

    for (var i = 0; i < self.dialog_count; ++i)
    {
      var dialog = self.dialogs[i]
        , speaker = dialog.speaker()
      ;

      if (!struct_exists(map, speaker))
      {
        struct_set(map, speaker, count);
        self.speakers[count++] = speaker;
      }

      dialog.settings_mask = dialog.settings_mask & ~DIALOG.__BITMASK_SPEAKER_MASK | Dialog.speaker(struct_get(map, speaker));
    }

    return map;
  }



  /**
   * @desc Renumbers every dialog to match its array position and refreshes the back-link to this sequence. [CHAINABLE]
   * @returns {Struct.DialogSequence}
   */

  static __update_dialogs = function()
  {
    self.dialog_count = array_length(self.dialogs);

    for (var i = 0; i < self.dialog_count; ++i) {
      var dialog = self.dialogs[i];
      dialog.sequence = self;
      dialog.dialog_idx = i;
    }

    return self;
  }



  /**
   * @desc Retrieves the assigned manager object.
   * @returns {Struct.DialogManager}
   */

  static __get_manager = function()
  {
    return self.scene.manager;
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
      if (self.dialogs[i].tag() == tag)
        array_push(dialogs, self.dialogs[i]);

    return dialogs;
  }



  /**
   * @desc Serialises the sequence into a compact array.
   * @returns {Array<Any>}
   */

  static __array = function()
  {
    return [
      int64(self.sequence_id),
      int64(self.settings_mask),
      array_map(self.dialogs, function(dialog) {
        return dialog.__DIALOG_MANAGER_SERIALIZING_METHOD__();
      }),
      array_map(self.speakers, function(speaker) {
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
      sequence_id: int64(self.sequence_id),
      settings_mask: int64(self.settings_mask),
      dialogs: array_map(self.dialogs, function(dialog) {
        return dialog.__DIALOG_MANAGER_SERIALIZING_METHOD__();
      }),
      speakers: array_map(self.speakers, function(speaker) {
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
        return Dialog.__DIALOG_MANAGER_DESERIALIZING_METHOD__(dialog);
      }),
      data[2],
      data[3]
    )
    .__override_id(data[0]);
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
        return Dialog.__DIALOG_MANAGER_DESERIALIZING_METHOD__(dialog);
      }),
      data.settings_mask,
      data.speakers
    )
    .__override_id(data.sequence_id);
  }



  /**
   * @desc Serialises the sequence to JSON.
   * @param {Bool} [prettify] Whether the string should have line breaks/indentation (`true`) or not (`false`).
   * @returns {String}
   */

  static __serialize = function(prettify = false)
  {
    return json_stringify(__DIALOG_MANAGER_SERIALIZING_METHOD__(), prettify);
  }



  /**
   * @desc Deserialises a JSON string produced by {@link __serialize}.
   * @param {String} data_string The JSON payload.
   * @returns {Struct.DialogSequence}
   */

  static __deserialize = function(data_string)
  {
    var data = json_parse(data_string);
    return __DIALOG_MANAGER_DESERIALIZING_METHOD__(data).__update_dialogs();
  }



  add(dialogs);
}












// ----------------------------------------------------------------------------












/**
 * `Dialog` constructor.
 * @param {String} text The text message of the dialog.
 * @param {Constant.DIALOG|Real} settings_mask The dialog info.
 * @param {Array<Struct.DialogFX>} fx_map The array of `DialogFX` to apply.
 * @returns {Struct.Dialog}
 */

function Dialog(text, settings_mask, fx_map) : DialogLinkable(settings_mask) constructor
{
  static CONSTRUCTOR_ARGC = argument_count;

  self.dialog_idx = 0;
  self.sequence = undefined;
  self.text = text;
  self.fx_count = 0;
  self.fx_map = [];



  /**
   * @desc Returns the current/encoded dialog index.
   * @param {Real} [dialog_idx] The dialog index to encode.
   * @returns {Real}
   */

  static index = function(dialog_idx = undefined)
  {
    return dialog_idx != undefined
      ? DialogManager.__encode_dialog_idx(dialog_idx)
      : self.dialog_idx
    ;
  }



  /**
   * @desc Returns the number of dialogs in the selected dialog's pool.
   * @returns {Real}
   */

  static poolcount = function()
  {
    return self.sequence.dialog_count;
  }



  /**
   * @desc Returns whether the dialog idx is the last of the containing sequence's.
   * @returns {Bool}
   */

  static islast = function()
  {
    return self.dialog_idx == self.sequence.dialog_count - 1;
  }



  /**
   * @desc Retrieves the dialog's global position. Throws DIALOG_MANAGER.ERR_UNDEFINED_BACKREF_L1 if the back-reference to the sequence is undefined or DIALOG_MANAGER.ERR_UNDEFINED_BACKREF_L2 if the back-reference to the scene is undefined.
   * @returns {Real}
   */

  static position = function()
  {
    var sequence = self.sequence;

    if (!sequence) {
      throw DialogManager.ERROR(DIALOG_MANAGER.ERR_UNDEFINED_BACKREF_L1, [
        nameof(Dialog), nameof(DialogSequence), nameof(DialogLinkable), nameof(DialogFX), __struct()
      ]);
    }

    var scene = sequence.scene;

    if (!scene) {
      throw DialogManager.ERROR(DIALOG_MANAGER.ERR_UNDEFINED_BACKREF_L2, [
        nameof(Dialog), nameof(DialogSequence), nameof(DialogLinkable), nameof(DialogFX), __struct(), sequence.__struct()
      ]);
    }

    return DialogManager.__encode_position(scene.scene_idx, sequence.sequence_idx, self.dialog_idx);
  }



  /**
   * @desc Encodes/decodes the dialog textbox as a bitmask fragment.
   * @param {Constant.DIALOG|Real} [textbox_mask] The textbox identifier.
   * @returns {Real}
   */

  static textbox = function(textbox_mask = undefined)
  {
    return textbox_mask == undefined
      ? (self.settings_mask & DIALOG.__BITMASK_TEXTBOX_MASK) >> DIALOG.__BITMASK_TEXTBOX_SHIFT
      : textbox_mask << DIALOG.__BITMASK_TEXTBOX_SHIFT & DIALOG.__BITMASK_TEXTBOX_MASK
    ;
  }



  /**
   * @desc Encodes/decodes the dialog anchor as a bitmask fragment.
   * @param {Constant.DIALOG|Real} [anchor_mask] The anchor identifier.
   * @returns {Real}
   */

  static anchor = function(anchor_mask = undefined)
  {
    return anchor_mask == undefined
      ? (self.settings_mask & DIALOG.__BITMASK_ANCHOR_MASK) >> DIALOG.__BITMASK_ANCHOR_SHIFT
      : anchor_mask << DIALOG.__BITMASK_ANCHOR_SHIFT & DIALOG.__BITMASK_ANCHOR_MASK
    ;
  }



  /**
   * @desc Encodes/decodes the dialog emotion as a bitmask fragment.
   * @param {Constant.DIALOG|Real} [emotion_mask] The emotion identifier.
   * @returns {Real}
   */

  static emotion = function(emotion_mask = undefined)
  {
    return emotion_mask == undefined
      ? (self.settings_mask & DIALOG.__BITMASK_EMOTION_MASK) >> DIALOG.__BITMASK_EMOTION_SHIFT
      : emotion_mask << DIALOG.__BITMASK_EMOTION_SHIFT & DIALOG.__BITMASK_EMOTION_MASK
    ;
  }



  /**
   * @desc Encodes/decodes the dialog speaker as a bitmask fragment.
   * @param {Constant.DIALOG|Real} [speaker_mask] The speaker identifier.
   * @returns {Real}
   */

  static speaker = function(speaker_mask = undefined)
  {
    return speaker_mask == undefined
      ? (self.settings_mask & DIALOG.__BITMASK_SPEAKER_MASK) >> DIALOG.__BITMASK_SPEAKER_SHIFT
      : speaker_mask << DIALOG.__BITMASK_SPEAKER_SHIFT & DIALOG.__BITMASK_SPEAKER_MASK
    ;
  }



  /**
   * @desc Encodes/decodes the dialog tag as a bitmask fragment.
   * @param {Constant.DIALOG|Real} [tag_mask] The tag identifier.
   * @returns {Real}
   */

  static tag = function(tag_mask = undefined)
  {
    return tag_mask == undefined
      ? (self.settings_mask & DIALOG.__BITMASK_TAG_MASK) >> DIALOG.__BITMASK_TAG_SHIFT
      : tag_mask << DIALOG.__BITMASK_TAG_SHIFT & DIALOG.__BITMASK_TAG_MASK
    ;
  }



  /**
   * @desc Retrieves a dialog fx given an index. Negative indices will iterate backwards.
   * @returns {Struct.DialogFX}
   */

  static fx = function(fx_idx)
  {
    return self.fx_map[fx_idx + self.fx_count * (fx_idx < 0)];
  }



  /**
   * @desc Returns the final jump FX in this dialog, if one exists.
   * @returns {Struct.DialogFX|undefined}
   */

  static jump = function()
  {
    for (var i = array_length(self.fx_map) - 1; i >= 0; --i)
      if (self.fx_map[i].type() == DIALOG_FX.TYPE_JUMP)
        return self.fx_map[i];

    return undefined;
  }



  /**
   * @desc Returns the first fallback FX that evaluates truthfully, if any.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the effect.
   * @returns {Struct.DialogFX|undefined}
   */

  static fallback = function(argv = undefined)
  {
    var fx_count = array_length(self.fx_map);

    for (var i = 0; i < fx_count; ++i)
      if (self.fx_map[i].type() == DIALOG_FX.TYPE_FALLBACK && __get_manager().fx_condition_map[self.fx_map[i].argv[DIALOG_FX.ARG_FALLBACK_CONDITION]](__get_manager(), argv))
        return self.fx_map[i];

    return undefined;
  }



  /**
   * @desc Returns the first choice FX, if any.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the effect.
   * @returns {Struct.DialogFX|undefined}
   */

  static choice = function(argv = undefined)
  {
    var fx_count = array_length(self.fx_map);

    for (var i = 0; i < fx_count; ++i)
      if (self.fx_map[i].type() == DIALOG_FX.TYPE_CHOICE)
        return self.fx_map[i];

    return undefined;
  }



  /**
   * @desc Makes the current dialog derive from a specified choice fx. [CHAINABLE]
   * @param {Struct.DialogFX} fx The effect derive the dialog from.
   * @param {String} prompt The choice's option text.
   * @param {Real} [index] The specific index where to insert the new option in the choice list. Defaults to list length.
   * @returns {Struct.Dialog}
   */

  static derive = function(fx, prompt, index = undefined)
  {
    var choice_count = array_length(fx.argv)
      , choice = [prompt, self]
    ;

    index ??= choice_count;

    if (index >= choice_count || is_array(fx.argv[index]))
      array_insert(fx.argv, index, choice);
    else
      fx.argv[index] = choice;

    return self;
  }



  /**
   * @desc Inserts effects in the dialog effect list at a given index. [CHAINABLE]
   * @param {Struct.DialogSequence|Array<Struct.DialogSequence>} sequences The new sequences to add.
   * @param {Real} [index] The index where to add the new sequences. Defaults to last index.
   * @returns {Struct.DialogScene}
   */

  static add = function(fxs, index = self.fx_count)
  {
    if (!is_array(fxs))
      fxs = [fxs];

    var fx_count = array_length(fxs);

    for (var i = 0; i < fx_count; ++i)
      array_insert(self.fx_map, index + i, fxs[i]);

    self.fx_count += fx_count;

    array_sort(self.fx_map, function(f1, f2) {
      var f1_type = f1.type()
        , f2_type = f2.type()
      ;

      return f1_type != f2_type
        ? f1_type - f2_type
        : f1.trigger() - f2.trigger()
      ;
    });

    return self;
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
   * @desc Executes all dialog FX which match a filter. [CHAINABLE]
   * @param {Function} [filter_fn] The predicate to test against each FX. Defaults to `true`.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the effects.
   * @returns {Struct.Dialog}
   */

  static __fx_execute_all_of = function(filter_fn = function(fx, argv) { return true; }, argv = undefined)
  {
    var fx_count = array_length(self.fx_map);

    for (var i = 0; i < fx_count; ++i)
      if (filter_fn(self.fx_map[i], argv))
        self.fx_map[i].__exec(argv, self);

    return self;
  }



  /**
   * @desc Serialises the dialog into a compact array.
   * @returns {Array<Any>}
   */

  static __array = function()
  {
    return [
      self.text,
      int64(self.settings_mask),
      array_map(self.fx_map, function(fx) {
        return fx.__DIALOG_MANAGER_SERIALIZING_METHOD__();
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
      text: self.text,
      settings_mask: int64(self.settings_mask),
      fx_map: array_map(self.fx_map, function(fx) {
        return fx.__DIALOG_MANAGER_SERIALIZING_METHOD__();
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
        return DialogFX.__DIALOG_MANAGER_DESERIALIZING_METHOD__(fx);
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
        return DialogFX.__DIALOG_MANAGER_DESERIALIZING_METHOD__(fx);
      })
    );
  }



  /**
   * @desc Serialises the dialog to JSON.
   * @param {Bool} [prettify] Whether the string should have line breaks/indentation (`true`) or not (`false`).
   * @returns {String}
   */

  static __serialize = function(prettify = false)
  {
    return json_stringify(__DIALOG_MANAGER_SERIALIZING_METHOD__(), prettify);
  }



  /**
   * @desc Deserialises a JSON string produced by {@link __serialize}.
   * @param {String} data_string The JSON payload.
   * @returns {Struct.Dialog}
   */

  static __deserialize = function(data_string)
  {
    var data = json_parse(data_string);
    return __DIALOG_MANAGER_DESERIALIZING_METHOD__(data);
  }



  add(fx_map);
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

  static fx_map = [
    /* Make and add functions to index here */
    function(argv, parent) { },
    function(argv, parent) { return DialogFX.__fx_jump(argv, parent);     },
    function(argv, parent) { return DialogFX.__fx_fallback(argv, parent); },
    function(argv, parent) { return DialogFX.__fx_choice(argv, parent);   },
  ];

  static fx_condition_map = [
    /* Make and add condition functions to index here */
    function(argv, parent) { return false; },
    function(argv, parent) { return true; },
  ];

  static fx_map_count = array_length(DialogFX.fx_map);
  static fx_condition_count = array_length(DialogFX.fx_condition_map);

  self.settings_mask = settings_mask;
  self.argv = argv;



  /**
   * @desc Encodes/decodes the dialog FX trigger as a bitmask fragment.
   * @param {Constant.DIALOG_FX|Real} [trigger_mask] The trigger identifier.
   * @returns {Real}
   */

  static trigger = function(trigger_mask = undefined)
  {
    return trigger_mask == undefined
      ? (self.settings_mask & DIALOG_FX.__BITMASK_TRIGGER_MASK) >> DIALOG_FX.__BITMASK_TRIGGER_SHIFT
      : trigger_mask << DIALOG_FX.__BITMASK_TRIGGER_SHIFT & DIALOG_FX.__BITMASK_TRIGGER_MASK
    ;
  }



  /**
   * @desc Encodes/decodes the dialog FX type as a bitmask fragment.
   * @param {Constant.DIALOG_FX|Real} [type_mask] The type identifier.
   * @returns {Real}
   */

  static type = function(type_mask = undefined)
  {
    return type_mask == undefined
      ? (self.settings_mask & DIALOG_FX.__BITMASK_TYPE_MASK) >> DIALOG_FX.__BITMASK_TYPE_SHIFT
      : type_mask << DIALOG_FX.__BITMASK_TYPE_SHIFT & DIALOG_FX.__BITMASK_TYPE_MASK
    ;
  }



  /**
   * @desc Adds an indexed function to the global dialog fx data.
   * @param {Function} func The function to bind.
   * @param {Constant.DIALOG_FX|Real} type The effect type designating the index.
   * @returns {Real}
   */

  static register = function(func, type = DialogFX.fx_map_count)
  {
    var index = type;

    if (type == DIALOG_FX.TYPE_FALLBACK) {
      if (is_callable(self.argv[DIALOG_FX.ARG_FALLBACK_CONDITION])) {
        self.argv[DIALOG_FX.ARG_FALLBACK_CONDITION] = DialogFX.fx_condition_count++;
      }

      index = self.argv[DIALOG_FX.ARG_FALLBACK_CONDITION];
      DialogFX.fx_condition_map[index] = func;
    }
    else if (type >= DialogFX.fx_map_count) {
      DialogFX.fx_map[index] = func;
      ++DialogFX.fx_map_count;
    }

    return index;
  }



  /**
   * @desc Executes the FX using the registered handlers.
   * @param {Array<Any>} [argv] The arguments to pass to the effect.
   * @param {Struct.DialogLinkable} parent The parent object invoking the effect.
   * @returns {Any}
   */

  static __exec = function(argv = self.argv, parent = undefined)
  {
    return DialogFX.fx_map[self.type()](argv, parent);
  }



  /**
   * @desc Executes the inconditional jump effect.
   * @param {Array<Any>} argv The arguments to pass to the fx function.
   * @param {Struct.DialogLinkable} parent The FX container object.
   * @returns {Struct.Dialog}
   */

  static __fx_jump = function(argv, parent)
  {
    var manager = parent.__get_manager()
      , jump_data = argv[DIALOG_FX.ARG_JUMP_DATA]
      , jump_position = jump_data[DIALOG_FX.ARG_JUMP_DATA_POSITION]
      , jump_options = array_length(jump_data) < DIALOG_FX.ARG_JUMP_DATA_COUNT ? 0 : jump_data[DIALOG_FX.ARG_JUMP_DATA_OPTIONS]
      , position = manager.__resolve_position(jump_position, jump_options, parent.position())
    ;

    manager.status |= DIALOG_MANAGER.FLAG_STATUS_EXECUTED_JUMP;

    return manager.__get_dialog_from_position(position);
  }



  /**
   * @desc Executes the conditional jump effect.
   * @param {Array<Any>} argv The arguments to pass to the fx function.
   * @param {Struct.DialogLinkable} parent The FX container object.
   * @returns {Struct.Dialog}
   */

  static __fx_fallback = function(argv, parent)
  {
    var manager = parent.__get_manager()
      , jump_data = argv[DIALOG_FX.ARG_JUMP_DATA]
      , jump_position = jump_data[DIALOG_FX.ARG_JUMP_DATA_POSITION]
      , jump_options = array_length(jump_data) < DIALOG_FX.ARG_JUMP_DATA_COUNT ? 0 : jump_data[DIALOG_FX.ARG_JUMP_DATA_OPTIONS]
      , position = manager.position
    ;

    if (DialogFX.fx_condition_map[argv[DIALOG_FX.ARG_FALLBACK_CONDITION]](manager, argv))
    {
      position = manager.__resolve_position(jump_position, jump_options, parent.position());
      manager.status |= DIALOG_MANAGER.FLAG_STATUS_EXECUTED_FALLBACK;
    }

    return manager.__get_dialog_from_position(position);
  }



  /**
   * @desc Executes the multi-option jump effect.
   * @param {Array<Any>} argv The arguments to pass to the fx function.
   * @param {Struct.DialogLinkable} parent The FX container object.
   * @returns {Struct.Dialog}
   */

  static __fx_choice = function(argv, parent)
  {
    var manager = parent.__get_manager()
      , choice_index = argv[DIALOG_FX.ARG_CHOICE_INDEX]
      , position = manager.position
    ;

    if (choice_index != DIALOG_FX.CHOICE_INDEX_UNSELECTED)
    {
      var choice = argv[DIALOG_FX.ARG_JUMP_DATA][choice_index]
        , jump_position = choice[DIALOG_FX.ARG_JUMP_DATA_POSITION]
        , jump_options = array_length(choice) < DIALOG_FX.ARG_JUMP_DATA_COUNT ? 0 : choice[DIALOG_FX.ARG_JUMP_DATA_OPTIONS]
      ;

      position = manager.__resolve_position(jump_position, jump_options, parent.position());
      manager.status |= DIALOG_MANAGER.FLAG_STATUS_EXECUTED_CHOICE;
    }

    return manager.__get_dialog_from_position(position);
  }



  /**
   * @desc Serialises the FX into a compact array.
   * @returns {Array<Any>}
   */

  static __array = function()
  {
    return [
      int64(self.settings_mask),
      __resolve_recursive(self.argv)
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
   * @desc Serialises the FX to a JSON string.
   * @param {Bool} [prettify] Whether the string should be pretty-printed.
   * @returns {String}
   */

  static __serialize = function(prettify = false)
  {
    return json_stringify(__DIALOG_MANAGER_SERIALIZING_METHOD__(), prettify);
  }



  /**
   * @desc Deserialises a JSON string produced by {@link __serialize}.
   * @param {String} data_string The JSON payload.
   * @returns {Struct.DialogFX}
   */

  static __deserialize = function(data_string)
  {
    var data = json_parse(data_string);
    return __DIALOG_MANAGER_DESERIALIZING_METHOD__(data);
  }



  var fx_type = self.type();

  func ??= fx_type == DIALOG_FX.TYPE_FALLBACK && is_callable(self.argv[DIALOG_FX.ARG_FALLBACK_CONDITION])
    ? self.argv[DIALOG_FX.ARG_FALLBACK_CONDITION]
    : undefined
  ;

  if (func)
    DialogFX.register(func, fx_type);

  // Recursive argument serializer function
  function __resolve_recursive(arg) {
    return is_array(arg)
      ? array_map(arg, __resolve_recursive)
      : (is_instanceof(arg, DialogLinkable) ? arg.position() : arg)
    ;
  }
}
