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

  c_superjump: input_action_combo_create(function(argv) {
      return argv[0] > .25 && a_crouch.held(30, 45) && a_jump.pressed(5);
      [
        [a_crouch, InputAction.held   , [30, 45]],
        [a_jump  , InputAction.pressed, [5]     ],
      ]
    }, 30 // Time to live (for repeated inputs)
  ),
  c_superdoublejump: input_action_combo_create(function(argv) {
    return c_superjump.check(15, 25) && a_jump.pressed();
  }),
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

input_action = Array(InputCombo)
input_combo = Array(InputChord)
input_chord = Array(InputKey)




/**
 * @desc A complete multi-profile chord/combo-aware input manager.
 * @version 0.5
 * 
 * TO-DO LIST:
 * +: Ensure correct struct members' conversion during initialization
 * +: Validate keys and chords' pressing inside specified time window
 * +: Validate InputActionCombo creation
 * +: Create methods to work with input device bitmasks
 * +: Add support for pressing more times inside time window
 * +: Save/load functionalities
 */



#macro __INPUT_MANAGER_MOUSE_NAME_1__    "mouse"
#macro __INPUT_MANAGER_KEYBOARD_NAME_1__ "keyboard"
#macro __INPUT_MANAGER_KEYBOARD_NAME_2__ "kb"
#macro __INPUT_MANAGER_GAMEPAD_NAME_1__  "gamepad"
#macro __INPUT_MANAGER_GAMEPAD_NAME_2__  "controller"












// ----------------------------------------------------------------------------












/**
 *
 */

enum INPUT
{
  // Input device types
  DEVICE_NONE = 0,
  DEVICE_MOUSE,
  DEVICE_KEYBOARD,
  DEVICE_GAMEPAD,
  DEVICE_COUNT,
  DEVICE_DEFAULT = INPUT.DEVICE_NONE,

  // Input profiles
  PROFILE_NONE = 0,
  PROFILE_MENU,
    // ...
  PROFILE_COUNT,
  PROFILE_DEFAULT = INPUT.PROFILE_NONE,

  // Input constants
  __MOUSE_MIN = 0x0000,
  __MOUSE_MAX = 0x0006,
  __KEYBOARD_MIN,
  __KEYBOARD_MAX = 0x03FF,
  __GAMEPAD_MIN,
  __GAMEPAD_MAX = 0xFFFF,

  // Bitmasks
  __BITMASK_DEVICE_STATUS_FLAG_INDEX_ACTIVE = 0,
  __BITMASK_DEVICE_STATUS_FLAG_INDEX_REBINDING,
  __BITMASK_DEVICE_STATUS_FLAG_COUNT,
  __BITMASK_DEVICE_STATUS_MASK = ((1 << INPUT.__BITMASK_DEVICE_STATUS_FLAG_COUNT) - 1),
  __BITMASK_DEVICE_STATUS_MOUSE_SHIFT = 0,
  __BITMASK_DEVICE_STATUS_KEYBOARD_SHIFT = INPUT.__BITMASK_DEVICE_STATUS_MOUSE_SHIFT + INPUT.__BITMASK_DEVICE_STATUS_FLAG_COUNT,
  __BITMASK_DEVICE_STATUS_GAMEPAD_SHIFT = INPUT.__BITMASK_DEVICE_STATUS_KEYBOARD_SHIFT + INPUT.__BITMASK_DEVICE_STATUS_FLAG_COUNT,
  DEVICE_STATUS_MOUSE_MASK = INPUT.__BITMASK_DEVICE_STATUS_MASK << INPUT.__BITMASK_DEVICE_STATUS_MOUSE_SHIFT,
  DEVICE_STATUS_KEYBOARD_MASK = INPUT.__BITMASK_DEVICE_STATUS_MASK << INPUT.__BITMASK_DEVICE_STATUS_KEYBOARD_SHIFT,
  DEVICE_STATUS_GAMEPAD_MASK = INPUT.__BITMASK_DEVICE_STATUS_MASK << INPUT.__BITMASK_DEVICE_STATUS_GAMEPAD_SHIFT,
  DEVICE_STATUS_ALL_MASK = INPUT.DEVICE_STATUS_MOUSE_MASK | INPUT.DEVICE_STATUS_KEYBOARD_MASK | INPUT.DEVICE_STATUS_GAMEPAD_MASK,
  DEVICE_STATUS_ALL_ACTIVE_MASK = (1 << INPUT.__BITMASK_DEVICE_STATUS_MOUSE_SHIFT + INPUT.__BITMASK_DEVICE_STATUS_FLAG_INDEX_ACTIVE) | (1 << INPUT.__BITMASK_DEVICE_STATUS_KEYBOARD_SHIFT + INPUT.__BITMASK_DEVICE_STATUS_FLAG_INDEX_ACTIVE) | (1 << INPUT.__BITMASK_DEVICE_STATUS_GAMEPAD_SHIFT + INPUT.__BITMASK_DEVICE_STATUS_FLAG_INDEX_ACTIVE),
  DEVICE_STATUS_ALL_REBINDING_MASK = INPUT.DEVICE_STATUS_ALL_ACTIVE_MASK << INPUT.__BITMASK_DEVICE_STATUS_FLAG_INDEX_REBINDING - INPUT.__BITMASK_DEVICE_STATUS_FLAG_INDEX_ACTIVE,
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
  // Input actions
  ACTION_NONE = -1,
  ACTION_HELD,
  ACTION_PRESSED,
  ACTION_RELEASED,
  ACTION_COUNT,

  // Bitmasks
  __BITMASK_ID_PLAYER_SHIFT = 0,
  __BITMASK_ID_PLAYER_BITS = 5,
  __BITMASK_ID_PLAYER_MASK = ((1 << INPUT_ACTION.__BITMASK_USER_BITS) - 1) << INPUT_ACTION.__BITMASK_USER_SHIFT,
  __BITMASK_ID_PROFILE_SHIFT = INPUT_ACTION.__BITMASK_ID_PLAYER_SHIFT + INPUT_ACTION.__BITMASK_ID_PLAYER_BITS,
  __BITMASK_ID_PROFILE_BITS = 5,
  __BITMASK_ID_PROFILE_MASK = ((1 << INPUT_ACTION.__BITMASK_ID_PROFILE_BITS) - 1) << INPUT_ACTION.__BITMASK_ID_PROFILE_SHIFT,
}












// ----------------------------------------------------------------------------












/**
 *
 * @param player_count
 */

function InputManager(player_count, profile_count) constructor
{
  static GLOBAL_INPUT_FRAME = 0;

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
      "UNKNOWN DEVICE NAME: {0}",
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

  static save = function(prettify = false)
  {

  }



  /**
   *
   */

  static load = function(data_string)
  {

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

  static input = function(input_idx = 0)
  {
    return player_inputs[input_idx + self.player_count * (input_idx < 0)];
  }



  /**
   *
   */

  static step = function()
  {
    ++InputManager.GLOBAL_INPUT_FRAME;

    array_foreach(self.player_inputs, function(input) {
      ++input.last_input_type_frames[input.profile_index];
    });

    return self;
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
  self.profiles = variable_clone(profiles);
  self.input_type_frames = array_create(INPUT.ACTION_COUNT, InputManager.GLOBAL_INPUT_FRAME);


}












// ----------------------------------------------------------------------------












/**
 *
 */

function InputAction(binds, context) constructor
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
        detected &= check_fn(bind[k], self.context);
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
   */

  static devices = function()
  {
    return self.context.devices;
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
  self.last_input_frame = noone;
  self.last_input_type_frames = array_create(INPUT.ACTION_COUNT, noone);
  self.settings_mask = INPUT.DEVICE_STATUS_ALL_MASK;

  // !:
  self.recording = false;
  self.time = InputAction.CHORD_TIME_WINDOW;
}












// ----------------------------------------------------------------------------












/**
 *
 */

function InputActionCombo(chords, time, context) constructor
{
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



  self.step = 0;
  self.time = time;
  self.time_max = time;
  self.context = context;
  self.actions = actions;
  self.action_count = array_length(actions);
}












// ----------------------------------------------------------------------------












/**
 *
 */

function InputDevice(device_index)
{
  static funcs = [
    [device_mouse_check_button         , function(index, key) { return keyboard_check(key);          }, gamepad_button_check         ],
    [device_mouse_check_button_pressed , function(index, key) { return keyboard_check_pressed(key);  }, gamepad_button_check_pressed ],
    [device_mouse_check_button_released, function(index, key) { return keyboard_check_released(key); }, gamepad_button_check_released],
  ];



  /**
   *
   */

  static sourceof = function(key)
  {
    return (key <= INPUT.__GAMEPAD_MAX) * (
      (key >= INPUT.__MOUSE_MIN) + (key >= INPUT.__KEYBOARD_MIN) + (key >= INPUT.__GAMEPAD_MIN)
    );
  }



  /**
   *
   */

  function check(action, key, index)
  {
    return InputDevice.funcs[action][InputDevice.sourceof(key)](index, key);
  }



  /**
   *
   */

  function held(key, index)
  {
    return InputDevice.check(INPUT.ACTION_HELD, key, index);
  }



  /**
   *
   */

  function pressed(key, index)
  {
    return InputDevice.check(INPUT.ACTION_PRESSED, key, index);
  }



  /**
   *
   */

  function released(key, index)
  {
    return InputDevice.check(INPUT.ACTION_RELEASED, key, index);
  }
}
