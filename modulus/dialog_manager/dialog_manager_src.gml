/**
 * @desc A lightweight, bitmask-focused dialog management system.
 * @link https://github.com/MaximilianVolt/GMS2_scripts/tree/main/modulus/dialog_manager
 * @author @MaximilianVolt
 * @version 0.10.0
*/



#macro __DIALOG_MANAGER_SERIALIZER_METHOD__   __struct      // Must be <__struct> or <__array>
#macro __DIALOG_MANAGER_DESERIALIZER_METHOD__ __from_struct // Must be <__from_struct> or <__from_array>











// ----------------------------------------------------------------------------












/**
 * @desc `DialogRunner` constructor.
 * @param dialog_manager The dialog manager to run on.
 * @returns {Struct.DialogRunner}
 */

function dialog_runner_create(dialog_manager)
{
  return new DialogRunner(dialog_manager);
}












// ----------------------------------------------------------------------------












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
  return dialog_scene_create(data[DIALOG_SCENE.ARG_SEQUENCES], data[DIALOG_SCENE.ARG_SETTINGS_MASK]);
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
  return dialog_sequence_create(data[DIALOG_SEQUENCE.ARG_DIALOGS], data[DIALOG_SEQUENCE.ARG_SETTINGS_MASK], data[DIALOG_SEQUENCE.ARG_SPEAKERS]);
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
  return dialog_create(data[DIALOG.ARG_TEXT], data[DIALOG.ARG_SETTINGS_MASK], data[DIALOG.ARG_FX_MAP]);
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












// ----------------------------------------------------------------------------












/**
 * @desc `DialogFX` constructor.
 * @param {Constant.DIALOG_FX|Real} [settings_mask] The effect info.
 * @param {Any|Array<Any>} [argv] The arguments of the mapped effect function.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create(settings_mask = 0, argv = [])
{
  return new DialogFX(settings_mask, is_array(argv) ? argv : [argv]);
}



/**
 * @desc Creates a flow option for a flow resolutor dialog effect.
 * @param {Constant.DIALOG_MANAGER|Real|Struct.DialogLinkable} jump_position The jump option destination.
 * @param {Constant.DIALOG_RUNNER|Real} [jump_settings] The settings mask for the jump data.
 * @param {String} [prompt] The flow option's text.
 * @param {Constant.DIALOG_FX|Real} [jump_metadata_settings] Extra bitmask data about the flow option.
 * @returns {Array}
 */

function dialog_fx_create_flow_option(jump_position, jump_settings = 0, prompt = undefined, jump_metadata_settings = 0)
{
  return DialogFX.__create_option_flow(jump_position, jump_settings, prompt, jump_metadata_settings);
}



/**
 * @desc Creates a jump dialog effect.
 * @param {Constant.DIALOG_FX|Real} [settings_mask] The effect info.
 * @param {Constant.DIALOG_MANAGER|Real|Struct.DialogLinkable} [flow_option] The jump option's data.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create_jump(settings_mask = 0, flow_option = undefined)
{
  return new DialogFX(
    DialogFX.type(DIALOG_FX.TYPE_FLOWRES_JUMP) | settings_mask,
    [[flow_option], undefined, undefined, undefined, undefined]
  );
}



/**
 * @desc Creates a dispatch dialog effect.
 * @param {Constant.DIALOG_FX|Real} [settings_mask] The effect info.
 * @param {Array} [flow_options] The jump options' data.
 * @param {Constant.DIALOG_FX|Real} [fx_indexer_index] The indexer function index to evaluate.
 * @param {Array} [fx_indexer_argv] The arguments of the indexer function.
 * @param {Constant.DIALOG_FX|Real} [fx_condition_index] The condition function index to evaluate.
 * @param {Array} [fx_condition_argv] The additional arguments to pass to the condition function.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create_dispatch(settings_mask = 0, flow_options = [], fx_indexer_index = undefined, fx_condition_index = undefined,  fx_indexer_argv = [], fx_condition_argv = [])
{
  return new DialogFX(
    DialogFX.type(DIALOG_FX.TYPE_FLOWRES_DISPATCH) | settings_mask,
    [flow_options, fx_indexer_index, fx_condition_index, fx_indexer_argv, fx_condition_argv]
  );
}



/**
 * @desc Creates a fallback dialog effect.
 * @param {Constant.DIALOG_FX|Real} [settings_mask] The effect info.
 * @param {Constant.DIALOG_MANAGER|Real|Struct.DialogLinkable} [flow_option] The jump option's data.
 * @param {Constant.DIALOG_FX|Real} [fx_condition_index] The condition function index to evaluate.
 * @param {Array} [fx_condition_argv] The additional arguments to pass to the condition function.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create_fallback(settings_mask = 0, flow_option = undefined, fx_condition_index = undefined, fx_condition_argv = [])
{
  return new DialogFX(
    DialogFX.type(DIALOG_FX.TYPE_FLOWRES_FALLBACK) | settings_mask,
    [[flow_option], undefined, fx_condition_index, undefined, fx_condition_argv]
  );
}



/**
 * @desc Creates a choice dialog effect.
 * @param {Constant.DIALOG_FX|Real} [settings_mask] The effect info.
 * @param {Array} [flow_options] The array of choice options.
 * @param {Constant.DIALOG_FX|Real} [fx_indexer_index] The indexer function index to evaluate.
 * @param {Array} [fx_indexer_argv] The arguments of the indexer function.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create_choice(settings_mask = 0, flow_options = [], fx_indexer_index = DIALOG_FX.FUNC_INDEXER_RUNNER_CHOICE_INDEX, fx_indexer_argv = [])
{
  return new DialogFX(
    DialogFX.type(DIALOG_FX.TYPE_FLOWRES_CHOICE) | settings_mask,
    [flow_options, fx_indexer_index, undefined, fx_indexer_argv, undefined]
  );
}



/**
 * @desc Creates a new `DialogFX` object from an array.
 * @param {Array} data The data to create the `DialogFX` from.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create_from_array(data)
{
  return dialog_fx_create(data[DIALOG_FX.ARG_SETTINGS_MASK], data[DIALOG_FX.ARG_ARGV]);
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












// ----------------------------------------------------------------------------













// Self-initialization
gml_pragma(
  "global",
  "new DialogRunner(undefined); new DialogManager(\"\", false); new DialogScene([], 0); new DialogSequence([], 0, []); new Dialog(\"\", 0, []); new DialogFX(0, []);"
);



/**
 * @desc `__BITMASK_*` settings are used to manage bitmasks and should not be referenced directly.
 * @desc `STATUS_*` flags refer to possible positioning/execution states of the dialog runner.
 * @desc `JUMP_SETTING_*` options refer to jump effect settings.
 */

enum DIALOG_RUNNER // Should not edit
{
  // Argument positions
  ARG_DIALOG_MANAGER = 0,
  ARG_COUNT,

  // Status info indices
  __BITMASK_FLAG_INDEX_STATUS_UNINITIALIZED = 0,
  __BITMASK_FLAG_INDEX_STATUS_FIRST_DIALOG,
  __BITMASK_FLAG_INDEX_STATUS_FIRST_SEQUENCE,
  __BITMASK_FLAG_INDEX_STATUS_FIRST_SCENE,
  __BITMASK_FLAG_INDEX_STATUS_FIRST_OF_SEQUENCE,
  __BITMASK_FLAG_INDEX_STATUS_FIRST_OF_SCENE,
  __BITMASK_FLAG_INDEX_STATUS_MIDDLE_OF_SEQUENCE,
  __BITMASK_FLAG_INDEX_STATUS_MIDDLE_OF_SCENE,
  __BITMASK_FLAG_INDEX_STATUS_MIDDLE_SCENE,
  __BITMASK_FLAG_INDEX_STATUS_LAST_DIALOG,
  __BITMASK_FLAG_INDEX_STATUS_LAST_SEQUENCE,
  __BITMASK_FLAG_INDEX_STATUS_LAST_SCENE,
  __BITMASK_FLAG_INDEX_STATUS_LAST_OF_SEQUENCE,
  __BITMASK_FLAG_INDEX_STATUS_LAST_OF_SCENE,
  __BITMASK_STATUS_NO_AUTORESET_COUNT,
  __BITMASK_FLAG_INDEX_STATUS_ADVANCED_DIALOG = DIALOG_RUNNER.__BITMASK_STATUS_NO_AUTORESET_COUNT,
  __BITMASK_FLAG_INDEX_STATUS_ADVANCED_SEQUENCE,
  __BITMASK_FLAG_INDEX_STATUS_ADVANCED_SCENE,
  __BITMASK_FLAG_INDEX_STATUS_RECEDED_DIALOG,
  __BITMASK_FLAG_INDEX_STATUS_RECEDED_SEQUENCE,
  __BITMASK_FLAG_INDEX_STATUS_RECEDED_SCENE,
  __BITMASK_FLAG_INDEX_STATUS_MAINTAINED_DIALOG,
  __BITMASK_FLAG_INDEX_STATUS_MAINTAINED_SEQUENCE,
  __BITMASK_FLAG_INDEX_STATUS_MAINTAINED_SCENE,
  __BITMASK_FLAG_INDEX_STATUS_EXECUTED_JUMP,
  __BITMASK_FLAG_INDEX_STATUS_EXECUTED_DISPATCH,
  __BITMASK_FLAG_INDEX_STATUS_EXECUTED_FALLBACK,
  __BITMASK_FLAG_INDEX_STATUS_EXECUTED_CHOICE,
  FLAG_STATUS_COUNT,

  // Status info values
  STATUS_UNINITIALIZED       = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_UNINITIALIZED,
  STATUS_FIRST_DIALOG        = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_FIRST_DIALOG,
  STATUS_FIRST_SEQUENCE      = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_FIRST_SEQUENCE,
  STATUS_FIRST_SCENE         = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_FIRST_SCENE,
  STATUS_FIRST_OF_SEQUENCE   = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_FIRST_OF_SEQUENCE,
  STATUS_FIRST_OF_SCENE      = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_FIRST_OF_SCENE,
  STATUS_MIDDLE_OF_SEQUENCE  = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_MIDDLE_OF_SEQUENCE,
  STATUS_MIDDLE_OF_SCENE     = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_MIDDLE_OF_SCENE,
  STATUS_MIDDLE_SCENE        = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_MIDDLE_SCENE,
  STATUS_LAST_DIALOG         = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_LAST_DIALOG,
  STATUS_LAST_SEQUENCE       = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_LAST_SEQUENCE,
  STATUS_LAST_SCENE          = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_LAST_SCENE,
  STATUS_LAST_OF_SEQUENCE    = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_LAST_OF_SEQUENCE,
  STATUS_LAST_OF_SCENE       = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_LAST_OF_SCENE,
  STATUS_ADVANCED_DIALOG     = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_ADVANCED_DIALOG,
  STATUS_ADVANCED_SEQUENCE   = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_ADVANCED_SEQUENCE,
  STATUS_ADVANCED_SCENE      = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_ADVANCED_SCENE,
  STATUS_RECEDED_DIALOG      = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_RECEDED_DIALOG,
  STATUS_RECEDED_SEQUENCE    = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_RECEDED_SEQUENCE,
  STATUS_RECEDED_SCENE       = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_RECEDED_SCENE,
  STATUS_MAINTAINED_DIALOG   = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_MAINTAINED_DIALOG,
  STATUS_MAINTAINED_SEQUENCE = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_MAINTAINED_SEQUENCE,
  STATUS_MAINTAINED_SCENE    = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_MAINTAINED_SCENE,
  STATUS_EXECUTED_JUMP       = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_EXECUTED_JUMP,
  STATUS_EXECUTED_DISPATCH   = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_EXECUTED_DISPATCH,
  STATUS_EXECUTED_FALLBACK   = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_EXECUTED_FALLBACK,
  STATUS_EXECUTED_CHOICE     = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_EXECUTED_CHOICE,

  // Status masks
  __BITMASK_STATUS_AUTORESET_COUNT = DIALOG_RUNNER.FLAG_STATUS_COUNT - DIALOG_RUNNER.__BITMASK_STATUS_NO_AUTORESET_COUNT,
  __BITMASK_STATUS_NO_AUTORESET_MASK = (1 << DIALOG_RUNNER.__BITMASK_STATUS_NO_AUTORESET_COUNT) - 1,
  __BITMASK_STATUS_AUTORESET_MASK = ((1 << DIALOG_RUNNER.__BITMASK_STATUS_AUTORESET_COUNT) - 1) << DIALOG_RUNNER.__BITMASK_STATUS_NO_AUTORESET_COUNT,
  __BITMASK_STATUS_MASK = (1 << DIALOG_RUNNER.FLAG_STATUS_COUNT) - 1,

  // Jump settings
  JUMP_TYPE_ABSOLUTE = 0,
  JUMP_TYPE_RELATIVE,
  __BITMASK_MASK_JUMP_SETTING_RESOLUTION_SHIFT = 0,
  __BITMASK_MASK_JUMP_SETTING_TYPE_SHIFT = DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_RESOLUTION_SHIFT,
  __BITMASK_MASK_JUMP_SETTING_TYPE_BITS = 1,
  __BITMASK_MASK_JUMP_SETTING_TYPE_MASK = ((1 << DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_TYPE_BITS) - 1) << DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_TYPE_SHIFT,
  JUMP_SETTING_TYPE_ABSOLUTE = DIALOG_RUNNER.JUMP_TYPE_ABSOLUTE << DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_TYPE_SHIFT,
  JUMP_SETTING_TYPE_RELATIVE = DIALOG_RUNNER.JUMP_TYPE_RELATIVE << DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_TYPE_SHIFT,
  JUMP_UNIT_DIALOG = 0,
  JUMP_UNIT_SEQUENCE,
  JUMP_UNIT_SCENE,
  __BITMASK_MASK_JUMP_SETTING_UNIT_SHIFT = DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_TYPE_SHIFT + DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_TYPE_BITS,
  __BITMASK_MASK_JUMP_SETTING_UNIT_BITS = 2,
  __BITMASK_MASK_JUMP_SETTING_UNIT_MASK = ((1 << DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_UNIT_BITS) - 1) << DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_UNIT_SHIFT,
  JUMP_SETTING_UNIT_DIALOG = DIALOG_RUNNER.JUMP_UNIT_DIALOG << DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_UNIT_SHIFT | DIALOG_RUNNER.JUMP_SETTING_TYPE_RELATIVE,
  JUMP_SETTING_UNIT_SEQUENCE = DIALOG_RUNNER.JUMP_UNIT_SEQUENCE << DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_UNIT_SHIFT | DIALOG_RUNNER.JUMP_SETTING_TYPE_RELATIVE,
  JUMP_SETTING_UNIT_SCENE = DIALOG_RUNNER.JUMP_UNIT_SCENE << DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_UNIT_SHIFT | DIALOG_RUNNER.JUMP_SETTING_TYPE_RELATIVE,
  __BITMASK_MASK_JUMP_SETTING_RESOLUTION_BITS = DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_TYPE_BITS + DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_UNIT_BITS,
  __BITMASK_MASK_JUMP_SETTING_RESOLUTION_MASK = ((1 << DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_RESOLUTION_BITS) - 1) << DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_RESOLUTION_SHIFT,
  __BITMASK_JUMP_SETTINGS_BEHAVIOUR_SHIFT = DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_RESOLUTION_SHIFT + DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_RESOLUTION_BITS,
  __BITMASK_FLAG_INDEX_JUMP_SETTING_CHOICE = DIALOG_RUNNER.__BITMASK_JUMP_SETTINGS_BEHAVIOUR_SHIFT,
  __BITMASK_FLAG_INDEX_JUMP_SETTING_BYPASS_FX_ON_ENTER,
  __BITMASK_FLAG_INDEX_JUMP_SETTING_BYPASS_FX_ON_STAY,
  __BITMASK_FLAG_INDEX_JUMP_SETTING_BYPASS_FX_ON_LEAVE,
  __BITMASK_FLAG_INDEX_JUMP_SETTING_MAINTAIN_DIALOG,
  __BITMASK_FLAG_INDEX_JUMP_SETTING_MAINTAIN_SEQUENCE,
  __BITMASK_FLAG_INDEX_JUMP_SETTING_MAINTAIN_SCENE,
  __BITMASK_JUMP_SETTINGS_BEHAVIOUR_COUNT,
  __BITMASK_JUMP_SETTINGS_BEHAVIOUR_MASK = ((1 << DIALOG_RUNNER.__BITMASK_JUMP_SETTINGS_BEHAVIOUR_COUNT) - 1) << DIALOG_RUNNER.__BITMASK_JUMP_SETTINGS_BEHAVIOUR_SHIFT,
  __BITMASK_MASK_JUMP_SETTING_MAINTAIN_BEHAVIOUR_SHIFT = DIALOG_RUNNER.__BITMASK_FLAG_INDEX_JUMP_SETTING_MAINTAIN_DIALOG,
  __BITMASK_MASK_JUMP_SETTING_MAINTAIN_BEHAVIOUR_BITS = DIALOG_RUNNER.__BITMASK_JUMP_SETTINGS_BEHAVIOUR_COUNT - DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_MAINTAIN_BEHAVIOUR_SHIFT,
  __BITMASK_MASK_JUMP_SETTING_MAINTAIN_BEHAVIOUR_MASK = ((1 << DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_MAINTAIN_BEHAVIOUR_BITS) - 1) << DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_MAINTAIN_BEHAVIOUR_SHIFT,
  JUMP_SETTING_CHOICE             = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_JUMP_SETTING_CHOICE,
  JUMP_SETTING_BYPASS_FX_ON_ENTER = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_JUMP_SETTING_BYPASS_FX_ON_ENTER,
  JUMP_SETTING_BYPASS_FX_ON_STAY  = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_JUMP_SETTING_BYPASS_FX_ON_STAY,
  JUMP_SETTING_BYPASS_FX_ON_LEAVE = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_JUMP_SETTING_BYPASS_FX_ON_LEAVE,
  JUMP_SETTING_MAINTAIN_DIALOG    = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_JUMP_SETTING_MAINTAIN_DIALOG,
  JUMP_SETTING_MAINTAIN_SEQUENCE  = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_JUMP_SETTING_MAINTAIN_SEQUENCE,
  JUMP_SETTING_MAINTAIN_SCENE     = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_JUMP_SETTING_MAINTAIN_SCENE,
}



/**
 * @desc `POSITION_CODE_*` options refer to relative dialog positioning encodings when absolute jumps are to be made.
 * @desc `__BITMASK_*` settings are used to manage bitmasks and should not be referenced directly.
 * @desc `ERR_*` options refer to error codes and can be used to check error types.
 */

enum DIALOG_MANAGER // Should not edit
{
  // Argument positions
  ARG_DATA_STRING = 0,
  ARG_IS_FILE,
  ARG_COUNT,

  // Positioning codes
  POSITION_CODE_SCENE_LAST = -14,
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
  POSITION_CODE_NONE,
  POSITION_CODE_COUNT = -DIALOG_MANAGER.POSITION_CODE_SCENE_LAST + 1,

  // Positioning masks
  __BITMASK_POSITION_DIALOG_SHIFT = 0,
  __BITMASK_POSITION_DIALOG_BITS = 12,
  __BITMASK_POSITION_DIALOG_MASK = ((1 << DIALOG_MANAGER.__BITMASK_POSITION_DIALOG_BITS) - 1) << DIALOG_MANAGER.__BITMASK_POSITION_DIALOG_SHIFT,
  __BITMASK_POSITION_SEQUENCE_SHIFT = DIALOG_MANAGER.__BITMASK_POSITION_DIALOG_SHIFT + DIALOG_MANAGER.__BITMASK_POSITION_DIALOG_BITS,
  __BITMASK_POSITION_SEQUENCE_BITS = 9,
  __BITMASK_POSITION_SEQUENCE_MASK = ((1 << DIALOG_MANAGER.__BITMASK_POSITION_SEQUENCE_BITS) - 1) << DIALOG_MANAGER.__BITMASK_POSITION_SEQUENCE_SHIFT,
  __BITMASK_POSITION_SCENE_SHIFT = DIALOG_MANAGER.__BITMASK_POSITION_SEQUENCE_SHIFT + DIALOG_MANAGER.__BITMASK_POSITION_SEQUENCE_BITS,
  __BITMASK_POSITION_SCENE_BITS = 10,
  __BITMASK_POSITION_SCENE_MASK = ((1 << DIALOG_MANAGER.__BITMASK_POSITION_SCENE_BITS) - 1) << DIALOG_MANAGER.__BITMASK_POSITION_SCENE_SHIFT,

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
  ERR_TEXT_OVERFLOW,
  ERR_MAX_FX_CAPACITY_REACHED,
  ERR_COUNT,

  // Error checks
  ERRCHECK_INFINITE_LOOP_TRESHOLD = 32,
}



/**
 * @desc Contains all useful information about a dialog scene.
 * @desc `BG_*` options refer to the background index.
 * @desc `BGM_*` options refer to the background music index.
 * @desc `BGS_*` flags refer to the background sound index.
 * @desc `TAG_*` options refer to the scene type for categorization (useful for filtering).
 * @desc `__BITMASK_*` settings are used to manage bitmasks and should not be referenced directly.
 */

enum DIALOG_SCENE // Edit as needed
{
  // Argument positions
  ARG_SEQUENCES = 0,
  ARG_SETTINGS_MASK,
  ARG_COUNT,
  ARG_SEQUENCE_COUNT = DIALOG_SCENE.ARG_COUNT,
  ARG_COUNT_DESERIALIZATION,

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

  // Settings masks
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



/**
 * @desc Contains all useful information about a dialog sequence.
 * @desc `TAG_*` options refer to the sequence type for categorization (useful for filtering).
 * @desc `__BITMASK_*` settings are used to manage bitmasks and should not be referenced directly.
 */

enum DIALOG_SEQUENCE // Edit as needed
{
  // Argument positions
  ARG_DIALOGS = 0,
  ARG_SETTINGS_MASK,
  ARG_SPEAKERS,
  ARG_COUNT,
  ARG_DIALOG_COUNT = DIALOG_SEQUENCE.ARG_COUNT,
  ARG_COUNT_DESERIALIZATION,

  // Sequence tags
  TAG_NONE = 0,
    // ...
  TAG_COUNT,
  TAG_DEFAULT = DIALOG_SEQUENCE.TAG_NONE,

  // Settings masks
  __BITMASK_TAG_SHIFT = 0,
  __BITMASK_TAG_BITS = 5,
  __BITMASK_TAG_MASK = ((1 << DIALOG_SEQUENCE.__BITMASK_TAG_BITS) - 1) << DIALOG_SEQUENCE.__BITMASK_TAG_SHIFT,
}



/**
 * @desc Contains all useful information about a dialog.
 * @desc `SPEAKER_*` options refer to the speakers (actors).
 * @desc `EMOTION_*` options refer to the emotions (frames or expressions).
 * @desc `ANCHOR_*` options refer to the dialog box positioning.
 * @desc `TEXTBOX_*` options refer to the dialog box style.
 * @desc `TAG_*` options refer to the dialog type for categorization (useful for filtering).
 * @desc `__BITMASK_*` settings are used to manage bitmasks and should not be referenced directly.
 */

enum DIALOG // Edit as needed
{
  // Argument positions
  ARG_TEXT = 0,
  ARG_SETTINGS_MASK,
  ARG_FX_MAP,
  ARG_COUNT,
  ARG_FX_COUNT = DIALOG.ARG_COUNT,
  ARG_COUNT_DESERIALIZATION,

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

  // Settings masks
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
}



/**
 * @desc Contains all the useful information about a dialog effect.
 * @desc `TYPE_*` options refer to the effect type. In particular, `FLOWRES_*` types refer to flow control effects.
 * @desc `TRIGGER_*` options refer to the effect trigger type.
 * @desc `SIGNAL_*` options refer to the return signals from effect execution.
 * @desc `TAG_*` options refer to the dialog fx type for categorization (useful for filtering).
 * @desc `FUNC_CONDITION_*` options refer to the condition functions used by the effects effects.
 * @desc `FUNC_INDEXER_*` options refer to the indexer functions used by the effects effects.
 * @desc `[FX_TYPE_NAME]_*` options refer to particular values for that type of fx.
 * @desc `ARG_*` options refer to the positions of the arguments passed to the fx.
 * @desc `FX_ARG_FLOWRES_*` options refer to the positions of the arguments passed to the flow resolver fx.
 * @desc `REGISTER_SETTING_*` options refer to where a function should be registered.
 * @desc `__BITMASK_*` settings are used to manage bitmasks and should not be referenced directly.
 */

enum DIALOG_FX // Edit as needed
{
  // Argument positions
  ARG_SETTINGS_MASK = 0,
  ARG_ARGV,
  ARG_FUNC,
  ARG_COUNT,

  // FX flowres argument positions
  FX_ARG_FLOWRES_DATA = 0,
  FX_ARG_FLOWRES_INDEXER_INDEX,
  FX_ARG_FLOWRES_CONDITION_INDEX,
  FX_ARG_FLOWRES_INDEXER_ARGV,
  FX_ARG_FLOWRES_CONDITION_ARGV,
  FX_ARG_FLOWRES_SETTINGS,
  FX_ARG_FLOWRES_INDEX_UNSELECTED = -1,

  // FX flowres subargument positions
  FX_ARG_FLOWRES_DATA_POSITION = 0,
  FX_ARG_FLOWRES_DATA_PROMPT,
  FX_ARG_FLOWRES_DATA_METADATA,
  FX_ARG_FLOWRES_DATA_COUNT,
  FX_ARG_FLOWRES_DATA_POSITION_DESTINATION = 0,
  FX_ARG_FLOWRES_DATA_POSITION_SETTINGS,
  FX_ARG_FLOWRES_DATA_POSITION_COUNT,

  // FX types
  TYPE_ANY = 0,
  TYPE_FLOWRES_JUMP,
  TYPE_FLOWRES_DISPATCH,
  TYPE_FLOWRES_FALLBACK,
  TYPE_FLOWRES_CHOICE,
  __TYPE_FLOWRES_COUNT = DIALOG_FX.TYPE_FLOWRES_CHOICE,
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
  TRIGGER_NONE = 0,
  TRIGGER_ON_ENTER,
  TRIGGER_ON_STAY,
  TRIGGER_ON_LEAVE,
  TRIGGER_ON_CUSTOM,
    // ...
  TRIGGER_COUNT,
  TRIGGER_DEFAULT = DIALOG_FX.TRIGGER_NONE,

  // Flow signals
  SIGNAL_NONE = 0,
  SIGNAL_JUMP,
  SIGNAL_SKIP_NEXT,
  SIGNAL_STOP_CYCLE,
  SIGNAL_STOP_RESOLUTION,
  SIGNAL_COUNT,
  SIGNAL_DEFAULT = DIALOG_FX.SIGNAL_NONE,

  // FX tags
  TAG_NONE = 0,
    // ...
  TAG_COUNT,
  TAG_DEFAULT = DIALOG_FX.TAG_NONE,

  // FX condition indices
  FUNC_CONDITION_FALSE = 0,
  FUNC_CONDITION_TRUE,
    // ...
  FUNC_CONDITION_COUNT,

  // FX indexers indices
  FUNC_INDEXER_RUNNER_CHOICE_INDEX = 0,
    // ...
  FUNC_INDEXER_COUNT,

  // Settings masks
  __BITMASK_TYPE_SHIFT = 0,
  __BITMASK_TYPE_BITS = 10,
  __BITMASK_TYPE_MAX_COUNT = (1 << DIALOG_FX.__BITMASK_TYPE_BITS) - 1,
  __BITMASK_TYPE_MASK = DIALOG_FX.__BITMASK_TYPE_MAX_COUNT << DIALOG_FX.__BITMASK_TYPE_SHIFT,
  __BITMASK_TRIGGER_SHIFT = DIALOG_FX.__BITMASK_TYPE_SHIFT + DIALOG_FX.__BITMASK_TYPE_BITS,
  __BITMASK_TRIGGER_BITS = 3,
  __BITMASK_TRIGGER_MASK = ((1 << DIALOG_FX.__BITMASK_TRIGGER_BITS) - 1) << DIALOG_FX.__BITMASK_TRIGGER_SHIFT,
  __BITMASK_SIGNAL_SHIFT = DIALOG_FX.__BITMASK_TRIGGER_SHIFT + DIALOG_FX.__BITMASK_TRIGGER_BITS,
  __BITMASK_SIGNAL_BITS = 3,
  __BITMASK_SIGNAL_MASK = ((1 << DIALOG_FX.__BITMASK_SIGNAL_BITS) - 1) << DIALOG_FX.__BITMASK_SIGNAL_SHIFT,
  __BITMASK_TAG_SHIFT = DIALOG_FX.__BITMASK_SIGNAL_SHIFT + DIALOG_FX.__BITMASK_SIGNAL_BITS,
  __BITMASK_TAG_BITS = 4,
  __BITMASK_TAG_MASK = ((1 << DIALOG_FX.__BITMASK_TAG_BITS) - 1) << DIALOG_FX.__BITMASK_TAG_SHIFT,

  // Registering settings
  __REGISTER_SETTING_FX_FUNC = 0,
  __REGISTER_SETTING_FX_FUNC_INDEXER,
  __REGISTER_SETTING_FX_FUNC_CONDITION,
  __REGISTER_SETTING_FX_FUNC_TYPE_COUNT,
  __BITMASK_REGISTER_SHIFT = 0,
  __BITMASK_REGISTER_BITS = 2,
  __BITMASK_REGISTER_MASK = ((1 << DIALOG_FX.__BITMASK_REGISTER_BITS) - 1) << DIALOG_FX.__BITMASK_REGISTER_SHIFT,
  REGISTER_SETTING_FX_FUNC = DIALOG_FX.__REGISTER_SETTING_FX_FUNC << DIALOG_FX.__BITMASK_REGISTER_SHIFT & DIALOG_FX.__BITMASK_REGISTER_MASK,
  REGISTER_SETTING_FX_FUNC_INDEXER = DIALOG_FX.__REGISTER_SETTING_FX_FUNC_INDEXER << DIALOG_FX.__BITMASK_REGISTER_SHIFT & DIALOG_FX.__BITMASK_REGISTER_MASK,
  REGISTER_SETTING_FX_FUNC_CONDITION = DIALOG_FX.__REGISTER_SETTING_FX_FUNC_CONDITION << DIALOG_FX.__BITMASK_REGISTER_SHIFT & DIALOG_FX.__BITMASK_REGISTER_MASK,
}












// ----------------------------------------------------------------------------












/**
 * @desc `DialogRunner` constructor. Manages runtime state and position in the dialog graph.
 * @param {Struct.DialogManager} manager The dialog manager instance to associate with this runner.
 * @returns {Struct.DialogRunner}
 */

function DialogRunner(manager) constructor
{
  static __CONSTRUCTOR_ARGC = argument_count;

  self.manager = manager;

  self.choice_index = DIALOG_FX.FX_ARG_FLOWRES_INDEX_UNSELECTED;
  self.status = DIALOG_RUNNER.STATUS_UNINITIALIZED;
  self.position = DIALOG_MANAGER.POSITION_CODE_NONE;

  self.seed = irandom(0x7FFFFFFF);
  self.history = [];
  self.vars = {};



  /**
   * @desc Changes the dialog runner position to the given one. [CHAINABLE]
   * @param {Real|Constant.DialogManager|Struct.DialogLinkable} [position] The position to load.
   * @param {Bool} [busy] Whether the dialog runner should execute jumps normally with effects (`true`) or not (`false`).
   * @param {Array} [argv] The arguments to pass to eventual fallback effects (only if `busy` is `true`).
   * @returns {Struct.DialogRunner}
   */

  static load = function(position = self.position, busy = false, argv = undefined)
  {
    self.status = 0;

    self.position = busy
      ? __resolve(position, self.position, 0, argv)
      : manager.__resolve_position_absolute(position, 0)
    ;

    self.status |= __status();

    return self;
  }




  /**
   * @desc Retrieves a scene given an index. Negative indices will iterate backwards. Throws DIALOG_MANAGER.ERR_INVALID_POSITION if out of bounds.
   * @param {Real} [scene_idx] The index of the scene to get.
   * @returns {Struct.DialogScene}
   */

  static scene = function(scene_idx = undefined)
  {
    return manager.scene(scene_idx ?? manager.__decode_scene_idx(self.position));
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
      return manager.__get_sequence_relative(sequence_idx, 0, 0);

    if (scene_idx != undefined && sequence_idx == undefined)
      sequence_idx = 0;

    sequence_idx ??= manager.__decode_sequence_idx(self.position);
    scene_idx ??= manager.__decode_scene_idx(self.position);

    return manager.sequence(sequence_idx, scene_idx);
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
    var u = (scene_idx == undefined) + (sequence_idx == undefined) + (dialog_idx == undefined)
      , position = self.position
    ;

    if (u == 2 && dialog_idx != undefined)
      return manager.__get_dialog_relative(dialog_idx, 0, 0);

    if (u && u < 3)
    {
      scene_idx ??= 0;
      sequence_idx ??= 0;
      dialog_idx ??= 0;
    }

    scene_idx ??= manager.__decode_scene_idx(position);
    sequence_idx ??= manager.__decode_sequence_idx(position);
    dialog_idx ??= manager.__decode_dialog_idx(position);

    return manager.dialog(dialog_idx, sequence_idx, scene_idx);
  }



  /**
   * @desc Retrieves a scene given a relative index. Negative indices will iterate backwards.
   * @param {Real} [scene_shift] The relative index shift of the scene. Defaults to `0`.
   * @param {Real|Struct.DialogLinkable} [start_position] The starting position of the iteration. Defaults to the current one.
   * @param {Constant.DIALOG_MANAGER|Real} [jump_settings] The settings of the jump to perform.
   * @returns {Struct} { position: Struct.DialogScene, status: Constant.DIALOG_RUNNER|Real }
   */

  static deltascene = function(scene_shift = 0, start_position = self.position, jump_settings = 0)
  {
    return manager.deltascene(scene_shift, start_position, jump_settings);
  }



  /**
   * @desc Retrieves a sequence given a relative index. Negative indices will iterate backwards.
   * @param {Real} [sequence_shift] The relative index shift of the sequence. Defaults to `0`.
   * @param {Real|Struct.DialogLinkable} [start_position] The starting position of the iteration. Defaults to the current one.
   * @param {Constant.DIALOG_MANAGER|Real} [jump_settings] The settings of the jump to perform.
   * @returns {Struct} { position: Struct.DialogSequence, status: Constant.DIALOG_RUNNER|Real }
   */

  static deltasequence = function(sequence_shift = 0, start_position = self.position, jump_settings = 0)
  {
    return manager.deltasequence(sequence_shift, start_position, jump_settings);
  }



  /**
   * @desc Retrieves a dialog given a relative index. Negative indices will iterate backwards.
   * @param {Real} [dialog_shift] The relative index shift of the dialog. Defaults to `0`.
   * @param {Real|Struct.DialogLinkable} [start_position] The starting position of the iteration. Defaults to the current one.
   * @param {Constant.DIALOG_MANAGER|Real} [jump_settings] The settings of the jump to perform.
   * @returns {Struct} { position: Struct.Dialog, status: Constant.DIALOG_RUNNER|Real }
   */

  static deltadialog = function(dialog_shift = 0, start_position = self.position, jump_settings = 0)
  {
    return manager.deltadialog(dialog_shift, start_position, jump_settings);
  }



  /**
   * @desc Resolves a position given a shift and unit.
   * @param {Real} [shift] The shift to apply.
   * @param {Constant.DIALOG_MANAGER|Real} [unit] The unit of the shift.
   * @param {Real|Struct.DialogLinkable} [start_position] The starting position of the iteration. Defaults to the current one.
   * @param {Constant.DIALOG_MANAGER|Real} [jump_settings] The settings of the jump to perform.
   * @returns {Struct} { position: Struct.DialogLinkable, status: Constant.DIALOG_RUNNER|Real }
   */

  static delta = function(shift = 0, unit = DIALOG_RUNNER.JUMP_SETTING_UNIT_DIALOG, start_position = self.position, jump_settings = 0)
  {
    return manager.delta(shift, unit, start_position, jump_settings);
  }



  /**
   * @desc Simulates advancing the dialog runner without state modifications.
   * @param {Real} [shift] The number of units to advance of. Defaults to `1`.
   * @param {Constant.DIALOG_RUNNER|Real} [jump_settings] The settings mask for the jump.
   * @param {Constant.DIALOG_MANAGER|Real|Struct.DialogLinkable} [start_position] The starting position of the forecast. Defaults to the current one.
   * @param {Any|Array<Any>} [argv] The argument(s) to pass to eventual dialog effects.
   * @returns {Struct.DialogRunner}
   */

  static predict = function(shift = 1, jump_settings = DIALOG_RUNNER.JUMP_SETTING_TYPE_RELATIVE, start_position = self.position, argv = undefined)
  {
    return variable_clone(self).advance(shift, jump_settings, start_position, argv);
  }



  /**
   * @desc Makes the dialog runner advance of a specified shift. Produces side effects on dialog manager position and/or status. [CHAINABLE]
   * @param {Real} [shift] The number of units to advance of. Defaults to `1`.
   * @param {Constant.DIALOG_MANAGER|Real} [jump_settings] The settings mask for the jump.
   * @param {Constant.DIALOG_MANAGER|Real|Struct.DialogLinkable} [prev_position] The starting position of the advancement. Defaults to the current one.
   * @param {Any|Array<Any>} [argv] The argument(s) to pass to eventual dialog effects.
   * @returns {Struct.DialogRunner}
   */

  static advance = function(shift = 1, jump_settings = DIALOG_RUNNER.JUMP_SETTING_TYPE_RELATIVE, prev_position = self.position, argv = undefined)
  {
    var manager = self.manager;
    prev_position = manager.__to_position(prev_position);

    self.status &= ~(
      shift != 0
        ? DIALOG_RUNNER.__BITMASK_STATUS_MASK
        : DIALOG_RUNNER.__BITMASK_STATUS_AUTORESET_MASK
    );

    if (shift == 0 || !manager.scene_count)
    {
      if (!(jump_settings & DIALOG_RUNNER.JUMP_SETTING_BYPASS_FX_ON_STAY)) {
        manager.__to_dialog(prev_position).__fx_execute_all_of(function(fx) {
          return fx.trigger() == DIALOG_FX.TRIGGER_ON_STAY;
        });
      }

      return self;
    }

    shift *= !(jump_settings & DIALOG_RUNNER.JUMP_SETTING_CHOICE);

    var shift_sign = sign(shift)
      , current_scene_idx = manager.__decode_scene_idx(prev_position)
      , current_sequence_idx = manager.__decode_sequence_idx(prev_position)
      , current_dialog_idx = manager.__decode_dialog_idx(prev_position)
      , resolved = manager.__resolve_position_relative(shift, prev_position, jump_settings)
      , target_position = __resolve(
          resolved.position,
          prev_position,
          jump_settings & DIALOG_RUNNER.__BITMASK_JUMP_SETTINGS_BEHAVIOUR_MASK,
          argv
        )
    ;

    self.position = target_position;
    self.status |= __status(
      target_position,
      shift_sign * (current_scene_idx != manager.__decode_scene_idx(target_position)),
      shift_sign * (current_sequence_idx != manager.__decode_sequence_idx(target_position)),
      shift * (current_dialog_idx != manager.__decode_dialog_idx(target_position)),
      resolved.status
    );

    return self;
  }



  /**
   * @desc Executes the fx cycle, resolving all effects in sequence and following jumps until no more flow resolvers are triggered.
   * @param {Real|Struct.DialogLinkable} [target_position] The target position of the runner.
   * @param {Real|Struct.DialogLinkable} [position] The current position of the runner.
   * @param {Constant.DIALOG_RUNNER|Real} [jump_settings] The settings of the jump.
   * @param {Array} [argv] The arguments to pass to eventual DialogFX's.
   */

  static __resolve = function(target_position = self.position, position = self.position, jump_settings = 0, argv = undefined)
  {
    var manager = self.manager
      , ctx = new DialogCycleContext(self, position)
      , target_dialog = manager.__to_dialog(target_position)
      , current_dialog = manager.__to_dialog(position)
      , flow = undefined
      , _fx_cycle = function(condition, dialog, argv, ctx, trigger, filter_fn = undefined) {
          return condition
            ? dialog.__fx_execute_cycle(argv, ctx, trigger, filter_fn)
            : undefined
          ;
        }
    ;

    for (var jumps = 0; flow || !jumps; ++jumps)
    {
      if (jumps > DIALOG_MANAGER.ERRCHECK_INFINITE_LOOP_TRESHOLD) {
        throw DialogManager.ERROR(DIALOG_MANAGER.ERR_INFINITE_LOOP_DETECTED, [jumps, current_dialog.__struct()]);
      }

      flow = _fx_cycle(!(jump_settings & DIALOG_RUNNER.JUMP_SETTING_BYPASS_FX_ON_LEAVE), current_dialog, argv, ctx, DIALOG_FX.TRIGGER_ON_LEAVE);

      if (flow) {
        target_dialog = flow.target;
      }

      current_dialog = target_dialog;

      flow = _fx_cycle(!(jump_settings & DIALOG_RUNNER.JUMP_SETTING_BYPASS_FX_ON_ENTER), target_dialog, argv, ctx, DIALOG_FX.TRIGGER_ON_ENTER);

      if (flow) {
        target_dialog = flow.target;
      }
    }

    return manager.__to_position(target_dialog);
  }



  /**
   * @desc Updates the dialog runner's status based on the target position and movement diffs.
   * @param {Real} [target_position] The position to check.
   * @param {Real} [scene_diff] The signed amount of scenes traveled from the previous position.
   * @param {Real} [sequence_diff] The signed amount of sequences traveled from the previous position.
   * @param {Real} [dialog_diff] The signed amount of dialogs traveled from the previous position.
   * @param {Bool} [maintained_status] The status flag for any maintained position.
   * @returns {Real} A bitmask of status flags indicating position state and movement.
   */

  static __status = function(target_position = self.position, scene_diff = 0, sequence_diff = 0, dialog_diff = 0, maintained_status = 0)
  {
    var manager = self.manager
      , target_scene_idx = manager.__decode_scene_idx(target_position)
      , target_sequence_idx = manager.__decode_sequence_idx(target_position)
      , target_dialog_idx = manager.__decode_dialog_idx(target_position)
      , target_sequence_count = manager.scene(target_scene_idx).sequence_count
      , target_dialog_count = manager.sequence(target_sequence_idx, target_scene_idx).dialog_count
      , is_last_scene = target_scene_idx == manager.scene_count - 1
      , is_last_of_scene = target_sequence_idx == target_sequence_count - 1
      , is_last_of_sequence = target_dialog_idx == target_dialog_count - 1
      , is_last_sequence = is_last_scene && is_last_of_scene
      , maintained_dialog = maintained_status & DIALOG_RUNNER.STATUS_MAINTAINED_DIALOG
      , maintained_sequence = maintained_status & DIALOG_RUNNER.STATUS_MAINTAINED_SEQUENCE
      , maintained_scene = maintained_status & DIALOG_RUNNER.STATUS_MAINTAINED_SCENE
    ;

    scene_diff *= !(maintained_scene || maintained_sequence || maintained_dialog);
    sequence_diff *= !(maintained_sequence || maintained_dialog);
    dialog_diff *= !maintained_dialog;

    return maintained_status
      | DIALOG_RUNNER.STATUS_FIRST_DIALOG       * (target_position == 0                                                )
      | DIALOG_RUNNER.STATUS_FIRST_SEQUENCE     * (target_position < 1 << DIALOG_MANAGER.__BITMASK_POSITION_DIALOG_BITS)
      | DIALOG_RUNNER.STATUS_FIRST_SCENE        * (target_scene_idx == 0                                               )
      | DIALOG_RUNNER.STATUS_FIRST_OF_SEQUENCE  * (target_dialog_idx == 0                                              )
      | DIALOG_RUNNER.STATUS_FIRST_OF_SCENE     * (target_sequence_idx == 0                                            )
      | DIALOG_RUNNER.STATUS_MIDDLE_OF_SEQUENCE * (target_dialog_idx == target_dialog_count >> 1                       )
      | DIALOG_RUNNER.STATUS_MIDDLE_OF_SCENE    * (target_sequence_idx == target_sequence_count >> 1                   )
      | DIALOG_RUNNER.STATUS_MIDDLE_SCENE       * (target_scene_idx == manager.scene_count >> 1                        )
      | DIALOG_RUNNER.STATUS_LAST_DIALOG        * (is_last_sequence && is_last_of_sequence                             )
      | DIALOG_RUNNER.STATUS_LAST_SEQUENCE      * (is_last_sequence                                                    )
      | DIALOG_RUNNER.STATUS_LAST_SCENE         * (is_last_scene                                                       )
      | DIALOG_RUNNER.STATUS_LAST_OF_SEQUENCE   * (is_last_of_sequence                                                 )
      | DIALOG_RUNNER.STATUS_LAST_OF_SCENE      * (is_last_of_scene                                                    )
      | DIALOG_RUNNER.STATUS_ADVANCED_DIALOG    * (dialog_diff > 0                                                     )
      | DIALOG_RUNNER.STATUS_ADVANCED_SEQUENCE  * (sequence_diff > 0                                                   )
      | DIALOG_RUNNER.STATUS_ADVANCED_SCENE     * (scene_diff > 0                                                      )
      | DIALOG_RUNNER.STATUS_RECEDED_DIALOG     * (dialog_diff < 0                                                     )
      | DIALOG_RUNNER.STATUS_RECEDED_SEQUENCE   * (sequence_diff < 0                                                   )
      | DIALOG_RUNNER.STATUS_RECEDED_SCENE      * (scene_diff < 0                                                      )
    ;
  }
}












// ----------------------------------------------------------------------------












/**
 * @desc `DialogCycleContext` constructor. Provides per-cycle caching for condition and indexer evaluations.
 * @param {Struct.DialogRunner} runner The dialog runner instance.
 * @param {Real} position The current position in the dialog graph.
 * @returns {Struct.DialogCycleContext}
 */

function DialogCycleContext(runner, position) constructor
{
  static __CONSTRUCTOR_ARGC = argument_count;

  self.runner = runner;
  self.dialog = runner.manager.__to_dialog(position);

  self.executed = 0;
  self.resolved = false;
  self.target = undefined;
  self.cache = {
    conditions: {},
    indexers: {},
  };



  /**
   * @desc Signals a successful flow resolution, setting the target position and updating runner status.
   * @param {Array} jump_option_data The data for the jump option.
   * @param {Real} [runner_status] Additional status flags to OR into the runner's status.
   * @returns {Struct.Dialog}
   */

  static success = function(jump_option_data, runner_status = 0)
  {
    var runner = self.runner
      , manager = runner.manager
      , jump_position_data = jump_option_data[DIALOG_FX.FX_ARG_FLOWRES_DATA_POSITION]
      , jump_position = jump_position_data[DIALOG_FX.FX_ARG_FLOWRES_DATA_POSITION_DESTINATION]
      , jump_settings = jump_position_data[DIALOG_FX.FX_ARG_FLOWRES_DATA_POSITION_SETTINGS] ?? 0
      , target_position = manager.__to_dialog(manager.__resolve_position(jump_position, runner.position, jump_settings))
    ;

    runner.status |= runner_status;
    self.target = target_position;

    return target_position;
  }



  /**
   * @desc Signals a failed flow resolution, returning the target position (mostly undefined).
   * @param {Struct.Dialog} [target_position] Unused parameter for consistency.
   * @param {Real} [runner_status] Unused parameter for consistency.
   * @returns {Struct.Dialog}
   */

  static fail = function(target_position = undefined, runner_status = 0)
  {
    var runner = self.runner;

    runner.status |= runner_status;
    self.target = target_position;

    return target_position;
  }



  /**
   * @desc Evaluates a condition function with caching to ensure it's not re-evaluated multiple times per cycle.
   * @param {Real} fx_condition_index The index of the condition function.
   * @param {Array} fx_condition_argv The arguments for the condition function.
   * @returns {Bool} The result of the condition evaluation.
   */

  static condition = function(fx_condition_index, fx_condition_argv)
  {
    return __eval_cache(
      self.cache.conditions,
      DialogFX.data.fx_condition_map,
      fx_condition_index,
      fx_condition_argv,
      DIALOG_FX.FUNC_CONDITION_TRUE
    );
  }



  /**
   * @desc Evaluates an indexer function with caching to ensure it's not re-evaluated multiple times per cycle.
   * @param {Real} fx_indexer_index The index of the indexer function.
   * @param {Array} fx_indexer_argv The arguments for the indexer function.
   * @returns {Real} The result of the indexer evaluation, or unselected if invalid.
   */

  static indexer = function(fx_indexer_index, fx_indexer_argv)
  {
    return __eval_cache(
      self.cache.indexers,
      DialogFX.data.fx_indexer_map,
      fx_indexer_index,
      fx_indexer_argv,
      DIALOG_FX.FX_ARG_FLOWRES_INDEX_UNSELECTED
    );
  }



  /**
   * @desc Evaluates and caches a function result to avoid repeated computations within a cycle.
   * @param {Struct} storage The cache storage struct.
   * @param {Struct} map The function map containing funcs array.
   * @param {Real} key The function index key.
   * @param {Array} argv The arguments to pass to the function.
   * @param {Any} defaultret The default return value if key is invalid.
   * @returns {Any} The cached or newly computed result.
   */

  static __eval_cache = function(storage, map, key, argv, defaultret)
  {
    if ((key ?? DIALOG_FX.FX_ARG_FLOWRES_INDEX_UNSELECTED) < 0)
      return defaultret;

    if (struct_exists(storage, key))
      return storage[$ key];

    var result = map.funcs[key](argv, self);
    storage[$ key] = result;

    return result;
  }
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
  static __CONSTRUCTOR_ARGC = argument_count;

  self.scene_count = 0;
  self.scenes = [];
  self.data = {};



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
        "POTENTIAL TEXT OVERFLOW DETECTED (W: {0}/{1}): SPLIT INTO MULTIPLE DIALOG OBJECTS\n\nVIOLATOR DATA: {2}",
        "FX LIMIT EXCEEDED - MAX FX MAP CAPACITY REACHED WHILE REGISTERING FX {0}\n(TOTAL CAPACITY: {1})",
      ][type],
      argv
    );

    return $"\n\n\n{msg}\n\n";
  }



  /**
   * @desc Retrieves a scene given an index. Negative indices will iterate backwards. Throws DIALOG_MANAGER.ERR_INVALID_POSITION if out of bounds.
   * @param {Real} scene_idx The index of the scene to get.
   * @returns {Struct.DialogScene}
   */

  static scene = function(scene_idx)
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
   * @param {Real} sequence_idx The index of the sequence to get.
   * @param {Real} scene_idx The index of the scene to get the sequence from.
   * @returns {Struct.DialogSequence}
   */

  static sequence = function(sequence_idx, scene_idx)
  {
    try {
      return self.scene(scene_idx).sequence(sequence_idx);
    }
    catch (ex) {
      throw DialogManager.ERROR(DIALOG_MANAGER.ERR_INVALID_POSITION, [scene_idx, sequence_idx, 0]);
    }
  }



  /**
   * @desc Retrieves a dialog given an index. Negative indices will iterate backwards. Throws DIALOG_MANAGER.ERR_INVALID_POSITION if out of bounds.
   * @param {Real} dialog_idx The index of the dialog to get.
   * @param {Real} sequence_idx The index of the sequence to get the dialog from.
   * @param {Real} scene_idx The index of the scene to get the sequence from.
   * @returns {Struct.Dialog}
   */

  static dialog = function(dialog_idx, sequence_idx, scene_idx)
  {
    try {
      return self.sequence(sequence_idx, scene_idx).dialog(dialog_idx);
    }
    catch (ex) {
      throw DialogManager.ERROR(DIALOG_MANAGER.ERR_INVALID_POSITION, [scene_idx, sequence_idx, dialog_idx]);
    }
  }



  /**
   * @desc Retrieves a scene given a relative index. Negative indices will iterate backwards.
   * @param {Real} scene_shift The relative index shift of the scene. Defaults to `0`.
   * @param {Real|Struct.DialogLinkable} start_position The starting position of the iteration. Defaults to the current one.
   * @param {Constant.DIALOG_MANAGER|Real} jump_settings The settings of the jump to perform.
   * @returns {Struct.DialogScene}
   */

  static deltascene = function(scene_shift, start_position, jump_settings)
  {
    return __get_scene_relative(scene_shift, __resolve_position_absolute(start_position), jump_settings);
  }



  /**
   * @desc Retrieves a sequence given a relative index. Negative indices will iterate backwards.
   * @param {Real} sequence_shift The relative index shift of the sequence. Defaults to `0`.
   * @param {Real|Struct.DialogLinkable} start_position The starting position of the iteration. Defaults to the current one.
   * @param {Constant.DIALOG_MANAGER|Real} jump_settings The settings of the jump to perform.
   * @returns {Struct.DialogSequence}
   */

  static deltasequence = function(sequence_shift, start_position, jump_settings)
  {
    return __get_sequence_relative(sequence_shift, __resolve_position_absolute(start_position), jump_settings);
  }



  /**
   * @desc Retrieves a dialog given a relative index. Negative indices will iterate backwards.
   * @param {Real} dialog_shift The relative index shift of the dialog. Defaults to `0`.
   * @param {Real|Struct.DialogLinkable} start_position The starting position of the iteration. Defaults to the current one.
   * @param {Constant.DIALOG_MANAGER|Real} jump_settings The settings of the jump to perform.
   * @returns {Struct.Dialog}
   */

  static deltadialog = function(dialog_shift, start_position, jump_settings)
  {
    return __get_dialog_relative(dialog_shift, __resolve_position_absolute(start_position), jump_settings);
  }



  /**
   * @desc Resolves a position given a shift and unit.
   * @param {Real} shift The shift to apply.
   * @param {Constant.DIALOG_MANAGER|Real} unit The unit of the shift.
   * @param {Real|Struct.DialogLinkable} start_position The starting position of the iteration. Defaults to the current one.
   * @param {Constant.DIALOG_MANAGER|Real} jump_settings The settings of the jump to perform.
   * @returns {Struct.DialogLinkable}
   */

  static delta = function(shift, unit, start_position, jump_settings)
  {
    return __resolve_position_relative(shift, __resolve_position_absolute(start_position), jump_settings & ~DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_UNIT_MASK | __encode_jump_setting_unit(unit));
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

    return self;
  }



  /**
   * @desc Converts all the dialog manager data to a JSON string. Throws DIALOG_MANAGER.ERR_SERIALIZATION_FAILED if serialization fails.
   * @param {Bool} [prettify] Specifies whether the output should be prettified (`true`) or not (`false`). Defaults to `false`.
   * @returns {String}
   */

  static serialize = function(prettify = false)
  {
    try {
      return json_stringify({
          scenes: array_map(self.scenes, function(scene) {
            return scene.__DIALOG_MANAGER_SERIALIZER_METHOD__();
          }),
          scene_count: int64(self.scene_count),
        },
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

      try
      {
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

    return self.parse(json_parse(data_string));
  }



  /**
   * @desc Converts raw data into `DialogLinkable` objects. Throws DIALOG_MANAGER.ERR_PARSING_FAILED if parsing fails. [CHAINABLE]
   * @param {Struct} data The parsed data to convert and add.
   * @returns {Struct.DialogManager}
   */

  static parse = function(data)
  {
    try
    {
      __reset_parser_state().scene_count = data.scene_count;

      for (var i = 0; i < self.scene_count; ++i) {
        var scene = DialogScene.__DIALOG_MANAGER_DESERIALIZER_METHOD__(data.scenes[i]);
        scene.manager = self;
        scene.scene_idx = i;
        self.scenes[i] = scene;
      }
    }
    catch (ex) {
      throw DialogManager.ERROR(DIALOG_MANAGER.ERR_PARSING_FAILED);
    }

    return self;
  }



  /**
   * @desc Returns a dialog given an encoded position.
   * @param {Real} position The encoded position.
   * @returns {Struct.Dialog}
   */

  static __get_dialog_from_position = function(position)
  {
    return self.dialog(__decode_dialog_idx(position), __decode_sequence_idx(position), __decode_scene_idx(position));
  }



  /**
   * @desc Converts the argument into the corresponding Dialog object.
   * @param {Real|Struct.DialogLinkable} [position] The position object to convert to the corresponding Dialog struct.
   * @returns {Struct.Dialog}
   */

  static __to_dialog = function(position)
  {
    return __get_dialog_from_position(
      is_instanceof(position, DialogLinkable)
        ? position.position()
        : position
    );
  }



  /**
   * @desc Converts the argument into the corresponding position value.
   * @param {Real|Struct.DialogLinkable} [position] The position object to convert to the corresponding position value.
   * @returns {Real}
   */

  static __to_position = function(position)
  {
    return is_numeric(position)
      ? position
      : position.position()
    ;
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
    return scene_idx << DIALOG_MANAGER.__BITMASK_POSITION_SCENE_SHIFT & DIALOG_MANAGER.__BITMASK_POSITION_SCENE_MASK;
  }



  /**
   * @desc Encodes a sequence position given an index.
   * @param {Real} sequence_idx The sequence index to encode.
   * @returns {Real}
   */

  static __encode_sequence_idx = function(sequence_idx)
  {
    return sequence_idx << DIALOG_MANAGER.__BITMASK_POSITION_SEQUENCE_SHIFT & DIALOG_MANAGER.__BITMASK_POSITION_SEQUENCE_MASK;
  }



  /**
   * @desc Encodes a dialog position given an index.
   * @param {Real} dialog_idx The dialog index to encode.
   * @returns {Real}
   */

  static __encode_dialog_idx = function(dialog_idx)
  {
    return dialog_idx << DIALOG_MANAGER.__BITMASK_POSITION_DIALOG_SHIFT & DIALOG_MANAGER.__BITMASK_POSITION_DIALOG_MASK;
  }



  /**
   * @desc Encodes jump settings into a position.
   * @param {Constant.DIALOG_MANAGER} jump_type The jump type to encode.
   * @param {Constant.DIALOG_MANAGER} jump_unit The jump unit to encode.
   * @returns {Real}
   */

  static __encode_jump_settings = function(jump_type, jump_unit)
  {
    return __encode_jump_setting_type(jump_type) | __encode_jump_setting_unit(jump_unit);
  }



  /**
   * @desc Encodes a jump type into a position.
   * @param {Constant.DIALOG_MANAGER} jump_type The jump type to encode.
   * @returns {Real}
   */

  static __encode_jump_setting_type = function(jump_type)
  {
    return jump_type << DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_TYPE_SHIFT & DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_TYPE_MASK;
  }



  /**
   * @desc Encodes a jump unit into a position.
   * @param {Constant.DIALOG_MANAGER} jump_unit The jump unit to encode.
   * @returns {Real}
   */

  static __encode_jump_setting_unit = function(jump_unit)
  {
    return jump_unit << DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_UNIT_SHIFT & DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_UNIT_MASK;
  }



  /**
   * @desc Returns the scene index given a position.
   * @param {Real} position The position to decode.
   * @returns {Real}
   */

  static __decode_scene_idx = function(position)
  {
    return (position & DIALOG_MANAGER.__BITMASK_POSITION_SCENE_MASK) >> DIALOG_MANAGER.__BITMASK_POSITION_SCENE_SHIFT;
  }



  /**
   * @desc Returns the sequence index given a position.
   * @param {Real} position The position to decode.
   * @returns {Real}
   */

  static __decode_sequence_idx = function(position)
  {
    return (position & DIALOG_MANAGER.__BITMASK_POSITION_SEQUENCE_MASK) >> DIALOG_MANAGER.__BITMASK_POSITION_SEQUENCE_SHIFT;
  }



  /**
   * @desc Returns the dialog index given a position.
   * @param {Real} position The position to decode.
   * @returns {Real}
   */

  static __decode_dialog_idx = function(position)
  {
    return (position & DIALOG_MANAGER.__BITMASK_POSITION_DIALOG_MASK) >> DIALOG_MANAGER.__BITMASK_POSITION_DIALOG_SHIFT;
  }



  /**
   * @desc Returns the jump unit given a jump settings bitfield.
   * @param {Real} [jump_settings] The jump settings decode from.
   * @returns {Constant.DIALOG_MANAGER|Real}
   */

  static __decode_jump_setting_type = function(jump_settings)
  {
    return (jump_settings & DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_TYPE_MASK) >> DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_TYPE_SHIFT;
  }



  /**
   * @desc Returns the jump unit given a jump setting bitfield.
   * @param {Real} [jump_settings] The jump settings to decode from.
   * @returns {Constant.DIALOG_MANAGER|Real}
   */

  static __decode_jump_setting_unit = function(jump_settings)
  {
    return (jump_settings & DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_UNIT_MASK) >> DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_UNIT_SHIFT;
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
   * @desc Returns a scene given its relative index from a position.
   * @param {Real} scene_shift The relative index shift of the scene. Defaults to `0`. Negative indices will iterate backwards.
   * @param {Real} start_position The position where to start the iteration. Defaults to current position.
   * @param {Constant.DIALOG_MANAGER|Real} jump_settings The settings of the jump to perform.
   * @returns {Struct} { position: Struct.DialogScene, status: Constant.DIALOG_RUNNER|Real }
   */

  static __get_scene_relative = function(scene_shift, start_position, jump_settings)
  {
    var shift_cancelled = (jump_settings & DIALOG_RUNNER.__BITMASK_MASK_JUMP_SETTING_MAINTAIN_BEHAVIOUR_MASK) != 0
      , status = (shift_cancelled && jump_settings & DIALOG_RUNNER.JUMP_SETTING_MAINTAIN_SCENE) * DIALOG_RUNNER.STATUS_MAINTAINED_SCENE
        | (shift_cancelled && jump_settings & DIALOG_RUNNER.JUMP_SETTING_MAINTAIN_SEQUENCE) * DIALOG_RUNNER.STATUS_MAINTAINED_SEQUENCE
        | (shift_cancelled && jump_settings & DIALOG_RUNNER.JUMP_SETTING_MAINTAIN_DIALOG) * DIALOG_RUNNER.STATUS_MAINTAINED_DIALOG
    ;

    return {
      position: self.scene((__decode_scene_idx(start_position) + scene_shift * !status) % self.scene_count),
      status,
    };
  }



  /**
   * @desc Returns a sequence given its relative index from a position.
   * @param {Real} sequence_shift The relative index shift of the sequence. Defaults to `0`. Negative indices will iterate backwards.
   * @param {Real} start_position The position where to start the iteration. Defaults to current position.
   * @param {Constant.DIALOG_MANAGER|Real} jump_settings The settings of the jump to perform.
   * @returns {Struct} { position: Struct.DialogSequence, status: Constant.DIALOG_RUNNER|Real }
   */

  static __get_sequence_relative = function(sequence_shift, start_position, jump_settings)
  {
    var shift_cancelled = (jump_settings & (DIALOG_RUNNER.JUMP_SETTING_MAINTAIN_SEQUENCE | DIALOG_RUNNER.JUMP_SETTING_MAINTAIN_DIALOG)) != 0
      , status = (shift_cancelled && jump_settings & DIALOG_RUNNER.JUMP_SETTING_MAINTAIN_SEQUENCE) * DIALOG_RUNNER.STATUS_MAINTAINED_SEQUENCE
        | (shift_cancelled && jump_settings & DIALOG_RUNNER.JUMP_SETTING_MAINTAIN_DIALOG) * DIALOG_RUNNER.STATUS_MAINTAINED_DIALOG
    ;

    sequence_shift *= !shift_cancelled;

    var next_scene_idx = __decode_scene_idx(start_position)
      , next_scene = self.scene(next_scene_idx)
      , next_sequence_idx = __decode_sequence_idx(start_position)
      , shift_sign = sign(sequence_shift)
      , _in_range = function(val, min, max) {
        return val >= min && val < max;
      }
    ;

    if (jump_settings & DIALOG_RUNNER.JUMP_SETTING_MAINTAIN_SCENE) {
      var target_sequence_idx = next_sequence_idx + sequence_shift;
      next_sequence_idx = clamp(target_sequence_idx, 0, next_scene.sequence_count - 1);
      status |= DIALOG_RUNNER.STATUS_MAINTAINED_SCENE * !_in_range(target_sequence_idx, 0, next_scene.sequence_count);
      sequence_shift = 0;
    }
    else if (!_in_range(next_sequence_idx + sequence_shift, 0, next_scene.sequence_count))
    {
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
    }

    return {
      position: self.sequence(next_sequence_idx + sequence_shift, next_scene_idx),
      status,
    };
  }



  /**
   * @desc Returns a dialog given its relative index from a position.
   * @param {Real} dialog_shift The relative index shift of the dialog. Defaults to `0`. Negative indices will iterate backwards.
   * @param {Real} start_position The position where to start the iteration. Defaults to current position.
   * @param {Constant.DIALOG_MANAGER|Real} jump_settings The settings of the jump to perform.
   * @returns {Struct} { position: Struct.Dialog, status: Constant.DIALOG_RUNNER|Real }
   */

  static __get_dialog_relative = function(dialog_shift, start_position, jump_settings)
  {
    var shift_cancelled = (jump_settings & DIALOG_RUNNER.JUMP_SETTING_MAINTAIN_DIALOG) != 0
      , status = shift_cancelled * DIALOG_RUNNER.STATUS_MAINTAINED_DIALOG
    ;

    dialog_shift *= !shift_cancelled;

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

    if (jump_settings & DIALOG_RUNNER.JUMP_SETTING_MAINTAIN_SEQUENCE) {
      var target_dialog_idx = next_dialog_idx + dialog_shift;
      next_dialog_idx = clamp(target_dialog_idx, 0, next_sequence.dialog_count - 1);
      status |= DIALOG_RUNNER.STATUS_MAINTAINED_SEQUENCE * !_in_range(target_dialog_idx, 0, next_sequence.dialog_count);
      dialog_shift = 0;
    }
    else if (!_in_range(next_dialog_idx + dialog_shift, 0, next_sequence.dialog_count))
    {
      var dialog_diff = shift_sign ? next_dialog_idx + 1 : next_sequence.dialog_count - next_dialog_idx;
      next_dialog_idx = shift_sign ? -1 : next_sequence.dialog_count;
      dialog_shift += dialog_diff * shift_sign;

      while (!_in_range(next_dialog_idx + dialog_shift, 0, next_sequence.dialog_count))
      {
        dialog_shift -= next_sequence.dialog_count * shift_sign;
        next_sequence_idx += shift_sign;

        if (!_in_range(next_sequence_idx, 0, next_scene.sequence_count))
        {
          if (jump_settings & DIALOG_RUNNER.JUMP_SETTING_MAINTAIN_SCENE) {
            next_dialog_idx = shift_sign ? next_sequence.dialog_count - 1 : 0;
            status |= DIALOG_RUNNER.STATUS_MAINTAINED_SCENE;
            next_sequence_idx -= shift_sign;
            dialog_shift = 0;
            break;
          }

          next_scene_idx = __index_wrap(next_scene_idx + shift_sign, 0, self.scene_count);
          next_scene = self.scene(next_scene_idx);
          next_sequence_idx = shift_sign ? 0 : next_scene.sequence_count - 1;
        }

        next_sequence = self.sequence(next_sequence_idx, next_scene_idx);
        next_dialog_idx = shift_sign ? -1 : next_sequence.dialog_count;
      }
    }

    return {
      position: self.dialog(next_dialog_idx + dialog_shift, next_sequence_idx, next_scene_idx),
      status,
    };
  }



  /**
   * Evaluates a given position to determine the destination of a jump. Throws DIALOG_MANAGER.ERR_INVALID_POSITION if the resolved position is out of bounds.
   * @param {Real|Constant.DIALOG_MANAGER|Struct.DialogLinkable} position The position to resolve. Defaults to current position.
   * @param {Real|Constant.DIALOG_MANAGER|Struct.DialogLinkable} [prev_position] The last stacked absolute position. Defaults to current position.
   * @param {Constant.DIALOG_MANAGER|Real} [jump_settings] The settings of the jump to perform.
   * @returns {Real}
   */

  static __resolve_position = function(position, prev_position = 0, jump_settings = 0)
  {
    if (__decode_jump_setting_type(jump_settings) == DIALOG_RUNNER.JUMP_SETTING_TYPE_RELATIVE)
      return self.__resolve_position_relative(position, prev_position, jump_settings).position;

    return self.__resolve_position_absolute(position, jump_settings);
  }



  /**
   * Evaluates a given position to determine the destination of a jump. Throws DIALOG_MANAGER.ERR_INVALID_POSITION if the resolved position is out of bounds.
   * @param {Real|Constant.DIALOG_MANAGER|Struct.DialogLinkable} position The position to resolve.
   * @param {Constant.DIALOG_MANAGER|Real} [jump_settings] The settings of the jump to perform.
   * @returns {Real}
   */

  static __resolve_position_absolute = function(position, jump_settings = 0)
  {
    if (is_instanceof(position, DialogLinkable))
      return position.position();

    var dialog_idx = __decode_dialog_idx(self.position)
      , sequence_idx = __decode_sequence_idx(self.position)
      , scene_idx = __decode_scene_idx(self.position)
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
        return __get_sequence_relative(1, position, jump_settings).position.position();
      case DIALOG_MANAGER.POSITION_CODE_SEQUENCE_END:
        return __encode_position(scene_idx, sequence_idx, sequence.dialog_count - 1);
      case DIALOG_MANAGER.POSITION_CODE_SEQUENCE_MIDDLE:
        return __encode_position(scene_idx, sequence_idx, sequence.dialog_count >> 1);
      case DIALOG_MANAGER.POSITION_CODE_SEQUENCE_START:
        return __encode_position(scene_idx, sequence_idx, 0);
      case DIALOG_MANAGER.POSITION_CODE_SEQUENCE_PREVIOUS:
        return __get_sequence_relative(-1, position, jump_settings).position.position();
    }

    dialog_idx = __decode_dialog_idx(position);
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

    return position ?? DIALOG_MANAGER.POSITION_CODE_NONE;
  }



  /**
   * @desc Evaluates a given position to determine the destination of a relative jump.
   * @param {Real|Constant.DIALOG_MANAGER|Struct.DialogLinkable} position The position to resolve. Defaults to current position.
   * @param {Real|Constant.DIALOG_MANAGER|Struct.DialogLinkable} prev_position The last stacked absolute position. Defaults to current position.
   * @param {Constant.DIALOG_MANAGER|Real} jump_settings The settings of the jump to perform.
   * @returns {Struct} { position: Real, status: Real }
   */

  static __resolve_position_relative = function(position, prev_position, jump_settings)
  {
    if (is_instanceof(prev_position, DialogLinkable))
      prev_position = prev_position.position();

    var target_position = DIALOG_MANAGER.POSITION_CODE_NONE;

    switch (__decode_jump_setting_unit(jump_settings))
    {
      case DIALOG_RUNNER.JUMP_UNIT_SCENE:
        target_position = __get_scene_relative(position, prev_position, jump_settings);
      break;

      case DIALOG_RUNNER.JUMP_UNIT_SEQUENCE:
        target_position = __get_sequence_relative(position, prev_position, jump_settings);
      break;

      case DIALOG_RUNNER.JUMP_UNIT_DIALOG:
        target_position = __get_dialog_relative(position, prev_position, jump_settings);
      break;
    }

    return {
      position: target_position.position.position(),
      status: target_position.status
    };
  }



  /**
   * @desc Resets the state of the manager. [CHAINABLE]
   * @returns {Struct.DialogManager}
   */

  static __reset_parser_state = function()
  {
    self.scenes = [];
    self.scene_count = 0;

    return self;
  }



  self.deserialize(data_string, is_file);
}












// ----------------------------------------------------------------------------












/**
 * @desc `DialogLinkable` constructor. Used to generalize dialog components' types.
 * @returns {Struct.DialogLinkable}
 */

function DialogLinkable(settings_mask) constructor
{
  static __CONSTRUCTOR_ARGC = argument_count;

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
  static __CONSTRUCTOR_ARGC = argument_count;

  self.sequences = [];
  self.scene_idx = 0;
  self.sequence_count = 0;
  self.manager = undefined;



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
      array_map(self.sequences, function(sequence) {
        return sequence.__DIALOG_MANAGER_SERIALIZER_METHOD__();
      }),
      int64(self.settings_mask),
      int64(self.sequence_count),
    ];
  }



  /**
   * @desc Serialises the scene into a plain struct.
   * @returns {Struct}
   */

  static __struct = function()
  {
    return {
      sequences: array_map(self.sequences, function(sequence) {
        return sequence.__DIALOG_MANAGER_SERIALIZER_METHOD__();
      }),
      settings_mask: int64(self.settings_mask),
      sequence_count: int64(self.sequence_count),
    };
  }



  /**
   * @desc Deserializes a scene from an array produced by {@link __array}.
   * @param {Array<Any>} data The array payload.
   * @returns {Struct.DialogScene}
   */

  static __from_array = function(data)
  {
    return new DialogScene([], data[DIALOG_SCENE.ARG_SETTINGS_MASK])
      .__parse(data[DIALOG_SCENE.ARG_SEQUENCES], data[DIALOG_SCENE.ARG_SEQUENCE_COUNT])
    ;
  }



  /**
   * @desc Deserializes a scene from a struct produced by {@link __struct}.
   * @param {Struct} data The struct payload.
   * @returns {Struct.DialogScene}
   */

  static __from_struct = function(data)
  {
    return new DialogScene([], data.settings_mask)
      .__parse(data.sequences, data.sequence_count)
    ;
  }



  /**
   * @desc Serialises the scene to JSON.
   * @param {Bool} [prettify] Whether the string should have line breaks/indentation (`true`) or not (`false`).
   * @returns {String}
   */

  static __serialize = function(prettify = false)
  {
    return json_stringify(DialogScene.__DIALOG_MANAGER_SERIALIZER_METHOD__(), prettify);
  }



  /**
   * @desc Deserialises a JSON string produced by {@link __serialize}.
   * @param {String} data_string The JSON payload.
   * @returns {Struct.DialogScene}
   */

  static __deserialize = function(data_string)
  {
    return DialogScene.__DIALOG_MANAGER_DESERIALIZER_METHOD__(json_parse(data_string));
  }



  /**
   * @desc Prepares the data inside the DialogScene structure.
   * @param {Array<Struct>} sequences The sequences to update.
   * @param {Real} sequence_count The number of sequences.
   * @returns {Struct.DialogScene}
   */

  static __parse = function(sequences, sequence_count)
  {
    for (var i = 0; i < sequence_count; ++i) {
      var sequence = DialogSequence.__DIALOG_MANAGER_DESERIALIZER_METHOD__(sequences[i]);
      sequence.sequence_idx = i;
      sequence.scene = self;
      sequences[i] = sequence;
    }

    self.sequence_count = sequence_count;
    self.sequences = sequences;

    return self;
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
  static __CONSTRUCTOR_ARGC = argument_count;

  self.dialogs = [];
  self.speakers = speakers;
  self.sequence_idx = 0;
  self.dialog_count = 0;
  self.scene = undefined;



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
      int64(self.settings_mask),
      array_map(self.dialogs, function(dialog) {
        return dialog.__DIALOG_MANAGER_SERIALIZER_METHOD__();
      }),
      array_map(self.speakers, function(speaker) {
        return int64(speaker);
      }),
      int64(self.dialog_count),
    ];
  }



  /**
   * @desc Serialises the sequence into a plain struct.
   * @returns {Struct}
   */

  static __struct = function()
  {
    return {
      settings_mask: int64(self.settings_mask),
      dialogs: array_map(self.dialogs, function(dialog) {
        return dialog.__DIALOG_MANAGER_SERIALIZER_METHOD__();
      }),
      speakers: array_map(self.speakers, function(speaker) {
        return int64(speaker);
      }),
      dialog_count: int64(self.dialog_count),
    };
  }



  /**
   * @desc Deserialises a sequence from an array produced by {@link __array}.
   * @param {Array} data The array payload.
   * @returns {Struct.DialogSequence}
   */

  static __from_array = function(data)
  {
    return new DialogSequence([], data[DIALOG_SEQUENCE.ARG_SETTINGS_MASK], data[DIALOG_SEQUENCE.ARG_SPEAKERS])
      .__parse(data[DIALOG_SEQUENCE.ARG_DIALOGS], data[DIALOG_SEQUENCE.ARG_DIALOG_COUNT])
    ;
  }



  /**
   * @desc Deserialises a sequence from a struct produced by {@link __struct}.
   * @param {Struct} data The struct payload.
   * @returns {Struct.DialogSequence}
   */

  static __from_struct = function(data)
  {
    return new DialogSequence([], data.settings_mask, data.speakers)
      .__parse(data.dialogs, data.dialog_count)
    ;
  }



  /**
   * @desc Serialises the sequence to JSON.
   * @param {Bool} [prettify] Whether the string should have line breaks/indentation (`true`) or not (`false`).
   * @returns {String}
   */

  static __serialize = function(prettify = false)
  {
    return json_stringify(DialogSequence.__DIALOG_MANAGER_SERIALIZER_METHOD__(), prettify);
  }



  /**
   * @desc Deserialises a JSON string produced by {@link __serialize}.
   * @param {String} data_string The JSON payload.
   * @returns {Struct.DialogSequence}
   */

  static __deserialize = function(data_string)
  {
    return DialogSequence.__DIALOG_MANAGER_DESERIALIZER_METHOD__(json_parse(data_string));
  }



  /**
   * @desc Prepares the data inside the DialogSequence structure.
   * @param {Array<Struct>} dialogs The dialogs to update.
   * @param {Real} dialog_count The number of dialogs.
   * @returns {Struct.DialogSequence}
   */

  static __parse = function(dialogs, dialog_count)
  {
    for (var i = 0; i < dialog_count; ++i) {
      var dialog = Dialog.__DIALOG_MANAGER_DESERIALIZER_METHOD__(dialogs[i]);
      dialog.dialog_idx = i;
      dialog.sequence = self;
      dialogs[i] = dialog;
    }

    self.dialog_count = dialog_count;
    self.dialogs = dialogs;

    return self;
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
  static __CONSTRUCTOR_ARGC = argument_count;
  static TEXT_WIDTH_MAX = -1;
  static TEXT_WIDTH_FUNC = function(dialog) {
    return string_width(dialog.text);
  }

  self.text = text;
  self.fx_map = [];
  self.dialog_idx = 0;
  self.fx_count = 0;
  self.sequence = undefined;

  if (Dialog.TEXT_WIDTH_MAX)
  {
    var text_width = Dialog.TEXT_WIDTH_FUNC(self);

    if (text_width > Dialog.TEXT_WIDTH_MAX) {
      throw DialogManager.ERROR(DIALOG_MANAGER.ERR_TEXT_OVERFLOW, [
        text_width, Dialog.TEXT_WIDTH_MAX, self.__struct()
      ]);
    }
  }

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
   * @param {Real} n The effect position to look for.
   * @param {Function} [filter_fn] The predicate to test against each jump FX. Defaults to a function returning `true`.
   * @param {Array} [argv] The arguments to pass to the effect.
   * @returns {Struct.DialogFX}
   */

  static fx = function(n, filter_fn = undefined, argv = undefined)
  {
    return filter_fn
      ? __fx_get_nth_of(n, filter_fn, argv)
      : self.fx_map[n + self.fx_count * (n < 0)]
    ;
  }



  /**
   * @desc Returns the specified n-th flow resolver FX in this dialog, if one exists.
   * @param {Real} [n] The effect position to look for.
   * @param {Function} [filter_fn] The predicate to test against each flow resolver FX. Defaults to a function returning `true`.
   * @param {Array} [argv] The arguments to pass to the effect.
   * @returns {Struct.DialogFX|undefined}
   */

  static flowresolver = function(n = 1, filter_fn = function(fx, argv) { return true; }, argv = undefined)
  {
    return __fx_get_nth_of(n, function(fx, argv) {
      return fx.isflowresolver() && argv[0](fx, argv[1]);
    }, [filter_fn, argv]);
  }



  /**
   * @desc Returns the specified n-th jump FX in this dialog, if one exists.
   * @param {Real} [n] The effect position to look for.
   * @param {Function} [filter_fn] The predicate to test against each jump FX. Defaults to a function returning `true`.
   * @param {Array} [argv] The arguments to pass to the effect.
   * @returns {Struct.DialogFX|undefined}
   */

  static jump = function(n = 1, filter_fn = function(fx, argv) { return true; }, argv = undefined)
  {
    return __fx_get_nth_of(n, function(fx, argv) {
      return fx.type() == DIALOG_FX.TYPE_FLOWRES_JUMP && argv[0](fx, argv[1]);
    }, [filter_fn, argv]);
  }



  /**
   * @desc Returns the specified n-th dispatch FX in this dialog, if one exists.
   * @param {Real} [n] The effect position to look for.
   * @param {Function} [filter_fn] The predicate to test against each dispatch FX. Defaults to a function returning `true`.
   * @param {Array} [argv] The arguments to pass to the effect.
   * @returns {Struct.DialogFX|undefined}
   */

  static dispatch = function(n = 1, filter_fn = function(fx, argv) { return true; }, argv = undefined)
  {
    return __fx_get_nth_of(n, function(fx, argv) {
      return fx.type() == DIALOG_FX.TYPE_FLOWRES_DISPATCH && argv[0](fx, argv[1]);
    }, [filter_fn, argv]);
  }



  /**
   * @desc Returns the specified n-th fallback FX in this dialog, if one exists.
   * @param {Real} [n] The effect position to look for.
   * @param {Function} [filter_fn] The predicate to test against each fallback FX. Defaults to a function returning `true`.
   * @param {Array} [argv] The arguments to pass to the effect.
   * @returns {Struct.DialogFX|undefined}
   */

  static fallback = function(n = 1, filter_fn = function(fx, argv) { return true; }, argv = undefined)
  {
    return __fx_get_nth_of(n, function(fx, argv) {
      return fx.type() == DIALOG_FX.TYPE_FLOWRES_FALLBACK && argv[0](fx, argv[1]);
    }, [filter_fn, argv]);
  }



  /**
   * @desc Returns the specified n-th choice FX in this dialog, if one exists.
   * @param {Real} [n] The effect position to look for.
   * @param {Function} [filter_fn] The predicate to test against each choice FX. Defaults to a function returning `true`.
   * @param {Array} [argv] The arguments to pass to the effect.
   * @returns {Struct.DialogFX|undefined}
   */

  static choice = function(n = 1, filter_fn = function(fx, argv) { return true; }, argv = undefined)
  {
    return __fx_get_nth_of(n, function(fx, argv) {
      return fx.type() == DIALOG_FX.TYPE_FLOWRES_CHOICE && argv[0](fx, argv[1]);
    }, [filter_fn, argv]);
  }



  /**
   * @desc Makes the current dialog derive from a specified fx adding the calling dialog to the fx flow option list. [CHAINABLE]
   * @param {Struct.DialogFX} fx The effect derive the dialog from.
   * @param {String} [prompt] The choice's option text.
   * @param {Real} [index] The specific index where to insert the new option in the option list. Defaults to list length.
   * @param {Constant.DIALOG_RUNNER|Real} [jump_metadata_settings] The settings mask for the flow option.
   * @returns {Struct.Dialog}
   */

  static from = function(fx, prompt = undefined, index = undefined, jump_metadata_settings = 0)
  {
    var type = fx.type();

    if (!fx.isflowresolver(type))
      return self;

    var flow_option_list = fx.argv[DIALOG_FX.FX_ARG_FLOWRES_DATA]
      , flow_option_count = array_length(flow_option_list)
      , flow_option = DialogFX.__create_option_flow(self, 0, prompt, jump_metadata_settings)
    ;

    switch (type)
    {
      case DIALOG_FX.TYPE_FLOWRES_JUMP:
      case DIALOG_FX.TYPE_FLOWRES_FALLBACK:
        flow_option_list[DIALOG_FX.FX_ARG_FLOWRES_DATA_POSITION] = flow_option;
      break;

      case DIALOG_FX.TYPE_FLOWRES_CHOICE:
      case DIALOG_FX.TYPE_FLOWRES_DISPATCH:
      {
        index ??= flow_option_count;

        if (index >= flow_option_count || is_array(flow_option_list[index]))
          array_insert(flow_option_list, index, flow_option);
        else
          flow_option_list[index] = flow_option;
      }
      break;
    }

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
   * @param {Function} [filter_fn] The predicate to test against each FX. Defaults to a function returning `true`.
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
   * @desc Retrieves the first dialog FX which matches a filter.
   * @param {Function} [filter_fn] The predicate to test against each FX. Defaults to a function returning `true`.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the effects.
   * @returns {Struct.DialogFX}
   */

  static __fx_get_first_of = function(filter_fn = function(fx, argv = undefined) { return true; }, argv = undefined)
  {
    for (var i = 0; i < self.fx_count; ++i)
      if (filter_fn(self.fx_map[i], argv))
        return self.fx_map[i];

    return undefined;
  }



  /**
   * @desc Retrieves the last dialog FX which matches a filter.
   * @param {Function} [filter_fn] The predicate to test against each FX. Defaults to a function returning `true`.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the effects.
   * @returns {Struct.DialogFX}
   */

  static __fx_get_last_of = function(filter_fn = function(fx, argv = undefined) { return true; }, argv = undefined)
  {
    var fx = undefined;

    for (var i = 0; i < self.fx_count; ++i)
      if (filter_fn(self.fx_map[i], argv))
        fx = self.fx_map[i];

    return fx;
  }



  /**
   * @desc Retrieves the nth dialog FX which matches a filter.
   * @param {Real} n The nth occurrence to look for.
   * @param {Function} [filter_fn] The predicate to test against each FX. Defaults to a function returning `true`.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the effects.
   * @returns {Struct.DialogFX|undefined}
   */

  static __fx_get_nth_of = function(n, filter_fn = function(fx, argv = undefined) { return true; }, argv = undefined)
  {
    var fx = undefined;

    for (var i = 0; n && i < self.fx_count; ++i)
      if (filter_fn(self.fx_map[i], argv) && n--)
        fx = self.fx_map[i];

    return n ? undefined : fx;
  }



  /**
   * @desc Retrieves all dialog FX which match a filter.
   * @param {Function} [filter_fn] The predicate to test against each FX. Defaults to a function returning `true`.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the effects.
   * @returns {Array<Struct.DialogFX>}
   */

  static __fx_get_all_of = function(filter_fn = function(fx, argv = undefined) { return true; }, argv = undefined)
  {
    return __fx_get_all_of_until(
      function(fx, argv = undefined) { return false; },
      filter_fn,
      argv
    );
  }



  /**
   * @desc Retrieves all dialog FX until the filter is met.
   * @param {Function} [stop_fn] The predicate to test against each FX. Defaults to a function returning `true`.
   * @param {Function} [filter_fn] The predicate to test against each FX. Defaults to a function returning `true`.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the effects.
   * @returns {Array<Struct.DialogFX>}
   */

  static __fx_get_all_of_until = function(stop_fn = function(fx, argv = undefined) { return true; }, filter_fn = function(fx, argv = undefined) { return true; }, argv = undefined)
  {
    var filtered = [];

    for (var i = 0; i < self.fx_count; ++i)
    {
      var fx = self.fx_map[i];

      if (stop_fn(fx, argv))
        break;

      if (filter_fn(fx, argv))
        array_push(filtered, fx);
    }

    return filtered;
  }



  /**
   * @desc Executes all dialog FX which match a filter. [CHAINABLE]
   * @param {Function} [filter_fn] The predicate to test against each FX. Defaults to a function returning `true`.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the effects.
   * @returns {Struct.Dialog}
   */

  static __fx_execute_all_of = function(filter_fn = function(fx, argv) { return true; }, argv = undefined)
  {
    return __fx_execute_all_of_until(
      function (fx, argv = undefined) { return false; },
      filter_fn,
      argv
    );
  }



  /**
   * @desc Executes all dialog FX which match a filter. [CHAINABLE]
   * @param {Function} [stop_fn] The predicate to test against each FX. Defaults to a function returning `true`.
   * @param {Function} [filter_fn] The predicate to test against each FX. Defaults to a function returning `true`.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the effects.
   * @returns {Struct.Dialog}
   */

  static __fx_execute_all_of_until = function(stop_fn = function(fx, argv = undefined) { return true; }, filter_fn = function(fx, argv = undefined) { return true; }, argv = undefined)
  {
    for (var i = 0; i < self.fx_count; ++i)
    {
      var fx = self.fx_map[i];

      if (stop_fn(fx, argv))
        return self;

      if (filter_fn(fx, argv))
        fx.execute(argv);
    }

    return self;
  }



  /**
   * @desc Executes dialog FX in sequence until a flow resolver is found. Returns the context after execution.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the effects.
   * @param {Struct.DialogCycleContext} [ctx] The context to pass to the effects.
   * @param {Constant.DIALOG_FX|Real} [trigger] The trigger causing the cycle execution.
   * @param {Function} [filter_fn] The predicate to test against each FX. Defaults to a function returning `true`.
   * @returns {Struct.DialogCycleContext}
   */

  static __fx_execute_cycle = function(argv = undefined, ctx = undefined, trigger = DIALOG_FX.TRIGGER_NONE, filter_fn = function(fx, argv = undefined) { return true; })
  {
    var resolved = false;

    for (var i = 0; i < self.fx_count; ++i)
    {
      var fx = self.fx_map[i];

      if (fx.trigger() != trigger || !filter_fn(fx, argv))
        continue;

      if (fx.execute(argv, ctx) && fx.iscyclebreaker(ctx)) {
        resolved = true;
        break;
      }
    }

    return resolved ? ctx : undefined;
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
        return fx.__DIALOG_MANAGER_SERIALIZER_METHOD__();
      }),
      int64(self.fx_count),
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
        return fx.__DIALOG_MANAGER_SERIALIZER_METHOD__();
      }),
      fx_count: int64(self.fx_count),
    };
  }



  /**
   * @desc Deserialises a dialog from an array produced by {@link __array}.
   * @param {Array<Any>} data The array payload.
   * @returns {Struct.Dialog}
   */

  static __from_array = function(data)
  {
    var dialog = new Dialog(
      data[DIALOG.ARG_TEXT],
      data[DIALOG.ARG_SETTINGS_MASK],
      array_map(data[DIALOG.ARG_FX_MAP], function(fx) {
        return DialogFX.__DIALOG_MANAGER_DESERIALIZER_METHOD__(fx);
      })
    );

    dialog.fx_count = data[DIALOG.ARG_FX_COUNT];

    return dialog;
  }



  /**
   * @desc Deserialises a dialog from a struct produced by {@link __struct}.
   * @param {Struct} data The struct payload.
   * @returns {Struct.Dialog}
   */

  static __from_struct = function(data)
  {
    var dialog = new Dialog(
      data.text,
      data.settings_mask,
      array_map(data.fx_map, function(fx) {
        return DialogFX.__DIALOG_MANAGER_DESERIALIZER_METHOD__(fx);
      })
    );

    dialog.fx_count = data.fx_count;

    return dialog;
  }



  /**
   * @desc Serialises the dialog to JSON.
   * @param {Bool} [prettify] Whether the string should have line breaks/indentation (`true`) or not (`false`).
   * @returns {String}
   */

  static __serialize = function(prettify = false)
  {
    return json_stringify(Dialog.__DIALOG_MANAGER_SERIALIZER_METHOD__(), prettify);
  }



  /**
   * @desc Deserialises a JSON string produced by {@link __serialize}.
   * @param {String} data_string The JSON payload.
   * @returns {Struct.Dialog}
   */

  static __deserialize = function(data_string)
  {
    return Dialog.__DIALOG_MANAGER_DESERIALIZER_METHOD__(json_parse(data_string));
  }



  add(fx_map);
}












// ----------------------------------------------------------------------------












/**
 * `DialogFX` constructor.
 * @param {Constant.DIALOG_FX|Real} settings_mask The effect info.
 * @param {Array<Any>} argv The arguments of the mapped effect function.
 * @returns {Struct.DialogFX}
 */

function DialogFX(settings_mask, argv) constructor
{
  static __CONSTRUCTOR_ARGC = argument_count;
  static data = {
    initialized: false,
    fx_map: {
      funcs: [
        /* Make and add behavior functions to index here */
        function(argv, ctx) { },
        function(argv, ctx) { return DialogFX.__fx_jump(argv, ctx);     },
        function(argv, ctx) { return DialogFX.__fx_dispatch(argv, ctx); },
        function(argv, ctx) { return DialogFX.__fx_fallback(argv, ctx); },
        function(argv, ctx) { return DialogFX.__fx_choice(argv, ctx);   },
      ],
    },
    fx_condition_map: {
      funcs: [
        /* Make and add condition functions to index here */
        function(argv, ctx) { return false; },
        function(argv, ctx) { return true; },
      ],
    },
    fx_indexer_map: {
      funcs: [
        /* Make and add indexing functions to index here */
        function(argv, ctx) { return ctx.runner.choice_index; }
      ],
    },
  };

  var fxdata = DialogFX.data;

  if (!fxdata.initialized) {
    fxdata.fx_map.count = array_length(fxdata.fx_map.funcs);
    fxdata.fx_condition_map.count = array_length(fxdata.fx_condition_map.funcs);
    fxdata.fx_indexer_map.count = array_length(fxdata.fx_indexer_map.funcs);
    fxdata.initialized = true;
  }



  self.settings_mask = settings_mask;
  self.argv = argv;



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
   * @desc Encodes/decodes the dialog FX signal as a bitmask fragment.
   * @param {Constant.DIALOG_FX|Real} [signal_mask] The signal identifier.
   * @returns {Real}
   */

  static signal = function(signal_mask = undefined)
  {
    return signal_mask == undefined
      ? (self.settings_mask & DIALOG_FX.__BITMASK_SIGNAL_MASK) >> DIALOG_FX.__BITMASK_SIGNAL_SHIFT
      : signal_mask << DIALOG_FX.__BITMASK_SIGNAL_SHIFT & DIALOG_FX.__BITMASK_SIGNAL_MASK
    ;
  }



  /**
   * @desc Encodes/decodes the dialog FX tag as a bitmask fragment.
   * @param {Constant.DIALOG_FX|Real} [tag_mask] The tag identifier.
   * @returns {Real}
   */

  static tag = function(tag_mask = undefined)
  {
    return tag_mask == undefined
      ? (self.settings_mask & DIALOG_FX.__BITMASK_TAG_MASK) >> DIALOG_FX.__BITMASK_TAG_SHIFT
      : tag_mask << DIALOG_FX.__BITMASK_TAG_SHIFT & DIALOG_FX.__BITMASK_TAG_MASK
    ;
  }



  /**
   * @desc Retrieves the flow resolver options data.
   * @returns {Array}
   */

  static options = function()
  {
    return self.isflowresolver()
      ? self.argv[DIALOG_FX.FX_ARG_FLOWRES_DATA]
      : undefined
    ;
  }



  /**
   * @desc Retrieves the flow resolver options data.
   * @param {Real} [option_idx] The index of the option to retrieve.
   * @returns {Array}
   */

  static option = function(option_idx = 0)
  {
    var flow_options = self.argv[DIALOG_FX.FX_ARG_FLOWRES_DATA]
      , flow_option_count = array_length(flow_options)
    ;

    return self.isflowresolver()
      ? flow_options[option_idx + flow_option_count * (option_idx < 0)]
      : undefined
    ;
  }



  /**
   * @desc Retrieves the flow resolver indexer index.
   * @returns {Real}
   */

  static indexer = function()
  {
    return self.isflowresolver()
      ? self.argv[DIALOG_FX.FX_ARG_FLOWRES_INDEXER_INDEX]
      : undefined
    ;
  }



  /**
   * @desc Retrieves the flow resolver condition index.
   * @returns {Real}
   */

  static condition = function()
  {
    return self.isflowresolver()
      ? self.argv[DIALOG_FX.FX_ARG_FLOWRES_CONDITION_INDEX]
      : undefined
    ;
  }



  /**
   * @desc Retrieves the flow resolver prompt text of a specified option.
   * @param {Real} [option_idx] The index of the option to retrieve the prompt for.
   * @returns {String}
   */

  static prompt = function(option_idx = 0)
  {
    var option = self.option(option_idx);
    
    return is_array(option)
      ? option[DIALOG_FX.FX_ARG_FLOWRES_DATA_PROMPT]
      : undefined
    ;
  }



  /**
   * @desc Retrieves the flow resolver metadata settings of a specified option.
   * @param {Real} [option_idx] The index of the option to retrieve the metadata for.
   * @returns {Constant.DIALOG_RUNNER|Real}
   */

  static metadata = function(option_idx = 0)
  {
    var option = self.option(option_idx);
    
    return is_array(option)
      ? option[DIALOG_FX.FX_ARG_FLOWRES_DATA_METADATA]
      : undefined
    ;
  }



  /**
   * @desc Checks whether the FX is a flow control effect.
   * @param {Constant.DIALOG_FX|Real} [type] The type of the effect to check.
   * @returns {Bool}
   */

  static isflowresolver = function(type = self.type())
  {
    return type && type <= DIALOG_FX.__TYPE_FLOWRES_COUNT;
  }



  /**
   * @desc Checks whether the FX is a cycle-breaking flow control effect.
   * @param {Struct.DialogCycleContext} [ctx] The context object with the environment data of for the effect.
   * @returns {Bool}
   */

  static iscyclebreaker = function(ctx = undefined)
  {
    return ctx && self.isflowresolver();
  }



  /**
   * @desc Adds an indexed function to the global dialog fx data. Throws DIALOG_MANAGER.ERR_MAX_FX_CAPACITY_REACHED if the maximum number of normal fx functions has been reached.
   * @param {Function} func The function to bind.
   * @param {Constant.DIALOG_FX|Real} [register_settings] The settings of the registering call.
   * @param {Constant.DIALOG_FX|Real} [type] The effect type designating the index.
   * @returns {Real}
   */

  static register = function(func, register_settings = DIALOG_FX.REGISTER_SETTING_FX_FUNC, type = undefined)
  {
    var mapdata = [
        DialogFX.data.fx_map,
        DialogFX.data.fx_indexer_map,
        DialogFX.data.fx_condition_map,
      ]
      , map = mapdata[(register_settings & DIALOG_FX.__BITMASK_REGISTER_MASK) >> DIALOG_FX.__BITMASK_REGISTER_SHIFT]
      , index = type ?? map.count
    ;

    if (register_settings == DIALOG_FX.REGISTER_SETTING_FX_FUNC && map.count >= DIALOG_FX.__BITMASK_TYPE_MAX_COUNT) {
      throw DialogManager.ERROR(DIALOG_MANAGER.ERR_MAX_FX_CAPACITY_REACHED, [
        index, DIALOG_FX.__BITMASK_TYPE_MAX_COUNT
      ]);
    }

    map.count += index >= map.count;
    map.funcs[index] = func;

    return index;
  }



  /**
   * @desc Executes the FX using the registered handlers, incrementing the context's executed count if a context is provided.
   * @param {Array<Any>} [argv] The arguments to pass to the effect.
   * @param {Struct.DialogCycleContext} [context] The context object with the environment data for the effect.
   * @returns {Any}
   */

  static execute = function(argv = self.argv, context = undefined)
  {
    if (is_instanceof(context, DialogCycleContext))
      ++context.executed;

    return DialogFX.data.fx_map.funcs[self.type()](argv, context);
  }



  /**
   * @desc Creates a flow option for a flow resolutor dialog effect.
   * @param {Constant.DIALOG_MANAGER|Real|Struct.DialogLinkable} jump_position The jump option destination.
   * @param {Constant.DIALOG_RUNNER|Real} [jump_settings] The settings mask for the jump data.
   * @param {String} [prompt] The flow option's text.
   * @param {Constant.DIALOG_FX|Real} [jump_metadata_settings] Extra bitmask data about the flow option.
   * @returns {Array}
   */

  static __create_option_flow = function(jump_position, jump_settings = 0, prompt = undefined, jump_metadata_settings = 0)
  {
    return [[jump_position, jump_settings], prompt, jump_metadata_settings];
  }



  /**
   * @desc Executes the inconditional jump effect.
   * @param {Array<Any>} argv The arguments to pass to the fx function.
   * @param {Struct.DialogCycleContext} ctx The context for the effect execution.
   * @returns {Struct.Dialog}
   */

  static __fx_jump = function(argv, ctx)
  {
    return ctx.success(
      argv[DIALOG_FX.FX_ARG_FLOWRES_DATA][0],
      DIALOG_RUNNER.STATUS_EXECUTED_JUMP
    );
  }



  /**
   * @desc Executes the branching jump effect.
   * @param {Array<Any>} argv The arguments to pass to the fx function.
   * @param {Struct.DialogCycleContext} ctx The context for the effect execution.
   * @returns {Struct.Dialog}
   */

  static __fx_dispatch = function(argv, ctx)
  {
    var fx_condition_index = argv[DIALOG_FX.FX_ARG_FLOWRES_CONDITION_INDEX]
      , fx_condition_argv = argv[DIALOG_FX.FX_ARG_FLOWRES_CONDITION_ARGV]
      , fx_indexer_index = argv[DIALOG_FX.FX_ARG_FLOWRES_INDEXER_INDEX]
      , fx_indexer_argv = argv[DIALOG_FX.FX_ARG_FLOWRES_INDEXER_ARGV]
    ;

    if (!ctx.condition(fx_condition_index, fx_condition_argv))
      return ctx.fail();

    var idx = ctx.indexer(fx_indexer_index, fx_indexer_argv);

    return ctx.success(
      argv[DIALOG_FX.FX_ARG_FLOWRES_DATA][idx],
      DIALOG_RUNNER.STATUS_EXECUTED_DISPATCH
    );
  }



  /**
   * @desc Executes the conditional jump effect.
   * @param {Array<Any>} argv The arguments to pass to the fx function.
   * @param {Struct.DialogCycleContext} ctx The context for the effect execution.
   * @returns {Struct.Dialog}
   */

  static __fx_fallback = function(argv, ctx)
  {
    var fx_condition_index = argv[DIALOG_FX.FX_ARG_FLOWRES_CONDITION_INDEX]
      , fx_condition_argv = argv[DIALOG_FX.FX_ARG_FLOWRES_CONDITION_ARGV]
    ;

    if (!ctx.condition(fx_condition_index, fx_condition_argv))
      return ctx.fail();

    return ctx.success(
      argv[DIALOG_FX.FX_ARG_FLOWRES_DATA][0],
      DIALOG_RUNNER.STATUS_EXECUTED_FALLBACK
    );
  }



  /**
   * @desc Executes the multi-option jump effect.
   * @param {Array<Any>} argv The arguments to pass to the fx function.
   * @param {Struct.DialogCycleContext} ctx The context for the effect execution.
   * @returns {Struct.Dialog}
   */

  static __fx_choice = function(argv, ctx)
  {
    var fx_indexer_index = argv[DIALOG_FX.FX_ARG_FLOWRES_INDEXER_INDEX]
      , fx_indexer_argv = argv[DIALOG_FX.FX_ARG_FLOWRES_INDEXER_ARGV]
      , idx = ctx.indexer(fx_indexer_index, fx_indexer_argv)
    ;

    if (idx <= DIALOG_FX.FX_ARG_FLOWRES_INDEX_UNSELECTED)
      return ctx.fail();

    return ctx.success(
      argv[DIALOG_FX.FX_ARG_FLOWRES_DATA][idx],
      DIALOG_RUNNER.STATUS_EXECUTED_CHOICE
    );
  }



  /**
   * @desc Serialises the FX into a compact array.
   * @returns {Array<Any>}
   */

  static __array = function()
  {
    return [
      int64(self.settings_mask),
      __resolve_recursive(self.argv),
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
      argv: __resolve_recursive(self.argv),
    };
  }



  /**
   * @desc Deserialises an FX from an array produced by {@link __array}.
   * @param {Array<Any>} data The array payload.
   * @returns {Struct.DialogFX}
   */

  static __from_array = function(data)
  {
    return new DialogFX(data[DIALOG_FX.ARG_SETTINGS_MASK], data[DIALOG_FX.ARG_ARGV]);
  }



  /**
   * @desc Deserialises an FX from a struct produced by {@link __struct}.
   * @param {Struct} data The struct payload.
   * @returns {Struct.DialogFX}
   */

  static __from_struct = function(data)
  {
    return new DialogFX(data.settings_mask, data.argv);
  }



  /**
   * @desc Serialises the FX to a JSON string.
   * @param {Bool} [prettify] Whether the string should be pretty-printed.
   * @returns {String}
   */

  static __serialize = function(prettify = false)
  {
    return json_stringify(DialogFX.__DIALOG_MANAGER_SERIALIZER_METHOD__(), prettify);
  }



  /**
   * @desc Deserialises a JSON string produced by {@link __serialize}.
   * @param {String} data_string The JSON payload.
   * @returns {Struct.DialogFX}
   */

  static __deserialize = function(data_string)
  {
    return DialogFX.__DIALOG_MANAGER_DESERIALIZER_METHOD__(json_parse(data_string));
  }



  // Recursive argument serializer function
  function __resolve_recursive(arg) {
    return is_array(arg)
      ? array_map(arg, __resolve_recursive)
      : (is_instanceof(arg, DialogLinkable)
        ? arg.position()
        : (is_numeric(arg) && frac(arg) == 0
          ? int64(arg)
          : arg
        )
      )
    ;
  }
}
