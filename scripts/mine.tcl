
proc bin2dec {bin} {
  set result 0
  set string_length [string length $bin]
  for {set i [expr $string_length - 1]} {$i >= 0} {incr i -1} {
    set corresponding_index [expr {$string_length - $i - 1}]
    if {[string index $bin $corresponding_index] == 1} {
      set result [expr {$result+pow(2, $i)}]
    }
  }
  return $result
}


set usb [lindex [get_hardware_names] 0]

set all_devices [get_device_names -hardware_name $usb]

set device_name "None"
foreach device $all_devices {
  if {[string first "5CSE" $device] != -1} {
    set device_name $device
  }
}

if { $device_name eq "None"} {
    error "No suitable device found"
}

puts "Starting probe for device $device_name - $usb"
start_insystem_source_probe -device_name $device_name -hardware_name $usb


#read_probe_data -instance_index 0 - STP_OUTPUT_DONE
#                                1 - STP_OUTPUT_NONCE
#write_source_data -instance_index 0 - STP_INPUT_CALCULATE
#                                  2 - STP_INPUT_MIDSTATE
#                                  3 - STP_INPUT_TARGET
#                                  4 - STP_INPUT_DATA


write_source_data -instance_index 2 -value_in_hex -value 9fd47d57faf88825063461d541602d390d6660430815e94bbf5de76d74b4c79d
write_source_data -instance_index 3 -value_in_hex -value 0000000000006a93b30000000000000000000000000000000000000000000000
write_source_data -instance_index 4 -value_in_hex -value 1a65600ea6c8cb4db3936a1a
write_source_data -instance_index 0 -value 1
write_source_data -instance_index 0 -value 0

puts "Mining..."

while {1} {
  set done_signal [read_probe_data -instance_index 0]

  if {$done_signal} {
    break
  }
}

set nonce [read_probe_data -instance_index 1]
puts [bin2dec $nonce]
