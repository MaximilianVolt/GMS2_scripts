enum LOGIC_GATE_INPUTS {
  LITERAL,
  GATE
}



enum LOGIC_GATE {
  NOT,
  AND,
  OR,
  XOR,
  NAND,
  NOR,
  XNOR,
  COUNT
}



/**
 * @param {LogicCircuitGate} output_gate - The output gate of the circuit.
 */

function LogicCircuit(output_gate) constructor
{
  self.output_gate = output_gate;



  /**
   * @returns {Bool}
   */

  static __resolve = function()
  {
    return self.output_gate.__evaluate();
  }



  /**
   * @returns {String}
   */

  static __json_stringify = function()
  {
    var circuit_save_state = {
      circuit_cache: ds_map_create(),
      gate_list: [],
      gate_id: 0
    };

    var output_gate_id = self.output_gate.__json_stringify(circuit_save_state);
    var circuit_data = {
      gate_list: circuit_save_state.gate_list,
      output_gate_id
    };

    ds_map_destroy(circuit_save_state.circuit_cache);

    return json_stringify(circuit_data);
  }



  /**
   * @param {String} string
   * @returns {Struct.LogicCircuit}
   */

  static __json_parse = function(string)
  {
    var circuit_data = json_parse(string);

    var circuit_load_state = {
      circuit_cache: ds_map_create()
    };

    var output_gate = LogicCircuitGate.__json_parse(circuit_data, circuit_load_state, circuit_data.output_gate_id);

    ds_map_destroy(circuit_load_state.circuit_cache);

    return new LogicCircuit(output_gate);
  }
}



/**
 * @param {Constant.LOGIC_GATE} type - The type of the logic gate.
 * @param {Real | Gate | Array<Real | Gate>} inputs - The inputs of the gate.
 */

function LogicCircuitGate(type, inputs) constructor
{
  self.type = type;
  self.gate_id = gate_id++;
  self.inputs = is_array(inputs) ? inputs : [inputs];

  static gate_id = 0;



  /**
   * @returns {Bool}
   */

  static __evaluate = function()
  {
    var input_count = array_length(self.inputs);

    if (!input_count)
      throw ("Voided-input gate provided.");

    if (
      self.type == LOGIC_GATE.NOT && input_count != 1
      || self.type != LOGIC_GATE.NOT && input_count == 1
    )
      throw ("Invalid gate input count.");

    var resolved_inputs = array_map(self.inputs, function(input) {
      return is_instanceof(input, LogicCircuitGate)
        ? input.__evaluate()
        : input;
    });

    var one = self.__one(resolved_inputs, input_count)
      , odd = self.__odd(resolved_inputs, input_count)
      , every = self.__every(resolved_inputs, input_count);

    return [
      !resolved_inputs[@ 0],
      every,
      one,
      odd,
      !every,
      !one,
      !odd,
    ][@ self.type];
  }



  /**
   * @param {Real | Gate | Array<Real | Gate>} inputs
   * @param {Real} input_count
   * @returns {Bool}
   */

  static __every = function(inputs, input_count)
  {
    var res = 1;

    for (var i = 0; i < input_count && res; ++i)
      res &= inputs[@ i];

    return res;
  }



  /**
   * @param {Real | Gate | Array<Real | Gate>} inputs
   * @param {Real} input_count
   * @returns {Bool}
   */

  static __one = function(inputs, input_count)
  {
    var res = 0;

    for (var i = 0; i < input_count && !res; ++i)
      res |= inputs[@ i];

    return res;
  }



  /**
   * @param {Real | Gate | Array<Real | Gate>} inputs
   * @param {Real} input_count
   * @returns {Bool}
   */

  static __odd = function(inputs, input_count)
  {
    var count = 0;

    for (var i = 0; i < input_count; ++i)
      count += inputs[@ i] & 1;

    return count & 1;
  }



  /**
   * @param {Struct} circuit_save_state
   * @returns {String}
   */

  static __json_stringify = function(circuit_save_state)
  {
    var gate_id = self.gate_id;
    var gate_type = self.type;

    if (ds_map_exists(circuit_save_state.circuit_cache, gate_id))
      return gate_id;

    var gate_data = {
      type: gate_type,
      inputs: [],
      gate_id
    };

    var input_count = array_length(self.inputs);
    var input_types = [
      LOGIC_GATE_INPUTS.LITERAL,
      LOGIC_GATE_INPUTS.GATE
    ];

    for (var i = 0; i < input_count; ++i)
    {
      var input = self.inputs[@ i];
      var is_gate = is_instanceof(input, LogicCircuitGate);

      gate_data.inputs[@ i] = {
        type: input_types[is_gate],
        value: is_gate
          ? input.__json_stringify(circuit_save_state)
          : input
      };
    }

		circuit_save_state.gate_list[@ gate_id] = gate_data;
    ds_map_add(circuit_save_state.circuit_cache, gate_id, gate_id);

    return gate_id;
  }



  /**
   * @param {Struct} circuit_data
   * @param {Struct} circuit_load_state
   * @param {Real} gate_id
   * @returns {Struct.LogicCircuitGate}
   */

  static __json_parse = function(circuit_data, circuit_load_state, gate_id)
  {
    if (ds_map_exists(circuit_load_state.circuit_cache, gate_id))
      return circuit_load_state.circuit_cache[? gate_id];

    var gate_data = circuit_data.gate_list[@ gate_id];
    var input_count = array_length(gate_data.inputs);
    var inputs = [];

    for (var i = 0; i < input_count; ++i)
    {
      var input = gate_data.inputs[@ i];

      inputs[@ i] = input.type == LOGIC_GATE_INPUTS.GATE
        ? LogicCircuitGate.__json_parse(circuit_data, circuit_load_state, input.value)
        : input.value;
    }

    var gate = new LogicCircuitGate(gate_data.type, inputs);
    gate.gate_id = gate_id;

    ds_map_add(circuit_load_state.circuit_cache, gate_id, gate.gate_id);

    return gate;
  }
}