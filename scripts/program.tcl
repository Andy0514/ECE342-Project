
set usb [lindex [get_hardware_names] 0]

set all_devices [get_device_names -hardware_name $usb]

set device_id 0
foreach device $all_devices {
  incr device_id
  if {[string first "5CSE" $device] != -1} {
    set device_name $device
    break
  }
}

if { $device_id == 0} {
    error "No suitable device found"
}

# assume the .sof file is in output_files directory, and there's only one of it
set bitstream [glob ../output_files/*.sof]

if {[string length $bitstream] == 0} {
  error "No programming file found"
} else {
  puts "Found programming file $bitstream, will proceed to program it"
}

set program_operation "P;$bitstream@$device_id"
if {[catch {exec quartus_pgm -c $usb -m JTAG -o $program_operation} result]} {
	puts "\nResult: $result\n"
	puts "ERROR: Programming failed.\n"
} else {
	puts "Programming successful!"
}
