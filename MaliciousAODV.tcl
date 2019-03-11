#malicious node generation AODV program in tcl JOHN
 

 set val(ifq)          Queue/DropTail/PriQueue  ;
 set val(ifqlen)       50                       ;
 set val(netif)        Phy/WirelessPhy          ;
 set val(mac)          Mac/802_11               ;
 set val(nn)           100                      ;
 set val(rp)           AODV                     ;
 set val(x)            4000			;
 set val(y)            4000			;
 set val(chan)         Channel/WirelessChannel  ;
 set val(prop)         Propagation/TwoRayGround ;
 set val(ant)          Antenna/OmniAntenna      ;
 set val(ll)           LL                       ;



set ns [new Simulator]
#ns-random 0

set f [open output.tr w]
$ns trace-all $f
set namtrace [open output.nam w]
$ns namtrace-all-wireless $namtrace $val(x) $val(y)
set topo [new Topography]
$topo load_flatgrid 4000 4000

create-god $val(nn)

set chan_1 [new $val(chan)]
set chan_2 [new $val(chan)]
set chan_3 [new $val(chan)]
set chan_4 [new $val(chan)]
set chan_5 [new $val(chan)]
set chan_6 [new $val(chan)]


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
        exec nam -r 5m output.nam &
    exit 0
}

#colour of the nodes
$ns color 0 blue
$ns color 1 red
$ns color 2 chocolate
$ns color 3 red
$ns color 4 brown
$ns color 5 tan
$ns color 6 gold
$ns color 7 black
                      
set n(0) [$ns node]

$n(0) color "0"
$n(0) shape "circle"
set n(1) [$ns node]
$ns at 0.0 "$n(1) color blue"
$n(1) color "blue"
$n(1) shape "circle"


#set chan_1 [new $val(chan)]
#set chan_2 [new $val(chan)]
#set chan_3 [new $val(chan)]
#set chan_4 [new $val(chan)]
#set chan_5 [new $val(chan)]
#set chan_6 [new $val(chan)]





for {set i 2} {$i < $val(nn)} {incr i} {
   set n($i) [$ns node]
   $ns at 0.0 "$n($i) color blue"
   $n($i) color "0"
   $n($i) shape "circle"
}

#$n(0) color "0"
#$n(0) shape "circle"
#set n(1) [$ns node]
#$ns at 0.0 "$n(1) color blue"
#$n(1) color "blue"
#$n(1) shape "circle"
#for {set i 0} {$i < $val(nn)} {incr i} {
    #$ns initial_node_pos $n($i) 30+i*100
#}
for {set i 10} {$i <30 } {incr i} {
$ns at 0.0 "$n($i) color red"    
$n($i) color "red"
$ns at 0.0 "[$n($i) set ragent_] malicious"  
}

$ns at 0.0 "$n(0) setdest 100.0 350.0 3000.0"
$ns at 0.0 "$n(1) setdest 200.0 450.0 3000.0"
$ns at 0.0 "$n(2) setdest 300.0 650.0 3000.0"
$ns at 0.0 "$n(3) setdest 400.0 750.0 3000.0"
$ns at 0.0 "$n(4) setdest 500.0 950.0 3000.0"
$ns at 0.0 "$n(5) setdest 600.0 850.0 3000.0"



 
for {set i 10} {$i < $val(nn)} {incr i} {
    $ns at 0.0 "$n($i) setdest [expr rand()*$i*30+500.0] [expr rand()*$i*30+500.0] 3000.0"
}






set sink0 [new Agent/LossMonitor]
set sink1 [new Agent/LossMonitor]
set sink2 [new Agent/LossMonitor]
set sink3 [new Agent/LossMonitor]
set sink4 [new Agent/LossMonitor]
set sink5 [new Agent/LossMonitor]



$ns attach-agent $n(70) $sink0
$ns attach-agent $n(71) $sink1
$ns attach-agent $n(72) $sink2
$ns attach-agent $n(73) $sink3
$ns attach-agent $n(74) $sink4
$ns attach-agent $n(75) $sink5


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


proc attach-CBR-traffic { node sink size interval } {
  
   set ns [Simulator instance]
   
   set cbr [new Agent/CBR]
   $ns attach-agent $node $cbr
   $cbr set packetSize_ $size
   $cbr set interval_ $interval

   
   $ns connect $cbr $sink
   return $cbr
  }

set cbr0 [attach-CBR-traffic $n(0) $sink5 1000 .030]
$ns at 0.5 "$cbr0 start"
$ns at 20.5 "finish"
puts "Start of simulation.."
$ns run
