/**
 * @desc A lightweight index-based state machine manager.
 * @link https://github.com/MaximilianVolt/GMS2/tree/main/modulus/managers/state_machine_manager
 * @author @MaximilianVolt
 * @version 0.5.1
 */



#macro __STATE_MACHINE_FIELD_NAME_ID__             "id"
#macro __STATE_MACHINE_FIELD_NAME_PARENT_ID__      "parent"
#macro __STATE_MACHINE_FIELD_NAME_IN_FUNCTION__    "in"
#macro __STATE_MACHINE_FIELD_NAME_OUT_FUNCTION__   "out"
#macro __STATE_MACHINE_FIELD_NAME_STATE_FUNCTION__ "run"
#macro __STATE_MACHINE_LINK__                      "https://github.com/MaximilianVolt/GMS2/tree/main/modulus/managers/state_machine_manager"
#macro __STATE_MACHINE_VERSION__                   "0.5.1"



gml_pragma("global", "new StateMachineManager(); new StateMachineState();");

// ----------------------------------------------------------------------------

#region Lib functions












/**
 * @desc Creates a state machine instance. Returns the instance for chaining.
 * @param {Constant.STATE_MACHINE} machine_idx The index of the state machine to create.
 * @param {Asset.GMObject|Id.Instance} executor The executor object for the state machine.
 * @returns {Struct.StateMachine} The created state machine instance.
 */

function state_machine_create(machine_idx, executor)
{
  return new StateMachine(machine_idx, executor);
}












#endregion

// ----------------------------------------------------------------------------

#region Source code













/**
 * @desc State machine manager constructor.
 * @returns {Struct.StateMachineManager}
 */

function StateMachineManager() constructor
{
  /**
   * @desc Enum for state machine and state indices, as well as error types.
   * @desc `FSM_*` constants refer to state machine and state indices and options.
   * @desc `ERR_*` constants refer to error types.
   * @desc `ERRCHECK_*` constants refer to error check limits.
   */

  enum STATE_MACHINE
  {
    // State machine indices
    FSM_PLAYER = 0,
      // ...
    FSM_COUNT,

    // State machine state indices
    FSM_STATE_NONE = -1,
    FSM_PLAYER_STATE_IDLE = 0,
      // ...
    FSM_PLAYER_STATE_COUNT,

    // ...

    // State machine options
    FSM_HISTORY_SIZE = 4,

    // Error
    ERR_UNDEFINED_ERROR_TYPE = 0,
    ERR_CIRCULAR_INHERITANCE,
    ERR_INFINITE_RESOLUTION_LOOP,
    ERR_COUNT,

    // Error check
    ERRCHECK_INFINITE_RESOLUTION_LOOP = 64,
  }



  static MACHINES = array_create(STATE_MACHINE.FSM_COUNT, undefined);



  /**
   * @desc Error handling function. Returns a formatted error message string based on the error type and arguments.
   * @param {Constant.STATE_MACHINE|Real} type The error type.
   * @param {Array} [argv] Optional arguments for formatting the error message.
   * @returns {String}
   */

  static ERROR = function(type, argv = [])
  {
    static messages = [
      "UNKNOWN ERROR TYPE: {0}",
      "CIRCULAR INHERITANCE DETECTED. VIOLATING STATE: {0}",
      "INFINITE RESOLUTION LOOP DETECTED: EXCEEDED SAFE LIMIT OF {0} ITERATIONS",
    ];

    if (type < 0 || type >= STATE_MACHINE.ERR_COUNT)
    {
      argv = [type];
      type = STATE_MACHINE.ERR_UNDEFINED_ERROR_TYPE;
    }

    if (!is_array(argv))
      argv = [argv];

    return string_ext($"\n\n\n<<State Machine Manager>>:\n{messages[type]}\n\n", argv);
  }



  /**
   * @desc Retrieves the state machine data for the given index. If `machine_data` is provided, it sets the state machine data for the given index before retrieving it.
   * @param {Constant.STATE_MACHINE} machine_idx The index of the state machine to retrieve
   * @param {Struct} [machine_data] Optional state machine data to set for the given index before retrieval.
   * @returns {Struct}
   */

  static machine = function(machine_idx, machine_data = undefined)
  {
    if (machine_data) {
      StateMachineManager.MACHINES[machine_idx] = machine_data;
    }

    return StateMachineManager.MACHINES[machine_idx];
  }
}












// ----------------------------------------------------------------------------












/**
 * @desc State machine constructor.
 * @param {Constant.STATE_MACHINE} machine_idx The index of the state machine.
 * @param {Asset.GMInstance} executor The executor object for the state machine.
 * @returns {Struct.StateMachine}
 */

function StateMachine(machine_idx, executor) constructor
{
  /**
   * @desc Generates a unique state ID. If an ID is provided, it ensures that the generated ID is greater than or equal to the provided ID.
   * @param {Real} [id] Optional ID to ensure the generated ID is greater.
   * @returns {Real}
   */

  static yieldid = function(id)
  {
    self.state_id_generator = max(self.state_id_generator, id ?? self.state_id_generator + 1);

    return id ?? self.state_id_generator;
  }



  /**
   * @desc Starts the state machine with the specified initial state. If `execute_transition` is true, it executes the transition to the initial state before starting.
   * @param {Constant.STATE_MACHINE|Struct.StateMachineState} [state_id] The index or ID of the initial state.
   * @param {Bool} [execute_transition] Whether to execute the transition to the initial state before starting.
   * @param {Array} [argv_initial_state] Optional arguments for the initial state.
   * @returns {Struct.StateMachine}
   */

  static start = function(state_id = STATE_MACHINE.FSM_STATE_NONE, execute_transition = false, argv_initial_state = undefined)
  {
    if (is_instanceof(state_id, StateMachineState))
      state_id = state_id.id;

    var initial_state = self.state_map[$ state_id];

    self.state = __update_history(
      execute_transition
        ? __cycle(initial_state, initial_state.input(argv_initial_state).in())
        : initial_state
    );

    return self;
  }



  /**
   * @desc Executes the state machine with the given input for the current state. Returns the new current state after execution.
   * @param {Array} [argv_current_state] Optional input arguments for the current state. If not provided, the current state's input will be used.
   * @returns {Struct.StateMachineState}
   */

  static execute = function(argv_current_state = undefined)
  {
    self.state = __step(argv_current_state);

    return self.state;
  }



  /**
   * @desc Retrieves the state machine's history of previously active states.
   * @param {Real|Array} [index] Optional index or indices to retrieve specific historical states. If not provided, the entire history array is returned.
   * @returns {Array<Struct.StateMachineState>}
   */

  static historyget = function(index)
  {
    if (is_undefined(index))
      return self.history;

    if (!is_array(index))
      index = [index];

    var register_count = min(self.history_size, STATE_MACHINE.FSM_HISTORY_SIZE)
      , ret = []
    ;

    for (var i = array_length(index) - 1; i >= 0; --i)
      ret[i] = self.history[index[i] + register_count * (index[i] < 0)];

    return ret;
  }



  /**
   * @desc Determines the target state resolving transition cycles returning the resolved state.
   * @param {Array} [argv_current_state] Optional input arguments for the current state. If not provided, the current state's input will be used.
   * @returns {Struct.StateMachineState}
   */

  static __step = function(argv_current_state)
  {
    var current_state = self.state
      , target_state = current_state.input(argv_current_state).run()
    ;

    return target_state
      ? __update_history(__cycle(current_state, target_state ?? current_state))
      : current_state
    ;
  }



  /**
   * @desc Resolves state transitions and returnes the resolved state. Throws STATE_MACHINE.ERR_INFINITE_RESOLUTION_LOOP if a transition cycle exceeds the safe limit.
   * @desc If a transition cycle is detected, it throws an error to prevent infinite loops.
   * @param {Struct.StateMachineState} current_state The current state before transition.
   * @param {Struct.StateMachineState} target_state The target state after transition.
   * @returns {Struct.StateMachineState}
   */

  static __cycle = function(current_state = self.state, target_state = self.state)
  {
    var cycle = STATE_MACHINE.ERRCHECK_INFINITE_RESOLUTION_LOOP;

    while (current_state != target_state && cycle--) {
      target_state = current_state.out() ?? target_state;
      current_state = target_state.in() ?? target_state;
    }

    if (!cycle) {
      throw StateMachineManager.ERROR(STATE_MACHINE.ERR_INFINITE_RESOLUTION_LOOP, [
        STATE_MACHINE.ERRCHECK_INFINITE_RESOLUTION_LOOP
      ]);
    }

    return target_state;
  }



  /**
   * @desc Resolves the state machine data and resolves state hierarchy. Throws STATE_MACHINE.ERR_CIRCULAR_INHERITANCE if circular inheritance is detected.
   * @param {Constant.STATE_MACHINE} machine_idx The index of the state machine to resolve.
   * @returns {Struct.StateMachine}
   */

  static __resolve = function(machine_idx)
  {
    var machine_data = variable_clone(StateMachineManager.machine(machine_idx))
      , keys = struct_get_names(machine_data)
    ;

    self.state_count = array_length(keys);

    // ID mapping
    for (var i = 0; i < self.state_count; ++i)
    {
      var key = keys[i]
        , state_data = machine_data[$ key]
        , state = is_callable(state_data)
          ? StateMachineState.fromfunction(self, state_data)
          : new StateMachineState(
              self,
              struct_exists(state_data, __STATE_MACHINE_FIELD_NAME_ID__            ) ? state_data[$ __STATE_MACHINE_FIELD_NAME_ID__            ] : self.yieldid(),
              struct_exists(state_data, __STATE_MACHINE_FIELD_NAME_STATE_FUNCTION__) ? state_data[$ __STATE_MACHINE_FIELD_NAME_STATE_FUNCTION__] : undefined,
              struct_exists(state_data, __STATE_MACHINE_FIELD_NAME_IN_FUNCTION__   ) ? state_data[$ __STATE_MACHINE_FIELD_NAME_IN_FUNCTION__   ] : undefined,
              struct_exists(state_data, __STATE_MACHINE_FIELD_NAME_OUT_FUNCTION__  ) ? state_data[$ __STATE_MACHINE_FIELD_NAME_OUT_FUNCTION__  ] : undefined,
              struct_exists(state_data, __STATE_MACHINE_FIELD_NAME_PARENT_ID__     ) ? state_data[$ __STATE_MACHINE_FIELD_NAME_PARENT_ID__     ] : undefined
            )
      ;

      self.state_map[$ state.id] = state;
      self[$ key] = state;
    }

    // Hierarchy resolution and circular inheritance checks
    for (var i = 0; i < self.state_count; ++i)
    {
      var state = self[$ keys[i]]
        , iter = state
      ;

      if (!state.parent)
        continue;

      for (var j = 0; iter.parent && j < self.state_count; ++j)
        iter = self.state_map[$ iter.parent];

      if (iter.parent) {
        throw StateMachineManager.ERROR(STATE_MACHINE.ERR_CIRCULAR_INHERITANCE, [
          keys[i]
        ]);
      }

      state.parent = self.state_map[$ state.parent];
    }

    return self;
  }



  /**
   * @desc Updates the state machine's history with the new state and returns it.
   * @param {Struct.StateMachineState} new_state The new state to add to the history.
   * @returns {Struct.StateMachineState}
   */

  static __update_history = function(new_state)
  {
    array_insert(self.history, 0, new_state);
    array_resize(self.history, STATE_MACHINE.FSM_HISTORY_SIZE);
    ++self.history_size;

    return new_state;
  }



  self.state_map = {};
  self.state_count = 0;
  self.executor = executor;
  self.state_id_generator = STATE_MACHINE.FSM_STATE_NONE;
  self.history = array_create(STATE_MACHINE.FSM_HISTORY_SIZE, undefined);
  self.history_size = 0;
  __resolve(machine_idx);
}












// ----------------------------------------------------------------------------












/**
 * @desc State machine state constructor.
 * @param {Struct.StateMachine} machine The state machine to which this state belongs.
 * @param {Real} id The unique ID of the state (inside the owning state machine).
 * @param {Function} [run_fn] Optional function to execute when the state is run.
 * @param {Function} [in_fn] Optional function to execute when entering the state.
 * @param {Function} [out_fn] Optional function to execute when exiting the state.
 * @param {Real|Struct.StateMachineState} [parent_id] Optional ID or reference to the parent state for inheritance.
 * @returns {Struct.StateMachineState}
 */

function StateMachineState(machine, id, run_fn, in_fn, out_fn, parent_id) constructor
{
  static __FUNC_EMPTY = function() {};



  if (!machine)
    return self;

  self.id = machine.yieldid(id);
  self.run_fn = method(self, run_fn ?? __FUNC_EMPTY);
  self.in_fn = method(self, in_fn ?? __FUNC_EMPTY);
  self.out_fn = method(self, out_fn ?? __FUNC_EMPTY);

  self.fsm = machine;
  self.parent = parent_id;
  self.executor = machine.executor;
  self.input_array = [];
  self.output_array = [];
  self.input_count = 0;
  self.output_count = 0;



  /**
   * @desc Creates a state struct from a function. The function becomes the `run` method of the state, and the state is assigned a unique ID. Returns the created state struct.
   * @param {Struct.StateMachine} machine The state machine to which this state belongs.
   * @param {Function} run_fn The function to execute when the state is run.
   * @returns {Struct.StateMachineState}
   */

  static fromfunction = function(machine, run_fn)
  {
    return new StateMachineState(machine, machine.yieldid(), run_fn, undefined, undefined, STATE_MACHINE.FSM_STATE_NONE);
  }



  /**
   * @desc Sets the input for the state. [CHAINABLE]
   * @param {Array} argv The input values for the state.
   * @returns {Struct.StateMachineState}
   */

  static input = function(argv)
  {
    if (is_undefined(argv))
      return self;

    self.input_array = is_array(argv) ? argv : [argv];
    self.input_count = array_length(argv);

    return self;
  }



  /**
   * @desc Gets the input for the state.
   * @param {Real|Array} [index] Optional index or indices to retrieve specific input values. If not provided, returns the entire input array.
   * @returns {Array<Any>} The requested input value(s) or the entire input array if no index is provided.
   */

  static inputget = function(index = undefined)
  {
    if (is_undefined(index))
      return self.input_array;

    if (!is_array(index))
      index = [index];

    var ret = [];

    for (var i = array_length(index) - 1; i >= 0; --i)
      ret[i] = self.input_array[index[i] + self.input_count * (index[i] < 0)];

    return ret;
  }



  /**
   * @desc Adds input values to the state at the specified index. If the index is greater than or equal to the current input count, it increases the input count accordingly. [CHAINABLE]
   * @param {Array} argv The input values to add to the state.
   * @param {Real} [index] Optional index at which to add the input values. If not provided, adds the input values at the end of the current input array.
   * @returns {Struct.StateMachineState}
   */

  static inputadd = function(argv, index = self.input_count)
  {
    if (is_undefined(argv))
      return self;

    self.input_array[index] = argv;
    self.input_count += index >= self.input_count;

    return self;
  }



  /**
   * @desc Clears the input info of the state and returns a copy of the cleared input array.
   * @returns {Array} A copy of the cleared input array.
   */

  static inputclear = function()
  {
    var copy = variable_clone(self.input_array);

    self.input_array = [];
    self.input_count = 0;

    return copy;
  }



  /**
   * @desc Sets the output for the state. [CHAINABLE]
   * @param {Array} argv The output values for the state.
   * @returns {Struct.StateMachineState}
   */

  static output = function(argv)
  {
    if (is_undefined(argv))
      return self;

    self.output_array = is_array(argv) ? argv : [argv];
    self.output_count = array_length(argv);

    return self;
  }



  /**
   * @desc Gets the output for the state.
   * @param {Real|Array} [index] Optional index or indices to retrieve specific output values. If not provided, returns the entire output array.
   * @returns {Array<Any>} The requested output value(s) or the entire output array if no index is provided.
   */

  static outputget = function(index = undefined)
  {
    if (is_undefined(index))
      return self.output_array;

    if (!is_array(index))
      index = [index];

    var ret = [];

    for (var i = array_length(index) - 1; i >= 0; --i)
      ret[i] = self.output_array[index[i] + self.output_count * (index[i] < 0)];

    return ret;
  }



  /**
   * @desc Adds output values to the state at the specified index. If the index is greater than or equal to the current output count, it increases the output count accordingly. [CHAINABLE]
   * @param {Array} argv The output values to add to the state.
   * @param {Real} [index] Optional index at which to add the output values. If not provided, adds the output values at the end of the current output array.
   * @returns {Struct.StateMachineState}
   */

  static outputadd = function(argv, index = self.output_count)
  {
    if (is_undefined(argv))
      return self;

    self.output_array[index] = argv;
    self.output_count += index >= self.output_count;

    return self;
  }



  /**
   * @desc Clears the output info of the state and returns a copy of the cleared output array.
   * @returns {Array} A copy of the cleared output array.
   */

  static outputclear = function()
  {
    var copy = variable_clone(self.output_array);

    self.output_array = [];
    self.output_count = 0;

    return copy;
  }



  /**
   * @desc Executes the `in` function of the state with the given input arguments.
   * @param {Array} [argv] Optional input arguments for the `in` function. If not provided, the current input array of the state will be used.
   * @returns {Struct.StateMachineState}
   */

  static in = function(argv = undefined)
  {
    return self.in_fn(argv ?? self.input_array);
  }



  /**
   * @desc Executes the `run` function of the state with the given input arguments.
   * @param {Array} [argv] Optional input arguments for the `run` function. If not provided, the current input array of the state will be used.
   * @returns {Struct.StateMachineState}
   */

  static run = function(argv = undefined)
  {
    return self.run_fn(argv ?? self.input_array);
  }



  /**
   * @desc Executes the `out` function of the state with the given input arguments.
   * @param {Array} [argv] Optional input arguments for the `out` function. If not provided, the current input array of the state will be used.
   * @returns {Struct.StateMachineState}
   */

  static out = function(argv = undefined)
  {
    return self.out_fn(argv ?? self.input_array);
  }
}

#endregion
