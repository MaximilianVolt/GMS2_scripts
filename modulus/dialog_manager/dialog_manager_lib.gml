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
 * @param {Struct.DialogLinkable | Array<Struct.DialogLinkable>} [dialog_linkable] The `DialogLinkable` components of the SAME TYPE to add.
 * @param {Struct.DialogManager} dialog_manager The dialog manager where to add the data.
 * @returns {Struct.DialogManager}
 */

function dialog_manager_add(dialog_manager, dialog_linkable = [])
{
  dialog_linkable = is_array(dialog_linkable) ? dialog_linkable : [dialog_linkable];

  if (is_instanceof(dialog_linkable[0], DialogScene))
    return dialog_manager.__add_scenes(dialog_linkable);

  if (is_instanceof(dialog_linkable[0], DialogSequence))
    return dialog_manager.__add_sequences(dialog_linkable);

  if (is_instanceof(dialog_linkable[0], Dialog))
    return dialog_manager.__add_dialogs(dialog_linkable);

  return dialog_manager;
}



/**
 * @desc Makes the dialog manager advance a given number of dialogs.
 * @param {Struct.DialogManager} dialog_manager The dialog manager to cycle through.
 * @param {Real} [idx_shift] The number of dialogs to advance of. Defaults to `1`.
 * @param {Bool} [already_initialized] Whether the dialog manager is already initialized (`true`) or not (`false`).
 * @returns {Struct.DialogManager}
 */

function dialog_manager_advance(dialog_manager, idx_shift = 1, already_initialized = true)
{
  return dialog_manager.__advance(idx_shift, already_initialized);
}



/**
 * @desc Transforms a `DialogManager` instance in a string.
 * @param {Struct.DialogScene} dialog_manager - The `DialogManager` to serialize.
 * @param {Bool} [prettify] - Whether the output should be prettified (true) or collapsed (false).
 * @returns {String}
 */

function dialog_manager_serialize(dialog_manager, prettify = false)
{
  return dialog_manager.__serialize(prettify);
}



/**
 * @desc Transforms a string into an array of `DialogScene` objects to assign to a `DialogManager` instance.
 * @param {Struct.DialogManager} dialog_manager The dialog manager where to assign the data.
 * @param {String} data_string - The data to deserialize.
 * @param {Bool} [is_file] - Specifies whether the data string is a file name to read from (`true`) or not (`false`). Defaults to `false`.
 * @returns {Struct.DialogManager}
 */

function dialog_manager_deserialize(dialog_manager, data_string, is_file = false)
{
  return dialog_manager.__deserialize(data_string, is_file);
}



/**
 * @desc Converts an array of raw data into an array of `DialogScene` objects.
 * @param {Struct.DialogManager} dialog_manager The dialog manager where to add the parsed data.
 * @param {Array<Struct>} scenes The parsed scenes to convert and add.
 * @returns {Struct.DialogManager}
 */

function dialog_manager_parse(dialog_manager, scenes)
{
  return dialog_manager.__parse(scenes);
}












// ----------------------------------------------------------------------------












/**
 * @desc DialogScene` constructor.
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
 * @desc Creates a new `DialogScene` object from an array.
 * @param {Array<Any>} data - The data of the object.
 * @returns {Struct.DialogScene}
 */

function dialog_scene_create_array(data)
{
  return dialog_scene_create(data[0], data[1]);
}



/**
 * @desc Creates a new `DialogScene` object from a struct.
 * @param {Struct} data - The data of the object.
 * @returns {Struct.DialogScene}
 */

function dialog_scene_create_struct(data)
{
  return dialog_scene_create(data.sequences, data.settings_mask);
}



/**
 * @desc Transforms a `DialogScene` instance in a string.
 * @param {Struct.DialogScene} dialog_scene - The `DialogScene` to serialize.
 * @param {Bool} [prettify] - Whether the output should be prettified (true) or collapsed (false).
 * @returns {String}
 */

function dialog_scene_serialize(dialog_scene, prettify = false)
{
  return dialog_scene.__serialize(prettify);
}



/**
 * @desc Transforms a string in a `DialogScene` instance.
 * @param {String} data_string - The data to deserialize.
 * @returns {Struct.DialogScene}
 */

function dialog_scene_deserialize(data_string)
{
  return DialogScene.__deserialize(data_string);
}












// ----------------------------------------------------------------------------












/**
 * @desc `DialogSequence` constructor.
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
 * @desc Creates a new `DialogSequence` object from an array.
 * @param {Array<Any>} data - The data of the object.
 * @returns {Struct.DialogSequence}
 */

function dialog_sequence_create_array(data)
{
  return dialog_sequence_create(data[0], data[1]);
}



/**
 * @desc Creates a new `DialogSequence` object from a struct.
 * @param {Struct} data - The data of the object.
 * @returns {Struct.DialogSequence}
 */

function dialog_sequence_create_struct(data)
{
  return dialog_sequence_create(data.dialogs, data.speaker_map);
}



/**
 * @desc Transforms a `DialogSequence` instance in a string.
 * @param {Struct.DialogSequence} dialog_sequence - The `DialogSequence` to serialize.
 * @param {Bool} [prettify] - Whether the output should be prettified (true) or collapsed (false).
 * @returns {String}
 */

function dialog_sequence_serialize(dialog_sequence, prettify = false)
{
  return dialog_sequence.__serialize(prettify);
}



/**
 * @desc Transforms a string in a `DialogSequence` instance.
 * @param {String} data_string - The data to deserialize.
 * @returns {Struct.DialogSequence}
 */

function dialog_sequence_deserialize(data_string)
{
  return DialogSequence.__deserialize(data_string);
}












// ----------------------------------------------------------------------------












/**
 * @desc `Dialog` constructor.
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
 * @desc Creates a new `Dialog` object from an array.
 * @param {Array<Any>} data - The data of the object.
 * @returns {Struct.Dialog}
 */

function dialog_create_array(data)
{
  return dialog_create(data[0], data[1], data[2]);
}



/**
 * @desc Creates a new `Dialog` object from a struct.
 * @param {Struct} data - The data of the object.
 * @returns {Struct.Dialog}
 */

function dialog_create_struct(data)
{
  return dialog_create(data.text, data.settings_mask, data.fx_map,);
}



/**
 * @desc Retrieves all dialog FX which match a filter.
 * @param {Struct.Dialog} dialog The dialog where the effects should be retrieved from.
 * @param {Function} [filter_fn] The predicate to test against each FX. Defaults to `true`.
 * @param {Array} [argv] The arguments to pass to the effects.
 * @returns {Array<Struct.DialogFX>}
 */

function dialog_get_fx_all_of(dialog, filter_fn = function(fx, argv) { return true; }, argv = undefined)
{
  return dialog.__fx_get_all_of(filter_fn, argv);
}



/**
 * @desc Executes all dialog FX which match a filter.
 * @param {Struct.Dialog} dialog The dialog that should execute all the effects.
 * @param {Function} [filter_fn] The predicate to test against each FX. Defaults to `true`.
 * @param {Array} [argv] The arguments to pass to the effects.
 * @returns {Struct.Dialog}
 */

function dialog_execute_fx_all_of(dialog, filter_fn = function(fx, argv) { return true; }, argv = undefined)
{
  return dialog.__fx_execute_all_of(filter_fn, argv);
}



/**
 * @desc Transforms a `Dialog` instance in a string.
 * @param {Struct.Dialog} dialog - The dialog to serialize.
 * @param {Bool} [prettify] - Whether the output should be prettified (true) or collapsed (false).
 * @returns {String}
 */

function dialog_serialize(dialog, prettify = false)
{
  return dialog.__serialize(prettify);
}



/**
 * @desc Transforms a string in a `Dialog` instance.
 * @param {String} data_string - The data to deserialize.
 * @returns {Struct.Dialog}
 */

function dialog_deserialize(data_string)
{
  return Dialog.__deserialize(data_string);
}












// ----------------------------------------------------------------------------












/**
 * @desc `DialogFX` constructor.
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
 * @desc Creates a new `DialogFX` object from an array.
 * @param {Array} data - The data to create the `DialogFX` from.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create_array(data)
{
  return dialog_fx_create(data[0], data[1]);
}



/**
 * @desc Creates a new `DialogFX` object from a struct.
 * @param {Struct} data - The data to create the `DialogFX` from.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create_struct(data)
{
  return dialog_fx_create(data.settings_mask, data.argv);
}



/**
 * @desc Executes a dialog FX.
 * @param {Struct.DialogFX} dialog_fx The dialog FX to execute.
 * @param {undefined | Array} [argv] The arguments to pass to the effect.
 * @returns {Any}
 */

function dialog_fx_execute(dialog_fx, argv = undefined)
{
  return dialog_fx.__exec(argv);
}



/**
 * @desc Transforms a `DialogFX` instance in a string.
 * @param {Struct.DialogFX} dialog_fx - The dialog effect to serialize.
 * @param {Bool} [prettify] - Whether the output should be prettified (true) or collapsed (false).
 * @returns {String}
 */

function dialog_fx_serialize(dialog_fx, prettify = false)
{
  return dialog_fx.__serialize(prettify);
}



/**
 * @desc Transforms a string in a `DialogFX` instance.
 * @param {String} data_string - The data to deserialize.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_deserialize(data_string)
{
  return DialogFX.__deserialize(data_string);
}
