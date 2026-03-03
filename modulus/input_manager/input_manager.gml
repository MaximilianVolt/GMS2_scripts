/// O_INPUT create event
input_manager = input_manager_create(4, 3);

input_manager.profile(0, {
  attack: [ [[vk_shift, ord("A")]]  , [[gp_shoulderl, gp_padl]]   ], // 2 combos of 1 chord of 2 buttons
  defend: [ [[vk_shift], [ord("A")]], [[gp_shoulderl], [gp_padl]] ], // 2 combos of 2 chords of 1 button
});

/// O_PLAYER create event
player_input = O_INPUT.input_manager.input(self.player_index);
input = player_input.profile(INPUT.PROFILE_DEFAULT);

if (input.attack.held()) {
  // ...
}





/**
 * @desc A complete multi-profile chord/combo-aware input manager.
 * @version 0.5
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

  // Input actions
  ACTION_HELD = 0,
  ACTION_PRESSED,
  ACTION_RELEASED,

  // Input constants
  __MOUSE_MIN = 0x0000,
  __MOUSE_MAX = 0x0006,
  __KEYBOARD_MIN,
  __KEYBOARD_MAX = 0x03FF,
  __GAMEPAD_MIN,
  __GAMEPAD_MAX = 0xFFFF,
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












// ----------------------------------------------------------------------------












/**
 *
 * @param player_count
 */

function InputManager(player_count, profile_count) constructor
{
  self.player_inputs = array_create(player_count);
  self.input_profiles = array_create(profile_count);
  self.player_count = player_count;
  self.profile_count = profile_count;
  self.input_frame = 0;



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
   * !:
   */

  static profile = function(profile_idx = 0, profile_data = undefined)
  {
    if (profile_data)
    {
      var keys = struct_get_names(profile_data)
        , device = undefined
      ;

      for (var i = array_length(keys) - 1; i >= 0; --i)
      {
        var key = keys[i];

        switch (key)
        {
          case __INPUT_MANAGER_MOUSE_NAME_1__:
            device = InputDeviceMouse;
          break;

          case __INPUT_MANAGER_KEYBOARD_NAME_1__:
          case __INPUT_MANAGER_KEYBOARD_NAME_2__:
            device = InputDeviceKeyboard;
          break;

          case __INPUT_MANAGER_GAMEPAD_NAME_1__:
          case __INPUT_MANAGER_GAMEPAD_NAME_2__:
            device = InputDeviceGamepad;
          break;

          default:
            throw InputManager.ERROR(INPUT_MANAGER.ERR_UNDEFINED_DEVICE_TYPE, [key]);
        }

        profile_data[$ key] = new device(profile_data[$ key]);
      }

      self.input_profiles[profile_idx] = profile_data;
    }

    return self.input_profiles[profile_idx];
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

  }
}












// ----------------------------------------------------------------------------












/**
 *
 */

function InputContext(player_index, source = INPUT.DEVICE_DEFAULT, gamepad = noone, mouse = noone) constructor
{
  self.source = source;
  self.player_index = player_index;
  self.gamepad = gamepad;
  self.mouse = mouse;
  self.profile = undefined;
  self.device = undefined;



}












// ----------------------------------------------------------------------------












/**
 *
 */

function InputAction(binds, context) constructor
{
  static CHORD_TIME_WINDOW = 5;



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

  static check = function(check_fn)
  {
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
        return true;
      }
    }

    return false;
  }



  static devices = function()
  {
    return self.context.devices;
  }



  function held(action = self)
  {
    return array_any(action.devices(), function(d) {
      return d && d.held(k);
    });
  }



  /**
   *
   */

  function pressed(action = self)
  {
    return array_any(action.devices(), function(d) {
      return d && d.pressed(k);
    });
  }



  /**
   *
   */

  function released(action = self)
  {
    return array_any(action.devices(), function(d) {
      return d && d.released(k);
    });
  }



  self.context = context;
  self.binds = self.normalize(binds);
  self.bind_count = array_length(self.binds);
  self.recording = false;
  self.time = InputAction.CHORD_TIME_WINDOW;
}












// ----------------------------------------------------------------------------












/**
 *
 */

function InputCombo(chords, time, context) constructor
{
  /**
   *
   */

  static check = function(check_fn = InputAction.pressed)
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



  self.device_index = device_index;



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





function InputDeviceMouse(device_index) : InputDevice(device_index) constructor
{
  /**
   * 
   */

  static sourceof = function()
  {
    return INPUT.DEVICE_MOUSE;
  }



  /**
   * 
   */

  function held(key)
  {
    return device_mouse_check_button(self.device_index, key);
  }



  /**
   * 
   */

  function pressed(key)
  {
    return device_mouse_check_button_pressed(self.device_index, key);
  }



  /**
   * 
   */

  function released(key)
  {
    return device_mouse_check_button_pressed(self.device_index, key);
  }
}



function InputDeviceKeyboard(device_index) : InputDevice(device_index) constructor
{
  /**
   * 
   */
  
  static sourceof = function()
  {
    return INPUT.DEVICE_KEYBOARD;
  }



  /**
   * 
   */
  
  function held(key)
  {
    return keyboard_check(key);
  }
  
  
  
  /**
   * 
   */
  
  function pressed(key)
  {
    return keyboard_check_pressed(key);
  }
  
  
  
  /**
   * 
   */
  
  function released(key)
  {
    return keyboard_check_released(key);
  }
}



function InputDeviceGamepad(device_index) : InputDevice(device_index) constructor
{
  /**
   * 
   */

  static sourceof = function()
  {
    return INPUT.DEVICE_GAMEPAD;
  }



  /**
   * 
   */
  
  function held(key)
  {
    return gamepad_button_check(self.device_index, key);
  }
  
  
  
  /**
   * 
   */
  
  function pressed(key)
  {
    return gamepad_button_check_pressed(self.device_index, key);
  }
  
  
  
  /**
   * 
   */
  
  function released(key)
  {
    return gamepad_button_check_released(self.device_index, key);
  }
}
