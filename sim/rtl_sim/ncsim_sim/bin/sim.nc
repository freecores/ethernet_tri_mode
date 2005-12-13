ncvlog -f vlog.list -logfile ../log/ncvlog.log

if test $? -ne 0
then
echo compiling err occured...
exit 1
fi

ncelab work.tb_top -loadvpi ip_32W_gen_vpi:PLI_register -loadvpi ip_32W_check_vpi:PLI_register -snapshot work:snap -timescale 1ns/1ps -message -access +rw -logfile ../log/ncelab.log

if test $? -ne 0
then
echo ncelab err occured...
exit 1
fi

ncsim work:snap $1 -UNBUFFERED -logfile ../log/ncsim.log -NOKEY 

