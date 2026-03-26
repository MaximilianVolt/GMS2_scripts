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
      if (self.executor.moving)
        return self.fsm.state_moving.input([true]);
    },
    in: function()  { self.executor.spd = 0; },
    out: function() { self.executor.spd = 5; },
  },
  state_moving: {
    id: STATE_MACHINE.FSM_PLAYER_STATE_MOVING,
    run: function(argv) {
      if (!self.executor.moving && argv[0])
        return self.fsm.state_idle;
    },
    in: function()  { self.executor.sprite_index = spr_run;  },
    out: function() { self.executor.sprite_index = spr_idle; },
  },
  state_running: {
    id: STATE_MACHINE.FSM_PLAYER_STATE_RUNNING,
    parent: STATE_MACHINE.FSM_PLAYER_STATE_MOVING,
    run: function(argv) {
      if (!audio_is_playing(snd_run))
        self.executor.SOUND_FN(snd_run);

      return self.parent.run(argv);
    },
  },
  state_quick_to_code: function() {
    // Creates struct and func becomes StateMachineState.run()
    // Autoassigns id and undefined parent. in and out functions are empty
    return self.fsm.state_idle;
  },
});

// StateMachineManager.machine(0).clone()
state_machine = state_machine_create(STATE_MACHINE.FSM_PLAYER, id);