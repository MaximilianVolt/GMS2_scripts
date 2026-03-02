input_manager = input_manager_create(4, 3);

input_manager.profile(0, {
  controller: { },
  mouse: { },
  kb: { },
});





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

  // Input constants
  __MOUSE_MIN = 0x0000,
  __MOUSE_MAX = 0x0006,
  __KEYBOARD_MIN,
  __KEYBOARD_MAX = 0x03FF,
  __GAMEPAD_MIN,
  __GAMEPAD_MAX = 0xFFFF,
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
            throw InputManager.ERROR();
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




}












// ----------------------------------------------------------------------------












/**
 *
 */

function InputAction(binds, context) constructor
{
  static TIME_WINDOW = 3;



  /**
   *
   */

  static normalize = function(binds)
  {
    var ret = [];

    if (!is_array(binds))
      return [[binds]];

    if (is_array(binds[0]))
      return binds;

    for (var i = array_length(binds) - 1; i >= 0; --i)
      ret[i] = [binds[i]];

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



  function held(action = self)
  {
    return action.check(function(k, ctx) {
      return keyboard_check(k)
        || (ctx.mouse != noone && device_mouse_check_button(ctx.mouse, k))
        || (ctx.gamepad != noone && gamepad_button_check(ctx.gamepad, k))
      ;
    });
  }



  /**
   *
   */

  function pressed(action = self)
  {
    return action.check(function(k, ctx) {
      return keyboard_check_pressed(k)
        || (ctx.mouse != noone && device_mouse_check_button_pressed(ctx.mouse, k))
        || (ctx.gamepad != noone && gamepad_button_check_pressed(ctx.gamepad, k))
      ;
    });
  }



  /**
   *
   */

  function released(action = self)
  {
    return action.check(function(k, ctx) {
      return keyboard_check_released(k)
        || (ctx.mouse != noone && device_mouse_check_button_released(ctx.mouse, k))
        || (ctx.gamepad != noone && gamepad_button_check_released(ctx.gamepad, k))
      ;
    });
  }



  self.context = context;
  self.binds = self.normalize(binds);
  self.bind_count = array_length(self.binds);
  self.recording = false;
  self.time = InputAction.TIME_WINDOW;
}












// ----------------------------------------------------------------------------












/**
 *
 */

function InputCombo(actions, time, context) constructor
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

function InputDevice()
{
  /**
   *
   */

  static sourceof = function(key)
  {
    return (key <= INPUT.__GAMEPAD_MAX) * (
      (key >= INPUT.__MOUSE_MIN) + (key >= INPUT.__KEYBOARD_MIN) + (key >= INPUT.__GAMEPAD_MIN)
    );
  }
}





function InputDeviceMouse()
{
  /**
   * 
   */

  static sourceof = function()
  {
    return INPUT.DEVICE_MOUSE;
  }
}



function InputDeviceKeyboard()
{
  /**
   * 
   */

  static sourceof = function()
  {
    return INPUT.DEVICE_KEYBOARD;
  }
}



function InputDeviceGamepad()
{
  /**
   * 
   */

  static sourceof = function()
  {
    return INPUT.DEVICE_GAMEPAD;
  }
}