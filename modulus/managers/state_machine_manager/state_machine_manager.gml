//
// StateMachineManager()
// | StateMachine()
// | StateMachineState()
//
//

StateMachineManager.machine(0, {
  state_idle: {
    run: function() { 
      return moving
        ? STATE_MACHINE.FSM_PLAYER_STATE_MOVING
        : STATE_MACHINE.FSM_STATE_SELF;
    },
    in: function()  { hsp = 0; },
    out: function() { hsp = 5; },
  },
  state_moving: function() { // Creates struct and func becomes StateMachineState.run()
    return moving
      ? STATE_MACHINE.FSM_STATE_SELF
      : STATE_MACHINE.FSM_PLAYER_STATE_IDLE
  },
});

// StateMachineManager.machine(0).clone()
state_machine = state_machine_create(STATE_MACHINE.FSM_PLAYER);