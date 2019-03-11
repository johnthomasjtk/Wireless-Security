
set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             3                          ;# number of mobilenodes
set val(rp)             DSDV                        ;# routing protocol
set val(x)              600   			   ;# X dimension of topography
set val(y)              600   			   ;# Y dimension of topography  
set val(stop)		200			   ;# time of simulation end

set ns		  [new Simulator]
set tracefd       [open simple.tr w]
set windowVsTime2 [open win.tr w] 
set namtrace      [open simple.nam w]    

$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)


set topo       [new Topography]

$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)



        $ns node-config -adhocRouting $val(rp) \
			 -llType $val(ll) \
			 -macType $val(mac) \
			 -ifqType $val(ifq) \
			 -ifqLen $val(ifqlen) \
			 -antType $val(ant) \
			 -propType $val(prop) \
			 -phyType $val(netif) \
			 -channelType $val(chan) \
			 -topoInstance $topo \
			 -agentTrace ON \
			 -routerTrace ON \
			 -macTrace OFF \
			 -movementTrace ON
			 
	for {set i 0} {$i < $val(nn) } { incr i } {
		set node_($i) [$ns node]	
	}


$node_(0) set X_ 5.0
$node_(0) set Y_ 5.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 490.0
$node_(1) set Y_ 285.0
$node_(1) set Z_ 0.0

$node_(2) set X_ 150.0
$node_(2) set Y_ 240.0
$node_(2) set Z_ 0.0


set tcp [new Agent/TCP/Newreno]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp
$ns attach-agent $node_(1) $sink
$ns connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 10.0 "$ftp start" 

set tcp0 [new Agent/TCP/Newreno]
$tcp0 set class_ 2
set sink0 [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp0
$ns attach-agent $node_(1) $sink0
$ns connect $tcp0 $sink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 10.0 "$ftp0 start" 

set tcp1 [new Agent/TCP/Newreno]
$tcp1 set class_ 2
set sink1 [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp1
$ns attach-agent $node_(1) $sink1
$ns connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 10.0 "$ftp1 start" 

for {set i 0} {$i < $val(nn)} { incr i } {

$ns initial_node_pos $node_($i) 30
}


 
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at 200.01 "puts \"end simulation\" ; $ns halt"

proc stop {} {
    global ns tracefd namtrace
    $ns flush-trace
    close $tracefd
    close $namtrace
}

$ns run

