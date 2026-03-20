/**
 * !: USE BITMASKS TO DETERMINE WHETHER AN INPUT SHOULD BE "LISTENED TO" OR NOT
 * #: EG: { GAMEPAD | KEYBOARD | MOUSE }   <=>   (detected & settings_mask >> InputDevice.sourceof(input)) == STATE_ACTIVE
 */

/// O_INPUT create event
input_manager = input_manager_create(4, 3);

input_manager.profile(0, {
  a_attack: [ [[vk_shift, ord("A")]]  , [[gp_shoulderl, gp_padl]]   ], // 2 combos of 1 chord of 2 buttons
  a_defend: [ [[vk_shift], [ord("A")]], [[gp_shoulderl], [gp_padl]] ], // 2 combos of 2 chords of 1 button
  a_crouch: [ [[vk_shift], [ord("A")]], [[gp_shoulderl], [gp_padl]] ], // 2 combos of 2 chords of 1 button
  a_jump:   [ [[vk_space]]            , [[gp_a]]                    ],

  c_superjump: function(argv) {
    return argv[0] > .25 && a_crouch.held(30, 45) && a_jump.pressedtimes(5, 30 /* TTL*/);
  },
  c_superdoublejump: function() {
    return c_superjump.check(15, 25) && a_jump.pressed();
  },
});

/// O_PLAYER create event
input_context = O_INPUT.input_manager.input(self.player_index);
input = input_context.profile(INPUT.PROFILE_DEFAULT);

if (input.a_attack.held()) {
  // ...
}

fsm.state_on_ground = function()
{
  if (input.c_superjump.check([hp / mhp])) {
    return fsm.transition(fsm.state_jump);
  }

  return fsm.state_current;
}

















































/**
 * @desc A complete multi-profile chord/combo-aware input manager.
 * @version 0.5
 *
 * TO-DO LIST:
 * +: Make the input context save also the device index in the settings mask
 * +: Add player_mask to input context to save both player index and profile index
 *
 * +: Validate keys and chords' pressing inside specified time window
 * +: Add support for pressing more times inside time window
 * +: Save/load functionalities
 *
 * #: InputAction.held(min = 1, max)
 * #: InputAction.pressed(max, min = 0)
 * #: InputAction.released(max, min = 0)
 * #: InputAction.pressedtimes(n, max, min = 0)
 * #: InputAction.releasedtimes(n, max, min = 0)
 * +: InputAction.heldfortimes(n, duration, max, min = 0) (count the released - pressed differences >= duration inside the ttl)
 * +: InputAction.pressedaftertimes(n, pause, max, min = 0) (count all the press differences >= pause inside the ttl)
 * +: InputAction.releasedaftertimes(n, pause, max, min = 0) (count all the release differences >= pause inside the ttl)
 */












// ----------------------------------------------------------------------------












/**
 * @desc Input-related constants.
 * @desc `DEVICE_*` constants represent input device types and are used to determine the source of an input and to specify device filters for input contexts.
 * @desc `DEVICE_STATUS_*` constants represent device status flags and are used to track the active and rebinding states of input devices in input contexts.
 * @desc `PROFILE_*` constants represent input profiles and are used to specify profile filters for input contexts.
 * @desc `ACTION_*` constants represent input action types and are used to specify the type of input action to check for in input performables.
 * @desc `ERR_*` constants represent error types and are used to specify the type of error when generating error messages in the input manager.
 * @desc `__BITMASK_*` constants are used for bitmask operations in input contexts and performables and should not be edited.
 */

enum INPUT
{
  // Input device types
  DEVICE_ANY = 0,
  DEVICE_MOUSE,
  DEVICE_KEYBOARD,
  DEVICE_GAMEPAD,
  DEVICE_COUNT,
  DEVICE_DEFAULT = INPUT.DEVICE_ANY,

  // Input profiles
  PROFILE_NONE = 0,
  PROFILE_MENU,
    // ...
  PROFILE_COUNT,
  PROFILE_DEFAULT = INPUT.PROFILE_NONE,

  // Input actions
  ACTION_NONE = -1,
  ACTION_HELD,
  ACTION_PRESSED,
  ACTION_RELEASED,
  ACTION_PERFORMED,
  ACTION_COUNT,

  // Management constants
  __KEY_MIN_MOUSE = 0x0000,
  __KEY_MAX_MOUSE = 0x0006,
  __KEY_MIN_KEYBOARD,
  __KEY_MAX_KEYBOARD = 0x03FF,
  __KEY_MIN_GAMEPAD,
  __KEY_MAX_GAMEPAD = 0xFFFF,
  __INPUT_BUFFER_MAX_SIZE = 64,

  // Bitmasks
  __BITMASK_BUFFER_ACTION_TYPE_SHIFT = 0,
  __BITMASK_BUFFER_ACTION_TYPE_BITS = 2,
  __BITMASK_BUFFER_ACTION_TYPE_MASK = (1 << INPUT.__BITMASK_BUFFER_ACTION_TYPE_BITS) - 1 << INPUT.__BITMASK_BUFFER_ACTION_TYPE_SHIFT,
  __BITMASK_BUFFER_DEVICE_SHIFT = INPUT.__BITMASK_BUFFER_ACTION_TYPE_SHIFT + INPUT.__BITMASK_BUFFER_ACTION_TYPE_BITS,
  __BITMASK_BUFFER_DEVICE_BITS = 6,
  __BITMASK_BUFFER_DEVICE_MASK = (1 << INPUT.__BITMASK_BUFFER_DEVICE_BITS) - 1 << INPUT.__BITMASK_BUFFER_DEVICE_SHIFT,
  __BITMASK_BUFFER_PROFILE_SHIFT = INPUT.__BITMASK_BUFFER_DEVICE_SHIFT + INPUT.__BITMASK_BUFFER_DEVICE_BITS,
  __BITMASK_BUFFER_PROFILE_BITS = 4,
  __BITMASK_BUFFER_PROFILE_MASK = (1 << INPUT.__BITMASK_BUFFER_PROFILE_BITS) - 1 << INPUT.__BITMASK_BUFFER_PROFILE_SHIFT,
  __BITMASK_DEVICE_STATUS_FLAG_INDEX_ACTIVE = 0,
  __BITMASK_DEVICE_STATUS_FLAG_INDEX_REBINDING,
  __BITMASK_DEVICE_STATUS_FLAG_COUNT,
  __BITMASK_DEVICE_STATUS_MASK = (1 << INPUT.__BITMASK_DEVICE_STATUS_FLAG_COUNT) - 1,
  __BITMASK_DEVICE_STATUS_ANY_SHIFT = 0,
  __BITMASK_DEVICE_STATUS_MOUSE_SHIFT = INPUT.__BITMASK_DEVICE_STATUS_FLAG_COUNT,
  __BITMASK_DEVICE_STATUS_KEYBOARD_SHIFT = INPUT.__BITMASK_DEVICE_STATUS_MOUSE_SHIFT + INPUT.__BITMASK_DEVICE_STATUS_FLAG_COUNT,
  __BITMASK_DEVICE_STATUS_GAMEPAD_SHIFT = INPUT.__BITMASK_DEVICE_STATUS_KEYBOARD_SHIFT + INPUT.__BITMASK_DEVICE_STATUS_FLAG_COUNT,
  __BITMASK_DEVICE_STATUS_ALTERNATING_MASK = ((1 << INPUT.__BITMASK_DEVICE_STATUS_FLAG_COUNT * INPUT.DEVICE_COUNT) - 1) / ((1 << INPUT.__BITMASK_DEVICE_STATUS_FLAG_COUNT) - 1),
  __BITMASK_INPUT_MASK_CHORD_SHIFT = 0,
  __BITMASK_INPUT_MASK_CHORD_BITS = 4,
  __BITMASK_INPUT_MASK_CHORD_MASK = (1 << INPUT.__BITMASK_INPUT_MASK_CHORD_BITS) - 1 << INPUT.__BITMASK_INPUT_MASK_CHORD_SHIFT,
  __BITMASK_INPUT_MASK_SEQUENCE_SHIFT = INPUT.__BITMASK_INPUT_MASK_CHORD_SHIFT + INPUT.__BITMASK_INPUT_MASK_CHORD_BITS,
  __BITMASK_INPUT_MASK_SEQUENCE_BITS = 4,
  __BITMASK_INPUT_MASK_SEQUENCE_MASK = (1 << INPUT.__BITMASK_INPUT_MASK_SEQUENCE_BITS) - 1 << INPUT.__BITMASK_INPUT_MASK_SEQUENCE_SHIFT,
  DEVICE_STATUS_ANY_MASK = INPUT.__BITMASK_DEVICE_STATUS_MASK << INPUT.__BITMASK_DEVICE_STATUS_ANY_SHIFT,
  DEVICE_STATUS_MOUSE_MASK = INPUT.__BITMASK_DEVICE_STATUS_MASK << INPUT.__BITMASK_DEVICE_STATUS_MOUSE_SHIFT,
  DEVICE_STATUS_KEYBOARD_MASK = INPUT.__BITMASK_DEVICE_STATUS_MASK << INPUT.__BITMASK_DEVICE_STATUS_KEYBOARD_SHIFT,
  DEVICE_STATUS_GAMEPAD_MASK = INPUT.__BITMASK_DEVICE_STATUS_MASK << INPUT.__BITMASK_DEVICE_STATUS_GAMEPAD_SHIFT,
  DEVICE_STATUS_ALL_MASK = (1 << INPUT.DEVICE_COUNT * INPUT.__BITMASK_DEVICE_STATUS_FLAG_COUNT) - 1,
  DEVICE_STATUS_ALL_ACTIVE_MASK = INPUT.__BITMASK_DEVICE_STATUS_ALTERNATING_MASK << INPUT.__BITMASK_DEVICE_STATUS_FLAG_INDEX_ACTIVE,
  DEVICE_STATUS_ALL_REBINDING_MASK = INPUT.__BITMASK_DEVICE_STATUS_ALTERNATING_MASK << INPUT.__BITMASK_DEVICE_STATUS_FLAG_INDEX_REBINDING,

  // Error types
  ERR_UNDEFINED_ERROR_TYPE,
  ERR_UNDEFINED_DEVICE_TYPE,
  ERR_UNSPECIFIED_INPUT,
  ERR_COUNT,
}












// ----------------------------------------------------------------------------












/**
 *
 * @param player_count
 */

function InputManager(player_count, profile_count) constructor
{
  static GLOBAL_INPUT_FRAME = INPUT.ACTION_NONE;

  self.player_inputs = array_create(player_count);
  self.input_profiles = array_create(profile_count);
  self.player_count = player_count;
  self.profile_count = profile_count;



  /**
   * @desc Returns a formatted error message for a given error type and arguments.
   * @param {Constant.INPUT} type The error type to get the message for.
   * @param {Array|Real|String} [argv] The arguments to format the message with. Can be a single value or an array of values.
   * @returns {String} The formatted error message.
   */

  static ERROR = function(type, argv = [])
  {
    static messages = [
      "UNKNOWN ERROR TYPE: {0}",
      "UNKNOWN DEVICE TYPE: {0}",
    ];

    if (type < 0 || type >= INPUT.ERR_COUNT)
    {
      argv = [type];
      type = INPUT.ERR_UNDEFINED_ERROR_TYPE;
    }

    if (!is_array(argv))
      argv = [argv];

    return string_ext($"\n\n\n{messages[type]}\n\n", argv);
  }



  /**
   * @desc Generates the input contexts for each player.
   * @param {Real} [settings_mask] The mask for the input settings. Defaults to `0`.
   * @returns {Struct.InputManager} The input manager instance with the generated input contexts.
   */

  static generate = function(settings_mask = 0)
  {
    for (var i = 0; i < self.player_count; ++i)
      self.player_inputs[i] = new InputContext(i, self.input_profiles, settings_mask);

    return self;
  }



  /**
   * @desc Creates a new input profile with the given data and index.
   * @param {Struct} profile_data The data for the input profile, containing the input action definitions.
   * @param {Real} [profile_idx] The index of the input profile to create. Defaults to `0`. If negative, it will be counted from the end of the input profiles array.
   * @returns {Struct.InputManager} The input manager instance with the new profile added.
   */

  static createprofile = function(profile_data, profile_idx = 0)
  {
    var idx = profile_idx + self.profile_count * (profile_idx < 0);

    if (profile_data)
      self.input_profiles[idx] = variable_clone(profile_data);

    return self;
  }



  /**
   * @desc Returns the input profile for a specific index.
   * @param {Real} [profile_idx] The index of the input profile to retrieve. Defaults to `0`. If negative, it will be counted from the end of the input profiles array.
   * @returns {Struct} The input profile for the specified index.
   */

  static profile = function(profile_idx = 0)
  {
    return self.input_profiles[profile_idx + self.profile_count * (profile_idx < 0)];
  }



  /**
   *
   */

  static alterprofile = function(player_idx = 0, profile_idx = 0, profile_data = undefined)
  {
    if (profile_data)
      self.input(player_idx).profiles[profile_idx] = InputContext.__resolve_profile(profile_data);

    return self;
  }



  /**
   * @desc Returns the input context for a specific player index.
   * @param {Real} [input_idx] The index of the player input to retrieve. Defaults to `0`. If negative, it will be counted from the end of the player inputs array.
   * @returns {Struct.InputContext} The input context for the specified player index.
   */

  static input = function(input_idx = 0)
  {
    return player_inputs[input_idx + self.player_count * (input_idx < 0)];
  }



  /**
   * @desc Updates the input manager state for the current frame.
   * @param {Bool} [update_all] Whether to update all player inputs or only the actively checked ones. Defaults to `false`.
   * @returns {Real} The global input manager frame.
   */

  static step = function(update_all = false)
  {
    if (update_all)
      for (var i = 0; i < self.player_count; ++i)
        self.player_inputs[i].step();

    return ++InputManager.GLOBAL_INPUT_FRAME;
  }



  /**
   * @desc Saves the current input manager state to a string.
   * @param {Bool} [prettify] Whether to format the output string. Defaults to `false`.
   * @returns {String} The saved input manager state as a string.
   */

  static save = function(prettify = false)
  {

  }



  /**
   * @desc Loads the input manager state from a string.
   * @param {String} data_string The string to load the input manager state from.
   * @returns {InputManager} The input manager instance with the loaded state.
   */

  static load = function(data_string)
  {

  }
}












// ----------------------------------------------------------------------------












/**
 * 
 */

function InputBitmaskable(settings_mask) constructor
{
  self.settings_mask = settings_mask;



  /**
   * @desc Checks whether the input context's settings mask matches a specific bitmask filter.
   * @param {Real} mask The bitmask filter to check against the input context's settings mask.
   * @param {Real} [settings_mask] The settings mask to apply the filter to. Defaults to the input context's current settings mask.
   * @returns {Real} the filtered mask.
   */

  static __bitmask_filter = function(mask, settings_mask = self.settings_mask)
  {
    return settings_mask & mask;
  }



  /**
   * @desc Checks whether a specific flag is set in the input context's settings mask.
   * @param {Real} flag_idx The index of the flag to check in the settings mask.
   * @param {Real} [settings_mask] The settings mask to check the flag in. Defaults to the input context's current settings mask.
   * @returns {Real} `1` if the specified flag is set in the settings mask, `0` otherwise.
   */

  static __bitmask_flag = function(flag_idx, settings_mask = self.settings_mask)
  {
    return settings_mask >> flag_idx & 1;
  }



  /**
   * @desc Decodes a group of bits from the input context's settings mask based on a specified group index and group size.
   * @param {Real} group_idx The index of the group to decode in the settings mask.
   * @param {Real} group_bits The number of bits in the group to decode.
   * @param {Real} [settings_mask] The settings mask to decode the group from. Defaults to the input context's current settings mask.
   * @returns {Real} The decoded value of the specified group of bits from the settings mask.
   */

  static __bitmask_decode_group = function(group_idx, group_bits, settings_mask = self.settings_mask)
  {
    return settings_mask >> group_idx * group_bits & (1 << group_bits) - 1;
  }



  /**
   * @desc Rewrites a group of bits in the input context's settings mask with a new value based on a specified group index and group size.
   * @param {Real} value The new value to write into the specified group of bits in the settings mask.
   * @param {Real} group_idx The index of the group to rewrite in the settings mask.
   * @param {Real} group_bits The number of bits in the group to rewrite.
   * @param {Real} [settings_mask] The settings mask to rewrite the group in. Defaults to the input context's current settings mask.
   * @return {Real} The updated settings mask with the specified group of bits rewritten with the new value.
   */

  static __bitmask_rewrite_region = function(value, shift, bits, settings_mask = self.settings_mask)
  {
    var mask = (1 << bits) - 1 << shift;
    return settings_mask & ~mask | value << shift & mask;
  }



  /**
   * @desc Checks whether a specific flag is set in a specific group of bits in the input context's settings mask.
   * @param {Real} group_idx The index of the group to check in the settings mask.
   * @param {Real} group_bits The number of bits in the group to check.
   * @param {Real} flag_idx The index of the flag to check within the specified group of bits.
   * @param {Real} [settings_mask] The settings mask to check the flag in. Defaults to the input context's current settings mask.
   * @returns {Real} `1` if the specified flag is set in the specified group of bits in the settings mask, `0` otherwise.
   */

  static __bitmask_flag_from_group = function(group_idx, group_bits, flag_idx, settings_mask = self.settings_mask)
  {
    return (settings_mask >> group_idx * group_bits & (1 << group_bits) - 1) >> flag_idx & 1;
  }
}












// ----------------------------------------------------------------------------












/**
 *
 */

function InputContext(player_index, profiles, settings_mask) : InputBitmaskable(settings_mask) constructor
{
  self.player_index = player_index;
  self.profile_idx = INPUT.PROFILE_DEFAULT;
  self.settings_mask = settings_mask;
  self.input_type_frames = array_create(INPUT.ACTION_COUNT, InputManager.GLOBAL_INPUT_FRAME);
  self.buffer = array_create(INPUT.__INPUT_BUFFER_MAX_SIZE, 0);
  self.buffer_index = 0;



  /**
   * @desc Updates the input context for the current frame.
   * @returns {Struct.InputContext} The input context instance with the updated state.
   */

  static step = function()
  {
    self.input_type_frames[self.profile_idx] = InputManager.GLOBAL_INPUT_FRAME;

    return self;
  }



  /**
   *
   */

  static profile = function(profile_idx)
  {
    return self.profiles[profile_idx + InputManager.profile_count * (profile_idx < 0)];
  }



  /**
   * @desc Sets the active input profile for this context.
   * @param {Real} [profile_idx] The index of the input profile to set as active.
   * @returns {Struct.InputContext} The input context instance with the updated active profile.
   */

  static setprofile = function(profile_idx)
  {
    self.profile_idx = profile_idx;

    return self;
  }



  /**
   * @desc Checks whether the input context is actively listening to inputs from a specific device.
   * @param {Constant.INPUT} [device] The device type to check for. Defaults to `INPUT.DEVICE_ANY`.
   * @returns {Real} `1` if the input context is actively listening to inputs from the specified device, `0` otherwise.
   */

  static active = function(device = INPUT.DEVICE_ANY)
  {
    return __bitmask_flag_from_group(device, INPUT.__BITMASK_DEVICE_STATUS_FLAG_COUNT, INPUT.__BITMASK_DEVICE_STATUS_FLAG_INDEX_ACTIVE);
  }



  /**
   * @desc Checks whether the input context is currently in rebinding mode for a specific device.
   * @param {Constant.INPUT} [device] The device type to check for. Defaults to `INPUT.DEVICE_ANY`.
   * @returns {Real} `1` if the input context is currently in rebinding mode for the specified device, `0` otherwise.
   */

  static rebinding = function(device = INPUT.DEVICE_ANY)
  {
    return __bitmask_flag_from_group(device, INPUT.__BITMASK_DEVICE_STATUS_FLAG_COUNT, INPUT.__BITMASK_DEVICE_STATUS_FLAG_INDEX_REBINDING);
  }



  /**
   * @desc Resolves the input action definitions in the input profiles into actual `InputPerformable` instances.
   * @param {Array} profiles The array of input profiles to resolve.
   * @return {Array} The array of resolved input profiles with `InputPerformable` instances.
   */

  static __resolve_profiles = function(profiles)
  {
    return array_map(profiles, __resolve_profile);
  }



  /**
   *
   */

  static __resolve_profile = function(profile)
  {
    var keys = struct_get_names(profile)
      , key_count = array_length(keys)
    ;

    for (var i = 0; i < key_count; ++i)
    {
      var key = keys[i]
        , item = profile[$ key]
      ;

      profile[$ key] = InputPerformable.resolve(item);
    }

    return profile;
  }



  self.profiles = __resolve_profiles(profiles);
}












// ----------------------------------------------------------------------------












/**
 *
 */

function InputPerformable(context, settings_mask) : InputBitmaskable(settings_mask) constructor
{
  self.context = context;
  self.settings_mask = settings_mask;
  self.last_input_type = INPUT.ACTION_NONE;
  self.last_input_type_frames = array_create(INPUT.ACTION_COUNT, INPUT.ACTION_NONE);



  /**
   * @desc Resolves an input action definition into an actual `InputPerformable` instance.
   * @param {Array|Real|Function|Struct.InputPerformable} item The input action definition to resolve. Can be a button combination, a function for combo checking, or an already resolved `InputPerformable` instance.
   * @return {Struct.InputPerformable} The resolved `InputPerformable` instance corresponding to the given input action definition.
   */

  static resolve = function(item)
  {
    if (is_callable(item) || is_numeric(item)) {
      return new InputActionCombo(self.context, item);
    }

    if (!is_instanceof(item, InputActionCombo)) {
      return new InputAction(self.context, item);
    }

    return item;
  }



  /**
   *
   */

  static check = function(input_type, settings_mask = self.settings_mask)
  {
    return false;
  }



  /**
   *
   */

  static buffermask = function(action_type, profile_idx = self.context.profile_idx, device = INPUT.DEVICE_ANY)
  {
    return action_type << INPUT.__BITMASK_BUFFER_ACTION_TYPE_SHIFT
      | profile_idx << INPUT.__BITMASK_BUFFER_PROFILE_SHIFT
      | device << INPUT.__BITMASK_BUFFER_DEVICE_SHIFT
    ;
  }



  /**
   *
   */

  static bufferize = function(input_type, settings_mask = self.settings_mask)
  {

  }



  /**
   * 
   */

  static buffercountquery = function(check_fn = function(entry) { return false; }, min_frames, max_frames)
  {
    var count = 0
      , context = self.context
      , buffer = context.buffer
      , idx = context.buffer_index
      , time = InputManager.GLOBAL_INPUT_FRAME
    ;

    while (time - buffer[idx].time < min_frames)
      idx += INPUT.__INPUT_BUFFER_MAX_SIZE * (idx == 0) - 1;

    for (; time - buffer[idx].time <= max_frames; idx += INPUT.__INPUT_BUFFER_MAX_SIZE * (idx == 0) - 1)
      count += check_fn(buffer[i]);

    return count;
  }



  /**
   *
   * @param min_frames
   * @param max_frames
   * @returns
   */

  function held(min_frames = 0, max_frames = +infinity)
  {
    return __validate(INPUT.ACTION_HELD, min_frames, max_frames);
  }



  /**
   *
   */

  function pressed(max_frames = 1, min_frames = 0)
  {
    return __validate(INPUT.ACTION_PRESSED, min_frames, max_frames);
  }



  /**
   *
   */

  function released(max_frames = 1, min_frames = 0)
  {
    return __validate(INPUT.ACTION_RELEASED, min_frames, max_frames);
  }



  /**
   *
   */

  static __validate = function(input_type, min_frames, max_frames)
  {
    return __input_in_range(self.last_input_type_frames[input_type], min_frames, max_frames)
      && self.check(input_type)
    ;
  }



  /**
   * @desc Checks whether the last input of a given type was performed within a specified time window.
   * @param {Real} frame The frame of the last input to check.
   * @param {Real} minval The minimum number of frames that should have passed since the last input.
   * @param {Real} maxval The maximum number of frames that should have passed since
   */

  static __input_in_range = function(frame, minval, maxval)
  {
    var val = InputManager.GLOBAL_INPUT_FRAME - frame;
    return val >= minval && val <= maxval;
  }
}












// ----------------------------------------------------------------------------












/**
 *
 */

function InputAction(context, binds) : InputPerformable(context) constructor
{
  static CHECK_FNS = [ InputDevice.held, InputDevice.pressed, InputDevice.released ];
  static TIME_WINDOW_FRAMES_SEQUENCE = 15;
  static TIME_WINDOW_FRAMES_CHORD = 5;



  /**
   * !:
   */

  static normalize = function(binds)
  {
    var ret = []
      , temp = binds
      , dim_max = 3
      , dim = 0
    ;

    for (; is_array(temp); ++dim)
      temp = temp[0];

    if (dim == dim_max)
      return binds;

    for (var i = array_length(binds) - 1; i >= 0; --i)
    {
      ret[i] = binds[i];

      for (var d = 0; d < dim_max - dim; ++d) {
        ret[i] = [ret[i]];
      }
    }

    return ret;
  }



  /**
   *
   */

  static sequence = function(idx)
  {
    return self.binds[idx + self.bind_count * (idx < 0)];
  }



  /**
   *
   */

  static chord = function(idx, sequence = undefined)
  {
    if (sequence)
      return sequence[idx];

    for (var i = 0; i < self.bind_count; ++i)
    {
      var sequence_chord_count = array_length(self.binds[i]);

      if (idx < sequence_chord_count) {
        return self.binds[i][idx];
      }

      idx -= sequence_chord_count;
    }

    return undefined;
  }



  /**
   * !:
   */

  static check = function(input_type = INPUT.ACTION_HELD)
  {
    var detected = false;

    for (var i = 0; i < self.bind_count && !detected; ++i)
      detected |= __check_sequence(self.sequence(i), input_type);

    if (detected) {
      self.context.source = InputDevice.sourceof(sequence[0]);
      self.last_input_frame = InputManager.GLOBAL_INPUT_FRAME;
      self.last_input_type_frames[input_type] = self.last_input_frame;
    }

    return detected;
  }



  /**
   *
   */

  static __check_sequence = function(sequence, input_type)
  {

  }



  /**
   *
   */

  static __check_chord = function(chord, input_type)
  {

  }



  self.binds = self.normalize(binds);
  self.bind_count = array_length(self.binds);
  self.last_keystroke_info = 0;
}












// ----------------------------------------------------------------------------












/**
 *
 */

function InputActionCombo(context, check_fn) : InputPerformable(context) constructor
{
  static COMBO_MAP = {
    combos: [],
    count: 0,
  };



  /**
   *
   */

  static check = function(argv = [])
  {
    return self.check_fn(is_array(argv) ? argv : [argv]);
  }



  /**
   *
   */

  static register = function(func, index = InputActionCombo.COMBO_MAP.count)
  {
    var map = InputActionCombo.COMBO_MAP;

    map.funcs[index] = func;
    ++map.count;

    return index;
  }



  self.check_fn_idx = is_callable(check_fn) ? self.register(check_fn) : check_fn;
  self.check_fn = method(context, variable_clone(InputActionCombo.COMBO_MAP[self.check_fn_idx]));
}












// ----------------------------------------------------------------------------












/**
 *
 */

function InputRingBufferData(input, settings_mask)
{
  self.time = InputManager.GLOBAL_INPUT_FRAME;
  self.settings_mask = settings_mask;
  self.input = input;
}












// ----------------------------------------------------------------------------












/**
 * @desc Device input management class.
 */

function InputDevice() constructor
{
  static funcs = [
    [device_mouse_check_button         , function(index, key) { return keyboard_check(key);          }, gamepad_button_check         ],
    [device_mouse_check_button_pressed , function(index, key) { return keyboard_check_pressed(key);  }, gamepad_button_check_pressed ],
    [device_mouse_check_button_released, function(index, key) { return keyboard_check_released(key); }, gamepad_button_check_released],
  ];



  /**
   * @desc Identifies the type of input of a given key.
   * @param {Constant.VirtualKey|Real} key The key to get the source from.
   * @returns {Constant.INPUT}
   */

  static sourceof = function(key)
  {
    return (key <= INPUT.__KEY_MAX_GAMEPAD) * (
      (key >= INPUT.__KEY_MIN_MOUSE) + (key >= INPUT.__KEY_MIN_KEYBOARD) + (key >= INPUT.__KEY_MIN_GAMEPAD)
    );
  }



  /**
   * @desc Checks whether a key is currently performing a specified action on a given device.
   * @param {Constant.INPUT} action The action type.
   * @param {Constant.VirtualKey|Real} key The key to check.
   * @param {Real} [index] The index of the device. Defaults to `0`.
   * @returns {Bool}
   */

  static check = function(action, key, index = 0)
  {
    return InputDevice.funcs[action][InputDevice.sourceof(key)](index, key);
  }



  /**
   * @desc Checks whether a key is currently held on a given device.
   * @param {Constant.VirtualKey|Real} key The key to check.
   * @param {Real} [index] The index of the device. Defaults to `0`.
   * @returns {Bool}
   */

  static held = function(key, index = 0)
  {
    return InputDevice.check(INPUT.ACTION_HELD, key, index);
  }



  /**
   * @desc Checks whether a key is currently pressed on a given device.
   * @param {Constant.VirtualKey|Real} key The key to check.
   * @param {Real} [index] The index of the device. Defaults to `0`.
   * @returns {Bool}
   */

  static pressed = function(key, index = 0)
  {
    return InputDevice.check(INPUT.ACTION_PRESSED, key, index);
  }



  /**
   * @desc Checks whether a key is currently released on a given device.
   * @param {Constant.VirtualKey|Real} key The key to check.
   * @param {Real} [index] The index of the device. Defaults to `0`.
   * @returns {Bool}
   */

  static released = function(key, index = 0)
  {
    return InputDevice.check(INPUT.ACTION_RELEASED, key, index);
  }
}
