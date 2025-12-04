/**
 * @desc Dialog management system utility library.
 * @link https://github.com/MaximilianVolt/GMS2_scripts/tree/main/modulus/dialog_manager
 * @author @MaximilianVolt
 * @version 0.9.1
 */



/**
 * @desc `DialogManager` constructor.
 * @param {String|Id.TextFile} [data_string] The data to parse.
 * @param {Bool} [is_file] Specifies whether `data_string` is a file (`true`) or not (`false`).
 * @returns {Struct.DialogManager}
 */

function dialog_manager_create(data_string = "", is_file = false)
{
  return new DialogManager(data_string, is_file);
}



/**
 * @desc Evaluates the `DialogLinkable` components' type and appends them after the last type's instance in a dialog manager.
 * @param {Struct.DialogManager} dialog_manager The dialog manager where to add the data.
 * @param {Struct.DialogLinkable|Array<Struct.DialogLinkable>} [dialog_linkable] The `DialogLinkable` components of the SAME TYPE to add.
 * @returns {Struct.DialogManager}
 */

function dialog_manager_add(dialog_manager, dialog_linkable = [])
{
  dialog_linkable = is_array(dialog_linkable) ? dialog_linkable : [dialog_linkable];

  if (is_instanceof(dialog_linkable[0], DialogScene))
    return dialog_manager.add(dialog_linkable);

  if (is_instanceof(dialog_linkable[0], DialogSequence))
    return dialog_manager.scene().add(dialog_linkable);

  if (is_instanceof(dialog_linkable[0], Dialog))
    return dialog_manager.sequence().add(dialog_linkable);

  return dialog_manager;
}



/**
 * @desc Makes the dialog manager advance of a specified shift. Produces side effects on dialog manager position and/or status. [CHAINABLE]
 * @param {Struct.DialogManager} dialog_manager The dialog manager to cycle through.
 * @param {Real} [shift] The number of units to advance of. Defaults to `1`.
 * @param {Constant.DIALOG_MANAGER|Real} [jump_options] The settings mask for the jump.
 * @param {Any|Array<Any>} [argv] The argument(s) to pass to eventual dialog effects.
 * @param {Constant.DIALOG_MANAGER|Real|Struct.DialogLinkable} [prev_position] The starting position of the advancement. Defaults to the current one.
 * @returns {Struct.DialogManager}
 */

function dialog_manager_advance(dialog_manager, shift = 1, jump_options = 0, argv = undefined, prev_position = self.position)
{
  return dialog_manager.advance(shift, jump_options, argv, prev_position);
}



/**
 * @desc Simulates advancing the dialog manager without state modifications. Temporarily modifies position and status to compute the result to then reset them to their previous values.
 * @param {Struct.DialogManager} dialog_manager The dialog manager to cycle through.
 * @param {Real} [shift] The number of units to advance of. Defaults to `1`.
 * @param {Constant.DIALOG_MANAGER|Real} [jump_options] The settings mask for the jump.
 * @param {Any|Array<Any>} [argv] The argument(s) to pass to eventual dialog effects.
 * @param {Constant.DIALOG_MANAGER|Real|Struct.DialogLinkable} [start_position] The starting position of the forecast. Defaults to the current one.
 * @returns {Struct} { dialog: Struct.Dialog, position: Real status: Real }
 */

function dialog_manager_forecast(dialog_manager, shift = 1, jump_options = 0, argv = undefined, prev_position = self.position)
{
  return dialog_manager.forecast(shift, jump_options, argv, prev_position);
}



/**
 * @desc Returns a list of all components from an element matching a tag.
 * @param {Struct.DialogManager|Struct.DialogLinkable} collection The collection where to execute the search.
 * @param {Constant.DIALOG_SCENE|Constant.DIALOG_SEQUENCE|Constant.DIALOG|Real} tag The tag to search for.
 * @returns {Array<Struct.DialogLinkable}
 */

function dialog_manager_search_by_tag(collection, tag)
{
  if (is_instanceof(collection, DialogManager))
    return collection.__get_scenes_by_tag(tag);

  if (is_instanceof(collection, DialogScene))
    return collection.__get_sequences_by_tag(tag);

  if (is_instanceof(collection, DialogSequence))
    return collection.__get_dialogs_by_tag(tag);

  return collection;
}



/**
 * @desc Transforms a `DialogManager` instance in a string.
 * @param {Struct.DialogScene} dialog_manager The `DialogManager` to serialize.
 * @param {Bool} [prettify] Whether the output should be prettified (true) or collapsed (false).
 * @returns {String}
 */

function dialog_manager_serialize(dialog_manager, prettify = false)
{
  return dialog_manager.serialize(prettify);
}



/**
 * @desc Transforms a string into an array of `DialogScene` objects to assign to a `DialogManager` instance.
 * @param {Struct.DialogManager} dialog_manager The dialog manager where to assign the data.
 * @param {String} data_string The data to deserialize.
 * @param {Bool} [is_file] Specifies whether the data string is a file name to read from (`true`) or not (`false`). Defaults to `false`.
 * @returns {Struct.DialogManager}
 */

function dialog_manager_deserialize(dialog_manager, data_string, is_file = false)
{
  return dialog_manager.deserialize(data_string, is_file);
}



/**
 * @desc Converts an array of raw data into an array of `DialogScene` objects.
 * @param {Struct.DialogManager} dialog_manager The dialog manager where to add the parsed data.
 * @param {Array<Struct>} scenes The parsed scenes to convert and add.
 * @returns {Struct.DialogManager}
 */

function dialog_manager_parse(dialog_manager, scenes)
{
  return dialog_manager.parse(scenes);
}












// ----------------------------------------------------------------------------












/**
 * @desc DialogScene` constructor.
 * @param {Struct.DialogSequence|Array<Struct.DialogSequence>} [sequences] The array of `DialogSequence` of the scene.
 * @param {Constant.DIALOG_SCENE|Real} [settings_mask] The scene settings.
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
 * @param {Array<Any>} data The data of the object.
 * @returns {Struct.DialogScene}
 */

function dialog_scene_create_from_array(data)
{
  return dialog_scene_create(data[0], data[1]);
}



/**
 * @desc Creates a new `DialogScene` object from a struct.
 * @param {Struct} data The data of the object.
 * @returns {Struct.DialogScene}
 */

function dialog_scene_create_from_struct(data)
{
  return dialog_scene_create(data.sequences, data.settings_mask);
}



/**
 * @desc Transforms a `DialogScene` instance in a string.
 * @param {Struct.DialogScene} dialog_scene The `DialogScene` to serialize.
 * @param {Bool} [prettify] Whether the output should be prettified (true) or collapsed (false).
 * @returns {String}
 */

function dialog_scene_serialize(dialog_scene, prettify = false)
{
  return dialog_scene.__serialize(prettify);
}



/**
 * @desc Transforms a string in a `DialogScene` instance.
 * @param {String} data_string The data to deserialize.
 * @returns {Struct.DialogScene}
 */

function dialog_scene_deserialize(data_string)
{
  return DialogScene.__deserialize(data_string);
}












// ----------------------------------------------------------------------------












/**
 * @desc `DialogSequence` constructor.
 * @param {Struct.Dialog|Array<Struct.Dialog>} [dialogs] The array of `Dialog` of the sequence.
 * @param {Constant.DIALOG_SEQUENCE|Real} [settings_mask] The sequence info.
 * @param {Array<Real>} [speakers] The indices of the speakers.
 * @returns {Struct.DialogSequence}
 */

function dialog_sequence_create(dialogs = [], settings_mask = 0, speakers = [])
{
  return new DialogSequence(
    is_array(dialogs) ? dialogs : [dialogs],
    settings_mask,
    is_array(speakers) ? speakers : [speakers]
  );
}



/**
 * @desc Creates a new `DialogSequence` object from an array.
 * @param {Array<Any>} data The data of the object.
 * @returns {Struct.DialogSequence}
 */

function dialog_sequence_create_from_array(data)
{
  return dialog_sequence_create(data[0], data[1], data[2]);
}



/**
 * @desc Creates a new `DialogSequence` object from a struct.
 * @param {Struct} data The data of the object.
 * @returns {Struct.DialogSequence}
 */

function dialog_sequence_create_from_struct(data)
{
  return dialog_sequence_create(data.dialogs, data.settings_mask, data.speakers);
}



/**
 * @desc Transforms a `DialogSequence` instance in a string.
 * @param {Struct.DialogSequence} dialog_sequence The `DialogSequence` to serialize.
 * @param {Bool} [prettify] Whether the output should be prettified (true) or collapsed (false).
 * @returns {String}
 */

function dialog_sequence_serialize(dialog_sequence, prettify = false)
{
  return dialog_sequence.__serialize(prettify);
}



/**
 * @desc Transforms a string in a `DialogSequence` instance.
 * @param {String} data_string The data to deserialize.
 * @returns {Struct.DialogSequence}
 */

function dialog_sequence_deserialize(data_string)
{
  return DialogSequence.__deserialize(data_string);
}












// ----------------------------------------------------------------------------












/**
 * @desc `Dialog` constructor.
 * @param {String} text The text message of the dialog.
 * @param {Constant.DIALOG|Real} [settings_mask] The dialog info.
 * @param {Struct.DialogFX|Array<Struct.DialogFX>} [fx_map] The array of `DialogFX` to apply.
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
 * @param {Array<Any>} data The data of the object.
 * @returns {Struct.Dialog}
 */

function dialog_create_from_array(data)
{
  return dialog_create(data[0], data[1], data[2]);
}



/**
 * @desc Creates a new `Dialog` object from a struct.
 * @param {Struct} data The data of the object.
 * @returns {Struct.Dialog}
 */

function dialog_create_from_struct(data)
{
  return dialog_create(data.text, data.settings_mask, data.fx_map);
}



/**
 * @desc Creates a dialog linked to the specified choice fx.
 * @param {Array<Any>} dialog_args The arguments to create the dialog with.
 * @param {Struct.DialogFX} fx The effect to link the dialog to.
 * @param {String} prompt The choice's option text.
 * @param {Real} [index] The specific index where to insert the new option in the choice list. Defaults to list length.
 * @param {Constant.DIALOG_FX|Real} [settings_mask] The settings mask for the choice effect.
 * @returns {Struct.Dialog}
 */

function dialog_create_from_choice(dialog_args, fx, prompt, index = array_length(fx.argv), settings_mask = 0)
{
  for (var arg = array_length(dialog_args); arg < Dialog.CONSTRUCTOR_ARGC; ++arg)
    dialog_args[arg] = undefined;

  return dialog_create_from_array(dialog_args).derive(fx, prompt, index, settings_mask);
}



/**
 * @desc Checks whether the specified `Dialog` object contains `DialogFX` objects of the specified type.
 * @param {Struct.Dialog} dialog The dialog to check.
 * @param {Constant.DIALOG_FX|Real} [type] The type of the effect to check for.
 * @returns {Bool}
 */

function dialog_has_fx_of_type(dialog, type = DIALOG_FX.TYPE_DEFAULT)
{
  return dialog.__fx_has_of(function(fx, argv) { return fx.type() == argv; }, type);
}



/**
 * @desc Retrieves all dialog FX which match a filter.
 * @param {Struct.Dialog} dialog The dialog where the effects should be retrieved from.
 * @param {Function} [filter_fn] The predicate to test against each FX. Defaults to `true`.
 * @param {Any|Array<Any>} [argv] The arguments to pass to the effects.
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
 * @param {Struct.Dialog} dialog The dialog to serialize.
 * @param {Bool} [prettify] Whether the output should be prettified (true) or collapsed (false).
 * @returns {String}
 */

function dialog_serialize(dialog, prettify = false)
{
  return dialog.__serialize(prettify);
}



/**
 * @desc Transforms a string in a `Dialog` instance.
 * @param {String} data_string The data to deserialize.
 * @returns {Struct.Dialog}
 */

function dialog_deserialize(data_string)
{
  return Dialog.__deserialize(data_string);
}












// ----------------------------------------------------------------------------












/**
 * @desc `DialogFX` constructor.
 * @param {Constant.DIALOG_FX|Real} [settings_mask] The effect info.
 * @param {Any|Array<Any>} [argv] The arguments of the mapped effect function.
 * @param {Function} [func] The function to add to the dialog manager (NOT SERIALIZED).
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create(settings_mask = 0, argv = [], func = undefined)
{
  return new DialogFX(settings_mask, is_array(argv) ? argv : [argv], func);
}



/**
 * @desc Creates a jump dialog effect.
 * @param {Constant.DIALOG_MANAGER|Real|Struct.DialogLinkable} jump_position The position to jump to.
 * @param {Constant.DIALOG_MANAGER|Real} [jump_settings] The settings mask for the jump effect.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create_jump(jump_position, jump_settings = 0)
{
  return dialog_fx_create(
    DialogFX.type(DIALOG_FX.TYPE_JUMP),
    [[jump_position, jump_settings]]
  );
}



/**
 * @desc Creates a fallback dialog effect.
 * @param {Function} fx_condition_function The condition function to evaluate.
 * @param {Array} [argv] The additional arguments to pass to the condition function.
 * @param {Constant.DIALOG_MANAGER|Real|Struct.DialogLinkable} jump_position The position to jump to if the condition is met.
 * @param {Constant.DIALOG_MANAGER|Real} [jump_settings] The settings mask for the jump effect.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create_fallback(fx_condition_function, argv, jump_position, jump_settings = 0)
{
  return dialog_fx_create(
    DialogFX.type(DIALOG_FX.TYPE_FALLBACK),
    [[jump_position, jump_settings], fx_condition_function, is_array(argv) ? argv : [argv]],
  );
}



/**
 * @desc Creates a fallback dialog effect using a pre-defined condition index.
 * @param {Real} fx_condition_index The index of the condition to evaluate.
 * @param {Function} fx_condition_function The condition function to evaluate.
 * @param {Array} [argv] The additional arguments to pass to the condition function.
 * @param {Constant.DIALOG_MANAGER|Real|Struct.DialogLinkable} jump_position The position to jump to if the condition is met.
 * @param {Constant.DIALOG_MANAGER|Real} [jump_settings] The settings mask for the jump effect.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create_fallback_indexed(fx_condition_index, fx_condition_function, argv, jump_position, jump_settings = 0)
{
  return dialog_fx_create(
    DialogFX.type(DIALOG_FX.TYPE_FALLBACK),
    [[jump_position, jump_settings], fx_condition_index, is_array(argv) ? argv : [argv]],
    fx_condition_function
  );
}



/**
 * @desc Creates a choice dialog effect.
 * @param {Array<Any>} choice_options The array of choice options.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create_choice(choice_options = [])
{
  return dialog_fx_create(
    DialogFX.type(DIALOG_FX.TYPE_CHOICE),
    choice_options
  );
}



/**
 * @desc Creates a choice option for a choice dialog effect.
 * @param {String} prompt The choice's option text.
 * @param {Constant.DIALOG_MANAGER|Real|Struct.DialogLinkable} jump_position The position to jump to if the option is selected.
 * @param {Constant.DIALOG_MANAGER|Real} [jump_settings] The settings mask for the jump data.
 * @param {Constant.DIALOG_FX|Real} [settings_mask] The settings mask for the choice effect.
 * @returns {Array<Any>}
 */

function dialog_fx_create_choice_option(prompt, jump_position, jump_settings = 0, settings_mask = 0)
{
  return [[jump_position, jump_settings], prompt, settings_mask];
}



/**
 * @desc Creates a new `DialogFX` object from an array.
 * @param {Array} data The data to create the `DialogFX` from.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create_from_array(data)
{
  return dialog_fx_create(data[0], data[1]);
}



/**
 * @desc Creates a new `DialogFX` object from a struct.
 * @param {Struct} data The data to create the `DialogFX` from.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create_from_struct(data)
{
  return dialog_fx_create(data.settings_mask, data.argv);
}



/**
 * @desc Executes a dialog FX.
 * @param {Struct.DialogFX} dialog_fx The dialog FX to execute.
 * @param {Struct.Dialog} parent The parent dialog of the effect.
 * @param {Any|Array<Any>} [argv] The arguments to pass to the effect.
 * @returns {Any}
 */

function dialog_fx_execute(dialog_fx, parent, argv = undefined)
{
  return dialog_fx.__exec(parent, argv);
}



/**
 * @desc Transforms a `DialogFX` instance in a string.
 * @param {Struct.DialogFX} dialog_fx The dialog effect to serialize.
 * @param {Bool} [prettify] Whether the output should be prettified (true) or collapsed (false).
 * @returns {String}
 */

function dialog_fx_serialize(dialog_fx, prettify = false)
{
  return dialog_fx.__serialize(prettify);
}



/**
 * @desc Transforms a string in a `DialogFX` instance.
 * @param {String} data_string The data to deserialize.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_deserialize(data_string)
{
  return DialogFX.__deserialize(data_string);
}
