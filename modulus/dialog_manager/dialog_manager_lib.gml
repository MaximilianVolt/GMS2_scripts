/**
 * @desc `DialogManager` constructor.
 * @param {String | Id.TextFile} [data_string] The data to parse.
 * @param {Bool} [is_file] Specifies whether `data_string` is a file (`true`) or not (`false`).
 * @param {Struct} [contractor] The struct, instance or object where to assign the properties.
 * @returns {Struct.DialogManager}
 */

function dialog_manager_create(data_string = "", is_file = false, contractor = global)
{
  return new DialogManager(data_string, is_file, contractor);
}



/**
 * @desc Evaluates the `DialogLinkable` components' type and appends them after the last type's instance in a dialog manager.
 * @param {Struct.DialogManager} dialog_manager The dialog manager where to add the data.
 * @param {Struct.DialogLinkable | Array<Struct.DialogLinkable>} [dialog_linkable] The `DialogLinkable` components to add.
 * @returns {Struct.DialogManager}
 */

function dialog_manager_add(dialog_manager, dialog_linkable = [])
{
  dialog_linkable = is_array(dialog_linkable) ? dialog_linkable : [dialog_linkable];

  if (is_instanceof(dialog_linkable, DialogScene))
    return dialog_manager.__add_scenes(dialog_linkable);

  if (is_instanceof(dialog_linkable, DialogSequence))
    return dialog_manager.__add_sequences(dialog_linkable);

  if (is_instanceof(dialog_linkable, Dialog))
    return dialog_manager.__add_dialogs(dialog_linkable);
}



/**
 * Transforms a `DialogManager` instance in a string.
 * @param {Struct.DialogScene} dialog_manager - The `DialogManager` to serialize.
 * @param {Bool} [prettify] - Whether the output should be prettified (true) or collapsed (false).
 * @returns {String}
 */

function dialog_manager_serialize(dialog_manager, prettify = false)
{
  return dialog_manager.__serialize(prettify);
}



/**
 * Transforms a string in a `DialogManager` instance.
 * @param {String} data_string - The data to deserialize.
 * @returns {Struct.DialogManager}
 */

function dialog_manager_deserialize(data_string)
{
  return DialogManager.__deserialize(data_string);
}












// ----------------------------------------------------------------------------












/**
 * `DialogScene` constructor.
 * @param {Array<Struct.DialogSequence>} [sequences] - The array of `DialogSequence` of the scene.
 * @param {Real} [settings_mask] - The scene settings.
 * @returns {Struct.DialogScene}
 */

function dialog_scene_create(sequences = [], settings_mask = 0)
{
  return new DialogScene(
    is_array(sequences) ? sequences : [sequences],
    settings_mask
  );
}



/**
 * Creates a new `DialogScene` object from an array.
 * @param {Array<Any>} data - The data of the object.
 * @returns {Struct.DialogScene}
 */

function dialog_scene_create_array(data)
{
  return dialog_scene_create(data[0], data[1]);
}



/**
 * Creates a new `DialogScene` object from a struct.
 * @param {Struct} data - The data of the object.
 * @returns {Struct.DialogScene}
 */

function dialog_scene_create_struct(data)
{
  return dialog_scene_create(data.sequences, data.settings_mask);
}



/**
 * Transforms a `DialogScene` instance in a string.
 * @param {Struct.DialogScene} dialog_scene - The `DialogScene` to serialize.
 * @param {Bool} [prettify] - Whether the output should be prettified (true) or collapsed (false).
 * @returns {String}
 */

function dialog_scene_serialize(dialog_scene, prettify = false)
{
  return dialog_scene.__serialize(prettify);
}



/**
 * Transforms a string in a `DialogScene` instance.
 * @param {String} data_string - The data to deserialize.
 * @returns {Struct.DialogScene}
 */

function dialog_scene_deserialize(data_string)
{
  return DialogScene.__deserialize(data_string);
}












// ----------------------------------------------------------------------------












/**
 * `DialogSequence` constructor.
 * @param {Array<Struct.Dialog>} [dialogs] - The array of `Dialog` of the sequence.
 * @param {Array<Real>} [speaker_map] - The indexes of the speakers.
 * @returns {Struct.DialogSequence}
 */

function dialog_sequence_create(dialogs = [], speaker_map = [])
{
  return new DialogSequence(
    is_array(dialogs) ? dialogs : [dialogs],
    is_array(speaker_map) ? speaker_map : [speaker_map]
  );
}



/**
 * Creates a new `DialogSequence` object from an array.
 * @param {Array<Any>} data - The data of the object.
 * @returns {Struct.DialogSequence}
 */

function dialog_sequence_create_array(data)
{
  return dialog_sequence_create(data[0], data[1]);
}



/**
 * Creates a new `DialogSequence` object from a struct.
 * @param {Struct} data - The data of the object.
 * @returns {Struct.DialogSequence}
 */

function dialog_sequence_create_struct(data)
{
  return dialog_sequence_create(data.dialogs, data.speaker_map);
}



/**
 * Transforms a `DialogSequence` instance in a string.
 * @param {Struct.DialogSequence} dialog_sequence - The `DialogSequence` to serialize.
 * @param {Bool} [prettify] - Whether the output should be prettified (true) or collapsed (false).
 * @returns {String}
 */

function dialog_sequence_serialize(dialog_sequence, prettify = false)
{
  return dialog_sequence.__serialize(prettify);
}



/**
 * Transforms a string in a `DialogSequence` instance.
 * @param {String} data_string - The data to deserialize.
 * @returns {Struct.DialogSequence}
 */

function dialog_sequence_deserialize(data_string)
{
  return DialogSequence.__deserialize(data_string);
}












// ----------------------------------------------------------------------------












/**
 * `Dialog` constructor.
 * @param {String} text - The text message of the dialog.
 * @param {Constant.DIALOG} [settings_mask] - The dialog info.
 * @param {Array<Struct.DialogFX>} [fx_map] - The array of `DialogFX` to apply.
 * @returns {Struct.Dialog}
 */

function dialog_create(text, settings_mask = 0, fx_map = [])
{
  return new Dialog(
    text,
    settings_mask,
    is_array(fx_map) ? fx_map : [fx_map]
  );
}



/**
 * Creates a new `Dialog` object from an array.
 * @param {Array<Any>} data - The data of the object.
 * @returns {Struct.Dialog}
 */

function dialog_create_array(data)
{
  return dialog_create(data[0], data[1], data[2]);
}



/**
 * Creates a new `Dialog` object from a struct.
 * @param {Struct} data - The data of the object.
 * @returns {Struct.Dialog}
 */

function dialog_create_struct(data)
{
  return dialog_create(data.text, data.settings_mask, data.fx_map,);
}



/**
 * Transforms a `Dialog` instance in a string.
 * @param {Struct.Dialog} dialog - The dialog to serialize.
 * @param {Bool} [prettify] - Whether the output should be prettified (true) or collapsed (false).
 * @returns {String}
 */

function dialog_serialize(dialog, prettify = false)
{
  return dialog.__serialize(prettify);
}



/**
 * Transforms a string in a `Dialog` instance.
 * @param {String} data_string - The data to deserialize.
 * @returns {Struct.Dialog}
 */

function dialog_deserialize(data_string)
{
  return Dialog.__deserialize(data_string);
}












// ----------------------------------------------------------------------------












/**
 * `DialogFX` constructor.
 * @param {DIALOG_FX | Real} [settings_mask] - The effect info.
 * @param {Array<Any>} [argv] - The arguments of the mapped effect function.
 * @param {Function} [func] - The function to add to the dialog manager (NOT SERIALIZED).
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create(settings_mask = 0, argv = [], func = undefined)
{
  return new DialogFX(settings_mask, is_array(argv) ? argv : [argv], func);
}



/**
 * Creates a new `DialogFX` object from an array.
 * @param {Array} data - The data to create the `DialogFX` from.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create_array(data)
{
  return dialog_fx_create(data[0], data[1]);
}



/**
 * Creates a new `DialogFX` object from a struct.
 * @param {Struct} data - The data to create the `DialogFX` from.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create_struct(data)
{
  return dialog_fx_create(data.settings_mask, data.argv);
}



/**
 * Transforms a `DialogFX` instance in a string.
 * @param {Struct.DialogFX} dialog_fx - The dialog effect to serialize.
 * @param {Bool} [prettify] - Whether the output should be prettified (true) or collapsed (false).
 * @returns {String}
 */

function dialog_fx_serialize(dialog_fx, prettify = false)
{
  return dialog_fx.__serialize(prettify);
}



/**
 * Transforms a string in a `DialogFX` instance.
 * @param {String} data_string - The data to deserialize.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_deserialize(data_string)
{
  return DialogFX.__deserialize(data_string);
}
