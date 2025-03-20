/*
  +: Modify object to store only the encoded position
  +: Add method to manage dialog jump
  +: Execute all ON_END and ON_START effects of a dialog
*/

#macro __DIALOG_MANAGER_ENCODING_METHOD__ __struct      // Must be <__struct> or <__array>
#macro __DIALOG_MANAGER_DECODING_METHOD__ __from_struct // Must be <__from_struct> or <__from_array>












//-----------------------------------------------------------------------------












/**
 * Creates a new DialogScene object.
 * @param {Real} settings_mask - The settings, which combine bg index, bgm index and bgs index.
 * @param {Array<Struct.DialogSequence>} [sequences] - The sequences of the scene.
 * @returns {Struct.DialogScene}
 */

function dialog_scene_create(settings_mask, sequences = [])
{
  return new DialogScene(
    settings_mask,
    is_array(sequences) ? sequences : [sequences],
  );
}



/**
 * Creates a new DialogScene object from an array.
 * @param {Array<Any>} data - The data of the object.
 * @returns {Struct.DialogScene}
 */

function dialog_scene_create_array(data)
{
  return dialog_scene_create(data[0], data[1]);
}



/**
 * Creates a new DialogScene object from a struct.
 * @param {Struct} data - The data of the object.
 * @returns {Struct.DialogScene}
 */

function dialog_scene_create_struct(data)
{
  return dialog_scene_create(data.settings_mask, data.sequences);
}



/**
 * Transforms a DialogScene instance in a string.
 * @param {Struct.DialogScene} dialog_condition - The dialog scene to serialize.
 * @param {Bool} [prettify] - Whether the output should be prettified (true) or collapsed (false).
 * @returns {String}
 */

function dialog_scene_serialize(dialog_scene, prettify = false)
{
  return dialog_scene.__serialize(prettify);
}



/**
 * Transforms a string in a DialogScene instance.
 * @param {String} data_string - The data to deserialize.
 * @returns {Struct.DialogScene}
 */

function dialog_scene_deserialize(data_string)
{
  return DialogScene.__deserialize(data_string);
}












// ----------------------------------------------------------------------------












/**
 * Creates a new DialogSequence object.
 * @param {Array<Struct.Dialog>} [dialogs] - The dialogs of the sequence.
 * @param {Array<Real>} [speaker_map] - The indexes of the speakers.
 * @returns {Struct.DialogSequence}
 */

function dialog_sequence_create(dialogs = [], speaker_map = [])
{
  return new DialogSequence(
    is_array(dialogs) ? dialogs : [dialogs],
    is_array(speaker_map) ? speaker_map : [speaker_map],
  );
}



/**
 * Creates a new DialogSequence object from an array.
 * @param {Array<Any>} data - The data of the object.
 * @returns {Struct.DialogSequence}
 */

function dialog_sequence_create_array(data)
{
  return dialog_sequence_create(data[0], data[1]);
}



/**
 * Creates a new DialogSequence object from a struct.
 * @param {Struct} data - The data of the object.
 * @returns {Struct.DialogSequence}
 */

function dialog_sequence_create_struct(data)
{
  return dialog_sequence_create(data.dialogs, data.speaker_map);
}



/**
 * Transforms a DialogSequence instance in a string.
 * @param {Struct.DialogSequence} dialog_condition - The dialog sequence to serialize.
 * @param {Bool} [prettify] - Whether the output should be prettified (true) or collapsed (false).
 * @returns {String}
 */

function dialog_sequence_serialize(dialog_sequence, prettify = false)
{
  return dialog_sequence.__serialize(prettify);
}



/**
 * Transforms a string in a DialogSequence instance.
 * @param {String} data_string - The data to deserialize.
 * @returns {Struct.DialogSequence}
 */

function dialog_sequence_deserialize(data_string)
{
  return DialogSequence.__deserialize(data_string);
}












// ----------------------------------------------------------------------------












/**
 * Creates a new Dialog object.
 * @param {Real} speaker_idx - The relative sequence index of the current speaker.
 * @param {Constant.DIALOG_EMOTION} emotion_id - The id of the emotion sprite.
 * @param {String} text - The text message of the dialog.
 * @param {Constant.DIALOG_ANCHOR} [anchor] - The relative screen position anchor.
 * @param {Constant.DIALOG_TEXTBOX_TYPE} [textbox_type] - The textbox type.
 * @param {Array<Struct.DialogFX>} [fx_map] - The list of effects to apply.
 * @returns {Struct.Dialog}
 */

function dialog_create(speaker_idx, emotion_id, text, anchor, textbox_type, fx_map = [])
{
  return new Dialog(
    speaker_idx,
    emotion_id,
    text,
    anchor,
    textbox_type,
    is_array(fx_map) ? fx_map : [fx_map]
  );
}



/**
 * Creates a new Dialog object from an array.
 * @param {Array<Any>} data - The data of the object.
 * @returns {Struct.Dialog}
 */

function dialog_create_array(data)
{
  return dialog_create(data[0], data[1], data[2], data[3], data[4], data[5]);
}



/**
 * Creates a new Dialog object from a struct.
 * @param {Struct} data - The data of the object.
 * @returns {Struct.Dialog}
 */

function dialog_create_struct(data)
{
  return dialog_create(
    data.speaker_idx,
    data.emotion_id,
    data.text,
    data.anchor,
    data.textbox_type,
    data.fx_map,
  );
}



/**
 * Transforms a Dialog instance in a string.
 * @param {Struct.Dialog} dialog_condition - The dialog state modifier to serialize.
 * @param {Bool} [prettify] - Whether the output should be prettified (true) or collapsed (false).
 * @returns {String}
 */

function dialog_serialize(dialog, prettify = false)
{
  return dialog.__serialize(prettify);
}



/**
 * Transforms a string in a Dialog instance.
 * @param {String} data_string - The data to deserialize.
 * @returns {Struct.Dialog}
 */

function dialog_deserialize(data_string)
{
  return Dialog.__deserialize(data_string);
}












// ----------------------------------------------------------------------------












/**
 * Creates a new Dialog FX object.
 * @param {Constant.DIALOG_FX_TYPE} type - The type of effect to apply.
 * @param {Constant.DIALOG_FX_TRIGGER_TYPE} trigger - The trigger type of the effect.
 * @param {Array<Any>} [args] - The arguments of the mapped effect function.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create(type, trigger, args = [])
{
  return new DialogFX(type, trigger, is_array(args) ? args : [args]);
}



/**
 * Creates a new Dialog FX object from an array.
 * @param {Array} data - The data to create the Dialog FX from.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create_array(data)
{
  return dialog_fx_create(data[0], data[1], data[2]);
}



/**
 * Creates a new Dialog FX object from a struct.
 * @param {Struct} data - The data to create the Dialog FX from.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create_struct(data)
{
  return dialog_fx_create(data.type, data.trigger, data.args);
}



/**
 * Transforms a DialogFX instance in a string.
 * @param {Struct.DialogFX} dialog_fx - The dialog effect to serialize.
 * @param {Bool} [prettify] - Whether the output should be prettified (true) or collapsed (false).
 * @returns {String}
 */

function dialog_fx_serialize(dialog_fx, prettify = false)
{
  return dialog_fx.__serialize(prettify);
}



/**
 * Transforms a string in a DialogFX instance.
 * @param {String} data_string - The data to deserialize.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_deserialize(data_string)
{
  return DialogFX.__deserialize(data_string);
}












//-----------------------------------------------------------------------------












enum DIALOG_POSITION_ENC
{
  DIALOG_BITS = 15,
  SEQUENCE_BITS = 6,
  SCENE_BITS = 10,
  DIALOG_SHIFT = 0,
  SEQUENCE_SHIFT = DIALOG_BITS + DIALOG_SHIFT,
  SCENE_SHIFT = SEQUENCE_BITS + SEQUENCE_SHIFT,
  DIALOG_MASK = ((1 << DIALOG_BITS) - 1) << DIALOG_SHIFT,
  SEQUENCE_MASK = ((1 << SEQUENCE_BITS) - 1) << SEQUENCE_SHIFT,
  SCENE_MASK = ((1 << SCENE_BITS) - 1) << SCENE_SHIFT,
}



enum DIALOG_JUMP_OPT_ID
{
  NONE = -5,
  SCENE_END,
  SCENE_RESTART,
  SEQUENCE_END,
  SEQUENCE_RESTART,
  COUNT = -NONE // This is magic
}



function DialogManager(data_string = "") constructor
{
  self.current_scene_index = 0;
  self.current_sequence_index = 0;
  self.current_dialog_index = 0;

  self.position = 0;
  self.scene_count = 0;
  self.scenes = [];



  /**
   * @param {Real} [scene_id]
   * @returns {Struct.DialogScene}
   */

  static __get_scene = function(scene_idx = __decode_scene_idx(self.position))
  {
    return self.scenes[scene_idx];
  }



  /**
   * @param {Real} [scene_idx]
   * @param {Real} [sequence_idx]
   * @returns {Struct.DialogSequence}
   */

  static __get_sequence = function(sequence_idx = __decode_sequence_idx(self.position), scene_idx = __decode_scene_idx(self.position))
  {
    return __get_scene(scene_idx).sequences[sequence_idx];
  }



  /**
   * @param {Real} [scene_idx]
   * @param {Real} [sequence_idx]
   * @param {Real} [dialog_idx]
   * @returns {Struct.Dialog}
   */

  static __get_dialog = function(dialog_idx = __decode_dialog_idx(self.position), sequence_idx = __decode_sequence_idx(self.position), scene_idx = __decode_scene_idx(self.position))
  {
    return __get_sequence(scene_idx, sequence_idx).dialogs[dialog_idx];
  }



  /**
   * @param {Real} [scene_idx]
   */

  static __set_scene_idx = function(scene_idx = 0)
  {
    self.position = __set_mask_region(DIALOG_POSITION_ENC.SCENE_SHIFT, DIALOG_POSITION_ENC.SCENE_BITS, scene_idx);
    // self.position = self.position & ~(((1 << DIALOG_POSITION_ENC.SCENE_BITS) - 1) << DIALOG_POSITION_ENC.SCENE_SHIFT) | scene_idx << DIALOG_POSITION_ENC.SCENE_SHIFT;
    //self.position = __encode_position(scene_idx, __decode_sequence_idx(), __decode_dialog_idx());
    //self.current_scene_index = scene_idx;
  }



  /**
   * @param {Real} [sequence_idx]
   */

  static __set_sequence_idx = function(sequence_idx = 0)
  {
    self.position = __set_mask_region(DIALOG_POSITION_ENC.SEQUENCE_SHIFT, DIALOG_POSITION_ENC.SEQUENCE_BITS, sequence_idx);
    // self.position = self.position & ~(((1 << DIALOG_POSITION_ENC.SEQUENCE_BITS) - 1) << DIALOG_POSITION_ENC.SEQUENCE_SHIFT) | sequence_idx << DIALOG_POSITION_ENC.SEQUENCE_SHIFT;
    //self.position = __encode_position(__decode_scene_idx(), sequence_idx, __decode_dialog_idx());
    //self.current_sequence_index = sequence_idx;
  }



  /**
   * @param {Real} [dialog_idx]
   */

  static __set_dialog_idx = function(dialog_idx = 0)
  {
    self.position = __set_mask_region(DIALOG_POSITION_ENC.DIALOG_SHIFT, DIALOG_POSITION_ENC.DIALOG_BITS, dialog_idx);
    //self.position = self.position & ~(((1 << DIALOG_POSITION_ENC.DIALOG_BITS) - 1) << DIALOG_POSITION_ENC.DIALOG_SHIFT) | dialog_idx << DIALOG_POSITION_ENC.DIALOG_SHIFT;
    //self.position = __encode_position(__decode_scene_idx(), __decode_sequence_idx(), dialog_idx);
    //self.current_dialog_index = dialog_idx;
  }



  /**
   * @param {Real} [scene_idx]
   * @param {Real} [sequence_idx]
   * @param {Real} [dialog_idx]
   */

  static __set_position = function(scene_idx = 0, sequence_idx = 0, dialog_idx = 0)
  {
    self.position = __encode_position(scene_idx, sequence_idx, dialog_idx);
    // __set_scene_idx(scene_idx);
    // __set_sequence_idx(sequence_idx);
    // __set_dialog_idx(dialog_idx);
  }



  /**
   * @param {Struct.DialogScene} scene
   * @returns {Struct.DialogManager}
   */

  static __add_scene = function(scene)
  {
    scene.scene_idx = self.scene_count++;

    array_push(self.scenes, scene);

    return self;
  }



  /**
   * @param {Array<Struct.DialogScene>} scenes
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
   * @param {Struct.DialogScene} scene
   * @param {Real} [index]
   * @return {Struct.DialogManager}
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
   * @param {Array<Struct.DialogScene>} scenes
   * @param {Real} [index]
   * @return {Struct.DialogManager}
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
   * @param {Struct.DialogSequence} sequence
   * @param {Real} [scene_idx]
   * @returns {Struct.DialogManager}
   */

  static __add_sequence = function(sequence, scene_idx = self.current_scene_index)
  {
    __get_scene(scene_idx).__add_sequence(sequence);

    return self;
  }



  /**
   * @param {Array<Struct.DialogSequence>} sequences
   * @param {Real} [scene_idx]
   * @returns {Struct.DialogManager}
   */

  static __add_sequences = function(sequences, scene_idx = self.current_scene_index)
  {
    __get_scene(scene_idx).__add_sequences(sequences);

    return self;
  }



  /**
   * @param {Struct.Dialog} dialog
   * @param {Real} [scene_idx]
   * @param {Real} [sequence_idx]
   * @returns {Struct.DialogManager}
   */

  static __add_dialog = function(dialog, scene_idx = self.current_scene_index, sequence_idx = self.current_sequence_index)
  {
    __get_sequence(scene_idx, sequence_idx).__add_dialog(dialog);

    return self;
  }



  /**
   * @param {Array<Struct.Dialog>} dialogs
   * @param {Real} [scene_idx]
   * @param {Real} [sequence_idx]
   * @returns {Struct.DialogManager}
   */

  static __add_dialogs = function(dialogs, scene_idx = self.current_scene_index, sequence_idx = self.current_sequence_index)
  {
    __get_sequence(scene_idx, sequence_idx).__add_dialogs(dialogs);

    return self;
  }



  /**
   * @param {Real} scene_idx
   * @param {Real} sequence_idx
   * @param {Real} dialog_idx
   * @return {Real}
   */

  static __encode_position = function(scene_idx, sequence_idx, dialog_idx)
  {
    return __encode_scene(scene_idx) | __encode_sequence(sequence_idx) | __encode_dialog(dialog_idx);
  }



  /**
   * @param {Real} dialog_idx
   * @returns {Real}
   */

  static __encode_dialog = function(dialog_idx)
  {
    return dialog_idx << DIALOG_POSITION_ENC.DIALOG_SHIFT & DIALOG_POSITION_ENC.DIALOG_MASK;
  }



  /**
   * @param {Real} sequence_idx
   * @returns {Real}
   */

  static __encode_sequence = function(sequence_idx)
  {
    return sequence_idx << DIALOG_POSITION_ENC.SEQUENCE_SHIFT & DIALOG_POSITION_ENC.SEQUENCE_MASK;
  }



  /**
   * @param {Real} scene_idx
   * @returns {Real}
   */

  static __encode_scene = function(scene_idx)
  {
    return scene_idx << DIALOG_POSITION_ENC.SCENE_SHIFT & DIALOG_POSITION_ENC.SCENE_MASK;
  }



  /**
   * @param {Real} shift
   * @param {Real} bits
   * @param {Real} [bitfield]
   */

  static __get_mask_region = function(shift, bits, bitfield = self.position)
  {
    return bitfield >> shift & ((1 << bits) - 1);
  }



  /**
   * @param {Real} bitfield
   * @param {Real} shift
   * @param {Real} bits
   * @param {Real} [mask]
   */

  static __set_mask_region = function(shift, bits, mask = 0, bitfield = self.position)
  {
    return bitfield & ~(((1 << bits) - 1) << shift) | mask << shift;
  }



  /**
   * @param {Real} position
   * @return {Real}
   */

  static __decode_scene_idx = function(position = self.position)
  {
    return position & DIALOG_POSITION_ENC.SCENE_MASK;
    //__get_mask_region(DIALOG_POSITION_ENC.SCENE_SHIFT, DIALOG_POSITION_ENC.SCENE_BITS, position);
    // return position >> DIALOG_POSITION_ENC.SCENE_SHIFT & ((1 << DIALOG_POSITION_ENC.SCENE_BITS) - 1);
  }



  /**
   * @param {Real} position
   * @return {Real}
  */

  static __decode_sequence_idx = function(position = self.position)
  {
    return position & DIALOG_POSITION_ENC.SEQUENCE_MASK; 
    // __get_mask_region(DIALOG_POSITION_ENC.SEQUENCE_SHIFT, DIALOG_POSITION_ENC.SEQUENCE_BITS, position);
    // return position >> DIALOG_POSITION_ENC.SEQUENCE_SHIFT & ((1 << DIALOG_POSITION_ENC.SEQUENCE_BITS) - 1);
  }



  /**
   * @param {Real} position
   * @return {Real}
  */

  static __decode_dialog_idx = function(position = self.position)
  {
    return position & DIALOG_POSITION_ENC.DIALOG_MASK;
    // __get_mask_region(DIALOG_POSITION_ENC.DIALOG_SHIFT, DIALOG_POSITION_ENC.DIALOG_BITS, position);
    // return position >> DIALOG_POSITION_ENC.DIALOG_SHIFT & ((1 << DIALOG_POSITION_ENC.DIALOG_BITS) - 1);
  }



  /**
   * @param {Struct.DialogScene} scene
   */

  static __jump_to_scene = function(scene)
  {
    __set_position(scene.scene_idx, 0, 0);
  }



  /**
   * @param {Struct.DialogSequence} sequence
   */

  static __jump_to_sequence = function(sequence)
  {
    var scene = sequence.scene;

    __set_position(scene.scene_idx, sequence.sequence_idx, 0);
  }



  /**
   * @param {Struct.Dialog} dialog
   */

  static __jump_to_dialog = function(dialog)
  {
    var sequence = dialog.sequence
      , scene = sequence.scene
    ;

    __set_position(scene.scene_idx, sequence.sequence_idx, dialog.dialog_idx);
  }



  /**
   * @param {Struct.Dialog} dialog
   */

  static __jump = function(dialog)
  {
    var jump_fx = array_filter(dialog.fx_map, function(fx) {
      return fx.type == DIALOG_FX_TYPE.JUMP;
    });

    var fx_count = array_length(jump_fx);

    for (var i = 0; i < fx_count; ++i)

  }



  /**
   * @param {Real} [dialog_idx_delta]
   * @returns {Struct.Dialog}
   */

  static __next = function(dialog_idx_delta = 1)
  {
    var current_scene = __get_scene();
    var current_sequence = __get_sequence();
    var scene_count = array_length(self.scenes);
    var sequence_count = array_length(current_scene.sequences);
    var dialog_count = array_length(current_sequence.dialogs);

    var next_dialog_idx = __decode_dialog_idx(self.position) + dialog_idx_delta
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

    var dialog = __get_dialog().__fx_execute_all_of(function(fx) {
      return fx.trigger == DIALOG_FX_TRIGGER_TYPE.ON_END;
    });

    __set_position(next_scene_idx, next_sequence_idx, next_dialog_idx);

    dialog = __get_dialog().__fx_execute_all_of(function(fx) {
      return fx.trigger == DIALOG_FX_TRIGGER_TYPE.ON_START;
    });

    return dialog;
  }



  /**
   * @param {Bool} [prettify]
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
   * @param {String} data_string
   * @returns {Struct.DialogManager}
  */

  static __deserialize = function(data_string)
  {
    var data = json_parse(data_string);

    array_map(data, function(scene)
    {
      scene = DialogScene.__DIALOG_MANAGER_DECODING_METHOD__(scene);

      for (var i = array_length(scene.sequences) - 1; i >= 0; scene.sequences[i--].scene = scene)
        for (var j = array_length(scene.sequences[i].dialogs) - 1; j >= 0; --j)
          scene.sequences[i].dialogs[j].sequence = scene.sequences[i];

      return scene;
    });

    return self;
  }



  /**
   * @returns {Struct.DialogManager}
   */

  static __reset_parser_state = function()
  {
    self.scenes = [];
    self.scene_count = 0;
    DialogScene.scene_id = 0;
    DialogSequence.sequence_id = 0;

    self.current_scene_index = 0;
    self.current_sequence_index = 0;
    self.current_dialog_index = 0;

    return self;
  }



  __deserialize(data_string);
}












// ----------------------------------------------------------------------------












function DialogScene(settings_mask, sequences) constructor
{
  static scene_id = 0;

  self.scene_idx = 0;

  self.position = 0;
  self.scene_id = scene_id++;
  self.settings_mask = settings_mask;
  self.sequences = [];



  /**
   * @param {Real} override_scene_id
   * @returns {Struct.DialogScene}
   */

  static __override_id = function(override_scene_id)
  {
    self.scene_id = override_scene_id;
    --DialogScene.scene_id;

    return self;
  }



  /**
   * @returns {Array}
   */

  static __array = function()
  {
    return [
      int64(scene_id),
      int64(settings_mask),
      array_map(sequences, function(sequence) {
        return sequence.__DIALOG_MANAGER_ENCODING_METHOD__();
      })
    ];
  }



  /**
   * @returns {Struct}
   */

  static __struct = function()
  {
    return {
      scene_id: int64(scene_id),
      settings_mask: int64(settings_mask),
      sequences: array_map(sequences, function(sequence) {
        return sequence.__DIALOG_MANAGER_ENCODING_METHOD__();
      })
    };
  }



  /**
   * @param {Array} data
   * @returns {Struct.DialogScene}
   */

  static __from_array = function(data)
  {
    return new DialogScene(
      data[1],
      array_map(data[2], function(sequence) {
        return DialogSequence.__DIALOG_MANAGER_DECODING_METHOD__(sequence);
      })
    )
    .__override_id(data[0]);
  }



  /**
   * @param {Struct} data
   * @returns {Struct.DialogScene}
   */

  static __from_struct = function(data)
  {
    return new DialogScene(
      data.settings_mask,
      array_map(data.sequences, function(sequence) {
        return DialogSequence.__DIALOG_MANAGER_DECODING_METHOD__(sequence);
      })
    )
    .__override_id(data.scene_id);
  }



  /**
   * @returns {Real}
   */

  static __get_position = function()
  {
    return DialogManager.__encode_position(self.scene_idx, 0, 0);
  }



  /**
   * @param {Struct.DialogSequence} sequence
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
   * @param {Array<Struct.DialogSequence>} sequences
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
   * @param {Struct.DialogSequence} sequence
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
   * @param {Array<Struct.DialogSequence>} sequences
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
   * @param {Bool} [prettify]
   * @returns {String}
   */

  static __serialize = function(prettify = false)
  {
    return json_stringify(__DIALOG_MANAGER_ENCODING_METHOD__(), prettify);
  }



  /**
   * @param {String} data_string
   * @returns {Struct.DialogScene}
   */

  static __deserialize = function(data_string)
  {
    var data = json_parse(data_string);
    return __DIALOG_MANAGER_DECODING_METHOD__(data);
  }



  __add_sequences(sequences);
}












// ----------------------------------------------------------------------------












function DialogSequence(dialogs, speaker_map) constructor
{
  static sequence_id = 0;

  self.scene = undefined;
  self.sequence_id = sequence_id++;
  self.speaker_map = speaker_map;
  self.sequence_idx = 0;
  self.dialogs = [];



  /**
   * @returns {Real}
   */

  static __get_position = function()
  {
    var scene = self.scene;

    return DialogManager.__encode_position(scene.scene_idx, self.sequence_idx, 0);
  }


  /**
   * @param {Real} override_sequence_id
   * @returns {Struct.DialogSequence}
  */

  static __override_id = function(override_sequence_id)
  {
    self.sequence_id = override_sequence_id;
    --DialogSequence.sequence_id;

    return self;
  }



  /**
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
   * @param {Array} data
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
    .__override_id(data[0]);
  }



  /**
   * @param {Struct} data
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
    .__override_id(data.sequence_id);
  }



  /**
   * @param {Struct.Dialog} dialog
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
   * @param {Array<Struct.Dialog>} dialogs
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
   * @param {Struct.Dialog} dialog
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
   * @param {Array<Struct.Dialog>} dialogs
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
   * @param {Bool} [prettify]
   * @returns {String}
   */

  static __serialize = function(prettify = false)
  {
    return json_stringify(__DIALOG_MANAGER_ENCODING_METHOD__(), prettify);
  }



  /**
   * @param {String} data_string
   * @returns {Struct.DialogSequence}
   */

  static __deserialize = function(data_string)
  {
    var data = json_parse(data_string);
    return __DIALOG_MANAGER_DECODING_METHOD__(data);
  }



  __add_dialogs(dialogs);
}












// ----------------------------------------------------------------------------












enum DIALOG_EMOTION
{
  DEFAULT,
  COUNT,
}



enum DIALOG_ANCHOR
{
  BOTTOM,
  CENTER,
  TOP,
  COUNT,
}



enum DIALOG_TEXTBOX_TYPE
{
  DEFAULT,
  COUNT,
}



function Dialog(speaker_idx, emotion_id, text, anchor, textbox_type, fx_map) constructor
{
  self.dialog_idx = 0;
  self.sequence = undefined;
  self.speaker_idx = speaker_idx;
  self.emotion_id = emotion_id;
  self.text = text;
  self.anchor = anchor;
  self.textbox_type = textbox_type;
  self.fx_map = fx_map;



  /**
   * @returns {Array}
   */

  static __array = function()
  {
    return [
      int64(speaker_idx),
      int64(emotion_id),
      text,
      int64(anchor),
      int64(textbox_type),
      array_map(fx_map, function(fx) {
        return fx.__DIALOG_MANAGER_ENCODING_METHOD__();
      })
    ];
  }



  /**
   * @returns {Struct}
   */

  static __struct = function()
  {
    return {
      speaker_idx: int64(speaker_idx),
      emotion_id: int64(emotion_id),
      text,
      anchor: int64(anchor),
      textbox_type: int64(textbox_type),
      fx_map: array_map(fx_map, function(fx) {
        return fx.__DIALOG_MANAGER_ENCODING_METHOD__();
      })
    };
  }



  /**
   * @param {Array} data
   * @returns {Struct.Dialog}
   */

  static __from_array = function(data)
  {
    return new Dialog(
      data[0],
      data[1],
      data[2],
      data[3],
      data[4],
      array_map(data[5], function(fx) {
        return DialogFX.__DIALOG_MANAGER_DECODING_METHOD__(fx);
      })
    );
  }



  /**
   * @param {Struct} data
   * @returns {Struct.Dialog}
   */

  static __from_struct = function(data)
  {
    return new Dialog(
      data.speaker_idx,
      data.emotion_id,
      data.text,
      data.anchor,
      data.textbox_type,
      array_map(data.fx_map, function(fx) {
        return DialogFX.__DIALOG_MANAGER_DECODING_METHOD__(fx);
      })
    );
  }



  /**
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
   * @param {Function} [filter_fn]
   * @return {Struct.Dialog}
   */

  static __fx_execute_all_of = function(filter_fn = function(fx) { return true; })
  {
    var fx_count = array_length(self.fx_map);

    if (!fx_count)
      return;

    var fx = fx_map[0];

    for (var i = 0; i < fx_count; fx = fx_map[++i])
      if (filter_fn(fx))
        DialogFX.fx_map[fx.type](fx.args);

    return self;
  }



  /**
   * @param {Bool} [prettify]
   * @returns {String}
   */

  static __serialize = function(prettify = false)
  {
    return json_stringify(__DIALOG_MANAGER_ENCODING_METHOD__(), prettify);
  }



  /**
   * @param {String} data_string
   * @returns {Struct.Dialog}
   */

  static __deserialize = function(data_string)
  {
    var data = json_parse(data_string);
    return __DIALOG_MANAGER_DECODING_METHOD__(data);
  }
}












// ----------------------------------------------------------------------------












enum DIALOG_FX_TYPE
{
  ANY,
  JUMP,
  STATE_MODIFY,
  COUNT,
}



enum DIALOG_FX_TRIGGER_TYPE
{
  NONE,
  ON_START,
  ON_END,
  ON_CUSTOM, // It is NOT effective, only here for readability
  COUNT,
}



function DialogFX(type, trigger, args) constructor
{
  static fx_map = [];

  self.type = type;
  self.trigger = trigger;
  self.args = args;



  /**
   * @returns {Array}
   */

  static __array = function()
  {
    return [
      int64(type),
      int64(trigger),
      args
    ];
  }



  /**
   * @returns {Struct}
   */

  static __struct = function()
  {
    return {
      type: int64(type),
      trigger: int64(trigger),
      args
    };
  }



  /**
   * @param {Array} data
   * @returns {Struct.DialogFX}
   */

  static __from_array = function(data)
  {
    return new DialogFX(data[0], data[1], data[2]);
  }



  /**
   * @param {Struct} data
   * @returns {Struct.DialogFX}
   */

  static __from_struct = function(data)
  {
    return new DialogFX(
      data.type,
      data.trigger,
      data.args
    );
  }



  /**
   * @param {Bool} [prettify]
   * @returns {String}
   */

  static __serialize = function(prettify = false)
  {
    return json_stringify(__DIALOG_MANAGER_ENCODING_METHOD__(), prettify);
  }



  /**
   * @param {String} data_string
   * @returns {Struct.DialogFX}
   */

  static __deserialize = function(data_string)
  {
    var data = json_parse(data_string);
    return __DIALOG_MANAGER_DECODING_METHOD__(data);
  }
}
