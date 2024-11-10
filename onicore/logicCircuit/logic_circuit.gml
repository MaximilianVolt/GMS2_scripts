/**
 * @param {Array<Struct.LogicCircuitLiteral | Struct.LogicCircuitGate>} [components] - The components (gates or literals) of the circuit. 
 * @returns {Struct.LogicCircuit}
 */

function logic_circuit_create(components = [new LogicCircuitLiteral(0)])
{
  return new LogicCircuit(is_array(components) ? components : [components]);
}



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
 * @param {Array<Struct.LogicCircuitLiteral | Struct.LogicCircuitGate>} components - The components of the circuit.
 */

function LogicCircuit(components) constructor
{
  self.components = components;



  /**
   * @returns {Bool}
   */

  static __resolve = function()
  {
    return self.components[@ array_length(self.components) - 1].__evaluate().value;
  }



  /**
   * 
   */

  static __add_component = function(component)
  {
    self.components = array_push(component);
  }

  /**
   * @returns {String}
   */

  static __json_stringify = function()
  {
    var circuit_save_state = {
      circuit_cache: ds_map_create(),
      component_count: 0,
      node_list: []
    };

    var output_node_id = self.output_node.__json_stringify(circuit_save_state);
    var circuit_data = {
      gate_list: circuit_save_state.node_list,
      output_node_id
    };

    ds_map_destroy(circuit_save_state.circuit_cache);

    return json_stringify(circuit_data, true);
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
 * @param {Constant.LOGIC_GATE} type
 * @param {Struct.LogicCircuitLiteral | Struct.LogicCircuitGate | Array<Struct.LogicCircuitLiteral | Struct.LogicCircuitGate>} inputs
 */

function LogicCircuitGate(operation, inputs) constructor
{
  self.operation = operation;
  self.gate_id = LogicCircuit.component_count++;
  self.inputs = is_array(inputs) ? inputs : [inputs];



  /**
   * @returns {Bool}
   */

  static __evaluate = function()
  {
    var input_count = array_length(self.inputs);

    if (!input_count)
      throw ("Voided-input gate provided.");

    if (
      self.operation == LOGIC_GATE.NOT && input_count != 1
      || self.operation != LOGIC_GATE.NOT && input_count == 1
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

    return {
			value: [
	      !resolved_inputs[@ 0],
	      every,
	      one,
	      odd,
	      !every,
	      !one,
	      !odd,
	    ][@ self.operation]
		};
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
      res &= inputs[@ i].value;

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
      res |= inputs[@ i].value;

    return res;
  }



  /**
   * @param {Real | Gate | Array<Real | Gate>} inputs
   * @param {Real} input_count
   * @returns {Bool}
   */

  static __odd = function(inputs, input_count)
  {
    var res = 0;

    for (var i = 0; i < input_count; ++i)
      res ^= inputs[@ i].value;

    return res;
  }



  /**
   * @param {Struct} circuit_save_state
   * @returns {String}
   */

  static __json_stringify = function(circuit_save_state)
  {
    var node_id = self.gate_id;
    var gate_operation = self.operation;

    if (ds_map_exists(circuit_save_state.circuit_cache, node_id))
      return node_id;

    var node_data = {
      type: gate_operation + 1,
      node_id
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

      if (is_gate)
        struct_set(node_data, "inputs", )

      gate_data.inputs[@ i] = {
        is_gate: input_types[is_gate],
        node_data: is_gate
          ? input.__json_stringify(circuit_save_state)
          : input
      };
    }

    circuit_save_state.gate_list[@ node_id] = node_data;
    ds_map_add(circuit_save_state.circuit_cache, node_id, node_id);

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

      inputs[@ i] = input.is_gate
        ? LogicCircuitGate.__json_parse(circuit_data, circuit_load_state, input.node_data)
        : input.node_data;
    }

    var gate = new LogicCircuitGate(gate_data.operation, inputs);
    gate.gate_id = gate_id;

    ds_map_add(circuit_load_state.circuit_cache, gate_id, gate.gate_id);

    return gate;
  }
}



/**
 * @param {Real} value
 */

function LogicCircuitLiteral(value) constructor
{
  self.value = value;
  self.literal_id = LogicCircuit.component_count++;
}