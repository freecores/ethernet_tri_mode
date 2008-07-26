if test -d work
then
echo work is ready
else
vlib work
echo work is created
fi

vlog -f vlog-$1.list 

if test $? -ne 0
then
echo compiling err occured...
exit 1
fi

if [ $1 = rtl ]
then
    vsim tb_top -pli ip_32W_gen.dll -pli ip_32W_check.dll $2 -do "run -all"
else
    vsim glbl tb_top -pli ip_32W_gen.dll -pli ip_32W_check.dll
fi    

