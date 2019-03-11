BEGIN {
sent=0;
received=0;
time = 0;
time1 = 0;
p0 = 0;
sent1 = 0;
p1 =0;
}
{
  if($1=="r" && $3 == "_1_" && $4=="AGT" )
   {
    sent++
    p0 = p0+$8
    time = $2
    a = time*100000
    b = sent*p0*8
    z = b/a
   }
  if($1=="r" && $4=="AGT" && $3 == "_2_")
   {
     sent1++
     p1 = p1+$8
     time1 =$1
    a = time*100000
    b = sent*p0*8
    z = b/a
   }
 
}
END {

printf("%f Mbps \n",z);
printf("%f Mbps \n",z);
}
