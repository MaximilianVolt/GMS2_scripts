function hex_pathfinding_node(_node)
{
  return {
    node: _node,
    explored: false,
    parent: undefined,
    neighbors: [],
    explore: function(_parent = undefined) {
      self.explored = true;
      self.parent = _parent;
      return self;
    },
  };
}



function hex_pathfinding_prepare(_grid)
{
  var _map = ds_map_create();

  // Mappa tutte le celle della griglia
  for (var i = array_length(_grid) - 1; i >= 0; --i) {
    var n = hex_pathfinding_node(_grid[i]);
    ds_map_add(_map, _grid[i], n);
  }

  // Collegamento dei vicini
  var keys = ds_map_keys(_map);

  for (var i = array_length(keys) - 1; i >= 0; --i)
  {
    var node = ds_map_find_value(_map, keys[i]);

    for (var d = 0; d < 6; ++d)
    {
      var neigh = hex_neighbor(node.node, d);

      if (ds_map_exists(_map, neigh)) {
        array_push(node.neighbors, ds_map_find_value(_map, neigh));
      }
    }
  }

  return _map;
}



function hex_pathfinding(_start, _goal, _grid = undefined, _traversable = function(tile) { return true; })
{
  var _graph = hex_pathfinding_prepare()
    , _queue = ds_queue_create()
    , start = ds_map_find_value(_graph, _start)
    , goal  = ds_map_find_value(_graph, _goal)
    , ret = []
  ;

  ds_queue_enqueue(_queue, start.explore());

  while (!ds_queue_empty(_queue))
  {
    var v = ds_queue_dequeue(_queue);

    if (v == goal) {
      ret = hex_pathfinding_reconstruct_path(v);
      break;
    }

    for (var i = array_length(v.neighbors) - 1; i >= 0; --i)
    {
      var n = v.neighbors[i];

      if (!n.explored && _traversable(n)) {
        ds_queue_enqueue(_queue, n.explore(v));
      }
    }
  }

  ds_queue_destroy(_queue);
  ds_map_destroy(_graph);

  return ret;
}



function hex_pathfinding_reconstruct_path(_target)
{
  var path = []
    , current = _target
  ;

  while (current) {
    array_push(path, current.node);
    current = current.parent;
  }

  return array_reverse(path);
}