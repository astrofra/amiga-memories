# 
#	File: scripts/thread_handler.nut
#	Author: Astrofra
# 

def GenericThreadWait(s):
	# _timeout = g_clock
	#
	# while ((g_clock - _timeout) < FixedSecToTick(Sec(s)))
	# 	suspend()
	pass

def RawClockThreadWait(s):
	# local	_timeout = 0.0
	#
	# while (_timeout < Sec(s)):
	# 	_timeout += g_raw_dt_frame
	# 	suspend()
	pass

# !
#	@short	ThreadHandler
#	@author	Astrofra
# 
class ThreadHandler:

	def __init__(self, scene = None):
		self.thread_list = []
		self.current_scene = scene

	def Update(self):
		self.HandleThreadList()

	def CreateThread(self, _thread_name):
		# self.thread_list.append({name = _thread_name, handle = 0})
		# local	_thread = self.thread_list[self.thread_list.len() - 1]
		# _thread.handle = newthread(_thread.name)
		# _thread.handle.call(self.current_scene)
		pass

	def DestroyThread(self, _thread_name):
		# for idx, _thread in self.thread_list:
		# 	if _thread.name == _thread_name:
		# 		_thread.handle = 0
		# 		self.thread_list.remove(idx)
		pass
	
	def HandleThreadList(self):
		# for _thread in self.thread_list:
		# 	if _thread.handle == 0:
		# 		return
		#
		# 	if _thread.handle.getstatus() == "suspended":
		# 		_thread.handle.wakeup()
		# 	else:
		# 		for idx, _thread_to_remove in self.thread_list:
		# 			if _thread_to_remove.handle == _thread.handle:
		# 				_thread_to_remove.handle = 0
		# 				self.thread_list.remove(idx)
		pass