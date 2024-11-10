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
 * @param {Array<Struct.LogicCircuitLiteral | Struct.LogicCircuitGate>} components
 * @returns {Struct.LogicCircuit}
 */

function LogicCircuit(components) constructor
{
  self.components = [];
  self.component_count = 0;

  var component_count = array_length(components);

  for (var i = 0; i < component_count; ++i)
    __add_component(components[@ i]);



  /**
   * @returns {Bool}
   */

  static __resolve = function()
  {
    return self.components[@ self.component_count - 1].__evaluate();
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
        component_save_data.type = int64(component.operation + 1);
        struct_set(component_save_data, "inputs",
          array_map(component.inputs, function(input) {
            return int64(input.component_id);
          })
        );
      }
      else if (is_instanceof(component, LogicCircuitLiteral))
        struct_set(component_save_data, "value", int64(component.value));

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

      if (component.type == LOGIC_GATE_INPUTS.LITERAL)
      {
        components[@ i] = new LogicCircuitLiteral(component.value, component.label, component.component_id);
        continue;
      }

      var inputs = [];
      var input_count = array_length(circuit_data[@ i].inputs);

      for (var j = 0; j < input_count; ++j)
        inputs[@ j] = components[@ component.inputs[@ j]];

      components[@ i] = new LogicCircuitGate(component.type - 1, inputs, component.label, component.component_id);
    }

    return new LogicCircuit(components);
  }
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

function LogicCircuitGate(operation, inputs, label = undefined, component_id = undefined) : LogicCircuitComponent(label, component_id) constructor
{
  self.operation = operation;
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
      return input.__evaluate();
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
    ][@ self.operation];
  }



  /**
   * @param {Array<Bool>} inputs
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
   * @param {Array<Bool>} inputs
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
   * @param {Array<Bool>} inputs
   * @param {Real} input_count
   * @returns {Bool}
   */

  static __odd = function(inputs, input_count)
  {
    var res = 0;

    for (var i = 0; i < input_count; ++i)
      res ^= inputs[@ i];

    return res;
  }
}



/**
 * @param {Bool} value
 * @param {Real | String} [label]
 * @param {Real} [component_id]
 */

function LogicCircuitLiteral(value, label = undefined, component_id = undefined) : LogicCircuitComponent(label, component_id) constructor
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