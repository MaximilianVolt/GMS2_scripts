//
// StateMachineManager()
// | StateMachine()
// | StateMachineState()
//
//

StateMachineManager.machine(STATE_MACHINE.FSM_PLAYER, {
  state_idle: {
    id: STATE_MACHINE.FSM_PLAYER_STATE_IDLE,
    run: function() {
      if (executor.moving)
        return fsm.state_moving.argv([true]);
    },
    in: function()  { executor.spd = 0; },
    out: function() { executor.spd = 5; },
  },
  state_moving: {
    id: STATE_MACHINE.FSM_PLAYER_STATE_MOVING,
    run: function(argv) {
      if (!executor.moving && argv[0])
        return fsm.state_idle;
    },
    in: function()  { executor.sprite_index = spr_run;  },
    out: function() { executor.sprite_index = spr_idle; },
  },
  state_running: {
    id: STATE_MACHINE.FSM_PLAYER_STATE_RUNNING,
    parent: STATE_MACHINE.FSM_PLAYER_STATE_MOVING,
  },
  state_quick_to_code: function() {
    // Creates struct and func becomes StateMachineState.run()
    // Autoassigns id and undefined parent. in and out functions are empty
    return fsm.state_idle;
  },
});

// StateMachineManager.machine(0).clone()
state_machine = state_machine_create(STATE_MACHINE.FSM_PLAYER, id);