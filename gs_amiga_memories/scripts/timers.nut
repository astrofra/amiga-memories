g_timer_table		<-	{}

//--------------------------------------------------
//	Timer generic routine
//--------------------------------------------------
function	WaitForTimer(timer_name, timer_duration)
//--------------------------------------------------
{
	//	Does this timer already exist?
	if (!(timer_name in g_timer_table))
		g_timer_table.rawset(timer_name, g_clock)
	else
	{
		print("FixedSecToTick(timer_duration) = " + FixedSecToTick(timer_duration))
		print("g_clock - g_timer_table[timer_name] = " + (g_clock - g_timer_table[timer_name]).tostring())
		if (g_clock - g_timer_table[timer_name] >= FixedSecToTick(timer_duration))
			return false
	}
	return true
}

//--------------------------------
function	ResetTimer(timer_name)
//--------------------------------
{
	g_timer_table.rawdelete(timer_name)
}