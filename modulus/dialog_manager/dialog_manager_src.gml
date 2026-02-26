/**
 * @desc A lightweight, bitmask-focused dialog management system.
 * @link https://github.com/MaximilianVolt/GMS2_scripts/tree/main/modulus/dialog_manager
 * @author @MaximilianVolt
 * @version 0.12.0
 */



#region Lib functions

#macro __DIALOG_MANAGER_VERSION__             "0.12.0"
#macro __DIALOG_MANAGER_LINK__                "https://github.com/MaximilianVolt/GMS2_scripts/tree/main/modulus/dialog_manager"
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
 * @param {String} [lang] The language to load from the file. Overridden if deserialized otherwise. Defaults to `"en"`.
 * @param {String|Id.TextFile} [data_string] The data to parse.
 * @param {Bool} [is_file] Specifies whether `data_string` is a file (`true`) or not (`false`).
 * @returns {Struct.DialogManager}
 */

function dialog_manager_create(lang = DialogManager.DATA.LANGS.ISO_639_1.english, data_string = "", is_file = false)
{
  return new DialogManager(lang, data_string, is_file);
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
      | (DialogScene.__bg(settings_mask) ? 0 : DialogScene.bg(DIALOG_SCENE.BG_DEFAULT))
      | (DialogScene.__bgm(settings_mask) ? 0 : DialogScene.bgm(DIALOG_SCENE.BGM_DEFAULT))
      | (DialogScene.__bgs(settings_mask) ? 0 : DialogScene.bgs(DIALOG_SCENE.BGS_DEFAULT))
      | (DialogScene.__tag(settings_mask) ? 0 : DialogScene.tag(DIALOG_SCENE.TAG_DEFAULT))
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
    settings_mask
      | (DialogSequence.__tag(settings_mask) ? 0 : DialogSequence.tag(DIALOG_SEQUENCE.TAG_DEFAULT)),
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
    settings_mask
      | (Dialog.__speaker(settings_mask) ? 0 : Dialog.speaker(DIALOG.SPEAKER_DEFAULT))
      | (Dialog.__emotion(settings_mask) ? 0 : Dialog.emotion(DIALOG.EMOTION_DEFAULT))
      | (Dialog.__anchor(settings_mask) ? 0 : Dialog.anchor(DIALOG.ANCHOR_DEFAULT))
      | (Dialog.__textbox(settings_mask) ? 0 : Dialog.textbox(DIALOG.TEXTBOX_DEFAULT))
      | (Dialog.__tag(settings_mask) ? 0 : Dialog.tag(DIALOG.TAG_DEFAULT)),
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












// ----------------------------------------------------------------------------












/**
 * @desc `DialogFX` constructor.
 * @param {Constant.DIALOG_FX|Real} [settings_mask] The effect info.
 * @param {Any|Array<Any>} [argv] The arguments of the mapped effect function.
 * @returns {Struct.DialogFX}
 */

function dialog_fx_create(settings_mask = 0, argv = [])
{
  return new DialogFX(
    settings_mask
      | (DialogFX.__type(settings_mask) ? 0 : DialogFX.type(DIALOG_FX.TYPE_DEFAULT))
      | (DialogFX.__trigger(settings_mask) ? 0 : DialogFX.trigger(DIALOG_FX.TRIGGER_DEFAULT))
      | (DialogFX.__signal(settings_mask) ? 0 : DialogFX.signal(DIALOG_FX.SIGNAL_DEFAULT))
      | (DialogFX.__tag(settings_mask) ? 0 : DialogFX.tag(DIALOG_FX.TAG_DEFAULT)),
    is_array(argv) ? argv : [argv]
  );
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
  return dialog_fx_create(
    DialogFX.__tag(settings_mask) | DialogFX.signal(DIALOG_FX.SIGNAL_STOP_CYCLE) | DialogFX.__trigger(settings_mask) | DialogFX.type(DIALOG_FX.TYPE_FLOWRES_JUMP),
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
  return dialog_fx_create(
    DialogFX.__tag(settings_mask) | DialogFX.signal(DIALOG_FX.SIGNAL_STOP_CYCLE) | DialogFX.__trigger(settings_mask) | DialogFX.type(DIALOG_FX.TYPE_FLOWRES_DISPATCH),
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
  return dialog_fx_create(
    DialogFX.__tag(settings_mask) | DialogFX.signal(DIALOG_FX.SIGNAL_STOP_CYCLE) | DialogFX.__trigger(settings_mask) | DialogFX.type(DIALOG_FX.TYPE_FLOWRES_FALLBACK),
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
  return dialog_fx_create(
    DialogFX.__tag(settings_mask) | DialogFX.signal(DIALOG_FX.SIGNAL_STOP_CYCLE) | DialogFX.__trigger(settings_mask) | DialogFX.type(DIALOG_FX.TYPE_FLOWRES_CHOICE),
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












#endregion

// ----------------------------------------------------------------------------

#region Enums












// Self-initialization
gml_pragma(
  "global",
  "new DialogRunner(undefined); new DialogManager(0, \"\", false); new DialogScene([], 0); new DialogSequence([], 0, []); new Dialog(\"\", 0, []); new DialogFX(0, []);"
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
  __BITMASK_STATUS_MAINTAINED_SHIFT,
  __BITMASK_FLAG_INDEX_STATUS_MAINTAINED_DIALOG = DIALOG_RUNNER.__BITMASK_STATUS_MAINTAINED_SHIFT,
  __BITMASK_FLAG_INDEX_STATUS_MAINTAINED_SEQUENCE,
  __BITMASK_FLAG_INDEX_STATUS_MAINTAINED_SCENE,
  __BITMASK_STATUS_MAINTAINED_COUNT = DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_MAINTAINED_SCENE - DIALOG_RUNNER.__BITMASK_STATUS_MAINTAINED_SHIFT + 1,
  __BITMASK_STATUS_EXECUTED_FLOWRES_SHIFT = DIALOG_RUNNER.__BITMASK_STATUS_MAINTAINED_SHIFT + DIALOG_RUNNER.__BITMASK_STATUS_MAINTAINED_COUNT,
  __BITMASK_FLAG_INDEX_STATUS_EXECUTED_JUMP = DIALOG_RUNNER.__BITMASK_STATUS_EXECUTED_FLOWRES_SHIFT,
  __BITMASK_FLAG_INDEX_STATUS_EXECUTED_DISPATCH,
  __BITMASK_FLAG_INDEX_STATUS_EXECUTED_FALLBACK,
  __BITMASK_FLAG_INDEX_STATUS_EXECUTED_CHOICE,
  __BITMASK_STATUS_EXECUTED_FLOWRES_COUNT = DIALOG_RUNNER.__BITMASK_FLAG_INDEX_STATUS_EXECUTED_CHOICE - DIALOG_RUNNER.__BITMASK_STATUS_EXECUTED_FLOWRES_SHIFT + 1,
  FLAG_STATUS_COUNT = DIALOG_RUNNER.__BITMASK_STATUS_EXECUTED_FLOWRES_SHIFT + DIALOG_RUNNER.__BITMASK_STATUS_EXECUTED_FLOWRES_COUNT,

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
  __BITMASK_STATUS_MAINTAINED_MASK = ((1 << DIALOG_RUNNER.__BITMASK_STATUS_MAINTAINED_COUNT) - 1) << DIALOG_RUNNER.__BITMASK_STATUS_MAINTAINED_SHIFT,
  __BITMASK_STATUS_EXECUTED_FLOWRES_MASK = ((1 << DIALOG_RUNNER.__BITMASK_STATUS_EXECUTED_FLOWRES_COUNT) - 1) << DIALOG_RUNNER.__BITMASK_STATUS_EXECUTED_FLOWRES_SHIFT,
  __BITMASK_STATUS_MASK = (1 << DIALOG_RUNNER.FLAG_STATUS_COUNT) - 1,

  // Jump settings
  JUMP_TYPE_ABSOLUTE = 0,
  JUMP_TYPE_RELATIVE,
  __BITMASK_JUMP_SETTING_RESOLUTION_SHIFT = 0,
  __BITMASK_JUMP_SETTING_TYPE_SHIFT = DIALOG_RUNNER.__BITMASK_JUMP_SETTING_RESOLUTION_SHIFT,
  __BITMASK_JUMP_SETTING_TYPE_BITS = 1,
  __BITMASK_JUMP_SETTING_TYPE_MASK = ((1 << DIALOG_RUNNER.__BITMASK_JUMP_SETTING_TYPE_BITS) - 1) << DIALOG_RUNNER.__BITMASK_JUMP_SETTING_TYPE_SHIFT,
  JUMP_SETTING_TYPE_ABSOLUTE = DIALOG_RUNNER.JUMP_TYPE_ABSOLUTE << DIALOG_RUNNER.__BITMASK_JUMP_SETTING_TYPE_SHIFT,
  JUMP_SETTING_TYPE_RELATIVE = DIALOG_RUNNER.JUMP_TYPE_RELATIVE << DIALOG_RUNNER.__BITMASK_JUMP_SETTING_TYPE_SHIFT,
  JUMP_UNIT_DIALOG = 0,
  JUMP_UNIT_SEQUENCE,
  JUMP_UNIT_SCENE,
  __BITMASK_JUMP_SETTING_UNIT_SHIFT = DIALOG_RUNNER.__BITMASK_JUMP_SETTING_TYPE_SHIFT + DIALOG_RUNNER.__BITMASK_JUMP_SETTING_TYPE_BITS,
  __BITMASK_JUMP_SETTING_UNIT_BITS = 2,
  __BITMASK_JUMP_SETTING_UNIT_MASK = ((1 << DIALOG_RUNNER.__BITMASK_JUMP_SETTING_UNIT_BITS) - 1) << DIALOG_RUNNER.__BITMASK_JUMP_SETTING_UNIT_SHIFT,
  JUMP_SETTING_UNIT_DIALOG = DIALOG_RUNNER.JUMP_UNIT_DIALOG << DIALOG_RUNNER.__BITMASK_JUMP_SETTING_UNIT_SHIFT | DIALOG_RUNNER.JUMP_SETTING_TYPE_RELATIVE,
  JUMP_SETTING_UNIT_SEQUENCE = DIALOG_RUNNER.JUMP_UNIT_SEQUENCE << DIALOG_RUNNER.__BITMASK_JUMP_SETTING_UNIT_SHIFT | DIALOG_RUNNER.JUMP_SETTING_TYPE_RELATIVE,
  JUMP_SETTING_UNIT_SCENE = DIALOG_RUNNER.JUMP_UNIT_SCENE << DIALOG_RUNNER.__BITMASK_JUMP_SETTING_UNIT_SHIFT | DIALOG_RUNNER.JUMP_SETTING_TYPE_RELATIVE,
  __BITMASK_JUMP_SETTING_RESOLUTION_BITS = DIALOG_RUNNER.__BITMASK_JUMP_SETTING_TYPE_BITS + DIALOG_RUNNER.__BITMASK_JUMP_SETTING_UNIT_BITS,
  __BITMASK_JUMP_SETTING_RESOLUTION_MASK = ((1 << DIALOG_RUNNER.__BITMASK_JUMP_SETTING_RESOLUTION_BITS) - 1) << DIALOG_RUNNER.__BITMASK_JUMP_SETTING_RESOLUTION_SHIFT,
  __BITMASK_JUMP_SETTING_BEHAVIOUR_SHIFT = DIALOG_RUNNER.__BITMASK_JUMP_SETTING_RESOLUTION_SHIFT + DIALOG_RUNNER.__BITMASK_JUMP_SETTING_RESOLUTION_BITS,
  __BITMASK_FLAG_INDEX_JUMP_SETTING_BYPASS_FX_ON_ENTER,
  __BITMASK_FLAG_INDEX_JUMP_SETTING_BYPASS_FX_ON_STAY,
  __BITMASK_FLAG_INDEX_JUMP_SETTING_BYPASS_FX_ON_LEAVE,
  __BITMASK_FLAG_INDEX_JUMP_SETTING_MAINTAIN_DIALOG,
  __BITMASK_FLAG_INDEX_JUMP_SETTING_MAINTAIN_SEQUENCE,
  __BITMASK_FLAG_INDEX_JUMP_SETTING_MAINTAIN_SCENE,
  __BITMASK_JUMP_SETTING_EXECUTED_IF_MAINTAINED_SHIFT,
  __BITMASK_FLAG_INDEX_JUMP_SETTING_EXEC_FX_ON_ENTER_IF_MAINTAINED = DIALOG_RUNNER.__BITMASK_JUMP_SETTING_EXECUTED_IF_MAINTAINED_SHIFT,
  __BITMASK_FLAG_INDEX_JUMP_SETTING_EXEC_FX_ON_LEAVE_IF_MAINTAINED,
  __BITMASK_JUMP_SETTING_EXECUTED_IF_MAINTAINED_COUNT = DIALOG_RUNNER.__BITMASK_FLAG_INDEX_JUMP_SETTING_EXEC_FX_ON_LEAVE_IF_MAINTAINED - DIALOG_RUNNER.__BITMASK_JUMP_SETTING_EXECUTED_IF_MAINTAINED_SHIFT + 1,
  __BITMASK_JUMP_INFO_MAINTAINED = DIALOG_RUNNER.__BITMASK_JUMP_SETTING_EXECUTED_IF_MAINTAINED_SHIFT + DIALOG_RUNNER.__BITMASK_JUMP_SETTING_EXECUTED_IF_MAINTAINED_COUNT,
  __BITMASK_JUMP_SETTING_BEHAVIOUR_COUNT,
  __BITMASK_JUMP_SETTING_BEHAVIOUR_MASK = ((1 << DIALOG_RUNNER.__BITMASK_JUMP_SETTING_BEHAVIOUR_COUNT) - 1) << DIALOG_RUNNER.__BITMASK_JUMP_SETTING_BEHAVIOUR_SHIFT,
  __BITMASK_JUMP_SETTING_MAINTAIN_BEHAVIOUR_SHIFT = DIALOG_RUNNER.__BITMASK_FLAG_INDEX_JUMP_SETTING_MAINTAIN_DIALOG,
  __BITMASK_JUMP_SETTING_MAINTAIN_BEHAVIOUR_BITS = DIALOG_RUNNER.__BITMASK_JUMP_SETTING_BEHAVIOUR_COUNT - DIALOG_RUNNER.__BITMASK_JUMP_SETTING_MAINTAIN_BEHAVIOUR_SHIFT,
  __BITMASK_JUMP_SETTING_MAINTAIN_BEHAVIOUR_MASK = ((1 << DIALOG_RUNNER.__BITMASK_JUMP_SETTING_MAINTAIN_BEHAVIOUR_BITS) - 1) << DIALOG_RUNNER.__BITMASK_JUMP_SETTING_MAINTAIN_BEHAVIOUR_SHIFT,
  __BITMASK_JUMP_SETTING_EXECUTED_IF_MAINTAINED_MASK = ((1 << DIALOG_RUNNER.__BITMASK_JUMP_SETTING_EXECUTED_IF_MAINTAINED_COUNT) - 1) << DIALOG_RUNNER.__BITMASK_JUMP_SETTING_EXECUTED_IF_MAINTAINED_SHIFT,
  JUMP_SETTING_BYPASS_FX_ON_ENTER             = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_JUMP_SETTING_BYPASS_FX_ON_ENTER,
  JUMP_SETTING_BYPASS_FX_ON_STAY              = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_JUMP_SETTING_BYPASS_FX_ON_STAY,
  JUMP_SETTING_BYPASS_FX_ON_LEAVE             = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_JUMP_SETTING_BYPASS_FX_ON_LEAVE,
  JUMP_SETTING_MAINTAIN_DIALOG                = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_JUMP_SETTING_MAINTAIN_DIALOG,
  JUMP_SETTING_MAINTAIN_SEQUENCE              = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_JUMP_SETTING_MAINTAIN_SEQUENCE,
  JUMP_SETTING_MAINTAIN_SCENE                 = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_JUMP_SETTING_MAINTAIN_SCENE,
  JUMP_SETTING_EXEC_FX_ON_ENTER_IF_MAINTAINED = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_JUMP_SETTING_EXEC_FX_ON_ENTER_IF_MAINTAINED,
  JUMP_SETTING_EXEC_FX_ON_LEAVE_IF_MAINTAINED = 1 << DIALOG_RUNNER.__BITMASK_FLAG_INDEX_JUMP_SETTING_EXEC_FX_ON_LEAVE_IF_MAINTAINED,
  JUMP_INFO_MAINTAINED                        = 1 << DIALOG_RUNNER.__BITMASK_JUMP_INFO_MAINTAINED,
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

  // Diff data codes
  DIFF_LEVEL_SCENE = 0,
  DIFF_LEVEL_SEQUENCE,
  DIFF_LEVEL_DIALOG,
  DIFF_LEVEL_FX,
  DIFF_SEVERITY_OK = 0,
  DIFF_SEVERITY_WARNING,
  DIFF_SEVERITY_ERROR,
  DIFF_ARG_TOLERANCE_INSERTIONS_MAX = 0,
  DIFF_ARG_TOLERANCE_DELETIONS_MAX,
  DIFF_ARG_TOLERANCE_MOVES_MAX,
  DIFF_ARG_TOLERANCE_INSERTIONS_WARNING,
  DIFF_ARG_TOLERANCE_DELETIONS_WARNING,
  DIFF_ARG_TOLERANCE_MOVES_WARNING,
  DIFF_ARG_TOLERANCE_COUNT,

  // Positioning masks
  __ID_SEPARATOR = 100000000,
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
  ERR_INFINITE_JUMP_LOOP_DETECTED,
  ERR_TEXT_OVERFLOW,
  ERR_MAX_FX_CAPACITY_REACHED,
  ERR_INFINITE_FX_LOOP_DETECTED,
  ERR_COUNT,

  // Error checks
  ERRCHECK_JUMP_INFINITE_LOOP_TRESHOLD = 32,
  ERRCHECK_FX_INFINITE_LOOP_TRESHOLD = 256,
}



/**
 * @desc `LEVEL_*` options refer to the linkable levels of the dialogical structure.
 */

enum DIALOG_ITEM
{
  LEVEL_SCENE,
  LEVEL_SEQUENCE,
  LEVEL_DIALOG,
  LEVEL_LINKABLE_COUNT,
  LEVEL_DIALOG_FX = DIALOG_ITEM.LEVEL_LINKABLE_COUNT,
  LEVEL_COUNT,
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
  ARG_ID,
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
  __INITIAL_ID = DIALOG_MANAGER.__ID_SEPARATOR * (DIALOG_ITEM.LEVEL_LINKABLE_COUNT - DIALOG_ITEM.LEVEL_SCENE - 1) - 1,
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
  ARG_ID,
  ARG_COUNT_DESERIALIZATION,

  // Sequence tags
  TAG_NONE = 0,
    // ...
  TAG_COUNT,
  TAG_DEFAULT = DIALOG_SEQUENCE.TAG_NONE,

  // Settings masks
  __INITIAL_ID = DIALOG_MANAGER.__ID_SEPARATOR * (DIALOG_ITEM.LEVEL_LINKABLE_COUNT - DIALOG_ITEM.LEVEL_SEQUENCE- 1) - 1,
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
  ARG_ID,
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
  __INITIAL_ID = DIALOG_MANAGER.__ID_SEPARATOR * (DIALOG_ITEM.LEVEL_LINKABLE_COUNT - DIALOG_ITEM.LEVEL_DIALOG - 1) - 1,
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
  ARG_ID = DIALOG_FX.ARG_COUNT,
  ARG_COUNT_DESERIALIZATION,

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
  SIGNAL_REPEAT_CYCLE,
  SIGNAL_REPEAT_PREVIOUS_FX,
  SIGNAL_REPEAT_FX,
  SIGNAL_SKIP_NEXT_FX,
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
  __INITIAL_ID = DIALOG_MANAGER.__ID_SEPARATOR * DIALOG_ITEM.LEVEL_DIALOG_FX - 1,
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












#endregion

// ----------------------------------------------------------------------------

#region Main classes












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
   * @desc Creates a clone of the dialog runner with the same state. Useful for simulating jumps or saving states. [CHAINABLE]
   * @returns {Struct.DialogRunner}
   */

  static clone = function()
  {
    var copy = new DialogRunner(self.manager);

    copy.choice_index = self.choice_index;
    copy.status = self.status;
    copy.position = self.position;

    copy.seed = self.seed;
    copy.history = variable_clone(self.history);
    copy.vars = variable_clone(self.vars);

    return copy;
  }



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
    return self.clone().advance(shift, jump_settings, start_position, argv);
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

    if (shift == 0 || !manager.itemcount())
    {
      if (!(jump_settings & DIALOG_RUNNER.JUMP_SETTING_BYPASS_FX_ON_STAY)) {
        manager.__to_dialog(prev_position).__fx_execute_all_of(function(fx) {
          return fx.trigger() == DIALOG_FX.TRIGGER_ON_STAY;
        });
      }

      return self;
    }

    var current_scene_idx = manager.__decode_scene_idx(prev_position)
      , current_sequence_idx = manager.__decode_sequence_idx(prev_position)
      , current_dialog_idx = manager.__decode_dialog_idx(prev_position)
      , resolved = manager.__resolve_position_relative(shift, prev_position, jump_settings)
      , maintained = (resolved.status & DIALOG_RUNNER.__BITMASK_STATUS_MAINTAINED_MASK) != 0
      , target_position = !maintained || jump_settings & DIALOG_RUNNER.__BITMASK_JUMP_SETTING_EXECUTED_IF_MAINTAINED_MASK
          ? __resolve(resolved.position, prev_position, jump_settings & DIALOG_RUNNER.__BITMASK_JUMP_SETTING_BEHAVIOUR_MASK | DIALOG_RUNNER.JUMP_INFO_MAINTAINED * maintained, argv)
          : resolved.position
      , shift_sign = sign(shift * (target_position == resolved.position))
    ;

    self.position = target_position;
    self.status |= __status(
      target_position,
      shift_sign * (current_scene_idx != manager.__decode_scene_idx(target_position)),
      shift_sign * (current_sequence_idx != manager.__decode_sequence_idx(target_position)),
      shift_sign * (current_dialog_idx != manager.__decode_dialog_idx(target_position)),
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
      , ctx = new DialogCycleContext(self, position, target_position)
      , current_dialog = manager.__to_dialog(position)
      , maintained_dialog = current_dialog
      , maintained = jump_settings & DIALOG_RUNNER.JUMP_INFO_MAINTAINED
      , should_execute_on_leave_maintained = jump_settings & DIALOG_RUNNER.JUMP_SETTING_EXEC_FX_ON_LEAVE_IF_MAINTAINED
      , should_execute_on_enter_maintained = jump_settings & DIALOG_RUNNER.JUMP_SETTING_EXEC_FX_ON_ENTER_IF_MAINTAINED
      , should_execute_on_leave = !(jump_settings & DIALOG_RUNNER.JUMP_SETTING_BYPASS_FX_ON_LEAVE)
      , should_execute_on_enter = !(jump_settings & DIALOG_RUNNER.JUMP_SETTING_BYPASS_FX_ON_ENTER)
      , flow = ctx
      , _fx_cycle = function(condition, dialog, argv, ctx, trigger, filter_fn = undefined) {
          return condition
            ? dialog.__fx_execute_cycle(argv, ctx, trigger, filter_fn)
            : undefined
          ;
        }
    ;

    for (var jumps = 0; flow; ++jumps)
    {
      if (jumps > DIALOG_MANAGER.ERRCHECK_JUMP_INFINITE_LOOP_TRESHOLD) {
        throw DialogManager.ERROR(DIALOG_MANAGER.ERR_INFINITE_JUMP_LOOP_DETECTED, [jumps, current_dialog.__struct()]);
      }

      maintained *= !jumps;

      flow = _fx_cycle(
        maintained && current_dialog == maintained_dialog
          ? should_execute_on_leave_maintained
          : should_execute_on_leave,
        current_dialog, argv, ctx, DIALOG_FX.TRIGGER_ON_LEAVE
      );

      if (flow && flow.signal >= DIALOG_FX.SIGNAL_STOP_RESOLUTION)
        break;

      flow = _fx_cycle(
        maintained && ctx.target == maintained_dialog
          ? should_execute_on_enter_maintained
          : should_execute_on_enter,
        ctx.target, argv, ctx, DIALOG_FX.TRIGGER_ON_ENTER
      );

      if (flow && flow.signal >= DIALOG_FX.SIGNAL_STOP_RESOLUTION)
        break;

      current_dialog = ctx.target;
    }

    return manager.__to_position(ctx.target);
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
    maintained_status *= !(self.status & DIALOG_RUNNER.__BITMASK_STATUS_EXECUTED_FLOWRES_MASK);

    var manager = self.manager
      , target_scene_idx = manager.__decode_scene_idx(target_position)
      , target_sequence_idx = manager.__decode_sequence_idx(target_position)
      , target_dialog_idx = manager.__decode_dialog_idx(target_position)
      , target_sequence_count = manager.scene(target_scene_idx).itemcount()
      , target_dialog_count = manager.sequence(target_sequence_idx, target_scene_idx).itemcount()
      , target_scene_count = manager.itemcount()
      , is_last_scene = target_scene_idx == target_scene_count - 1
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
      | DIALOG_RUNNER.STATUS_MIDDLE_SCENE       * (target_scene_idx == target_scene_count >> 1                         )
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
 * @desc `DialogManager` constructor.
 * @param {String} [lang] The language to load from the file. Overridden if deserialized otherwise. Defaults to `"en"`.
 * @param {String|Id.TextFile} data_string The data to parse.
 * @param {Bool} is_file Specifies whether `data_string` is a file (`true`) or not (`false`).
 * @returns {Struct.DialogManager}
 */

function DialogManager(lang, data_string, is_file) constructor
{
  static __CONSTRUCTOR_ARGC = argument_count;
  static DATA = {
    LANGS: {
      auto: 0,
      ISO_639_1: {
        afar: "aa", abkhazian: "ab", afrikaans: "af", akan: "ak", albanian: "sq", amharic: "am", arabic: "ar", aragonese: "an", armenian: "hy", assamese: "as", avaric: "av",
        avestan: "ae", aymara: "ay", azerbaijani: "az", bashkir: "ba", basque: "eu", belarusian: "be", bengali: "bn", bihari_languages: "bh", bislama: "bi", bosnian: "bs", breton: "br",
        bulgarian: "bg", burmese: "my", catalan: "ca", chamorro: "ch", chechen: "ce", chinese: "zh", church_slavic: "cu", chuvash: "cv", cornish: "kw", corsican: "co", cree: "cr", croatian: "hr", czech: "cs",
        danish: "da", divehi: "dv", dutch: "nl", dzongkha: "dz", english: "en", esperanto: "eo", estonian: "et", ewe: "ee", faroese: "fo", fijian: "fj", finnish: "fi", french: "fr", fulah: "ff",
        galician: "gl", ganda: "lg", georgian: "ka", german: "de", greek_modern: "el", kalaallisut: "kl", guarani: "gn", gujarati: "gu", haitian: "ht", hausa: "ha", hebrew: "he", herero: "hz", hindi: "hi", hiri_motu: "ho",
        hungarian: "hu", icelandic: "is", ido: "io", igbo: "ig", indonesian: "id", interlingua: "ia", interlingue: "ie", inuktitut: "iu", inupiaq: "ik", irish: "ga", italian: "it", japanese: "ja", kalaallisut: "kl", kannada: "kn",
        kashmiri: "ks", kazakh: "kk", khmer: "km", kikuyu: "ki", kinyarwanda: "rw", kirghiz: "ky", komi: "kv", kongo: "kg", korean: "ko", kuanyama: "kj", kurdish: "ku", lao: "lo", latin: "la", latvian: "lv",
        limburgan: "li", lingala: "ln", lithuanian: "lt", luxembourgish: "lb", macedonian: "mk", malagasy: "mg", malay: "ms", malayalam: "ml", maltese: "mt", manx: "gv", maori: "mi", marathi: "mr", marshallese: "mh", mongolian: "mn",
        nauru: "na", navajo: "nv", ndonga: "ng", nepali: "ne", north_ndebele: "nd", northern_sami: "se", norwegian: "no", norwegian_bokmal: "nb", norwegian_nynorsk: "nn", occitan: "oc", ojibwa: "oj", oriya: "or", oromo: "om", ossetian: "os",
        pali: "pi", panjabi: "pa", persian: "fa", polish: "pl", portuguese: "pt", pushto: "ps", quechua: "qu", romansh: "rm", romanian: "ro", rundi: "rn", russian: "ru", samoan: "sm", sango: "sg", sanskrit: "sa",
        sardinian: "sc", serbian: "sr", shona: "sn", sindhi: "sd", sinhala: "si", slovak: "sk", slovenian: "sl", somali: "so", sotho_southern: "st", spanish: "es", swahili: "sw", swati: "ss", swedish: "sv", tagalog: "tl", tahitian: "ty",
        tajik: "tg", tamil: "ta", tatar: "tt", telugu: "te", thai: "th", tibetan: "bo", tigrinya: "ti", tonga_tonga_islands: "to", tsonga: "ts", tswana: "tn", turkish: "tr", turkmen: "tk", uighur: "ug", ukrainian: "uk",
        urdu: "ur", uzbek: "uz", venda: "ve", vietnamese: "vi", volapuk: "vo", walloon: "wa", welsh: "cy", western_frisian: "fy", wolof: "wo", xhosa: "xh", yiddish: "yi", yoruba: "yo", zhuang: "za", zulu: "zu"
      },
      ISO_639_2: {
        afar: "aar", abkhazian: "abk", achinese: "ace", acoli: "ach", adangme: "ada", adyghe: "ady", afro_asiatic_languages: "afa", afrihili: "afh", afrikaans: "afr", ainu: "ain", akan: "aka", akkadian: "akk", albanian: "sqi", aleut: "ale",
        algonquian_languages: "alg", southern_altai: "alt", amharic: "amh", english_old: "ang", angika: "anp", apache_languages: "apa", arabic: "ara", aramaic_imperial: "arc", aragonese: "arg", armenian: "hye", artificial_languages: "art", assamese: "asm", asturian: "ast",
        athapascan_languages: "ath", australian_languages: "aus", avaric: "ava", avestan: "ave", awadhi: "awa", aymara: "aym", azerbaijani: "aze", bantu_languages: "bnt", basque: "eus", belarusian: "bel", bengali: "ben", berber_languages: "ber", bhojpuri: "bho", bosnian: "bos",
        breton: "bre", bulgarian: "bul", burmese: "mya", catalan: "cat", celtic_languages: "cel", central_khmer: "khm", chinese: "zho", church_slavic: "chu", corsican: "cos", croatian: "hrv", czech: "ces", danish: "dan", dutch: "nld", dzongkha: "dzo", english: "eng", esperanto: "epo",
        estonian: "est", ewe: "ewe", faroese: "fao", fijian: "fij", finnish: "fin", french: "fra", friulian: "fur", galician: "glg", georgian: "kat", german: "deu", gothic: "got", greek_ancient: "grc", greek_modern: "ell", guarani: "grn",
        gujarati: "guj", haitian: "hat", hausa: "hau", hebrew: "heb", hindi: "hin", hungarian: "hun", icelandic: "isl", igbo: "ibo", indonesian: "ind", iranian_languages: "ira", irish: "gle", italian: "ita", japanese: "jpn", kalaallisut: "kal",
        kannada: "kan", kashmiri: "kas", kazakh: "kaz", kalaallisut: "kal", korean: "kor", kurdish: "kur", lao: "lao", latin: "lat", latvian: "lav", lithuanian: "lit", luxembourgish: "ltz", macedonian: "mkd", malagasy: "mlg", malay: "msa", malayalam: "mal",
        maltese: "mlt", maori: "mri", marathi: "mar", mongolian: "mon", nepali: "nep", norwegian: "nor", occitan: "oci", persian: "fas", polish: "pol", portuguese: "por", romanian: "ron", russian: "rus", sanskrit: "san", serbian: "srp",
        slovak: "slk", slovenian: "slv", somali: "som", spanish: "spa", swahili: "swa", swedish: "swe", tamil: "tam", telugu: "tel", thai: "tha", tibetan: "bod", turkish: "tur", ukrainian: "ukr", urdu: "urd", uzbek: "uzb",
        vietnamese: "vie", welsh: "cym", yiddish: "yid", yoruba: "yor", zulu: "zul"
      },
    },
    DIFF: {
      LEVELS: ["scene", "sequence", "dialog", "fx"],
      LEVEL_IDS: [DIALOG_SCENE.__INITIAL_ID, DIALOG_SEQUENCE.__INITIAL_ID, DIALOG.__INITIAL_ID, DIALOG_FX.__INITIAL_ID],
      LEVEL_CONSTRUCTORS: [DialogScene, DialogSequence, Dialog, DialogFX],
      LEVEL_TYPES: [nameof(DialogScene), nameof(DialogSequence), nameof(Dialog), nameof(DialogFX)],
      OPERATIONS: {
        op_matched: "MATCHED",
        op_inserted: "INSERTED",
        op_deleted: "DELETED",
        op_modified: "MODIFIED",
        op_moved: "MOVED",
      }
    }
  };



  self.container = new DialogItemContainer([], self);
  self.version = __DIALOG_MANAGER_VERSION__;
  self.lang = lang;



  /**
   * @desc Error message function.
   * @param {Real} type The error type.
   * @param {Any|Array<Any>} [argv] The arguments for the message.
   */

  static ERROR = function(type, argv = [])
  {
    static messages = [
      "UNKNOWN ERROR TYPE: {0}",
      "SERIALIZATION FAILED - INVALID DATA:\nENSURE PRESENCE OF ALL REFERENCED \{Struct.{0}\} OBJECTS",
      "DESERIALIZATION FAILED - A PROBLEM OCCURRED WHILE OPENING FILE <{0}>:\nENSURE INTEGRITY OF FILE NAME/PATH OR FILE HANDLE",
      "PARSING FAILED - INVALID DATA: ENSURE INTEGRITY OF SERIALIZED DATA",
      "POSITION RESOLUTION FAILED FROM \{Struct.{0}\} - UNDEFINED \{Struct.{1}\} CONTAINER OBJECT:\nENSURE EXISTENCE OF BACK-REFERENCE AND AVOIDAL OF USAGE OF variable_clone()'d RECURSIVE COMPONENT REFERENCES (\{Struct.{2}\}, \{Struct.{3}\}) AS VALID OBJECTS.\n\nSTRUCTURE INFO: {4}",
      "POSITION RESOLUTION FAILED FROM \{Struct.{0}\} - UNDEFINED \{Struct.{1}\} CONTAINER OBJECT:\nENSURE EXISTENCE OF BACK-REFERENCE AND AVOIDAL OF USAGE OF variable_clone()'d RECURSIVE COMPONENT REFERENCES (\{Struct.{2}\}, \{Struct.{3}\}) AS VALID OBJECTS.\n\nSTRUCTURE INFO: {4}\n\nCONTAINER STRUCTURE INFO: {5}",
      "USED CONTAINER OBJECT OF TYPE \{Struct.{0}\} SHOULD NOT BE EMPTY",
      "INVALID POSITION - INDEX OUT OF BOUNDS: ERROR WHILE ATTEMPTING ACCESS TO:\n< SCENE {0} | SEQUENCE {1} | DIALOG {2} >",
      "INFINITE JUMP LOOP DETECTED - ITERATION {0}: ENSURE JUMP EFFECTS DO NOT POINT TO LOOPING LOCATIONS\n\nCRASH POSITION DATA: {1}",
      "POTENTIAL TEXT OVERFLOW DETECTED (W: {0}/{1}): SPLIT INTO MULTIPLE DIALOG OBJECTS\n\nVIOLATOR DATA: {2}",
      "FX LIMIT EXCEEDED - MAX FX MAP CAPACITY REACHED WHILE REGISTERING FX {0}\n(TOTAL CAPACITY: {1})",
      "INFINITE FX RESOLUTION LOOP DETECTED - ITERATION {0}: ENSURE FX SIGNALS ALLOW CORRECTNESS IN EXECUTION\n\nCRASH CONTEXT DATA: {1}",
    ];

    if (type < 0 || type >= DIALOG_MANAGER.ERR_COUNT)
    {
      argv = [type];
      type = DIALOG_MANAGER.ERR_UNDEFINED_ERROR_TYPE;
    }

    if (!is_array(argv))
      argv = [argv];

    return $"\n\n\n{string_ext(messages[type], argv)}\n\n";
  }



  /**
   * @desc Retrieves the contained items.
   * @returns {Array<Struct.DialogScene>}
   */

  static items = function()
  {
    return self.container.items;
  }



  /**
   * @desc Retrieves the number of items.
   * @returns {Real}
   */

  static itemcount = function()
  {
    return self.container.item_count;
  }



  /**
   * @desc Retrieves an item given an index. Negative indices will iterate backwards. Throws DIALOG_MANAGER.ERR_INVALID_POSITION if out of bounds.
   * @param {Real} item_idx The index of the item to get.
   * @param {Function} [filter_fn] An optional filter function to apply to the container items. Should return `true` for the item to be returned.
   * @param {Any|Array<Any>} [argv] The argument(s) to pass to the filter function.
   * @returns {Struct.DialogScene}
   */

  static item = function(item_idx, filter_fn = undefined, argv = undefined)
  {
    return filter_fn
      ? self.container.nth_of(item_idx, filter_fn, argv)
      : self.container.item(item_idx)
    ;
  }



  /**
   * @desc Retrieves a scene given an index. Negative indices will iterate backwards. Throws DIALOG_MANAGER.ERR_INVALID_POSITION if out of bounds.
   * @param {Real} scene_idx The index of the scene to get.
   * @param {Function} [filter_fn] An optional filter function to apply to the scenes. Should return `true` for the scene to be returned.
   * @param {Any|Array<Any>} [argv] The argument(s) to pass to the filter function.
   * @returns {Struct.DialogScene}
   */

  static scene = function(scene_idx, filter_fn = undefined, argv = undefined)
  {
    try {
      return self.item(scene_idx, filter_fn, argv);
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
    return __resolve_position_relative(shift, __resolve_position_absolute(start_position), jump_settings & ~DIALOG_RUNNER.__BITMASK_JUMP_SETTING_UNIT_MASK | __encode_jump_setting_unit(unit));
  }



  /**
   * @desc Inserts scenes in the scene list at a given index. Throws DIALOG_MANAGER.ERR_EMPTY_CONTAINER_OBJECT if any scene is empty. [CHAINABLE]
   * @param {Struct.DialogScene|Array<Struct.DialogScene>} scenes The new scenes to add.
   * @param {Real} [index] The index where to add the new scenes. Defaults to last index.
   * @returns {Struct.DialogManager}
   */

  static add = function(scenes, index = self.itemcount())
  {
    self.container.add(scenes, index);

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
          scenes: array_map(self.items(), function(scene) {
            return scene.__DIALOG_MANAGER_SERIALIZER_METHOD__();
          }),
          scene_count: int64(self.itemcount()),
          version: __DIALOG_MANAGER_VERSION__,
          link: __DIALOG_MANAGER_LINK__,
          lang: self.lang,
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
    try {
      self.container.refresh(data.scenes, self, DialogManager.__get_deserializer(DIALOG_ITEM.LEVEL_SCENE), data.scene_count);
      self.version = data.version;
      self.lang = data.lang;
    }
    catch (ex) {
      throw DialogManager.ERROR(DIALOG_MANAGER.ERR_PARSING_FAILED);
    }

    return self;
  }



  /**
   * @desc Deserializes and calculates all the structural differences between two SIMILAR managers. Should be used only as a quick one-time alternative. `DialogManager.diff()` is preferred if needed to compare multiple managers.
   * @param {String|Id.TextFile} data_string_1 The data to parse of the first manager.
   * @param {String|Id.TextFile} data_string_2 The data to parse of the second manager.
   * @param {Bool} is_file Specifies whether the `data_string_*` params are files (`true`) or not (`false`).
   * @param {Array<Struct>} [diff_tolerance_params] The parameters for which mark violating nodes as errors or warnings.
   * @returns {Struct}
   */

  static diffstatic = function(data_string_1, data_string_2, is_file = false, diff_tolerance_params = diff_tolerance_params_create())
  {
    var manager_1 = new DialogManager(DialogManager.DATA.LANGS.auto, data_string_1, is_file)
      , manager_2 = new DialogManager(DialogManager.DATA.LANGS.auto, data_string_2, is_file)
    ;

    return {
      diff: manager_1.diff(manager_2, diff_tolerance_params),
      manager_1, manager_2,
    };
  }



  /**
   * @desc Calculates all the structural differences between two SIMILAR managers.
   * @param {Struct.DialogManager} dialog_manager The manager to compare the structural difference with.
   * @param {Array<Struct>} [diff_tolerance_params] The parameters for which mark violating nodes as errors or warnings.
   * @returns {Struct}
   */

  static diff = function(dialog_manager, diff_tolerance_params = diff_tolerance_params_create())
  {
    var tree = __diff_level(self.container, dialog_manager.container);

    return {
      summary: __diff_stats_summary(tree, diff_tolerance_params),
      tree,
    };
  }



  /**
   * @desc Creates an array with the per-level-indexed tolerance parameters.
   * @param {Array<Real>} [fx_params_ins_del_mov] The fx tolerance params. Defaults to all 0's.
   * @param {Array<Real>} [dialog_params_ins_del_mov] The dialog tolerance params. Defaults to all 0's.
   * @param {Array<Real>} [sequence_params_ins_del_mov] The sequence tolerance params. Defaults to all 0's.
   * @param {Array<Real>} [scene_params_ins_del_mov] The scene tolerance params. Defaults to all 0's.
   * @returns {Array<Struct>}
   */

  static diff_tolerance_params_create = function(fx_params_ins_del_mov = undefined, dialog_params_ins_del_mov = undefined, sequence_params_ins_del_mov = undefined, scene_params_ins_del_mov = undefined)
  {
    return [
      __diff_tolerance_param_item(scene_params_ins_del_mov ?? array_create(DIALOG_MANAGER.DIFF_ARG_TOLERANCE_COUNT, 0)),
      __diff_tolerance_param_item(sequence_params_ins_del_mov ?? array_create(DIALOG_MANAGER.DIFF_ARG_TOLERANCE_COUNT, 0)),
      __diff_tolerance_param_item(dialog_params_ins_del_mov ?? array_create(DIALOG_MANAGER.DIFF_ARG_TOLERANCE_COUNT, 0)),
      __diff_tolerance_param_item(fx_params_ins_del_mov ?? array_create(DIALOG_MANAGER.DIFF_ARG_TOLERANCE_COUNT, 0)),
    ];
  }



  /**
   * @desc Converts an array of parameters into a struct.
   * @param {Array} [argv] The ordered arguments to convert to a struct.
   * @returns {Struct}
   */

  static __diff_tolerance_param_item = function(argv = [])
  {
    var argc = array_length(argv)
      , insertions_max = argc > DIALOG_MANAGER.DIFF_ARG_TOLERANCE_INSERTIONS_MAX ? argv[DIALOG_MANAGER.DIFF_ARG_TOLERANCE_INSERTIONS_MAX] : 0
      , deletions_max = argc > DIALOG_MANAGER.DIFF_ARG_TOLERANCE_DELETIONS_MAX ? argv[DIALOG_MANAGER.DIFF_ARG_TOLERANCE_DELETIONS_MAX] : 0
      , moves_max = argc > DIALOG_MANAGER.DIFF_ARG_TOLERANCE_MOVES_MAX ? argv[DIALOG_MANAGER.DIFF_ARG_TOLERANCE_MOVES_MAX] : 0
      , insertions_warning = argc > DIALOG_MANAGER.DIFF_ARG_TOLERANCE_INSERTIONS_WARNING ? argv[DIALOG_MANAGER.DIFF_ARG_TOLERANCE_INSERTIONS_WARNING] : 0
      , deletions_warning = argc > DIALOG_MANAGER.DIFF_ARG_TOLERANCE_DELETIONS_WARNING ? argv[DIALOG_MANAGER.DIFF_ARG_TOLERANCE_DELETIONS_WARNING] : 0
      , moves_warning = argc > DIALOG_MANAGER.DIFF_ARG_TOLERANCE_MOVES_WARNING ? argv[DIALOG_MANAGER.DIFF_ARG_TOLERANCE_MOVES_WARNING] : 0
    ;

    return {
      insertions_max: int64(insertions_max), deletions_max: int64(deletions_max), moves_max: int64(moves_max),
      insertions_warning: int64(insertions_warning), deletions_warning: int64(deletions_warning), moves_warning: int64(moves_warning),
    };
  }



  /**
   * @desc Calculates the differences between two lists of items, returning a tree of differences with stats and severity calculated based on the provided tolerance parameters.
   * @param {Array} l1 The first list of items.
   * @param {Real} n The number of items in the first list.
   * @param {Array} l2 The second list of items.
   * @param {Real} m The number of items in the second list.
   * @param {Real} lv The current level of the recursion, used for path generation. Defaults to `0`.
   * @param {String} path The current path in the tree, used for node identification. Defaults to `"DialogManager.{self.lang}"`.
   * @returns {Struct}
   */

  static __diff_level = function(c1, c2, lv = 0, path = $"DialogManager\{{self.lang}\}")
  {
    var _diff_node = function(id, level, type, index, index_match, path)
      {
        return {
          id: int64(id), level: int64(level), type, index: int64(index), index_match: int64(index_match), path,
          items: [], stats: undefined, severity: int64(0),
        };
      }
      , l1 = c1.items
      , l2 = c2.items
      , diffdata = __diff_list(l1, c1.item_count, l2, c2.item_count)
      , subdiffcount = 0
      , diffcount = 0
      , result = []
    ;

    for (var i = 0; i < diffdata.count; ++i)
    {
      var op = diffdata.ops[i]
        , node = _diff_node(op.id, lv, op.type, op.index, op.index_match, $"{path}.{DialogManager.DATA.DIFF.LEVELS[lv]}({op.index})")
        , diff_incr = 1
      ;

      if (op.type == DialogManager.DATA.DIFF.OPERATIONS.op_matched)
      {
        var sl1 = l1[op.index]
          , sl2 = l2[op.index_match]
          , recursion = is_instanceof(sl1, DialogLinkable)
          , level_data = recursion
              ? __diff_level(sl1.container, sl2.container, lv + 1, node.path)
              : undefined
          , has_diff = recursion && level_data.diffcount
        ;

        diff_incr &= has_diff;

        if (has_diff)
        {
          node.items = level_data.items;
          node.type = DialogManager.DATA.DIFF.OPERATIONS.op_modified;
          subdiffcount += level_data.subdiffcount;
        }
      }

      diffcount += diff_incr;
      result[i] = node;
    }

    return {
      items: result,
      subdiffcount: int64(subdiffcount),
      diffcount: int64(diffcount),
    };
  }



  /**
   * @desc Calculates the longest common subsequence between two lists of items, returning a list of operations to transform the first list into the second list.
    * @param {Array} l1 The first list of items.
    * @param {Real} n The number of items in the first list.
    * @param {Array} l2 The second list of items.
    * @param {Real} m The number of items in the second list.
    * @returns {Struct}
   */

  static __diff_list = function(l1, n, l2, m)
  {
    var w = m + 1
      , dp = array_create((n + 1) * w, 0)
      , _data = function(id, type, index, index_match = noone) {
          return { id: int64(id), type, index: int64(index), index_match: int64(index_match) };
      }
    ;

    for (var i = 1; i <= n; ++i)
      for (var j = 1; j <= m; ++j)
        if (l1[i - 1].id == l2[j - 1].id)
          dp[i * w + j] = dp[(i - 1) * w + j - 1] + 1;
        else
          dp[i * w + j] = max(dp[(i - 1) * w + j], dp[i * w + j - 1]);

    var i = n, j = m, f = 0
      , operations = []
    ;

    for (f = 0; i || j; ++f)
    {
      var _l1 = i - 1, _l2 = j - 1;

      if (i && j && l1[_l1].id == l2[_l2].id)
      {
        var type = _l1 == _l2
          ? DialogManager.DATA.DIFF.OPERATIONS.op_matched
          : DialogManager.DATA.DIFF.OPERATIONS.op_moved
        ;

        operations[f] = _data(l1[_l1].id, type, _l1, _l2);
        --i;
        --j;
      }
      else if (j && (!i || dp[i * w + _l2] >= dp[_l1 * w + j])) {
        operations[f] = _data(l2[_l2].id, DialogManager.DATA.DIFF.OPERATIONS.op_inserted, _l2);
        --j;
      }
      else {
        operations[f] = _data(l1[_l1].id, DialogManager.DATA.DIFF.OPERATIONS.op_deleted, _l1);
        --i;
      }
    }

    var ops_resolved = __diff_resolve_moves(array_reverse(operations), f);

    return {
      ops: ops_resolved.operations,
      count: int64(ops_resolved.count),
    };
  }



  /**
   * @desc Resolves move operations in a list of diff nodes.
   * @param {Array} nodelist The list of diff nodes to resolve.
   * @returns {Array}
   */

  static __diff_resolve_moves = function(nodelist, node_count = 0)
  {
    var insertions = {}, deletions = {};

    for (var i = 0; i < node_count; ++i)
    {
      var node = nodelist[i];

      switch (node.type)
      {
        case DialogManager.DATA.DIFF.OPERATIONS.op_inserted:
          insertions[$ node.id] = i;
        break;

        case DialogManager.DATA.DIFF.OPERATIONS.op_deleted:
          deletions[$ node.id] = i;
        break;
      }
    }

    var keys = variable_struct_get_names(insertions)
      , to_remove = array_create(ceil(node_count / 64), 0)
      , key_count = array_length(keys)
    ;

    for (var i = key_count - 1; i >= 0; --i)
    {
      var _id = int64(keys[i]);

      if (variable_struct_exists(deletions, _id))
      {
        var index_ins = insertions[$ _id]
          , index_del = deletions[$ _id]
          , ins = nodelist[index_ins]
          , del = nodelist[index_del]
        ;

        to_remove[i >> 6] |= 1 << (index_del & 0x3F);
        ins.type = DialogManager.DATA.DIFF.OPERATIONS.op_moved;
        ins.index_match = ins.index;
        ins.index = del.index;
      }
    }

    var resolved = []
      , resolved_count = 0
    ;

    for (var i = 0; i < node_count; ++i)
      if (!(to_remove[i >> 6] >> (i & 0x3F) & 1))
        resolved[resolved_count++] = nodelist[i];

    return {
      operations: resolved,
      count: int64(resolved_count),
    };
  }



  /**
   * @desc Creates an empty stats struct.
   * @returns {Struct}
   */

  static __diff_stats_empty = function()
  {
    return { insertions: int64(0), deletions: int64(0), moves: int64(0), modifications: int64(0), total: int64(0), };
  }



  /**
   * @desc Computes the stats for each level of the diff tree, returning an array with the stats indexed by level.
   * @param {Array} nodelist The list of diff nodes to compute the stats from.
   * @param {Array} level_stats The array to store the stats in. If `undefined`, a new array will be created. Defaults to `undefined`.
   * @returns {Array}
   */

  static __diff_stats_compute_level = function(nodelist, level_stats = undefined)
  {
    level_stats ??= array_map(array_create(DIALOG_ITEM.LEVEL_COUNT), __diff_stats_empty);

    var node_count = array_length(nodelist);

    for (var i = 0; i < node_count; ++i)
    {
      var node = nodelist[i]
        , lv = node.level
      ;

      level_stats[lv] = __diff_stats_merge(level_stats[lv], __diff_stats_compute_from_type(node.type));
      __diff_stats_compute_level(node.items, level_stats);
    }

    return level_stats;
  }



  /**
   * @desc Computes the total stats for a diff tree.
   * @param {Array} nodelist The list of diff nodes to compute the stats from.
   * @returns {Struct}
   */

  static __diff_stats_compute_tree = function(nodelist)
  {
    var node_count = array_length(nodelist)
      , total = __diff_stats_empty()
    ;

    for (var i = 0; i < node_count; ++i)
    {
      var node = nodelist[i]
        , stats_current = __diff_stats_compute_from_type(node.type)
        , stats_child = __diff_stats_compute_tree(node.items)
      ;

      node.stats = __diff_stats_merge(stats_current, stats_child);
      total = __diff_stats_merge(total, node.stats);
    }

    return total;
  }



  /**
   * @desc Computes the stats for a diff node type, returning a stats struct with the corresponding counts set to 1 and the rest set to 0.
   * @param {String} type The type of the diff node to compute the stats from.
   * @returns {Struct}
   */

  static __diff_stats_compute_from_type = function(type, weight = 1)
  {
    var stats = __diff_stats_empty();

    switch (type)
    {
      case DialogManager.DATA.DIFF.OPERATIONS.op_inserted:
        stats.insertions = weight;
      break;

      case DialogManager.DATA.DIFF.OPERATIONS.op_deleted:
        stats.deletions = weight;
      break;

      case DialogManager.DATA.DIFF.OPERATIONS.op_moved:
        stats.moves = weight;
      break;

      case DialogManager.DATA.DIFF.OPERATIONS.op_modified:
        stats.modifications = weight;
      break;
    }

    stats.total = stats.insertions + stats.deletions + stats.moves + stats.modifications;

    return stats;
  }



  /**
   * @desc Merges two stats structs, summing the counts of each stat type.
   * @param {Struct} dest The destination stats struct to merge into.
   * @param {Struct} src The source stats struct to merge from.
   * @returns {Struct}
   */

  static __diff_stats_merge = function(dest, src)
  {
    dest.insertions = int64(dest.insertions + src.insertions);
    dest.deletions = int64(dest.deletions + src.deletions);
    dest.modifications = int64(dest.modifications + src.modifications);
    dest.moves = int64(dest.moves + src.moves);
    dest.total = int64(dest.total + src.total);

    return dest;
  }



  /**
   * @desc Computes a summary of the diff tree statistics and checks for violation of the specified tolerance parameters.
   * @param {Struct.DialogManager.DiffNode} tree The diff tree to compute the summary from.
   * @param {Array<Struct.DialogManager.DiffToleranceParam>} diff_tolerance_params
   * @returns {Struct}
   */

  static __diff_stats_summary = function(tree, diff_tolerance_params)
  {
    __diff_stats_compute_tree(tree.items);

    var level_stats = __diff_stats_compute_level(tree.items)
      , level_summary = []
      , severity = 0
    ;

    for (var lv = array_length(level_stats) - 1; lv >= 0; --lv)
    {
      var stat = level_stats[lv]
        , stat_level_tolerance = diff_tolerance_params[lv]
      ;

      stat.severity = __diff_stat_severity(stat, stat_level_tolerance);
      severity = max(severity, stat.severity);
      level_summary[lv] = {
        level: DialogManager.DATA.DIFF.LEVELS[lv],
        tolerance: stat_level_tolerance,
        severity: stat.severity,
        stats: stat,
      };
    }

    var node_summary = __diff_stats_summary_update_severity(tree.items, diff_tolerance_params);

    return {
      level_summary, node_summary,
      severity: int64(max(severity, node_summary.severity)),
    };
  }



  /**
   * @desc Updates the severity of each node in the diff tree based on the provided tolerance parameters, returning a summary of the number of violating nodes and the maximum severity found.
   * @param {Array} nodelist The list of diff nodes to update the severity of.
   * @param {Array} diff_tolerance_params The array with the tolerance parameters indexed by level.
   * @returns {Struct}
   */

  static __diff_stat_severity = function(stat, level_stats)
  {
    var s_ins = stat.insertions, s_dels = stat.deletions, s_movs = stat.moves
      , e_ins = level_stats.insertions_max, e_dels = level_stats.deletions_max, e_movs = level_stats.moves_max
      , w_ins = level_stats.insertions_warning, w_dels = level_stats.deletions_warning, w_movs = level_stats.moves_warning
    ;

    return s_ins > e_ins || s_dels > e_dels || s_movs > e_movs
      ? DIALOG_MANAGER.DIFF_SEVERITY_ERROR
      : (
        s_ins > w_ins || s_dels > w_dels || s_movs > w_movs
        ? DIALOG_MANAGER.DIFF_SEVERITY_WARNING
        : DIALOG_MANAGER.DIFF_SEVERITY_OK
      )
    ;
  }



  /**
   * @desc Recursively updates the severity of each node in the diff tree based on the provided tolerance parameters, returning a summary of the number of violating nodes and the maximum severity found.
   * @param {Array} nodelist The list of diff nodes to update the severity of.
   * @param {Array} diff_tolerance_params The array with the tolerance parameters indexed by level.
   * @returns {Struct}
   */

  static __diff_stats_summary_update_severity = function(nodelist, diff_tolerance_params)
  {
    var node_count = array_length(nodelist)
      , violations = 0
      , severity = 0
    ;

    for (var i = 0; i < node_count; ++i)
    {
      var node = nodelist[i]
        , severity_current = __diff_stat_severity(node.stats, diff_tolerance_params[node.level])
        , child_data = __diff_stats_summary_update_severity(node.items, diff_tolerance_params)
      ;

      // Clear self-level error reporting by using -1 weight on node type
      node.stats = __diff_stats_merge(node.stats, __diff_stats_compute_from_type(node.type, -1));
      node.severity = max(severity_current, child_data.severity);
      node.violating = node.severity >= DIALOG_MANAGER.DIFF_SEVERITY_ERROR;
      violations += node.violating + child_data.violations;
      severity = max(node.severity, severity);
    }

    return {
      severity: int64(severity),
      violations: int64(violations),
    };
  }



  /**
   * @desc Returns the constructor function for a given level of DialogItem.
   * @param {Real} level The level of the DialogItem to get the constructor function for.
   * @returns {Function}
   */

  static __get_constructor = function(level)
  {
    return static_get(DialogManager.DATA.DIFF.LEVEL_CONSTRUCTORS[level]);
  }



  /**
   * @desc Returns the deserializer function for a given level of DialogItem.
   * @param {Real} level The level of the DialogItem to get the deserializer function for.
   * @returns {Function}
   */

  static __get_deserializer = function(level)
  {
    return __get_constructor(level).__DIALOG_MANAGER_DESERIALIZER_METHOD__;
  }



  /**
   * @desc Returns the unique id for a given level of DialogItem.
   * @param {Real} level The level of the DialogItem to get the unique id for.
   * @param {Real} [id] The deserialized id.
   * @returns {Real}
   */

  static __id_assign = function(item, id = undefined)
  {
    var level = item.__level();

    if (level < DIALOG_ITEM.LEVEL_SCENE) {
      return -infinity;
    }

    var constr = __get_constructor(level)
      , item_global_ids = DialogManager.DATA.DIFF.LEVEL_IDS
      , final_id = id ?? item_global_ids[level] + 1
    ;

    item_global_ids[level] = max(item_global_ids[level], final_id);

    return final_id;
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
   * @desc Encodes a value into a bitmask given a mask and a shift.
   * @param {Real} value The value to encode into the bitmask.
   * @param {Real} mask The bitmask to encode the value into.
   * @param {Real} shift The number of bits to shift the value to the left before applying the mask.
   * @returns {Real}
   */

  static __bitmask_encode = function(value, mask, shift)
  {
    return value << shift & mask;
  }



  /**
   * @desc Filters a value with a bitmask, returning only the bits that are set in the mask.
   * @param {Real} value The value to filter with the bitmask.
   * @param {Real} mask The bitmask to filter the value with.
   * @returns {Real}
   */

  static __bitmask_filter = function(value, mask)
  {
    return value & mask;
  }



  /**
   * @desc Decodes a value from a bitmask given a mask and a shift.
   * @param {Real} value The value to decode from the bitmask.
   * @param {Real} mask The bitmask to decode the value from.
   * @param {Real} shift The number of bits to shift the value to the right after applying the mask.
   * @returns {Real}
   */

  static __bitmask_decode = function(value, mask, shift)
  {
    return __bitmask_filter(value, mask) >> shift;
  }



  /**
   * @desc Encodes the position of a DialogLinkable item into a single value.
   * @param {Struct.DialogLinkable} item The item to encode the position of.
   * @returns {Real}
   */

  static __encode_level_position = function(item)
  {
    var idx = array_create(DIALOG_ITEM.LEVEL_LINKABLE_COUNT, 0);

    for (var lv = item.__level(); lv >= 0; --lv) {
      idx[lv] = item.index();
      item = item.parent;
    }

    return __encode_position(
      idx[DIALOG_ITEM.LEVEL_SCENE],
      idx[DIALOG_ITEM.LEVEL_SEQUENCE],
      idx[DIALOG_ITEM.LEVEL_DIALOG]
    );
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
    return __bitmask_encode(scene_idx, DIALOG_MANAGER.__BITMASK_POSITION_SCENE_MASK, DIALOG_MANAGER.__BITMASK_POSITION_SCENE_SHIFT);
  }



  /**
   * @desc Encodes a sequence position given an index.
   * @param {Real} sequence_idx The sequence index to encode.
   * @returns {Real}
   */

  static __encode_sequence_idx = function(sequence_idx)
  {
    return __bitmask_encode(sequence_idx, DIALOG_MANAGER.__BITMASK_POSITION_SEQUENCE_MASK, DIALOG_MANAGER.__BITMASK_POSITION_SEQUENCE_SHIFT);
  }



  /**
   * @desc Encodes a dialog position given an index.
   * @param {Real} dialog_idx The dialog index to encode.
   * @returns {Real}
   */

  static __encode_dialog_idx = function(dialog_idx)
  {
    return __bitmask_encode(dialog_idx, DIALOG_MANAGER.__BITMASK_POSITION_DIALOG_MASK, DIALOG_MANAGER.__BITMASK_POSITION_DIALOG_SHIFT);
  }



  /**
   * @desc Encodes a position given an index and a level.
   * @param {Real} idx The index to encode.
   * @param {Constant.DIALOG_ITEM} level The level to encode the index for.
   * @returns {Real}
   */

  static __encode_level_idx = function(idx, level)
  {
    return [__encode_scene_idx, __encode_sequence_idx, __encode_dialog_idx][level](idx);
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
    return __bitmask_encode(jump_type, DIALOG_RUNNER.__BITMASK_JUMP_SETTING_TYPE_MASK, DIALOG_RUNNER.__BITMASK_JUMP_SETTING_TYPE_SHIFT);
  }



  /**
   * @desc Encodes a jump unit into a position.
   * @param {Constant.DIALOG_MANAGER} jump_unit The jump unit to encode.
   * @returns {Real}
   */

  static __encode_jump_setting_unit = function(jump_unit)
  {
    return __bitmask_encode(jump_unit, DIALOG_RUNNER.__BITMASK_JUMP_SETTING_UNIT_MASK, DIALOG_RUNNER.__BITMASK_JUMP_SETTING_UNIT_SHIFT);
  }



  /**
   * @desc Returns the scene index given a position.
   * @param {Real} position The position to decode.
   * @returns {Real}
   */

  static __decode_scene_idx = function(position)
  {
    return __bitmask_decode(position, DIALOG_MANAGER.__BITMASK_POSITION_SCENE_MASK, DIALOG_MANAGER.__BITMASK_POSITION_SCENE_SHIFT);
  }



  /**
   * @desc Returns the sequence index given a position.
   * @param {Real} position The position to decode.
   * @returns {Real}
   */

  static __decode_sequence_idx = function(position)
  {
    return __bitmask_decode(position, DIALOG_MANAGER.__BITMASK_POSITION_SEQUENCE_MASK, DIALOG_MANAGER.__BITMASK_POSITION_SEQUENCE_SHIFT);
  }



  /**
   * @desc Returns the dialog index given a position.
   * @param {Real} position The position to decode.
   * @returns {Real}
   */

  static __decode_dialog_idx = function(position)
  {
    return __bitmask_decode(position, DIALOG_MANAGER.__BITMASK_POSITION_DIALOG_MASK, DIALOG_MANAGER.__BITMASK_POSITION_DIALOG_SHIFT);
  }



  /**
   * @desc Returns the jump unit given a jump settings bitfield.
   * @param {Real} [jump_settings] The jump settings decode from.
   * @returns {Constant.DIALOG_MANAGER|Real}
   */

  static __decode_jump_setting_type = function(jump_settings)
  {
    return __bitmask_decode(jump_settings, DIALOG_RUNNER.__BITMASK_JUMP_SETTING_TYPE_MASK, DIALOG_RUNNER.__BITMASK_JUMP_SETTING_TYPE_SHIFT);
  }



  /**
   * @desc Returns the jump unit given a jump setting bitfield.
   * @param {Real} [jump_settings] The jump settings to decode from.
   * @returns {Constant.DIALOG_MANAGER|Real}
   */

  static __decode_jump_setting_unit = function(jump_settings)
  {
    return __bitmask_decode(jump_settings, DIALOG_RUNNER.__BITMASK_JUMP_SETTING_UNIT_MASK, DIALOG_RUNNER.__BITMASK_JUMP_SETTING_UNIT_SHIFT);
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
    var shift_cancelled = (jump_settings & DIALOG_RUNNER.__BITMASK_JUMP_SETTING_MAINTAIN_BEHAVIOUR_MASK) != 0
      , status = (shift_cancelled && jump_settings & DIALOG_RUNNER.JUMP_SETTING_MAINTAIN_SCENE) * DIALOG_RUNNER.STATUS_MAINTAINED_SCENE
        | (shift_cancelled && jump_settings & DIALOG_RUNNER.JUMP_SETTING_MAINTAIN_SEQUENCE) * DIALOG_RUNNER.STATUS_MAINTAINED_SEQUENCE
        | (shift_cancelled && jump_settings & DIALOG_RUNNER.JUMP_SETTING_MAINTAIN_DIALOG) * DIALOG_RUNNER.STATUS_MAINTAINED_DIALOG
    ;

    return {
      position: self.scene((__decode_scene_idx(start_position) + scene_shift * !status) % self.itemcount()),
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
      next_sequence_idx = clamp(target_sequence_idx, 0, next_scene.itemcount() - 1);
      status |= DIALOG_RUNNER.STATUS_MAINTAINED_SCENE * !_in_range(target_sequence_idx, 0, next_scene.itemcount());
      sequence_shift = 0;
    }
    else if (!_in_range(next_sequence_idx + sequence_shift, 0, next_scene.itemcount()))
    {
      var sequence_diff = shift_sign ? next_sequence_idx + 1 : next_scene.itemcount() - next_sequence_idx;
      next_sequence_idx = shift_sign ? -1 : next_scene.itemcount();
      sequence_shift += sequence_diff * shift_sign;

      while (!_in_range(next_sequence_idx + sequence_shift, 0, next_scene.itemcount()))
      {
        sequence_shift -= next_scene.itemcount() * shift_sign;
        next_scene_idx = __index_wrap(next_scene_idx + shift_sign, 0, self.itemcount());
        next_scene = self.scene(next_scene_idx);
        next_sequence_idx = shift_sign ? -1 : next_scene.itemcount();
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
      next_dialog_idx = clamp(target_dialog_idx, 0, next_sequence.itemcount() - 1);
      status |= DIALOG_RUNNER.STATUS_MAINTAINED_SEQUENCE * !_in_range(target_dialog_idx, 0, next_sequence.itemcount());
      dialog_shift = 0;
    }
    else if (!_in_range(next_dialog_idx + dialog_shift, 0, next_sequence.itemcount()))
    {
      var dialog_diff = shift_sign ? next_dialog_idx + 1 : next_sequence.itemcount() - next_dialog_idx;
      next_dialog_idx = shift_sign ? -1 : next_sequence.itemcount();
      dialog_shift += dialog_diff * shift_sign;

      while (!_in_range(next_dialog_idx + dialog_shift, 0, next_sequence.itemcount()))
      {
        dialog_shift -= next_sequence.itemcount() * shift_sign;
        next_sequence_idx += shift_sign;

        if (!_in_range(next_sequence_idx, 0, next_scene.itemcount()))
        {
          if (jump_settings & DIALOG_RUNNER.JUMP_SETTING_MAINTAIN_SCENE) {
            next_dialog_idx = shift_sign ? next_sequence.itemcount() - 1 : 0;
            status |= DIALOG_RUNNER.STATUS_MAINTAINED_SCENE;
            next_sequence_idx -= shift_sign;
            dialog_shift = 0;
            break;
          }

          next_scene_idx = __index_wrap(next_scene_idx + shift_sign, 0, self.itemcount());
          next_scene = self.scene(next_scene_idx);
          next_sequence_idx = shift_sign ? 0 : next_scene.itemcount() - 1;
        }

        next_sequence = self.sequence(next_sequence_idx, next_scene_idx);
        next_dialog_idx = shift_sign ? -1 : next_sequence.itemcount();
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

    var dialog_idx = __decode_dialog_idx(position)
      , sequence_idx = __decode_sequence_idx(position)
      , scene_idx = __decode_scene_idx(position)
      , sequence = self.sequence(sequence_idx, scene_idx)
      , scene = self.scene(scene_idx)
    ;

    switch (position)
    {
      case DIALOG_MANAGER.POSITION_CODE_SCENE_FIRST:
      case DIALOG_MANAGER.POSITION_CODE_SEQUENCE_FIRST:
        return __encode_position(0, 0, 0);
      case DIALOG_MANAGER.POSITION_CODE_SCENE_LAST:
        return __encode_position(self.itemcount() - 1, 0, 0);
      case DIALOG_MANAGER.POSITION_CODE_SCENE_NEXT:
        return __encode_position((scene_idx + 1) % self.itemcount(), 0, 0);
      case DIALOG_MANAGER.POSITION_CODE_SCENE_END:
        return __encode_position(scene_idx, scene.itemcount() - 1, 0);
      case DIALOG_MANAGER.POSITION_CODE_SCENE_MIDDLE:
        return __encode_position(scene_idx, scene.itemcount() >> 1, 0);
      case DIALOG_MANAGER.POSITION_CODE_SCENE_START:
        return __encode_position(scene_idx, 0, 0);
      case DIALOG_MANAGER.POSITION_CODE_SCENE_PREVIOUS:
        return __encode_position((scene_idx + self.itemcount() - 1) % self.itemcount(), 0, 0);
      case DIALOG_MANAGER.POSITION_CODE_SEQUENCE_LAST:
        return __encode_position(self.itemcount() - 1, self.scenes[self.itemcount() - 1].itemcount() - 1, 0);
      case DIALOG_MANAGER.POSITION_CODE_SEQUENCE_NEXT:
        return __get_sequence_relative(1, position, jump_settings).position.position();
      case DIALOG_MANAGER.POSITION_CODE_SEQUENCE_END:
        return __encode_position(scene_idx, sequence_idx, sequence.itemcount() - 1);
      case DIALOG_MANAGER.POSITION_CODE_SEQUENCE_MIDDLE:
        return __encode_position(scene_idx, sequence_idx, sequence.itemcount() >> 1);
      case DIALOG_MANAGER.POSITION_CODE_SEQUENCE_START:
        return __encode_position(scene_idx, sequence_idx, 0);
      case DIALOG_MANAGER.POSITION_CODE_SEQUENCE_PREVIOUS:
        return __get_sequence_relative(-1, position, jump_settings).position.position();
    }

    dialog_idx = __decode_dialog_idx(position);
    sequence_idx = __decode_sequence_idx(position);
    scene_idx = __decode_scene_idx(position);

    if (
      scene_idx >= self.itemcount()
      || sequence_idx >= self.scene(scene_idx).itemcount()
      || dialog_idx >= self.sequence(sequence_idx, scene_idx).itemcount()
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



  self.deserialize(data_string, is_file);
}












// ----------------------------------------------------------------------------












/**
 * @desc `DialogScene` constructor.
 * @param {Array<Struct.DialogSequence>} sequences The array of `DialogSequence` of the scene.
 * @param {Constant.DIALOG_SCENE|Real} settings_mask The scene settings.
 * @param {Real} [id] The scene identifier. If `undefined`, an identifier will be automatically assigned to ensure uniqueness.
 * @returns {Struct.DialogScene}
 */

function DialogScene(sequences, settings_mask, id = undefined) : DialogLinkable(sequences, settings_mask, id) constructor
{
  static __CONSTRUCTOR_ARGC = argument_count;
  static __LEVEL = DIALOG_ITEM.LEVEL_SCENE;



  self.id = DialogManager.__id_assign(self, id);



  /**
   * @desc Encodes/decodes the scene bg as a bitmask fragment.
   * @param {Constant.DIALOG_SCENE|Real} [bg_mask] The bg identifier.
   * @returns {Real}
   */

  static bg = function(bg_mask = undefined)
  {
    return __bitmask_enc_dec(bg_mask, DIALOG_SCENE.__BITMASK_BG_MASK, DIALOG_SCENE.__BITMASK_BG_SHIFT);
  }



  /**
   * @desc Encodes/decodes the scene bgm as a bitmask fragment.
   * @param {Constant.DIALOG_SCENE|Real} [bgm_mask] The bgm identifier.
   * @returns {Real}
   */

  static bgm = function(bgm_mask = undefined)
  {
    return __bitmask_enc_dec(bgm_mask, DIALOG_SCENE.__BITMASK_BGM_MASK, DIALOG_SCENE.__BITMASK_BGM_SHIFT);
  }



  /**
   * @desc Encodes/decodes the scene bgs as a bitmask fragment.
   * @param {Constant.DIALOG_SCENE|Real} [bgs_mask] The bgs identifier.
   * @returns {Real}
   */

  static bgs = function(bgs_mask = undefined)
  {
    return __bitmask_enc_dec(bgs_mask, DIALOG_SCENE.__BITMASK_BGS_MASK, DIALOG_SCENE.__BITMASK_BGS_SHIFT);
  }



  /**
   * @desc Encodes/decodes the scene tag as a bitmask fragment.
   * @param {Constant.DIALOG_SCENE|Real} [tag_mask] The tag identifier.
   * @returns {Real}
   */

  static tag = function(tag_mask = undefined)
  {
    return __bitmask_enc_dec(tag_mask, DIALOG_SCENE.__BITMASK_TAG_MASK, DIALOG_SCENE.__BITMASK_TAG_SHIFT);
  }



  /**
   * @desc Retrieves a sequence given an index. Negative indices will iterate backwards.
   * @param {Real} sequence_idx The index of the sequence to get.
   * @param {Function} [filter_fn] An optional filter function that takes a sequence and the provided `argv` as arguments and returns a boolean indicating whether the sequence satisfies the filter condition.
   * @param {Any} [argv] An optional argument to be passed to the filter.
   * @returns {Struct.DialogSequence}
   */

  static sequence = function(sequence_idx, filter_fn = undefined, argv = undefined)
  {
    return self.item(sequence_idx, filter_fn, argv);
  }



  /**
   * @desc Encodes/decodes the scene bg as a bitmask fragment.
   * @param {Constant.DIALOG_SCENE|Real} [settings_mask] The settings mask.
   * @returns {Real}
   */

  static __bg = function(settings_mask = undefined)
  {
    return __bitmask_filter(settings_mask, DIALOG_SCENE.__BITMASK_BG_MASK);
  }



  /**
   * @desc Encodes/decodes the scene bgm as a bitmask fragment.
   * @param {Constant.DIALOG_SCENE|Real} [settings_mask] The settings mask.
   * @returns {Real}
   */

  static __bgm = function(settings_mask = undefined)
  {
    return __bitmask_filter(settings_mask, DIALOG_SCENE.__BITMASK_BGM_MASK);
  }



  /**
   * @desc Encodes/decodes the scene bgs as a bitmask fragment.
   * @param {Constant.DIALOG_SCENE|Real} [settings_mask] The settings mask.
   * @returns {Real}
   */

  static __bgs = function(settings_mask = undefined)
  {
    return __bitmask_filter(settings_mask, DIALOG_SCENE.__BITMASK_BGS_MASK);
  }



  /**
   * @desc Encodes/decodes the scene tag as a bitmask fragment.
   * @param {Constant.DIALOG_SCENE|Real} [settings_mask] The settings mask.
   * @returns {Real}
   */

  static __tag = function(settings_mask = undefined)
  {
    return __bitmask_filter(settings_mask, DIALOG_SCENE.__BITMASK_TAG_MASK);
  }



  /**
   * @desc Serialises the scene into a compact array.
   * @returns {Array<Any>}
   */

  static __array = function()
  {
    return [
      array_map(self.items(), function(sequence) {
        return sequence.__DIALOG_MANAGER_SERIALIZER_METHOD__();
      }),
      int64(self.settings_mask),
      int64(self.itemcount()),
      int64(self.id),
    ];
  }



  /**
   * @desc Serialises the scene into a plain struct.
   * @returns {Struct}
   */

  static __struct = function()
  {
    return {
      sequences: array_map(self.items(), function(sequence) {
        return sequence.__DIALOG_MANAGER_SERIALIZER_METHOD__();
      }),
      settings_mask: int64(self.settings_mask),
      sequence_count: int64(self.itemcount()),
      id: int64(self.id),
    };
  }



  /**
   * @desc Deserializes a scene from an array produced by {@link __array}.
   * @param {Array<Any>} data The array payload.
   * @returns {Struct.DialogScene}
   */

  static __from_array = function(data)
  {
    return new DialogScene([], data[DIALOG_SCENE.ARG_SETTINGS_MASK], data[DIALOG_SCENE.ARG_ID])
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
    return new DialogScene([], data.settings_mask, data.id)
      .__parse(data.sequences, data.sequence_count)
    ;
  }
}












// ----------------------------------------------------------------------------












/**
 * @desc `DialogSequence` constructor.
 * @param {Array<Struct.Dialog>} dialogs The array of `Dialog` of the sequence.
 * @param {Constant.DIALOG_SEQUENCE|Real} settings_mask The sequence info.
 * @param {Array<Real>} speakers The indices of the speakers.
 * @param {Real} [id] The sequence identifier. If `undefined`, an identifier will be automatically assigned to ensure uniqueness.
 * @returns {Struct.DialogSequence}
 */

function DialogSequence(dialogs, settings_mask, speakers, id = undefined) : DialogLinkable(dialogs, settings_mask, id) constructor
{
  static __CONSTRUCTOR_ARGC = argument_count;
  static __LEVEL = DIALOG_ITEM.LEVEL_SEQUENCE;



  self.id = DialogManager.__id_assign(self, id);
  self.speakers = speakers;



  /**
   * @desc Encodes/decodes the sequence tag as a bitmask fragment.
   * @param {Constant.DIALOG_SEQUENCE|Real} [tag_mask] The tag identifier.
   * @returns {Real}
   */

  static tag = function(tag_mask = undefined)
  {
    return __bitmask_enc_dec(tag_mask, DIALOG_SEQUENCE.__BITMASK_TAG_MASK, DIALOG_SEQUENCE.__BITMASK_TAG_SHIFT);
  }



  /**
   * @desc Retrieves a dialog given an index. Negative indices will iterate backwards.
   * @param {Real} dialog_idx The index of the dialog to get.
   * @param {Function} [filter_fn] An optional filter function that takes a dialog and the provided `argv` as arguments and returns a boolean indicating whether the dialog satisfies the filter condition.
   * @param {Any} [argv] An optional argument to be passed to the filter.
   * @returns {Struct.Dialog}
   */

  static dialog = function(dialog_idx, filter_fn = undefined, argv = undefined)
  {
    return self.item(dialog_idx, filter_fn, argv);
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
      , dialog_count = self.itemcount()
    ;

    for (var i = 0; i < dialog_count; ++i)
    {
      var dialog = self.dialog(i)
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
   * @desc Encodes/decodes the sequence tag as a bitmask fragment.
   * @param {Constant.DIALOG_SEQUENCE|Real} [settings_mask] The settings mask.
   * @returns {Real}
   */

  static __tag = function(settings_mask = undefined)
  {
    return __bitmask_filter(settings_mask, DIALOG_SEQUENCE.__BITMASK_TAG_MASK);
  }



  /**
   * @desc Serialises the sequence into a compact array.
   * @returns {Array<Any>}
   */

  static __array = function()
  {
    return [
      int64(self.settings_mask),
      array_map(self.items(), function(dialog) {
        return dialog.__DIALOG_MANAGER_SERIALIZER_METHOD__();
      }),
      array_map(self.speakers, function(speaker) {
        return int64(speaker);
      }),
      int64(self.itemcount()),
      int64(self.id),
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
      dialogs: array_map(self.items(), function(dialog) {
        return dialog.__DIALOG_MANAGER_SERIALIZER_METHOD__();
      }),
      speakers: array_map(self.speakers, function(speaker) {
        return int64(speaker);
      }),
      dialog_count: int64(self.itemcount()),
      id: int64(self.id),
    };
  }



  /**
   * @desc Deserialises a sequence from an array produced by {@link __array}.
   * @param {Array} data The array payload.
   * @returns {Struct.DialogSequence}
   */

  static __from_array = function(data)
  {
    return new DialogSequence([], data[DIALOG_SEQUENCE.ARG_SETTINGS_MASK], data[DIALOG_SEQUENCE.ARG_SPEAKERS], data[DIALOG_SEQUENCE.ARG_ID])
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
    return new DialogSequence([], data.settings_mask, data.speakers, data.id)
      .__parse(data.dialogs, data.dialog_count)
    ;
  }
}












// ----------------------------------------------------------------------------












/**
 * @desc `Dialog` constructor.
 * @param {String} text The text message of the dialog.
 * @param {Constant.DIALOG|Real} settings_mask The dialog info.
 * @param {Array<Struct.DialogFX>} fx_map The array of `DialogFX` to apply.
 * @param {Real} [id] The dialog identifier. If `undefined`, an identifier will be automatically assigned to ensure uniqueness.
 * @returns {Struct.Dialog}
 */

function Dialog(text, settings_mask, fx_map, id = undefined) : DialogLinkable(fx_map, settings_mask, id) constructor
{
  static __CONSTRUCTOR_ARGC = argument_count;
  static __LEVEL = DIALOG_ITEM.LEVEL_DIALOG;

  static TEXT_WIDTH_MAX = -1;
  static TEXT_WIDTH_FUNC = function(dialog) {
    return string_width(dialog.text);
  };



  self.id = DialogManager.__id_assign(self, id);
  self.text = text;

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
   * @desc Encodes/decodes the dialog speaker as a bitmask fragment.
   * @param {Constant.DIALOG|Real} [speaker_mask] The speaker identifier.
   * @returns {Real}
   */

  static speaker = function(speaker_mask = undefined)
  {
    return __bitmask_enc_dec(speaker_mask, DIALOG.__BITMASK_SPEAKER_MASK, DIALOG.__BITMASK_SPEAKER_MASK);
  }



  /**
   * @desc Encodes/decodes the dialog emotion as a bitmask fragment.
   * @param {Constant.DIALOG|Real} [emotion_mask] The emotion identifier.
   * @returns {Real}
   */

  static emotion = function(emotion_mask = undefined)
  {
    return __bitmask_enc_dec(emotion_mask, DIALOG.__BITMASK_EMOTION_MASK, DIALOG.__BITMASK_EMOTION_SHIFT);
  }



  /**
   * @desc Encodes/decodes the dialog anchor as a bitmask fragment.
   * @param {Constant.DIALOG|Real} [anchor_mask] The anchor identifier.
   * @returns {Real}
   */

  static anchor = function(anchor_mask = undefined)
  {
    return __bitmask_enc_dec(anchor_mask, DIALOG.__BITMASK_ANCHOR_MASK, DIALOG.__BITMASK_ANCHOR_SHIFT);
  }



  /**
   * @desc Encodes/decodes the dialog textbox as a bitmask fragment.
   * @param {Constant.DIALOG|Real} [textbox_mask] The textbox identifier.
   * @returns {Real}
   */

  static textbox = function(textbox_mask = undefined)
  {
    return __bitmask_enc_dec(textbox_mask, DIALOG.__BITMASK_TEXTBOX_MASK, DIALOG.__BITMASK_TEXTBOX_SHIFT);
  }



  /**
   * @desc Encodes/decodes the dialog tag as a bitmask fragment.
   * @param {Constant.DIALOG|Real} [tag_mask] The tag identifier.
   * @returns {Real}
   */

  static tag = function(tag_mask = undefined)
  {
    return __bitmask_enc_dec(tag_mask, DIALOG.__BITMASK_TAG_MASK, DIALOG.__BITMASK_TAG_SHIFT);
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
    return self.item(n, filter_fn, argv);
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
    return self.fx(n, function(fx, argv) {
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
    return self.fx(n, function(fx, argv) {
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
    return self.fx(n, function(fx, argv) {
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
    return self.fx(n, function(fx, argv) {
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
    return self.fx(n, function(fx, argv) {
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
   * @desc Encodes/decodes the dialog speaker as a bitmask fragment.
   * @param {Constant.DIALOG|Real} [settings_mask] The settings mask.
   * @returns {Real}
   */

  static __speaker = function(settings_mask = undefined)
  {
    return __bitmask_filter(settings_mask, DIALOG.__BITMASK_SPEAKER_MASK);
  }



  /**
   * @desc Encodes/decodes the dialog emotion as a bitmask fragment.
   * @param {Constant.DIALOG|Real} [settings_mask] The settings mask.
   * @returns {Real}
   */

  static __emotion = function(settings_mask = undefined)
  {
    return __bitmask_filter(settings_mask, DIALOG.__BITMASK_EMOTION_MASK);
  }



  /**
   * @desc Encodes/decodes the dialog anchor as a bitmask fragment.
   * @param {Constant.DIALOG|Real} [settings_mask] The settings mask.
   * @returns {Real}
   */

  static __anchor = function(settings_mask = undefined)
  {
    return __bitmask_filter(settings_mask, DIALOG.__BITMASK_ANCHOR_MASK);
  }



  /**
   * @desc Encodes/decodes the dialog textbox as a bitmask fragment.
   * @param {Constant.DIALOG|Real} [settings_mask] The settings mask.
   * @returns {Real}
   */

  static __textbox = function(settings_mask = undefined)
  {
    return __bitmask_filter(settings_mask, DIALOG.__BITMASK_TEXTBOX_MASK);
  }



  /**
   * @desc Encodes/decodes the dialog tag as a bitmask fragment.
   * @param {Constant.DIALOG|Real} [settings_mask] The settings mask.
   * @returns {Real}
   */

  static __tag = function(settings_mask = undefined)
  {
    return __bitmask_filter(settings_mask, DIALOG.__BITMASK_TAG_MASK);
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
    var fx_count = self.itemcount();

    for (var i = 0; i < fx_count; ++i)
    {
      var fx = self.fx(i);

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
    var resolved = false
      , fx_skip_next = false
      , fx_first_exec_index = -1
      , fx_last_exec_index = fx_first_exec_index
      , fx_previous_exec_index = fx_last_exec_index
      , loop_goto_next = false
      , fx_count = self.itemcount()
    ;

    for (var i = 0; i < fx_count; ++i)
    {
      if (ctx.executed > DIALOG_MANAGER.ERRCHECK_FX_INFINITE_LOOP_TRESHOLD) {
        throw DialogManager.ERROR(DIALOG_MANAGER.ERR_INFINITE_FX_LOOP_DETECTED, [
          ctx.executed, ctx.__struct()
        ]);
      }

      var fx = self.fx(i);

      if (fx.trigger() != trigger || !filter_fn(fx, argv))
        continue;

      if (fx_first_exec_index < 0)
        fx_first_exec_index = i;

      if (fx_skip_next) {
        fx_skip_next = false;
        continue;
      }

      fx_previous_exec_index = fx_last_exec_index;
      fx_last_exec_index = i;
      fx.execute(argv, ctx);

      switch (ctx.signal)
      {
        case DIALOG_FX.SIGNAL_STOP_CYCLE:
        case DIALOG_FX.SIGNAL_STOP_RESOLUTION:
          resolved = true;
        break;

        case DIALOG_FX.SIGNAL_REPEAT_CYCLE:
          i = fx_first_exec_index - 1;
          loop_goto_next = true;
        break;

        case DIALOG_FX.SIGNAL_REPEAT_PREVIOUS_FX:
          i = (fx_previous_exec_index < 0 ? fx_last_exec_index : fx_previous_exec_index) - 1;
          loop_goto_next = true;
        break;

        case DIALOG_FX.SIGNAL_REPEAT_FX:
          i -= 1;
          loop_goto_next = true;
        break;
      }

      if (resolved)
        break;

      if (loop_goto_next) {
        loop_goto_next = false;
        continue;
      }

      fx_skip_next = ctx.signal == DIALOG_FX.SIGNAL_SKIP_NEXT_FX;
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
      array_map(self.items(), function(fx) {
        return fx.__DIALOG_MANAGER_SERIALIZER_METHOD__();
      }),
      int64(self.itemcount()),
      int64(self.id),
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
      fx_map: array_map(self.items(), function(fx) {
        return fx.__DIALOG_MANAGER_SERIALIZER_METHOD__();
      }),
      fx_count: int64(self.itemcount()),
      id: int64(self.id),
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
      }),
      data[DIALOG.ARG_ID]
    );

    dialog.container.item_count = data[DIALOG.ARG_FX_COUNT];

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
      }),
      data.id
    );

    dialog.container.item_count = data.fx_count;

    return dialog;
  }
}












// ----------------------------------------------------------------------------












/**
 * @desc `DialogFX` constructor.
 * @param {Constant.DIALOG_FX|Real} settings_mask The effect info.
 * @param {Array<Any>} argv The arguments of the mapped effect function.
 * @param {Real} [id] The unique identifier of the effect. Optional, mainly used for deserialization.
 * @returns {Struct.DialogFX}
 */

function DialogFX(settings_mask, argv, id = undefined) : DialogItem(settings_mask, id) constructor
{
  static __CONSTRUCTOR_ARGC = argument_count;
  static __LEVEL = DIALOG_ITEM.LEVEL_DIALOG_FX;
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



  self.id = DialogManager.__id_assign(self, id);
  self.argv = argv;



  /**
   * @desc Encodes/decodes the dialog FX type as a bitmask fragment.
   * @param {Constant.DIALOG_FX|Real} [type_mask] The type identifier.
   * @returns {Real}
   */

  static type = function(type_mask = undefined)
  {
    return __bitmask_enc_dec(type_mask, DIALOG_FX.__BITMASK_TYPE_MASK, DIALOG_FX.__BITMASK_TYPE_SHIFT);
  }



  /**
   * @desc Encodes/decodes the dialog FX trigger as a bitmask fragment.
   * @param {Constant.DIALOG_FX|Real} [trigger_mask] The trigger identifier.
   * @returns {Real}
   */

  static trigger = function(trigger_mask = undefined)
  {
    return __bitmask_enc_dec(trigger_mask, DIALOG_FX.__BITMASK_TRIGGER_MASK, DIALOG_FX.__BITMASK_TRIGGER_SHIFT);
  }



  /**
   * @desc Encodes/decodes the dialog FX signal as a bitmask fragment.
   * @param {Constant.DIALOG_FX|Real} [signal_mask] The signal identifier.
   * @returns {Real}
   */

  static signal = function(signal_mask = undefined)
  {
    return __bitmask_enc_dec(signal_mask, DIALOG_FX.__BITMASK_SIGNAL_MASK, DIALOG_FX.__BITMASK_SIGNAL_SHIFT);
  }



  /**
   * @desc Encodes/decodes the dialog FX tag as a bitmask fragment.
   * @param {Constant.DIALOG_FX|Real} [tag_mask] The tag identifier.
   * @returns {Real}
   */

  static tag = function(tag_mask = undefined)
  {
    return __bitmask_enc_dec(tag_mask, DIALOG_FX.__BITMASK_TAG_MASK, DIALOG_FX.__BITMASK_TAG_SHIFT);
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
    if (is_instanceof(context, DialogCycleContext)) {
      ++context.executed;
      context.fx = self;
    }

    return DialogFX.data.fx_map.funcs[self.type()](argv, context);
  }



  /**
   * @desc Encodes/decodes the dialog FX type as a bitmask fragment.
   * @param {Constant.DIALOG_FX|Real} [settings_mask] The settings mask.
   * @returns {Real}
   */

  static __type = function(settings_mask = undefined)
  {
    return __bitmask_filter(settings_mask, DIALOG_FX.__BITMASK_TYPE_MASK);
  }



  /**
   * @desc Encodes/decodes the dialog FX trigger as a bitmask fragment.
   * @param {Constant.DIALOG_FX|Real} [settings_mask] The settings mask.
   * @returns {Real}
   */

  static __trigger = function(settings_mask = undefined)
  {
    return __bitmask_filter(settings_mask, DIALOG_FX.__BITMASK_TRIGGER_MASK);
  }



  /**
   * @desc Encodes/decodes the dialog FX signal as a bitmask fragment.
   * @param {Constant.DIALOG_FX|Real} [settings_mask] The settings mask.
   * @returns {Real}
   */

  static __signal = function(settings_mask = undefined)
  {
    return __bitmask_filter(settings_mask, DIALOG_FX.__BITMASK_SIGNAL_MASK);
  }



  /**
   * @desc Encodes/decodes the dialog FX tag as a bitmask fragment.
   * @param {Constant.DIALOG_FX|Real} [settings_mask] The settings mask.
   * @returns {Real}
   */

  static __tag = function(settings_mask = undefined)
  {
    return __bitmask_filter(settings_mask, DIALOG_FX.__BITMASK_TAG_MASK);
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
   * @param {Array} jump_option_data The data for the jump option.
   * @param {Struct.DialogCycleContext} [context] The context object with the environment data for the effect.
   * @returns {Struct.Dialog} The resolved position.
   */

  static __resolve_option_flow = function(option_flow, context = undefined)
  {
    if (!context)
      return undefined;

    var runner = context.runner
      , manager = runner.manager
      , jump_position_data = option_flow[DIALOG_FX.FX_ARG_FLOWRES_DATA_POSITION]
      , jump_position = jump_position_data[DIALOG_FX.FX_ARG_FLOWRES_DATA_POSITION_DESTINATION]
      , jump_settings = jump_position_data[DIALOG_FX.FX_ARG_FLOWRES_DATA_POSITION_SETTINGS] ?? 0
    ;

    return manager.__to_dialog(manager.__resolve_position(jump_position, runner.position, jump_settings));
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
      __resolve_option_flow(argv[DIALOG_FX.FX_ARG_FLOWRES_DATA][0], ctx),
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
      __resolve_option_flow(argv[DIALOG_FX.FX_ARG_FLOWRES_DATA][idx], ctx),
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
      __resolve_option_flow(argv[DIALOG_FX.FX_ARG_FLOWRES_DATA][0], ctx),
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
      __resolve_option_flow(argv[DIALOG_FX.FX_ARG_FLOWRES_DATA][idx], ctx),
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
      int64(self.id),
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
      id: int64(self.id),
    };
  }



  /**
   * @desc Deserialises an FX from an array produced by {@link __array}.
   * @param {Array<Any>} data The array payload.
   * @returns {Struct.DialogFX}
   */

  static __from_array = function(data)
  {
    return new DialogFX(data[DIALOG_FX.ARG_SETTINGS_MASK], data[DIALOG_FX.ARG_ARGV], data[DIALOG_FX.ARG_ID]);
  }



  /**
   * @desc Deserialises an FX from a struct produced by {@link __struct}.
   * @param {Struct} data The struct payload.
   * @returns {Struct.DialogFX}
   */

  static __from_struct = function(data)
  {
    return new DialogFX(data.settings_mask, data.argv, data.id);
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












#endregion

// ----------------------------------------------------------------------------

#region Support classes












/**
 * @desc `DialogCycleContext` constructor. Provides per-cycle caching for condition and indexer evaluations.
 * @param {Struct.DialogRunner} runner The dialog runner instance.
 * @param {Real} position The current position in the dialog graph.
 * @param {Real} target_position The target position of the current cycle.
 * @returns {Struct.DialogCycleContext}
 */

function DialogCycleContext(runner, position, target_position) constructor
{
  static __CONSTRUCTOR_ARGC = argument_count;

  self.runner = runner;
  self.dialog = runner.manager.__to_dialog(position);
  self.target = runner.manager.__to_dialog(target_position);

  self.fx = undefined;
  self.executed = 0;
  self.resolved = false;
  self.signal = DIALOG_FX.SIGNAL_NONE;
  self.cache = {
    conditions: {},
    indexers: {},
  };



  /**
   * @desc Signals a successful flow resolution, setting the target position and updating runner status.
   * @param {Struct.Dialog} [target_position] The target position to set.
   * @param {Real} [runner_status] Additional status flags to OR into the runner's status.
   * @returns {Struct.Dialog}
   */

  static success = function(target_position = self.target, runner_status = 0)
  {
    var runner = self.runner
      , fx = self.fx
    ;

    runner.status |= runner_status;
    self.target = target_position;
    self.signal = fx ? fx.signal() : DIALOG_FX.SIGNAL_NONE;

    return target_position;
  }



  /**
   * @desc Signals a failed flow resolution, returning the target position (mostly undefined).
   * @param {Struct.Dialog} [target_position] Unused parameter for consistency.
   * @param {Real} [runner_status] Unused parameter for consistency.
   * @returns {Struct.Dialog}
   */

  static fail = function(target_position = self.target, runner_status = 0)
  {
    var runner = self.runner;

    runner.status |= runner_status;
    self.target = target_position;
    self.signal = DIALOG_FX.SIGNAL_NONE;

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
 * @desc `DialogItemContainer` constructor. Manages a list of dialog items with indexing and parent references.
 * @param {Array<Struct.DialogItem>} items The initial list of dialog items to populate the container.
 * @returns {Struct.DialogItemContainer}
 */

function DialogItemContainer(items, parent) constructor
{
  self.item_count = 0;
  self.items = [];



  /**
   * @desc Retrieves the list of dialog linkable items.
   * @param {Real} item_idx The index of the item to retrieve. Supports negative indexing.
   * @returns {Array<Struct.DialogItem>}
   */

  static item = function(item_idx)
  {
    return self.items[item_idx + self.item_count * (item_idx < 0)];
  }



  /**
   * @desc Clears the dialog linkable list. [CHAINABLE]
   * @returns {Struct.DialogItemContainer}
   */

  static clear = function()
  {
    self.item_count = 0;
    self.items = [];

    return self;
  }



  /**
   * @desc Clears the dialog linkable list and adds new items. Throws DIALOG_MANAGER.ERR_EMPTY_CONTAINER_OBJECT if any of the item is empty. [CHAINABLE]
   * @param {Struct.DialogItem|Array<Struct.DialogItem>} items The new items to add.
   * @param {Struct.DialogLinkable} [parent] The parent linkable object to reference in the items.
   * @param {Function} [item_fn] An optional function to apply to each item before mapping.
   * @param {Real} [item_count] The number of items to add. Defaults to the length of the items array.
   * @returns {Struct.DialogItemContainer}
   */

  static refresh = function(items, parent = undefined, item_fn = undefined, item_count = undefined)
  {
    return self.clear().add(items, undefined, parent, item_fn, item_count);
  }



  /**
   * @desc Inserts items in the dialog linkable list at a given index. Throws DIALOG_MANAGER.ERR_EMPTY_CONTAINER_OBJECT if any of the item is empty. [CHAINABLE]
   * @param {Struct.DialogItem|Array<Struct.DialogItem>} items The new items to add.
   * @param {Real} [index] The index where to add the new items. Defaults to last index.
   * @param {Struct.DialogLinkable} [parent] The parent linkable object to reference in the items.
   * @param {Function} [item_fn] An optional function to apply to each item before mapping.
   * @param {Real} [item_count] The number of items to add. Defaults
   * @returns {Struct.DialogItemContainer}
   */

  static add = function(items, index = self.item_count, parent = undefined, item_fn = undefined, item_count = undefined)
  {
    if (!is_array(items))
      items = [items];

    item_count ??= array_length(items);

    for (var i = index; i < self.item_count; ++i)
      self.items[i].item_idx += item_count;

    for (var i = 0; i < item_count; ++i)
    {
      var insertion_idx = index + i
        , item = self.mapitem(items[i], insertion_idx, parent, item_fn)
      ;

      if (item.complete()) {
        array_insert(self.items, insertion_idx, item);
      }
    }

    self.item_count += item_count;

    return self;
  }



  /**
   * @desc Maps an item object to the dialog linkable list format, adding indexing and parent references.
   * @param {Struct.DialogItem} item The item to map.
   * @param {Real} item_idx The index of the item in the container.
   * @param {Struct.DialogLinkable} parent The parent linkable object to reference in the item.
   * @param {Function} [item_fn] An optional function to apply to the item
   * @returns {Struct.DialogItem}
   */

  static mapitem = function(item, item_idx, parent, item_fn = undefined)
  {
    if (item_fn)
      item = item_fn(item);

    item.item_idx = item_idx;
    item.parent = parent;

    return item;
  };



  /**
   * @desc Removes items from the dialog linkable list at a given index. Defaults to removing the last item if no index is provided. [CHAINABLE]
   * @param {Real} [index] The index where to remove items. Defaults to last index.
   * @param {Real} [count] The number of items to remove. Defaults to 1 if index is provided, otherwise -1 to remove all items.
   * @returns {Struct.DialogItemContainer}
   */

  static remove = function(index = self.item_count - 1, count = -1)
  {
    if (count != 0)
    {
      var count_abs = abs(count)
        , count_is_negative = count < 0
      ;

      self.item_count -= count_abs;
      index -= count_abs * count_is_negative - count_is_negative;
      array_delete(self.items, index, count_abs);

      for (var i = index; i < self.item_count; ++i)
        self.items[i].item_idx -= count_abs;
    }

    return self;
  }



  /**
   * @desc Checks whether the specified container object contains item objects matching a specified criteria.
   * @param {Function} [filter_fn] The predicate to test against each item. Defaults to a function returning `true`.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the filter.
   * @returns {Bool}
   */

  static has_of = function(filter_fn = function(item, argv) { return true; }, argv = undefined)
  {
    return self.first_of(filter_fn, argv) != undefined;
  }



  /**
   * @desc Retrieves the first item which matches a filter.
   * @param {Function} [filter_fn] The predicate to test against each item. Defaults to a function returning `true`.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the filter.
   * @returns {Struct.DialogItem}
   */

  static first_of = function(filter_fn = function(item, argv = undefined) { return true; }, argv = undefined)
  {
    for (var i = 0; i < self.item_count; ++i)
      if (filter_fn(self.items[i], argv))
        return self.items[i];

    return undefined;
  }



  /**
   * @desc Retrieves the last item which matches a filter.
   * @param {Function} [filter_fn] The predicate to test against each item. Defaults to a function returning `true`.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the item.
   * @returns {Struct.DialogItem}
   */

  static last_of = function(filter_fn = function(item, argv = undefined) { return true; }, argv = undefined)
  {
    var item = undefined;

    for (var i = 0; i < self.item_count; ++i)
      if (filter_fn(self.items[i], argv))
        item = self.items[i];

    return item;
  }



  /**
   * @desc Retrieves the nth dialog item which matches a filter.
   * @param {Real} n The nth occurrence to look for.
   * @param {Function} [filter_fn] The predicate to test against each item. Defaults to a function returning `true`.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the filter.
   * @returns {Struct.DialogItem|undefined}
   */

  static nth_of = function(n, filter_fn = function(item, argv = undefined) { return true; }, argv = undefined)
  {
    var item = undefined;

    for (var i = 0; n && i < self.item_count; ++i)
      if (filter_fn(self.items[i], argv) && n--)
        item = self.items[i];

    return n ? undefined : item;
  }



  /**
   * @desc Retrieves all dialog items which match a filter.
   * @param {Function} [filter_fn] The predicate to test against each items. Defaults to a function returning `true`.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the filter.
   * @returns {Array<Struct.DialogItem|undefined>}
   */

  static all_of = function(filter_fn = function(item, argv = undefined) { return true; }, argv = undefined)
  {
    return all_of_until(
      function(item, argv = undefined) { return false; },
      filter_fn,
      argv
    );
  }



  /**
   * @desc Retrieves all dialog items until the filter is met.
   * @param {Function} [stop_fn] The predicate to test against each FX. Defaults to a function returning `true`.
   * @param {Function} [filter_fn] The predicate to test against each FX. Defaults to a function returning `true`.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the filter.
   * @returns {Array<Struct.DialogItem|undefined>}
   */

  static all_of_until = function(stop_fn = function(item, argv = undefined) { return true; }, filter_fn = function(item, argv = undefined) { return true; }, argv = undefined)
  {
    var filtered = [];

    for (var i = 0; i < self.item_count; ++i)
    {
      var item = self.items[i];

      if (stop_fn(item, argv))
        break;

      if (filter_fn(item, argv))
        array_push(filtered, item);
    }

    return filtered;
  }



  self.add(items, 0, parent);
}












// ----------------------------------------------------------------------------












/**
 * @desc `DialogItem` constructor. Represents a dialog item with indexing and parent references.
 * @param {Real} settings_mask The settings mask for the dialog item.
 * @param {Real} [id] The optional ID for the dialog item. If not provided, an ID will be automatically assigned.
 * @returns {Struct.DialogItem}
 */

function DialogItem(settings_mask, id) constructor
{
  static __CONSTRUCTOR_ARGC = argument_count;
  static __LEVEL = -infinity;



  self.settings_mask = settings_mask;
  self.parent = undefined;
  self.item_idx = 0;



  /**
   * @desc Returns the current/encoded item index.
   * @param {Real} [item_idx] The item index to encode.
   * @returns {Real}
   */

  static index = function(item_idx = undefined)
  {
    return self.item_idx;
  }



  /**
   * @desc Returns the number of item in the selected item's pool.
   * @returns {Real}
   */

  static poolcount = function()
  {
    return self.parent.container.item_count;
  }



  /**
   * @desc Returns whether the item idx is the last of the containing item's.
   * @returns {Bool}
   */

  static islast = function()
  {
    return self.item_idx == self.poolcount() - 1;
  }



  /**
   * @desc Serialises the item to JSON.
   * @param {Bool} [prettify] Whether the string should have line breaks/indentation (`true`) or not (`false`).
   * @returns {String}
   */

  static serialize = function(prettify = false)
  {
    return json_stringify(self.__DIALOG_MANAGER_SERIALIZER_METHOD__(), prettify);
  }



  /**
   * @desc Deserialises a JSON string produced by {@link __serialize}.
   * @param {String} data_string The JSON payload.
   * @returns {Struct.DialogItem}
   */

  static deserialize = function(data_string)
  {
     return self.__DIALOG_MANAGER_DESERIALIZER_METHOD__(json_parse(data_string));
  }



  /**
   * @desc Checks whether the item is complete, meaning it has all the required data to be functional. This is used to determine whether the item should be added to a container or not, throwing an error if the item is incomplete and its container does not allow empty items.
   * @returns {Bool}
   */

  static complete = function()
  {
    var level = __level();

    if (level >= DIALOG_ITEM.LEVEL_DIALOG || self.itemcount()) {
      return true;
    }

    throw DialogManager.ERROR(DIALOG_MANAGER.ERR_EMPTY_CONTAINER_OBJECT, [
      DialogManager.DATA.LEVEL_TYPES[level]
    ]);
  }



  /**
   * @desc Retrieves the assigned manager object.
   * @returns {Struct.DialogManager}
   */

  static __get_manager = function()
  {
    var item = self;

    for (var lv = self.__LEVEL; lv >= 0; --lv) {
      item = item.parent;
    }

    return item;
  }



  /**
   * @desc Retrieves the item's level.
   * @returns {Real}
   */

  static __level = function()
  {
    return self.__LEVEL;
  }



  /**
   * @desc Encodes/decodes the item data as a bitmask fragment.
   * @param {Real} value The value identifier.
   * @param {Real} mask The identifier mask.
   * @param {Real} shift The identifier shift.
   * @returns {Real}
   */

  static __bitmask_enc_dec = function(value, mask, shift)
  {
    return value == undefined
      ? __bitmask_filter(undefined, mask) >> shift
      : __bitmask_filter(value << shift, mask)
    ;
  }



  /**
   * @desc Filters the current or given value as a bitmask fragment.
   * @param {Real} mask The filtering mask of the identifier.
   * @param {Real} value The value of the identifier.
   * @returns {Real}
   */

  static __bitmask_filter = function(value, mask)
  {
    return (value ?? self.settings_mask) & mask;
  }
}












// ----------------------------------------------------------------------------












/**
 * @desc `DialogLinkable` constructor. Used to generalize dialog components' types.
 * @param {Array<DialogLinkable|Any>} dialog_items The items of the dialogical entity.
 * @param {Real} settings_mask The settings mask for the dialogical entity.
 * @param {Real} [id] The optional ID for the dialogical entity. If not provided, an ID will be automatically assigned.
 * @returns {Struct.DialogLinkable}
 */

function DialogLinkable(dialog_items, settings_mask, id = undefined) : DialogItem(settings_mask, id) constructor
{
  self.container = new DialogItemContainer(dialog_items, self);



  /**
   * @desc Returns the current/encoded item index.
   * @param {Real} [item_idx] The item index to encode.
   * @returns {Real}
   */

  static index = function(item_idx = undefined)
  {
    return item_idx != undefined
      ? DialogManager.__encode_level_idx(item_idx, self.__LEVEL)
      : self.item_idx
    ;
  }



  /**
   * @desc Retrieves the items of the container.
   * @returns {Array<Struct.DialogItem>}
   */

  static items = function()
  {
    return self.container.items;
  }



  /**
   * @desc Retrieves the number of items in the container.
   * @returns {Real}
   */

  static itemcount = function()
  {
    return self.container.item_count;
  }



  /**
   * @desc Retrieves the item at a specified index, optionally filtered by a predicate function.
   * @param {Real} item_idx The index of the item to retrieve.
   * @param {Function} [filter_fn] The predicate to test against each item. Defaults to a function returning `true`.
   * @param {Any|Array<Any>} [argv] The arguments to pass to the filter function.
   * @returns {Struct.DialogItem|undefined}
   */

  static item = function(item_idx, filter_fn = undefined, argv = undefined)
  {
    return filter_fn
      ? self.container.nth_of(item_idx, filter_fn, argv)
      : self.container.item(item_idx)
    ;
  }



  /**
   * @desc Adds items to the container.
   * @param {Array<Struct.DialogItem>} items The items to add.
   * @param {Real} [index] The index at which to add the items. If not provided, the items are appended.
   * @param {Struct.DialogLinkable} [parent] The parent of the items to add.
   * @param {Function} [item_fn] The function to call for each item being added.
   * @param {Real} [item_count] The number of items to add.
   * @returns {Struct.DialogLinkable}
   */

  static add = function(items, index = undefined, parent = undefined, item_fn = undefined, item_count = undefined)
  {
    return self.container.add(items, index, parent, item_fn, item_count);
  }



  /**
   * @desc Removes items from the container.
   * @param {Real} [index] The index at which to remove items. If not provided, the last item is removed.
   * @param {Real} [count] The number of items to remove. If not provided, one item is removed.
   * @returns {Struct.DialogLinkable}
   */

  static remove = function(index = undefined, count = undefined)
  {
    return self.container.remove(index, count);
  }



  /**
   * @desc Retrieves the items's global position.
   * @returns {Real}
   */

  static position = function()
  {
    return DialogManager.__encode_level_position(self);
  }



  /**
   * @desc Parses the items of the container from a given array, using the dialog manager's deserializer method. Returns the parent object for chaining.
   * @param {Struct.DialogLinkable|Struct.DialogManager} items The objects to parse.
   * @param {Real} item_count The number of items to parse.
   * @param {Array} items The array of items to parse.
   */

  static __parse = function(items, item_count)
  {
    self.container.refresh(items, self, DialogManager.__get_deserializer(self.__LEVEL + 1), item_count);

    return self;
  }
}

#endregion
