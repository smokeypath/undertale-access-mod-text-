var filename = argument0;
var file_buffer = buffer_load(filename);
var json = buffer_read(file_buffer, buffer_string);
buffer_delete(file_buffer);
return json_decode(json);
