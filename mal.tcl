
 set val(chan)         Channel/WirelessChannel  ;# channel type
 set val(prop)         Propagation/TwoRayGround ;# radio-propagation model
 set val(ant)          Antenna/OmniAntenna      ;# Antenna type
 set val(ll)           LL                       ;# Link layer type
 set val(ifq)          Queue/DropTail/PriQueue  ;# Interface queue type
 set val(ifqlen)       50                       ;# max packet in ifq
 set val(netif)        Phy/WirelessPhy          ;# network interface type
 set val(mac)          Mac/802_11               ;# MAC type
 set val(nn)           100                    ;# number of mobilenodes
 set val(rp)           AODV                     ;# routing protocol
 set val(x)            5000
 set val(y)            5000



set ns [new Simulator]
#ns-random 0

set f [open out.tr w]
$ns trace-all $f
set namtrace [open out.nam w]
$ns namtrace-all-wireless $namtrace $val(x) $val(y)
set topo [new Topography]
$topo load_flatgrid 5000 5000

create-god $val(nn)

set chan_1 [new $val(chan)]
set chan_2 [new $val(chan)]
set chan_3 [new $val(chan)]
set chan_4 [new $val(chan)]
set chan_5 [new $val(chan)]
set chan_6 [new $val(chan)]
set chan_7 [new $val(chan)]
set chan_8 [new $val(chan)]
set chan_9 [new $val(chan)]
set chan_10 [new $val(chan)]

# CONFIGURE AND CREATE NODES

$ns node-config  -adhocRouting $val(rp) \
          -llType $val(ll) \
                 -macType $val(mac) \
                 -ifqType $val(ifq) \
                 -ifqLen $val(ifqlen) \
                 -antType $val(ant) \
                 -propType $val(prop) \
                 -phyType $val(netif) \
                 #-channelType $val(chan) \
                 -topoInstance $topo \
                 -agentTrace ON \
                 -routerTrace ON \
                 -macTrace ON \
                 -movementTrace OFF \
                 -channel $chan_1

proc finish {} {
    global ns namtrace
    $ns flush-trace
        close $namtrace 
        exec nam -r 5m out.nam &
    exit 0
}

# define color index
$ns color 0 blue
$ns color 1 red
$ns color 2 chocolate
$ns color 3 red
$ns color 4 brown
$ns color 5 tan
$ns color 6 gold
$ns color 7 black
$ns color 8 pink
$ns color 9 green

                      
set n(0) [$ns node]
$ns at 0.0 "$n(0) color blue"
$n(0) color "0"
$n(0) shape "circle"
set n(1) [$ns node]
$ns at 0.0 "$n(1) color red"
$n(1) color "blue"
$n(1) shape "circle"

for {set i 2} {$i < $val(nn)} {incr i} {
   set n($i) [$ns node]
   $ns at 0.0 "$n($i) color blue"
   $n($i) color "0"
   $n($i) shape "circle"
}


for {set i 0} {$i < $val(nn)} {incr i} {
    $ns initial_node_pos $n($i) 30+i*100
}
$ns at 0.0 "[$n(50) set ragent_] malicious"  
        
#$ns at 0.0 "$n(0) setdest 100.0 200.0 3000.0"
#$ns at 0.0 "$n(1) setdest 200.0 300.0 3000.0"
#$ns at 0.0 "$n(2) setdest 300.0 400.0 3000.0"
#$ns at 0.0 "$n(3) setdest 400.0 500.0 3000.0"
#$ns at 0.0 "$n(4) setdest 500.0 600.0 3000.0"
#$ns at 0.0 "$n(5) setdest 600.0 700.0 3000.0"

$ns at 10.000000 "$n(0) setdest 160 450 75"
$ns at 10.000000 "$n(1) setdest 343.017365 158.321411 12.667036"
$ns at 10.000000 "$n(2) setdest 943.017365 58.321411 16.667036"
$ns at 4.000000  "$n(3) setdest 2755 360 20"
$ns at 10.000000 "$n(4) setdest 960 1320 10"
$ns at 10.000000 "$n(5) setdest 343.017365 258.321411 11.667036"

$ns at 10.000000 "$n(6) setdest 2700.00 1500.00 64.935"
$ns at 10.000000 "$n(7) setdest 100 800 83.9130 "
$ns at 10.000000 "$n(8) setdest 500 1200 66.612 "

$ns at 10.000000 "$n(15) setdest 2700 1200 12.9682 "
$ns at 10.000000 "$n(25) setdest 150 1400 36.484 "
$ns at 10.000000 "$n(28) setdest 170 180 23.5053"


for {set i 10} {$i < $val(nn)} {incr i} {
    $ns at 0.0 "$n($i) setdest [expr rand()*$i*20 +500.0] [expr rand()*$i*20 + 500.0] 4000.0"
}




# CONFIGURE AND SET UP A FLOW

set sink0 [new Agent/LossMonitor]
set sink1 [new Agent/LossMonitor]
set sink2 [new Agent/LossMonitor]
set sink3 [new Agent/LossMonitor]
set sink4 [new Agent/LossMonitor]
set sink5 [new Agent/LossMonitor]
set sink6 [new Agent/LossMonitor]
set sink7 [new Agent/LossMonitor]
set sink8 [new Agent/LossMonitor]
set sink9 [new Agent/LossMonitor]
$ns attach-agent $n(0) $sink0
$ns attach-agent $n(1) $sink1
$ns attach-agent $n(2) $sink2
$ns attach-agent $n(3) $sink3
$ns attach-agent $n(4) $sink4
$ns attach-agent $n(5) $sink5
$ns attach-agent $n(6) $sink6
$ns attach-agent $n(7) $sink7
$ns attach-agent $n(8) $sink8
$ns attach-agent $n(9) $sink9


#$ns attach-agent $sink2 $sink3
set tcp0 [new Agent/TCP]
$ns attach-agent $n(0) $tcp0
set tcp1 [new Agent/TCP]
$ns attach-agent $n(1) $tcp1
set tcp2 [new Agent/TCP]
$ns attach-agent $n(2) $tcp2
set tcp3 [new Agent/TCP]
$ns attach-agent $n(3) $tcp3
set tcp4 [new Agent/TCP]
$ns attach-agent $n(4) $tcp4
set tcp5 [new Agent/TCP]
$ns attach-agent $n(5) $tcp5
set tcp6 [new Agent/TCP]
$ns attach-agent $n(6) $tcp6
set tcp7 [new Agent/TCP]
$ns attach-agent $n(7) $tcp7
set tcp8 [new Agent/TCP]
$ns attach-agent $n(8) $tcp8
set tcp9 [new Agent/TCP]
$ns attach-agent $n(9) $tcp9


proc attach-CBR-traffic { node sink size interval } {
   #Get an instance of the simulator
   set ns [Simulator instance]
   #Create a CBR  agent and attach it to the node
   set cbr [new Agent/CBR]
   $ns attach-agent $node $cbr
   $cbr set packetSize_ $size
   $cbr set interval_ $interval

   #Attach CBR source to sink;
   $ns connect $cbr $sink
   return $cbr
  }

set cbr0 [attach-CBR-traffic $n(0) $sink5 1000 .030]
$ns at 0.5 "$cbr0 start"
$ns at 5.5 "finish"
puts "Start of simulation.."
$ns run
