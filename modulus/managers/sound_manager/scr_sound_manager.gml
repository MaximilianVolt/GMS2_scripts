/**
 * @desc A generic-interfacing sound and music manager.
 * @link https://github.com/MaximilianVolt/GMS2/tree/main/modulus/managers/sound_manager
 * @author @MaximilianVolt
 * @version 0.1.0
 *
 *
 * !: Stick to a single timesource per sound. BGMs will be arrays of tracks -> 1 timesource/track
 * !: Have a way to know which loop has to be "consumed". If no loop is "marked for consumption", consume all iterations with the amount needed for each loop.
 * +: Add Sound.onloopenter(fn, loop), Sound.onloopleave(fn, loop), Sound.onloop(fn, loop), Sound.every(time, fn)
 * +: Add SoundBGM.every(time, unit, fn), SoundBGM.onbeat(fn, [beat]), SoundBGM.onmeasure(fn, [measure])
 */




/**
 *
 */

function SoundManager() constructor
{
  /**
   *
   */

  enum SOUND_MANAGER
  {
    SOUND_PRIORITY_NONE,
    SOUND_PRIORITY_UNCATEGORIZED,
    SOUND_PRIORITY_BGM,
    SOUND_PRIORITY_BGS,
    SOUND_PRIORITY_SFX,
  }
}



/**
 *
 */

function MusicManager() : SoundManager() constructor
{

}



/**
 *
 */

function Sound(asset, loops, pitch_level, gain_level, priority) constructor
{
  /**
   *
   */

  enum SOUND
  {
    LOOP_ARG_START = 0,
    LOOP_ARG_END,
    LOOP_ARG_ITERATIONS,
    LOOP_ARG_ON_START_FUNC,
    LOOP_ARG_ON_END_FUNC,
    LOOP_ARG_COUNT,

    TIMESOURCE_MAIN = 0,

    LISTENER_MASK_ALL = -1,
    LISTENER_MASK_NONE,
  }



  self.inst = noone;
  self.asset = asset;
  self.timesource = SoundTimeSource.create(self);
  self.length = audio_sound_length(asset);
  self.target_time_anchor = self.length;
  self.gain_level_target = gain_level;
  self.gain_level = gain_level;
  self.pitch_level = pitch_level;
  self.priority = priority;
  self.loop_iterations = 0;
  self.loop_count = 0;
  self.loop_idx = 0;
  self.loops = [];



  /**
   *
   */

  static play = function(offset = 0, listener_mask = SOUND.LISTENER_MASK_ALL)
  {
    return !self.playing()
      ? __play(audio_play_sound(self.asset, self.priority, false, self.gain_level, self.offset_real(offset), self.pitch_level, listener_mask))
      : self
    ;
  }



  /**
   *
   */

  static play_on = function(emitter, offset = 0, listener_mask = SOUND.LISTENER_MASK_ALL)
  {
    return !self.playing()
      ? __play(audio_play_sound_on(emitter, self.asset, self.priority, false, self.gain_level, self.offset_real(offset), self.pitch_level, listener_mask))
      : self
    ;
  }



  /**
   *
   */

  static play_at = function(x, y, z, offset = 0, falloff_ref = audio_falloff_exponent_distance, falloff_max = room_width >> 1, falloff_factor = 1, listener_mask = SOUND.LISTENER_MASK_ALL)
  {
    return !self.playing()
      ? __play(audio_play_sound_at(self.asset, x, y, z, falloff_ref, falloff_max, falloff_factor, false, self.priority, self.gain_level, self.offset_real(offset), self.pitch_level, listener_mask))
      : self
    ;
  }



  /**
   *
   */

  static resume = function(pos = undefined)
  {
    return !self.playing()
      ? __resume(self.inst, pos)
      : self
    ;
  }



  /**
   *
   */

  static pause = function()
  {
    return self.playing()
      ? __pause(self.inst)
      : self
    ;
  }



  /**
   *
   */

  static stop = function()
  {
    return self.loaded()
      ? __stop(self.inst)
      : self
    ;
  }



  /**
   *
   */

  static loaded = function(snd = self.inst)
  {
    return snd && audio_exists(snd);
  }



  /**
   *
   */

  static playing = function(snd = self.inst)
  {
    return self.loaded(snd) && audio_is_playing(snd);
  }



  /**
   *
   */

  static paused = function(snd = self.inst)
  {
    return self.loaded(snd) && audio_is_paused(snd);
  }



  /**
   *
   */

  static done = function()
  {
    return !(self.loop_iterations || self.inst && audio_exists(self.inst));
  }



  /**
   *
   */

  static offset_real = function(offset)
  {
    return offset + self.length * (offset < 0);
  }



  /**
   *
   */

  static gain = function(gain_level_target = undefined, time = 1, override = false)
  {
    if (gain_level_target != undefined)
    {
      if (
        override
        || self.gain_level == self.gain_level_target
        && gain_level_target != self.gain_level_target
      ) {
        audio_sound_gain(self.inst, gain_level_target, time * 1000);
      }

      self.gain_level = audio_sound_get_gain(self.inst);
      self.gain_level_target = gain_level_target;
    }

    return self.gain_level;
  }



  /**
   *
   */

  static pitch = function(pitch_level = undefined)
  {
    if (pitch_level != undefined) {
      audio_sound_pitch(self.inst, pitch_level);
      self.pitch_level = pitch_level;
    }

    return self.pitch_level;
  }



  /**
   *
   */

  static loop = function(loop_iterations = infinity)
  {
    // !: Fix time source
    self.loop_iterations = loop_iterations;

    return self;
  }



  /**
   *
   */

  static loopget = function(loop_idx = 0)
  {
    return self.loops[loop_idx + self.loop_count * (loop_idx < 0)];
  }



  /**
   *
   */

  static position = function()
  {
    return self.loaded()
      ? audio_sound_get_track_position(self.inst)
      : 0
    ;
  }



  /**
   *
   */

  static time = function(pitch_level = self.pitch_level)
  {
    return self.position() / pitch_level;
  }



  /**
   *
   */

  static time_delta = function(pos, pitch_level = self.pitch_level)
  {
    return (pos - self.position()) / pitch_level;
  }



  /**
   *
   */

  static time_left = function(pitch_level = undefined)
  {
    return self.time_delta(self.length, pitch_level);
  }



  /**
   *
   */

  static time_to_loop_start = function(loop_idx, pitch_level = undefined)
  {
    return self.time_delta(self.loopget(loop_idx).start, pitch_level);
  }



  /**
   *
   */

  static time_to_loop_end = function(loop_idx, pitch_level = undefined)
  {
    return self.time_delta(self.loopget(loop_idx).end, pitch_level);
  }



  /**
   *
   */

  static move_to = function(pos)
  {
    // !: Adjust timesource to next loop idx
    audio_sound_set_track_position(self.inst, pos);

    return self;
  }



  /**
   *
   */

  static move_to_loop_start = function(loop_idx)
  {
    return self.move_to(self.loopget(loop_idx).start);
  }



  /**
   *
   */

  static move_to_loop_end = function(loop_idx)
  {
    return self.move_to(self.loopget(loop_idx).end);
  }



  /**
   *
   */

  static cleanup = function()
  {
    self.timesource.cleanup();

    return self;
  }



  /**
   *
   */

  static __play = function(snd = self.inst)
  {
    self.timesource.start(self.position());
    self.inst = snd;

    return self;
  }



  /**
   *
   */

  static __resume = function(snd = self.inst, pos = undefined)
  {
    if (pos != undefined)
      self.move_to(pos);

    self.timesource.resume();
    audio_resume_sound(snd);
  }



  /**
   *
   */

  static __pause = function(snd = self.inst)
  {
    self.timesource.pause(snd);

    audio_pause_sound(snd);

    return self;
  }



  /**
   *
   */

  static __stop = function(snd = self.inst)
  {
    self.timesource.stop(snd);
    self.inst = noone;

    audio_stop_sound(snd);

    return self;
  }



  /**
   *
   */

  static __resolve_loops = function(loop_data)
  {
    var loop_count = is_array(loop_data)
      ? array_length(loop_data)
      : 1
    ;

    if (is_instanceof(loop_data, SoundLoop)) {
      self.loops[0] = loop_data;
    }
    else if (is_numeric(loop_data)) {
      self.loops[0] = SoundLoop.create(0, self.length, loop_data);
    }
    else for (var i = 0; i < loop_count; ++i) {
      self.loops[i] = SoundLoop.fromarray(loop_data[i]);
    }

    self.loop_count = loop_count;

    return self;
  }



  __resolve_loops(loops);
}



/**
 *
 */

function SoundLoop(start, end, iterations, onstart_fn, onend_fn) constructor
{
  static __CONSTRUCTOR_ARGC = argument_count;



  self.iterations = max(iterations, 0);
  self.start = max(start, 0);
  self.end = max(end, 0);
  self.onstart_fn = onstart_fn;
  self.onend_fn = onend_fn;



  /**
   *
   */

  static create = function(start = 0, end = infinity, iterations = 0, onstart_fn = undefined, onend_fn = undefined)
  {
    return new SoundLoop(start, end, iterations, onstart_fn, onend_fn);
  }



  /**
   *
   */

  static fromarray = function(data)
  {
    var argc = array_length(data);

    return SoundLoop.create(
      argc > SOUND.LOOP_ARG_START         ? data[SOUND.LOOP_ARG_START]         : undefined,
      argc > SOUND.LOOP_ARG_END           ? data[SOUND.LOOP_ARG_END]           : undefined,
      argc > SOUND.LOOP_ARG_ITERATIONS    ? data[SOUND.LOOP_ARG_ITERATIONS]    : undefined,
      argc > SOUND.LOOP_ARG_ON_START_FUNC ? data[SOUND.LOOP_ARG_ON_START_FUNC] : undefined,
      argc > SOUND.LOOP_ARG_ON_END_FUNC   ? data[SOUND.LOOP_ARG_ON_END_FUNC]   : undefined,
    );
  }



  /**
   *
   */

  static duration = function(count_iterations = false)
  {
    return (self.end - self.start) * (count_iterations ? self.iterations : 1);
  }



  /**
   *
   */

  static startfn = function(argv = undefined)
  {
    if (is_callable(self.onstart_fn))
      self.onstart_fn(argv);

    return self;
  }



  /**
   *
   */

  static endfn = function(argv = undefined)
  {
    if (is_callable(self.onend_fn))
      self.onend_fn(argv);

    return self;
  }
}



/**
 *
 */

function SoundTimeSource(sound, timesource_idx, time, callback, args) constructor
{
  self.sound = sound;
  self.timesource_idx = timesource_idx;
  self.timesource = time_source_create(time_source_game, time, time_source_unit_seconds, callbak, args, 0, time_source_expire_nearest);



  /**
   *
   */

  static create = function(sound, timesource_idx, time = 0, callback = function() {}, args = [])
  {
    return new SoundTimeSource(timesource_idx, time, callback, args);
  }



  /**
   *
   */

  static __timesource_of_loop = function(sound = self)
  {
    if (!sound.loop_iterations--)
      return sound;

    var loop = sound.loop(sound.loop_idx);

    time_source_reconfigure(
      sound.timesource, loop[SOUND.INTERVAL_END] - loop[SOUND.INTERVAL_START], time_source_unit_seconds,
      sound.__timesource_of_loop, [sound]
    );

    return sound;
  }



  /**
   *
   */

  static __timesource_reconfig = function(ts, time, restart = false, callback = undefined, sound = self)
  {
    if (sound)
      callback ??= sound.__timesource_of_loop;

    time_source_reconfigure(ts, time / sound.pitch_level, time_source_unit_seconds, callback, [sound]);

    if (restart)
      time_source_start(ts);

    return ts;
  }



  /**
   *
   */

  static __timesource_resume = function(ts = self.timesources[SOUND.TIMESOURCE_MAIN])
  {
    switch (time_source_get_state(ts))
    {
      case time_source_state_active:
        // !:
      return;

      case time_source_state_paused:
        time_source_resume(ts);
      return;

      case time_source_state_stopped:
        // !:
      case time_source_state_initial:
        time_source_start(ts);
      return;
    }
  }
}



/**
 *
 */

function SoundSFX() : Sound() constructor
{

}



/**
 *
 */

function SoundBGS() : Sound() constructor
{

}



/**
 *
 */

function SoundBGM() : Sound() constructor
{
  /**
   *
   */

  static __integrate_gauss12 = function(f, a, b)
  {
    var xm = (a + b) / 2
      , xr = (b - a) / 2
    ;

    return xr * (
      .2491470458134029 * (f(xm + xr * .1252334085114689) + f(xm - xr * .1252334085114689)) +
      .2334925365383548 * (f(xm + xr * .3678314989981802) + f(xm - xr * .3678314989981802)) +
      .2031674267230659 * (f(xm + xr * .5873179542866175) + f(xm - xr * .5873179542866175)) +
      .1600783285433462 * (f(xm + xr * .7699026741943050) + f(xm - xr * .7699026741943050)) +
      .1069393259953184 * (f(xm + xr * .9041172563704749) + f(xm - xr * .9041172563704749)) +
      .0471753363865118 * (f(xm + xr * .9815606342467192) + f(xm - xr * .9815606342467192))
    );
  }
}
