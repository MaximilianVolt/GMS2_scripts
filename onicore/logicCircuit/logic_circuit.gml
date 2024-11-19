/**
 * Creates a new logic circuit.
 * @param {Array<Struct.LogicCircuitLiteral | Struct.LogicCircuitGate>} [components] - The components (gates or literals), in order, of the circuit.
 * @returns {Struct.LogicCircuit}
 */

function logic_circuit_create(components = [])
{
  return new LogicCircuit(is_array(components) ? components : [components]);
}



/**
 * Adds a series of components, in order, to a circuit.
 * @param {Struct.LogicCircuit} logic_circuit - The logic circuit to edit.
 * @param {Array<Struct.LogicCircuitLiteral | Struct.LogicCircuitGate>} [components] - The components (gates or literals), in order, to add to the circuit.
 * @returns {Struct.LogicCircuit}
 */

function logic_circuit_add_components(logic_circuit, components = [])
{
  return logic_circuit.__add_components(is_array(components) ? components : [components]);
}



/**
 * Returns the value of a circuit, given the previously assigned literals and gates.
 * @param {Struct.LogicCircuit} logic_circuit - The logic circuit to resolve.
 * @returns {Bool}
 */

function logic_circuit_resolve(logic_circuit)
{
  return logic_circuit.__resolve();
}



/**
 * Returns the components of a circuit.
 * @param {Struct.LogicCircuit} logic_circuit - The circuit to analyze.
 * @returns {Array<Struct.LogicCircuitComponent>}
 */

function logic_circuit_get_components(logic_circuit)
{
  return logic_circuit.components;
}



/**
 * Returns the number of components of a circuit.
 * @param {Struct.LogicCircuit} logic_circuit - The circuit to analyze.
 * @returns {Array<Struct.LogicCircuitComponent>}
 */

function logic_circuit_get_component_count(logic_circuit)
{
  return logic_circuit.component_count;
}



/**
 * Returns the literals of a circuit.
 * @param {Struct.LogicCircuit} logic_circuit - The circuit to analyze.
 * @returns {Array<Struct.LogicCircuitLiteral>}
 */

function logic_circuit_get_literals(logic_circuit)
{
  return logic_circuit.__get_literals();
}



/**
 * Returns the number of the literals of a circuit.
 * @param {Struct.LogicCircuit} logic_circuit - The circuit to analyze.
 * @returns {Array<Struct.LogicCircuitLiteral>}
 */

function logic_circuit_get_literal_count(logic_circuit)
{
  return array_length(logic_circuit.__get_literals());
}



/**
 * Returns the gates of a circuit.
 * @param {Struct.LogicCircuit} logic_circuit - The circuit to analyze.
 * @returns {Array<Struct.LogicCircuitGate>}
 */

function logic_circuit_get_gates(logic_circuit)
{
  return logic_circuit.__get_gates();
}



/**
 * Returns the number of gates of a circuit.
 * @param {Struct.LogicCircuit} logic_circuit - The circuit to analyze.
 * @param {Bool} [include_variables] - Whether it should add 1 to the size to include the inputted literals.
 * @returns {Real}
 */

function logic_circuit_get_gate_count(logic_circuit, include_variables = false)
{
  return array_length(logic_circuit.__get_gates());
}



/**
 * Returns the maximum number of gate nesting of a circuit.
 * @param {Struct.LogicCircuit} logic_circuit - The circuit to analyze.
 * @param {Bool} [include_variables] - Whether it should add 1 to the size to include the inputted literals.
 * @returns {Real}
 */

function logic_circuit_get_size(logic_circuit, include_variables = false)
{
  return logic_circuit.__get_size() + include_variables;
}



/**
 * @param {Constant.LOGIC_GATE} operation - The operation of the logic gate.
 * @param {Array<Struct.LogicCircuitComponent>} inputs - The inputs of the logic gate.
 * @param {Real | String} [label] - The label of the component.
 * @param {Real} [component_id] - The id of the component.
 * @returns {Struct.LogicCircuit}
 */

function logic_circuit_gate_create(operation, inputs, label = undefined, component_id = undefined)
{
  return new LogicCircuitGate(operation, is_array(inputs) ? inputs : [inputs], label, component_id);
}



/**
 * @param {Struct} gate_data - The data of the gate.
 * @returns {Struct.LogicCircuitGate}
 */

function logic_circuit_gate_create_from_struct(gate_data)
{
  return new LogicCircuitGate(gate_data.operation, gate_data.inputs, gate_data.label, gate_data.component_id);
}



/**
 * @param {Bool} value - The value of the literal.
 * @param {Real | String} [label] - The label of the component.
 * @param {Real} [component_id] - The id of the component.
 * @returns {Struct.LogicCircuit}
 */

function logic_circuit_literal_create(value, label = undefined, component_id = undefined)
{
  return new LogicCircuitLiteral(value, label, component_id);
}



/**
 * @param {Struct} gate_data - The data of the gate.
 * @returns {Struct.LogicCircuitLiteral}
 */

function logic_circuit_literal_create_from_struct(literal_data)
{
  return new LogicCircuitLiteral(literal_data.value, literal_data.label, literal_data.component_id);
}



//---------------------------------------------------------------------------



#region Source code

#macro LOGIC_CIRCUIT_JSON_INPUTS "inputs"
#macro LOGIC_CIRCUIT_JSON_VALUE "value"

enum LOGIC_CIRCUIT_GATE {
  LITERAL,
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
 * @param {Array<Struct.LogicCircuitLiteral | Struct.LogicCircuitGate>} components
 * @returns {Struct.LogicCircuit}
 */

function LogicCircuit(components) constructor
{
  self.components = [];
  self.component_count = 0;



  /**
   * @returns {Bool}
   */

  static __resolve = function()
  {
    return self.components[@ self.component_count - 1].__evaluate();
  }



  /**
   * @param {Array<Struct.LogicCircuitComponent>} components
   * @returns {Struct.LogicCircuit}
   */

  static __add_components = function(components)
  {
    var component_count = array_length(components);

    for (var i = 0; i < component_count; ++i)
      __add_component(components[@ i]);

    return self;
  }



  /**
   * @param {Struct.LogicCircuitComponent} component
   * @returns {Struct.LogicCircuit}
   */

  static __add_component = function(component)
  {
    self.components = array_concat(self.components, [component]);
    component.component_id = self.component_count++;

    return self;
  }



  /**
   * @returns {Array<Struct.LogicCircuitLiteral>}
   */

  static __get_literals = function(components = self.components)
  {
    return array_filter(components, function(component) {
      return is_instanceof(component, LogicCircuitLiteral)
    });
  }


  /**
   * @returns {Array<Struct.LogicCircuitGate>}
   */

  static __get_gates = function(components = self.components)
  {
    return array_filter(components, function(component) {
      return is_instanceof(component, LogicCircuitGate)
    });
  }



  /**
   * @returns {Real}
   */

  static __get_size = function()
  {
    var nesting_max = 0;
    var nesting_current = 0;
    var gates = __get_gates();
    var gates_count = array_length(gates);

    for (var i = gates_count - 1; i >= nesting_max; --i)
    {
      nesting_current = 0;
      var input_count = array_length(gates[@ i][$ LOGIC_CIRCUIT_JSON_INPUTS]);

      for (var j = 0; j < input_count; ++j)
      {
        var root = gates[@ i][$ LOGIC_CIRCUIT_JSON_INPUTS][@ j];

        for (; is_instanceof(root, LogicCircuitGate); ++nesting_current)
          root = struct_get(root, LOGIC_CIRCUIT_JSON_INPUTS);

        if (nesting_current > nesting_max)
          nesting_max = nesting_current;
      }
    }

    return nesting_max;
  }



  /**
   * @returns {String}
   */

  static __json_stringify = function()
  {
    var circuit_data = [];
    var component_count = array_length(self.components);

    for (var i = 0; i < component_count; ++i)
    {
      var component = self.components[@ i];

      var component_save_data = {
        label: component.label,
        component_id: int64(component.component_id),
        type: int64(0)
      };

      if (is_instanceof(component, LogicCircuitGate))
      {
        component_save_data.type = int64(component.operation);
        struct_set(component_save_data, LOGIC_CIRCUIT_JSON_INPUTS,
          array_map(component.inputs, function(input) {
            return int64(input.component_id);
          })
        );
      }
      else if (is_instanceof(component, LogicCircuitLiteral))
        struct_set(component_save_data, LOGIC_CIRCUIT_JSON_VALUE, int64(component.value));

      circuit_data[@ i] = component_save_data;
    }

    return json_stringify(circuit_data, true);
  }



  /**
   * @param {String} string
   * @returns {Struct.LogicCircuit}
   */

  static __json_parse = function(string)
  {
    var components = [];
    var circuit_data = json_parse(string);
    var component_count = array_length(circuit_data);

    for (var i = 0; i < component_count; ++i)
    {
      var component = circuit_data[@ i];

      if (component.type == LOGIC_CIRCUIT_GATE.LITERAL)
      {
        components[@ i] = new LogicCircuitLiteral(component.value, component.label, component.component_id);
        continue;
      }

      var inputs = [];
      var input_count = array_length(circuit_data[@ i].inputs);

      for (var j = 0; j < input_count; ++j)
        inputs[@ j] = components[@ component.inputs[@ j]];

      components[@ i] = new LogicCircuitGate(component.type, inputs, component.label, component.component_id);
    }

    return new LogicCircuit(components);
  }



  // Feather-friendly method call on constructor
  __add_components(components);
}



/**
 * @param {Real | String} label
 * @param {Real} component_id
 * @returns {Struct.LogicCircuitComponent}
 */

function LogicCircuitComponent(label, component_id)
{
  self.component_id = component_id;
  self.label = label;



  /** @abstract */

  static __evaluate = function() {}
}



/**
 * @param {Constant.LOGIC_GATE} operation
 * @param {Struct.LogicCircuitComponent | Array<Struct.LogicCircuitComponent>} inputs
 * @param {Real | String} [label]
 * @param {Real} [component_id]
 * @returns {Struct.LogicCircuitGate}
 */

function LogicCircuitGate(operation, inputs, label, component_id) : LogicCircuitComponent(label, component_id) constructor
{
  self.operation = operation;
  self.inputs = array_concat(
    LogicCircuit.__get_literals(inputs), 
    LogicCircuit.__get_gates(inputs)
  );



  /**
   * @returns {Bool}
   */

  static __evaluate = function()
  {
    var input_count = array_length(self.inputs);

    if (!input_count)
      throw ("Unexpected voided-input.");

    if (
      self.operation == LOGIC_CIRCUIT_GATE.NOT && input_count != 1
      || self.operation != LOGIC_CIRCUIT_GATE.NOT && input_count == 1
    )
      throw ("Invalid gate input count.");

    switch (self.operation)
    {
      case LOGIC_CIRCUIT_GATE.NOT:
        return !resolved_inputs[@ 0];
      case LOGIC_CIRCUIT_GATE.AND:
        return self.__all(self.inputs);
      case LOGIC_CIRCUIT_GATE.OR:
        return self.__one(self.inputs);
      case LOGIC_CIRCUIT_GATE.XOR:
        return self.__odd(self.inputs);
      case LOGIC_CIRCUIT_GATE.NAND:
        return !self.__all(self.inputs);
      case LOGIC_CIRCUIT_GATE.NOR:
        return !self.__one(self.inputs);
      case LOGIC_CIRCUIT_GATE.XNOR:
        return !self.__odd(self.inputs);
      default:
        throw ("Invalid operation type");
    }
  }



  /**
   * @param {Array<Bool>} inputs
   * @param {Real} input_count
   * @returns {Bool}
   */

  static __all = function(inputs, input_count)
  {
    var res = 1;

    for (var i = 0; i < input_count && res; ++i)
      res &= inputs[@ i].__evaluate();

    return res;
  }



  /**
   * @param {Array<Bool>} inputs
   * @param {Real} input_count
   * @returns {Bool}
   */

  static __one = function(inputs, input_count)
  {
    var res = 0;

    for (var i = 0; i < input_count && !res; ++i)
      res |= inputs[@ i].__evaluate();

    return res;
  }



  /**
   * @param {Array<Bool>} inputs
   * @param {Real} input_count
   * @returns {Bool}
   */

  static __odd = function(inputs, input_count)
  {
    var res = 0;

    for (var i = 0; i < input_count; ++i)
      res ^= inputs[@ i].__evaluate();

    return res;
  }
}



/**
 * @param {Bool} value
 * @param {Real | String} [label]
 * @param {Real} [component_id]
 */

function LogicCircuitLiteral(value, label, component_id) : LogicCircuitComponent(label, component_id) constructor
{
  self.value = value;



  /**
   * @returns {Bool}
   */

  static __evaluate = function()
  {
    return self.value;
  }
}

#endregion
