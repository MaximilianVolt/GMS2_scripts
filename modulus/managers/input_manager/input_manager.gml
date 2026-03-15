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
  c_superdoublejump: function(argv) {
    return c_superjump.check(15, 25) && a_jump.pressed();
  },
});

/// O_PLAYER create event
player_input = O_INPUT.input_manager.input(self.player_index);
input = player_input.profile(INPUT.PROFILE_DEFAULT);

if (input.a_attack.held()) {
  // ...
}

state_on_ground = function()
{
  if (input.c_superjump.check([hp / mhp])) {

  }
}




// Description
input_manager = {
  profiles: [ /* Pure and stateless input template */ ],
  inputs: [
    /* InputContext: */ {
      profile: {
        action: input_action
      }
    },
  ],
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
 */












// ----------------------------------------------------------------------------












/**
 *
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
  DEVICE_STATUS_ANY_MASK = INPUT.__BITMASK_DEVICE_STATUS_MASK << INPUT.__BITMASK_DEVICE_STATUS_ANY_SHIFT,
  DEVICE_STATUS_MOUSE_MASK = INPUT.__BITMASK_DEVICE_STATUS_MASK << INPUT.__BITMASK_DEVICE_STATUS_MOUSE_SHIFT,
  DEVICE_STATUS_KEYBOARD_MASK = INPUT.__BITMASK_DEVICE_STATUS_MASK << INPUT.__BITMASK_DEVICE_STATUS_KEYBOARD_SHIFT,
  DEVICE_STATUS_GAMEPAD_MASK = INPUT.__BITMASK_DEVICE_STATUS_MASK << INPUT.__BITMASK_DEVICE_STATUS_GAMEPAD_SHIFT,
  DEVICE_STATUS_ALL_MASK = (1 << INPUT.DEVICE_COUNT * INPUT.__BITMASK_DEVICE_STATUS_FLAG_COUNT) - 1,
  DEVICE_STATUS_ALL_ACTIVE_MASK = INPUT.__BITMASK_DEVICE_STATUS_ALTERNATING_MASK << INPUT.__BITMASK_DEVICE_STATUS_FLAG_INDEX_ACTIVE,
  DEVICE_STATUS_ALL_REBINDING_MASK = INPUT.__BITMASK_DEVICE_STATUS_ALTERNATING_MASK << INPUT.__BITMASK_DEVICE_STATUS_FLAG_INDEX_REBINDING,
}



/**
 *
 */

enum INPUT_MANAGER
{
  ERR_UNDEFINED_ERROR_TYPE,
  ERR_UNDEFINED_DEVICE_TYPE,
  ERR_COUNT,
}



/**
 *
 */

enum INPUT_ACTION
{
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
   *
   */

  static ERROR = function(type, argv = [])
  {
    static messages = [
      "UNKNOWN ERROR TYPE: {0}",
      "UNKNOWN DEVICE TYPE: {0}",
    ];

    if (type < 0 || type >= INPUT_MANAGER.ERR_COUNT)
    {
      argv = [type];
      type = INPUT_MANAGER.ERR_UNDEFINED_ERROR_TYPE;
    }

    if (!is_array(argv))
      argv = [argv];

    return string_ext($"\n\n\n{messages[type]}\n\n", argv);
  }



  /**
   *
   */

  static generate = function(settings_mask = 0)
  {
    for (var i = 0; i < self.player_count; ++i) {
      self.player_inputs[i] = new InputContext(i, self.input_profiles, settings_mask);
    }

    return self;
  }



  /**
   *
   */

  static profile = function(profile_idx = 0, profile_data = undefined)
  {
    var idx = profile_idx + self.profile_count * (profile_idx < 0);

    if (profile_data) {
      self.input_profiles[idx] = variable_clone(profile_data);
    }

    return self.input_profiles[idx];
  }



  /**
   *
   */

  static input = function(input_idx = 0)
  {
    return player_inputs[input_idx + self.player_count * (input_idx < 0)];
  }



  /**
   *
   */

  static step = function(update_all = false)
  {
    if (update_all) {
      array_foreach(self.player_inputs, InputContext.update);
    }

    ++InputManager.GLOBAL_INPUT_FRAME;

    return self;
  }



  /**
   *
   */

  static save = function(prettify = false)
  {

  }



  /**
   *
   */

  static load = function(data_string)
  {

  }
}












// ----------------------------------------------------------------------------












/**
 *
 */

function InputContext(player_index, profiles, settings_mask) constructor
{
  self.player_index = player_index;
  self.settings_mask = settings_mask;
  self.input_type_frames = array_create(INPUT.ACTION_COUNT, InputManager.GLOBAL_INPUT_FRAME);
  self.buffer = array_create(INPUT.__INPUT_BUFFER_MAX_SIZE, 0);



  /**
   *
   */

  static step = function()
  {
    self.input_type_frames[self.profile_idx] = InputManager.GLOBAL_INPUT_FRAME;

    return self;
  }



  /**
   *
   */

  static setprofile = function(profile_idx)
  {
    self.profile_idx = profile_idx;

    return self;
  }



  /**
   *
   */

  static active = function(device = INPUT.DEVICE_ANY)
  {
    return __bitmask_flag_from_group(device, INPUT.__BITMASK_DEVICE_STATUS_FLAG_COUNT, INPUT.__BITMASK_DEVICE_STATUS_FLAG_INDEX_ACTIVE);
  }



  /**
   *
   */

  static rebinding = function(device = INPUT.DEVICE_ANY)
  {
    return __bitmask_flag_from_group(device, INPUT.__BITMASK_DEVICE_STATUS_FLAG_COUNT, INPUT.__BITMASK_DEVICE_STATUS_FLAG_INDEX_REBINDING);
  }



  /**
   *
   */

  static __bitmask_filter = function(mask)
  {
    return self.settings_mask & mask;
  }



  /**
   *
   */

  static __bitmask_flag = function(flag_idx)
  {
    return self.settings_mask >> flag_idx & 1;
  }



  /**
   *
   */

  static __bitmask_decode_group = function(group_idx, group_bits)
  {
    return self.settings_mask >> group_idx * group_bits & (1 << group_bits) - 1;
  }



  /**
   * 
   */

  static __bitmask_rewrite_region = function(value, shift, bits)
  {
    var mask = (1 << bits) - 1 << shift;
    return self.settings_mask & ~mask | value << shift & mask;
  }



  /**
   *
   */

  static __bitmask_flag_from_group = function(group_idx, group_bits, flag_idx)
  {
    return __bitmask_flag(__bitmask_decode_group(group_idx, group_bits), flag_idx);
  }



  /**
   *
   */

  static __resolve_profiles = function(profiles)
  {
    var profile_count = array_length(profiles)
      , resolved_profiles = array_create(profile_count, undefined)
    ;

    for (var i = 0; i < profile_count; ++i)
    {
      var profile = profiles[i]
        , keys = struct_get_names(profile)
        , key_count = array_length(keys)
      ;

      for (var j = 0; j < key_count; ++j)
      {
        var key = keys[j]
          , item = profile[$ key]
        ;

        profile[$ key] = __resolve_profile_item(item);
      }
    }

    return resolved_profiles;
  }



  /**
   *
   */

  static __resolve_profile_item = function(item)
  {
    if (is_callable(item) || is_numeric(item)) {
      return new InputActionCombo(self, item);
    }

    if (!is_instanceof(item, InputActionCombo)) {
      return new InputAction(self, item);
    }

    return item;
  }



  self.profiles = __resolve_profiles(profiles);
}












// ----------------------------------------------------------------------------












/**
 *
 */

function InputAction(context, binds) constructor
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
   * !:
   */

  static check = function(input_type, settings_mask = self.settings_mask)
  {
    var check_fn = InputAction.CHECK_FNS[input_type];

    for (var i = 0; i < self.bind_count; ++i)
    {
      var bind = self.binds[i]
        , bind_input_count = array_length(bind)
        , detected = true
      ;

      for (var k = 0; detected && k < bind_input_count; ++k) {
        detected &= check_fn(bind[k], self.context.player_index);
      }

      if (detected) {
        self.context.source = InputDevice.sourceof(bind[0]);
        self.last_input_frame = InputManager.GLOBAL_INPUT_FRAME;
        self.last_input_type_frames[input_type] = self.last_input_frame;
        return true;
      }
    }

    return false;
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
   *
   */

  static __input_in_range = function(frame, minval, maxval)
  {
    var val = InputManager.GLOBAL_INPUT_FRAME - frame;
    return val >= minval && val <= maxval;
  }



  self.context = context;
  self.binds = self.normalize(binds);
  self.bind_count = array_length(self.binds);
  self.settings_mask = INPUT.DEVICE_STATUS_ALL_ACTIVE_MASK;
  self.last_input_type_frames = array_create(INPUT.ACTION_COUNT, INPUT.ACTION_NONE);
  self.last_input_frame = INPUT.ACTION_NONE;
}












// ----------------------------------------------------------------------------












/**
 *
 */

function InputActionCombo(context, check_fn) constructor
{
  static COMBO_MAP = {
    combos: [],
    count: 0,
  };



  /**
   *
   */

  static check = function(check_fn = InputDevice.pressed)
  {
    var detected = self.step < self.action_count && check_fn(self.actions[step])
      , target_step = self.step + detected
    ;

    self.step = target_step * (self.time + detected > 0 && target_step < self.action_count);
    self.time = max(self.time - 1, self.time_max * detected);

    return detected && !self.step;
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



  self.check_fn_idx = self.register(check_fn);
  self.check_fn = method(context, variable_clone(InputActionCombo.COMBO_MAP[self.check_fn_idx]));
  self.context = context;
}












// ----------------------------------------------------------------------------












/**
 * 
 */

function InputRingBufferData(input, settings_mask)
{
  self.time = InputManager.GLOBAL_INPUT_FRAME;
  self.input = input;
  self.settings_mask = settings_mask;
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
