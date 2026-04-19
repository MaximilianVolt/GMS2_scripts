/**
 * @desc A generic-interfacing sound and music manager.
 * @link https://github.com/MaximilianVolt/GMS2/tree/main/modulus/managers/sound_manager
 * @author @MaximilianVolt
 * @version 0.1.0
 *
 *
 * !: Stick to a single timesource per sound. BGMs will be arrays of tracks -> 1 timesource/track
 * !: Have a way to know which loop has to be "consumed". If no loop is "marked for consumption", consume all iterations with the amount needed for each loop.
 *
 * #: BASE SOUND FUNCTIONALITY
 * +: Implement options for sorting loops
 * +: Add SoundTimelineEventNode.settings_mask options to allow an effect to be executed only if loop is active
 * +: Add Sound.loop_data being a matrix LOOP_COUNT x 2 to account for loop iterations and max iterations for each loop
 * +: Implement options for increasing the cap of the max loop iterations
 * +: Implement timesources and ensure that all play/pause/pitch/move methods properly update them
 * +: Loops are considered only if active (SoundLoop.status), else they are skipped without counting them
 * +: Add SoundLoop.parent() to find the parent loop if existent (p.start < l.start && p.end > l.end)
 * +: Add SoundLoop.onenter(fn), SoundLoop.onleave(fn), SoundLoop.onloop(fn), Sound.every(time, fn)
 * +: Add Sound.clone() to copy asset data (without sound instances)
 *
 * #: BGM SOUND FUNCTIONALITY
 * +: Ensure all BGM channels work correctly (channels for sync groups)
 * +: Resolve dynamic BPM and tempo sections time resolutions: calculate beats (quarters) and use them to calculate the integral to get the time
 * +: Add SoundBGM.every(time, unit, fn), SoundBGM.onbeat(fn, [beat]), SoundBGM.onmeasure(fn, [measure])
 * +: Add SoundBGM.transition_to(target_time, transition_time, track_list, options) to transition between BGMs with different options for fading in/out and syncing riffs and stuff
 * +: Add SoundBGM.measuremap(breakpoint_list, start_measure, measure_count) to allow creating a list of beats like [0, .5, .75, 1, 1.25, 1.50, 2, ...] to relatively place triggers and timesource events
 *
 * #: SOUND MANAGER FUNCTIONALITY
 * +: Add methods to operate with sound buses and effects
 * +: Add sound queues and lists and have settings to allow multiple tracks to fade in/out
 *
 * #: MUSIC MANAGER FUNCTIONALITY
 * +: Add methods to transition between tracks allowing for fade-in/out channels with prior riffs and stuff
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
    // Sound priority
    SOUND_PRIORITY_NONE,
    SOUND_PRIORITY_UNCATEGORIZED,
    SOUND_PRIORITY_BGM,
    SOUND_PRIORITY_BGS,
    SOUND_PRIORITY_SFX,
    SOUND_PRIORITY_COUNT,

    // Bitmasks
    LOOP_OPTION_SORT_SHORTEST_FIRST = 0,
    LOOP_OPTION_SORT_LONGEST_FIRST,
    LOOP_OPTION_SORT_COUNT,
    __BITMASK_LOOP_OPTION_SORT_SHIFT = 0,
    __BITMASK_LOOP_OPTION_SORT_BITS = 2,
    __BITMASK_LOOP_OPTION_SORT_MASK = (1 << SOUND_MANAGER.__BITMASK_LOOP_OPTION_SORT_BITS) - 1 << SOUND_MANAGER.__BITMASK_LOOP_OPTION_SORT_SHIFT,

    // Settings indices
    __BITMASK_LOOP_SETTINGS_SHIFT = SOUND_MANAGER.__BITMASK_LOOP_OPTION_SORT_SHIFT + SOUND_MANAGER.__BITMASK_LOOP_OPTION_SORT_BITS,
    __BITMASK_FLAG_INDEX_LOOP_SETTING_REFRESH_INNER = 0,
    __BITMASK_FLAG_LOOP_SETTINGS_COUNT,
    __BITMASK_LOOP_SETTINGS_MASK = (1 << SOUND_MANAGER.__BITMASK_FLAG_LOOP_SETTINGS_COUNT) - 1 << SOUND_MANAGER.__BITMASK_LOOP_SETTINGS_SHIFT,

    // Settings values
    LOOP_SETTING_REFRESH_INNER = 1 << SOUND_MANAGER.__BITMASK_FLAG_INDEX_LOOP_SETTING_REFRESH_INNER + SOUND_MANAGER.__BITMASK_LOOP_SETTINGS_SHIFT,
  }



  static SETTINGS = 0;
  static EPSILON_MS = 5;



  /**
   *
   */

  static sort_settings = function(settings_mask = SoundManager.SETTINGS)
  {
    return (settings_mask & SOUND_MANAGER.__BITMASK_LOOP_OPTION_SORT_MASK) >> SOUND_MANAGER.__BITMASK_LOOP_OPTION_SORT_SHIFT;
  }
}












// ----------------------------------------------------------------------------












/**
 *
 */

function MusicManager() : SoundManager() constructor
{

}












// ----------------------------------------------------------------------------












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
    LOOP_IDX_NONE = -1,

    LOOP_ARG_START = 0,
    LOOP_ARG_END,
    LOOP_ARG_ITERATIONS,
    LOOP_ARG_EVENTS,
    LOOP_ARG_ANCHORS,
    LOOP_ARG_STATUS,
    LOOP_ARG_COUNT,

    LOOP_STAT_INDEX_ITERATIONS = 0,
    LOOP_STAT_INDEX_ITERATIONS_MAX,
    LOOP_STAT_INDEX_ITERATIONS_MAX_ORIGINAL,
    LOOP_STAT_COUNT,

    TIMESOURCE_MAIN = 0,

    LISTENER_MASK_ALL = -1,
    LISTENER_MASK_NONE,

    __BITMASK_LOOP_STATUS_SHIFT = 0,
    __BITMASK_FLAG_INDEX_LOOP_STATUS_ACTIVE = 0,
    __BITMASK_FLAG_LOOP_STATUS_COUNT,
    __BITMASK_LOOP_STATUS_MASK = (1 << SOUND.__BITMASK_FLAG_LOOP_STATUS_COUNT) - 1 << SOUND.__BITMASK_LOOP_STATUS_SHIFT,

    LOOP_STATUS_ACTIVE = 1 << SOUND.__BITMASK_LOOP_STATUS_SHIFT + SOUND.__BITMASK_FLAG_INDEX_LOOP_STATUS_ACTIVE,
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
  self.loop_idx = 0;
  self.loops = [];
  self.timeline = [];



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
    return !(self.loop_idx >= self.loop_count || self.inst && audio_exists(self.inst));
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
    return self.time_delta(self.loop_get(loop_idx).start, pitch_level);
  }



  /**
   *
   */

  static time_to_loop_end = function(loop_idx, pitch_level = undefined)
  {
    return self.time_delta(self.loop_get(loop_idx).end, pitch_level);
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
    return self.move_to(self.loop_get(loop_idx).start);
  }



  /**
   *
   */

  static move_to_loop_end = function(loop_idx)
  {
    return self.move_to(self.loop_get(loop_idx).end);
  }



  /**
   *
   */

  static loop = function(loop_iterations = infinity)
  {
    // !: Fix time source
    self.loop_iterations = loop_iterations; // !:

    return self;
  }



  /**
   *
   */

  static loop_get = function(loop_idx = 0)
  {
    return self.loops[loop_idx % self.loop_count + self.loop_count * (loop_idx < 0)];
  }



  /**
   *
   */

  static loop_get_relative = function(loop_shift = 0)
  {
    return self.loop_get(self.loop_idx + loop_shift);
  }



  /**
   *
   */

  static loop_get_next = function()
  {
    for (var i = self.loop_idx + 1; i < self.loop_count; ++i)
      if (self.loop_get(i).active())
        return i;

    return SOUND.LOOP_IDX_NONE;
  }



  /**
   *
   */

  static loop_sort = function(sort_settings = SoundManager.sort_settings)
  {
    var sort_fns = [
      function(a, b) { return a.duration() - b.duration(); },
      function(a, b) { return b.duration() - a.duration(); },
    ];

    array_sort(self.loops, sort_fns[SoundManager.sort_settings(sort_settings)]);

    return self;
  }



  /**
   *
   */

  static timeline_build = function()
  {
    self.timeline = SoundTimeline.build(self);

    return self.timeline;
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

  static reset = function()
  {
    // Loops
    array_foreach(self.loops, function(loop) {
      loop.reset();
    });
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
      : 0
    ;

    if (is_instanceof(loop_data, SoundLoop)) {
      self.loops[0] = loop_data;
    }
    else for (var i = 0; i < loop_count; ++i) {
      self.loops[i] = SoundLoop.fromarray(self, loop_data[i]);
    }

    self.loop_sort();

    array_foreach(self.loops, function(loop) {
      loop.parent = loop.parent_find();
    });

    self.loops[loop_count] = SoundLoop.create(self, 0, self.length, is_numeric(loop_data) ? loop_data : undefined)
    self.loop_count = loop_count + add_full_track_loop;

    return self;
  }



  __resolve_loops(loops);
}












// ----------------------------------------------------------------------------












/**
 *
 */

function SoundLoop(sound, start, end, iterations, events, anchors, status) constructor
{
  static __CONSTRUCTOR_ARGC = argument_count;



  var event_count = array_length(events)
    , anchor_count = array_length(anchors)
  ;

  self.sound = sound;
  self.status = status;
  self.parent = undefined;
  self.start = max(start, 0);
  self.end = max(end, 0);
  self.iterations = 0;
  self.iterations_max = max(iterations, 0);
  self.iterations_max_original = self.iterations_max;
  self.events = events;
  self.event_count = event_count;
  self.anchors = event_count != anchor_count
    ? __anchors_normalize(event_count)
    : anchors
  ;



  /**
   *
   */

  static create = function(sound, start = 0, end = infinity, iterations = 0, events = [], anchors = [], status = SOUND.LOOP_STATUS_ACTIVE)
  {
    return new SoundLoop(sound, start, end, iterations, events, anchors, status);
  }



  /**
   *
   */

  static fromarray = function(sound, data)
  {
    var argc = array_length(data);

    return SoundLoop.create(
      sound,
      argc > SOUND.LOOP_ARG_START      ? data[SOUND.LOOP_ARG_START]      : undefined,
      argc > SOUND.LOOP_ARG_END        ? data[SOUND.LOOP_ARG_END]        : undefined,
      argc > SOUND.LOOP_ARG_ITERATIONS ? data[SOUND.LOOP_ARG_ITERATIONS] : undefined,
      argc > SOUND.LOOP_ARG_EVENTS     ? data[SOUND.LOOP_ARG_EVENTS]     : undefined,
      argc > SOUND.LOOP_ARG_ANCHORS    ? data[SOUND.LOOP_ARG_ANCHORS]    : undefined,
      argc > SOUND.LOOP_ARG_STATUS     ? data[SOUND.LOOP_ARG_STATUS]     : undefined
    );
  }



  /**
   *
   */

  static compare = function(loop)
  {
    return sign(
      self.end == loop.end
        ? self.duration() - loop.duration()
        : self.end - loop.end
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

  static execute = function(event_idx, argv = undefined)
  {
    return is_callable(self.events[event_idx])
      ? self.events[event_idx + self.event_count * (event_idx < 0)](argv)
      : self
    ;
  }



  /**
   *
   */

  static active = function()
  {
    return self.status & SOUND.LOOP_STATUS_ACTIVE;
  }



  /**
   *
   */

  static reset = function()
  {
    self.iterations_max = self.iterations_max_original;
    self.iterations = 0;

    return self;
  }



  /**
   *
   */

  static consume = function()
  {
    return self.active()
      ? ++self.iterations < self.iterations_max
      : false
    ;
  }



  /**
   *
   */

  static parent_get = function(hierarchy_lv = 1)
  {
    var ret = self.parent;

    while (--hierarchy_lv && ret.parent)
      ret = ret.parent;

    return hierarchy_lv
      ? undefined
      : ret
    ;
  }



  /**
   *
   */

  static parent_find = function(hierarchy_lv = 1)
  {
    if (!self.sound)
      return undefined;

    if (!hierarchy_lv)
      return self;

    var best_loop = undefined;

    for (var i = 0; i < self.sound.loop_count; ++i)
    {
      var loop = self.sound.loop_get(i);

      if (loop == self)
        continue;

      if (
        loop.__parent_intersection_policy(self)
        && (!best_loop || loop.__parent_timing_policy(best_loop))
      ) {
        best_loop = loop.parent(hierarchy_lv - 1);
      }
    }

    return best_loop;
  }



  /**
   *
   */

  static __parent_intersection_policy = function(loop, settings = SoundManager.SETTINGS)
  {
    return self.start < loop.start && self.end > loop.end;
  }



  /**
   *
   */

  static __parent_timing_policy = function(loop, settings = SoundManager.SETTINGS)
  {
    return self.duration() < loop.duration();
  }



  /**
   *
   */

  static __anchors_normalize = function(event_count)
  {
    if (event_count <= 1)
      return event_count ? [0] : [];

    var ret = [];

    for (var i = 0; i < event_count; ++i)
      ret[i] = i / (event_count - 1);

    return ret;
  }
}












// ----------------------------------------------------------------------------












/**
 *
 */

function SoundTimeline() constructor
{
  /**
   *
   */

  static collect = function(sound)
  {
    var events = [];

    for (var i = 0; i < sound.loop_count; ++i)
    {
      var loop = sound.loop_get(i);

      if (!(loop.event_count && loop.active()))
        continue;

      for (var j = 0; j < loop.event_count; ++j)
        array_push(events, SoundTimelineEventNode.create(loop, j));
    }

    return events;
  }



  /**
   *
   */

  static sort = function(events)
  {
    array_sort(events, function(a, b)
    {
      if (a.time != b.time)
        return a.time - b.time;

      var loop_a = a.loop
        , loop_b = b.loop
      ;

      if (loop_a == loop_b)
        return a.event_idx - b.event_idx;

      if (loop_b.__parent_intersection_policy(loop_a))
        return 1;

      return -1;
    });

    return events;
  }



  /**
   *
   */

  static group = function(events = [], epsilon_ms = SoundManager.EPSILON_MS)
  {
    var ret = []
      , event_count = array_length(events)
    ;

    if (!event_count)
      return ret;

    var event_group_time = events[0].time
      , event_group = []
    ;

    for (var i = 0; i < event_count; ++i)
    {
      var ev = events[i];

      if (abs(ev.time - event_group_time) / 1000 < epsilon_ms) {
        array_push(event_group, ev);
        continue;
      }

      array_push(ret, SoundTimelineEvent.create(event_group_time, event_group));
      event_group_time = ev.time;
      event_group = [];
    }

    array_push(ret, SoundTimelineEvent.create(event_group_time, event_group));

    return ret;
  }



  /**
   *
   */

  static build = function(sound)
  {
    var events = SoundTimeline.collect(sound);

    return SoundTimeline.group(SoundTimeline.sort(events));
  }
}












// ----------------------------------------------------------------------------












/**
 *
 */

function SoundTimelineEvent(time, nodes) constructor
{
  self.time = time;
  self.nodes = nodes;
  self.node_count = array_length(nodes);



  /**
   *
   */

  static create = function(time, nodes = [])
  {
    return new SoundTimelineEvent(time, is_array(nodes) ? nodes : [nodes]);
  }



  /**
   *
   */

  static execute = function(argv = undefined)
  {
    for (var i = 0; i < self.node_count; ++i)
      self.nodes[i].execute(argv);

    return self;
  }
}












// ----------------------------------------------------------------------------












/**
 *
 */

function SoundTimelineEventNode(loop, event_idx, settings_mask) constructor
{
  self.loop = loop;
  self.event_idx = event_idx;
  self.settings_mask = settings_mask;
  self.time = loop.start + loop.anchors[event_idx] * loop.duration();



  /**
   *
   */

  static create = function(loop, event_idx, settings_mask)
  {
    return new SoundTimelineEventNode(loop, event_idx, settings_mask);
  }



  /**
   *
   */

  static execute = function(argv = undefined)
  {
    return self.loop.execute(self.event_idx, argv);
  }
}












// ----------------------------------------------------------------------------












/**
 *
 */

function SoundTimeSource(sound, timesource_idx, time, callback, args) constructor
{
  self.sound = sound;
  self.timesource_idx = timesource_idx;
  self.timesource = time_source_create(time_source_game, time, time_source_unit_seconds, callback, args, 0, time_source_expire_nearest);



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












// ----------------------------------------------------------------------------












/**
 *
 */

function SoundSFX() : Sound() constructor
{

}












// ----------------------------------------------------------------------------












/**
 *
 */

function SoundBGS() : Sound() constructor
{

}












// ----------------------------------------------------------------------------












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
