function logtimes()
{
    echo "`date`" $@
}
function signout()
{
    if [ $x = @ ]
    then
	> $p.ans
	logtimes "$p has loged out" >> /home/emertxe/LAB/projectkkt/projectloins.log
	start $@
    fi
}
function start()
{
    echo "1.Sign in
    2.Sign up
    3.exit"
    read x
    if [ $x = 2 ]
    then
	function username()
	{
	    echo "Signup screen
	    Please enter the details"
	    echo -n  "username:"
	    read a
	    declare -a check1=(`cut -d ' ' -f1 pro.txt`)
	    for ((i=0; i<${#check1[@]}; i++))
	    do
		if [ $a = ${check1[$i]} ]
		then
		    echo "The user name is already exist..please Try different!"
		    echo
		    username $@
		fi
	    done
	}
	username $@
	declare -a usernames=$a
	function password()
	{
	    echo -n "Password:"
	    read x
	    pass=$x
	    n="${#pass[$@]}"
	    if [ $n -lt 8 ]
	    then
		echo "pass is short"
		password $@
	    else
		echo -n "renterpass:"
		read y
		if [ $y != $x ]
		then
		    echo "password mismatches
		    Please re-enter the details"
		    password $@
		fi
	    fi
	}
	password $@
	declare -a password=$x
	echo -n "${usernames[@]}" "${password[@]}" >>pro.txt
	echo >>pro.txt
	echo "Please Signin"
	start $@
    fi
    if [ $x = 1 ]
    then
	function signin()
	{
	    echo "Sign in screen"
	    echo -n "Username:"
	    read p
	    echo -n "Password:"
	    read -s q
	    declare -a check=(`cut -d ' ' -f1 pro.txt`)
	    declare -a pass=(`cut -d ' ' -f2 pro.txt`)
	    for ((i=0; i<${#check[@]}; i++))
	    do
		if [ $p = ${check[$i]} ]
		then
		    k=$i
		    a=$p
		fi
	    done
	    for ((j=0; j<${#pass[@]}; j++))
	    do
		if [ "$q" = "${pass[$k]}" ]
		then
		    b=$q
		fi
	    done
	    if [ "$p" != "$a" ]
	    then
		echo "USERNAME DOESNT EXIST
		PLEASE REGISTER"
		start $@
	    elif [ "$b" != "$q" -o -z "$q" ]
	    then
		echo "INVALID PASSWORD"
		signin $@
	    fi
	}
	signin $@
	if [ "$p" = "$a" -a "$q" = "$b" ]
	then
	    echo  
	    logtimes  "$p has loged in" >> /home/emertxe/LAB/projectkkt/projectloins.log
	    function answer()
	    {
		TMOUT=10
		export TMOUT
		echo "enter the answer"
		read y
		b=$y
		echo -n "${b[@]} " >> $p.ans
		echo $y >> $p.txt
		if [ -z "$y" ]
		then
		    echo "not attempted" >> $p.txt
		fi
	    }
	    function ask()
	    {
		echo "Test screen"
		echo "1.Take test
		2.View test
		@.signout"
		read x
		if [ $x = 1 ]
		then
		    echo "TEST STARTS"
		    echo
		    line=$(cat ./questions.txt|wc -l)
		    l=`expr $line / 2`
		    arr=(`shuf -i 1-$l -n$l`)
		    date >>$p.txt
		    for ((j=0; j<$l; j++))
		    do
			k=`expr ${arr[$j]} \* 2`
			cat ./questions.txt|grep '^'${arr[$j]}''>> $p.txt
			cat ./questions.txt|grep '^'${arr[$j]}
			sed -n ''$k'p' ./questions.txt
			answer $@
		    done
		    ask $@
		fi
		if [ $x = 2 ]
		then
		    if [[ -s $p.txt ]]
		    then
			cat $p.txt
			count=0
			tej=0
			for ((i=0; i<4; i++))
			do
			    a=(`cut -d ' ' -f${arr[$i]} ans.txt`)
			    count=`expr $count + 1`
			    c=(`cut -d ' ' -f$count $p.ans`)
			    if [ "$c" = "$a" ]
			    then
				tej=`expr $tej + 1`
			    fi
			done
			echo "YOUR SCORE IS $tej"
			signout $@
			echo "YOU ARE SIGNEDOUT....IF U WANT TO CONTINUE...PLZZ SIGNIN"
			start$@
		    else
			echo "Test not yet started"
			signout $@
		    fi
		fi
		signout$@
	    }
	    ask $@
	fi
    fi

}
start $@
