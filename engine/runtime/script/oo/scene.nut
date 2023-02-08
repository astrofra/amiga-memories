/*!
	@short  Scene record binding.

	The scene record object stores several snapshot of the scene members
	transformation taken at different times and provides a way to record and
	playback a scene evolution in time. (TODO rephrase)

	Scene I/O flags.
	These flags are bit fields and can be combined together.
	Example: import_mask = Light | Object | Globals;

	FlagLoadCamera, FlagLoadLight, FlagLoadObject, FlagLoadTrigger, FlagLoadGroup,
	FlagLoadSettings, FlagLoadGlobals, FlagLoadMotion, FlagLoadCollision,
	FlagLoadPhysic, FlagLoadAll

	@author Emmanuel Julien (barr@ninomojo.com)
*/
class		Record
{
	scene			=	0;
	handle			=	0;

/*!
	@name	Snapshot
	@{
*/

	/// Record a snapshot of the scene in its current state.
	function		Snapshot()
	{	SceneRecordSnapshot(scene, handle);	}
	/*!
		@short	Snapshot a given material.
		@param	material	(Material) The material to snapshot.
	*/
	function		SnaphotMaterial(material)
	{	SceneRecordSnapshotMaterial(scene, handle, material);	}

/// @}

/*!
	@short	Playback
	@{
*/

	/// Start record replay.
	function		StartReplay()
	{	SceneRecordStartReplay(scene, handle);	}
	/*!
		@short	Replay record.

		This function should be called in place of the standard Scene::Update().
		It will interpolate between available samples to recreate the scene
		configuration at the requested timecode.

		@param	timecode	(Time) Timecode to reproduce.
							Time origin is absolute in the record (0).
		@see	Record::GetDuration()
	*/
	function		Replay(timecode)
	{	SceneRecordReplay(scene, handle, timecode);	}
	/// End record replay.
	function		EndReplay()
	{	SceneRecordEndReplay(scene, handle);	}

///	@}

/*!
	@name	Management
	@{
*/

	/*!
		@short	Drop all samples in a record that were recorded before a given delay.
		@param	delay	(Time) Delay after wich samples get dropped.
	*/
	function		DropOlderSamples(delay)
	{	SceneRecordDropOlderSamples(scene, handle, delay);	}
	/// Finalize a record, prepare it for replay.
	function		Finalize(record)
	{	SceneRecordFinalize(scene, handle);	}

///	@}

/*!
	@name	Informations
	@{
*/

	/*!
		@short	Get record duration.
		@return (Time) Record duration.
	*/
	function		GetDuration()
	{	return SceneRecordGetDuration(handle);	}
	/*!
		@short	Get record memory footprint.
		@return (Integer) Record memory footprint in bytes.
	*/
	function		MemoryFootprint()
	{	return SceneRecordMemoryFootPrint(handle);	}

///	@}

	constructor(s, h)
	{
		scene = s;
		handle = h;
	}
}


/*!
	@short	Scene binding.
	@author Emmanuel Julien (barr@ninomojo.com)
*/
class		Scene
{
	handle			=	0;

/*!
	@name   Content setup
	@{
*/

	/*!
		@short  Scene setup.
		Setup all scene members and associated resources if needs be.
		Script units OnSetup() callbacks are called when defined.
	*/
	function    Setup()
	{	return SceneSetup(handle);	}
	/*!
		@short  Scene setup test.
		@return (Bool) true if setup, false otherwise.
	*/
	function    IsSetup()
	{	return SceneIsSetup(handle);	}
	/*!
		@short  Scene reset.
		Reset all scene members. Items are reset back to their starting
		transformations, script units OnReset() callbacks are called, the
		collision and physic systems are reset as well.
	*/
	function 	Reset()
	{	return SceneReset(handle);	}
	/*!
		@short  Scene reset script.
		Restricted scene reset. Script units OnReset() callbacks are called.
	*/
	function 	ResetScript()
	{	return SceneResetScript(handle);	}
	/*!
		@short  Record starting transformations.
		For each item record current transformation as default transformation.
		Subsequent calls to Scene::Reset() will bring all items back to this
		recorded transformation.
	*/
	function    RecordLocation()
	{	return SceneRecordLocation(handle);	}
	
	function	AddItem(item_name)
	{	return Item(ObjectGetItem(SceneAddObject(handle, item_name)));	}

/// @}

/*!
	@name   Runtime
	@{
*/
	function        GetCurrentCamera()
	{	return Camera(SceneGetCurrentCamera(handle));	}
	/*!
		@short	Set current camera.
		@param  c   (Camera) Camera to set as current camera.
	*/
	function		SetCurrentCamera(c)
	{	SceneSetCurrentCamera(handle, c.GetHandle());	}
	/*!
		@short  Scene update.
		All scene members are updated, the collision and physic systems are
		updated as well. This is the main high-level runtime scene management
		call.
	*/
	function 	Update()
	{	return SceneUpdate(handle);	}

	/*!
		@short  Set item deletion delay.

		Prevents item from being freed from memory for at least the given delay.
		This is useful when, for example, recording the content of a scene where
		items are created and destroyed at runtime.

		@param  delay   (Float) Item deletion delay.
		@see	Sec()
	*/
	function	SetItemDeletionDelay(delay)
	{	SceneSetItemDeletionDelay(handle, delay);	}

/// @}

/*!
	@name   Content raytracing
	@note   These functions are designed to perform raytracing in order to
			support AI systems, not for raytracing pictures.
	@see	Raytracer for raytracing pictures of a scene.
	@{
*/

	/*!
		@short  Raytrace scene triggers.
		@param  s   (Vector) Source of the ray.
		@param  d   (Vector) Direction of the ray.
		@param  l   (Float) Maximum ray length.
		@return (Item) Closest intersected trigger item.
	*/
	function	RaytraceTriggerList(s, d, l)
	{	return SceneRaytraceTriggerList(s, d, l);	}

/// @}

/*!
	@name   Content management
	@{
*/

	/*!
		@short	Find item in scene from its identifier.
		@param  id  	(String) Item name.
		@return (item) Scene item if found, check with Item::IsValid().
	*/
	function		FindItem(id)
	{	return Item(SceneFindItem(handle, id));	}
	/*!
		@short	Find item's child from its identifier.
		@param  item    (Item) Parent item.
		@param  id		(String) Child item name.
		@return (Item) Scene item if found, check with Item::IsValid().
	*/
	function		FindItemChild(item, child_id)
	{	return Item(SceneFindItemChild(handle, item.handle, child_id));	}
	/*!
		@short	Find camera in scene from its identifier.
		@param  id  	(String) Camera name.
		@return (Camera) Camera if found, check with Item::IsValid().
	*/
	function		FindCamera(id)
	{	return Camera(ItemCastToCamera(SceneFindItem(handle, id)));	}
	/*!
		@short	Find group in scene from its identifier.
		@param  id  (String) Group name.
		@return (Group) Group if found, check with Group::IsValid().
	*/
	function		FindGroup(id)
	{	return Group(SceneFindGroup(id));	}

	/// Delete content.
	function        DeleteContent()
	{	return SceneDeleteContent(handle);	}

/// @}

/*!
	@name   Rendering
	@{
*/
	/// Render scene content.
	function        Render()
	{	SceneRender(handle);	}
	/// Render scene to renderer queue.
	function        RenderQueue()
	{	SceneRenderToQueue(handle);	}
/// @}

/*!
	@name   Debugging/profiling
	@note	These are slow functions meant for debugging usage only.
	@{
*/
	/*!
		@short	Display on-screen debug informations.

		This function draws all members bounding-box and hotspot.
		<b>Should be called each frame</b>.
	*/
	function        Debug()
	{	SceneDebug(handle);	}
	/// Draw all scene AI paths, <b>should be called each frame</b>.
	function        DebugPath()
	{	SceneDebugPath(handle);	}
	/// Draw all physic contact point and constraints, <b>should be called each frame</b>.
	function        DebugPhysicSystem()
	{	SceneDebugPhysicSystem(handle);  }
	/// Draw all item collision shapes, <b>should be called each frame</b>.
	function        DebugCollisionSystem()
	{	SceneDebugCollisionSystem(handle);	}

	/*!
		@short Create UI based profiler.

		@param  desc    Raster font description.
		@param  face    Raster font face image file.

		@note	This profiler supports much more advanced features than its
				writer based counterpart but since it is based on the UI system
				it is also much slower.
	*/
	function        CreateProfiler(desc, face)
	{	SceneCreateProfiler(handle, desc, face);	}

	/// Print scene item members id to the log.
	function        PrintItemList()
	{	ScenePrintItemList(handle);	}
/// @}

/*!
	@name   UI user interface (Window system)
	@{
*/

	/*!
		@short		Get scene window system.
		@return	(UI) The scene window system.
	*/
	function		GetUI()
	{	return UI(SceneGetWindowSystem(handle));	}
	/// Render window system.
	function        RenderUI()
	{	SceneRenderUI(handle);	}

/// @}

/*!
	@name   Physic system.
	@{
*/

	/*!
		@short  Allocate collision node.

		@param  max_node    (Integer) Set the maximum number of collision pair
							that can be registered during a single update.
		@param	max_contact (Integer) Set the maximum number of contacts that
							can be registered during a single update.
							Note that this is note a maximum per pair but on the
							whole system.
	*/
	function		PhysicAllocateCollisionNode(max_node, max_contact)
	{	ScenePhysicAllocateCollisionNode(max_node, max_contact);	}
	/*!
		@short	Enable or disable the physic system deactivation.

		In order to speed up the physic system, physic items can be deactivated
		once they settled in position and woke up when an event setting them
		back in motion occurs.
		To prevent unwanted artefacts such as late wake you can globally disable
		physic item deactivation. Note however that the simulation will run much
		slower if you do.

		@param  enable      (Bool) Enable/disable flag.
	*/
	function        PhysicEnableDeactivation(enable)
	{	ScenePhysicEnableDeactivation(handle, enable);	}
	/*!
		@short	Set the number of contact iterations the physic solver can take.
		@param  step        (Integer) Maximum number of steps to take.
	*/
	function		SetPhysicContactSolverIteration(step)
	{	SceneSetPhysicContactSolverIteration(handle, step);	}
	/*!
		@short	Set the number of constraint iterations the physic solver can take.
		@param  step        (Integer) Maximum number of steps to take.
	*/
	function		SetPhysicConstraintSolverIteration(step)
	{	SceneSetPhysicConstraintSolverIteration(handle, step);	}
	/*!
		@short	Set the physic system frequency.
		@param  fq          (Float) Frequency in hertz. (Default: 75hz)
		@note   The physic system frequency is decoupled from the display
				frequency. The physic system output is interpolated to match the
				current display frequency.
	*/
	function        SetPhysicFrequency(fq)
	{	SceneSetPhysicFrequency(handle, fq);	}
	/*!
		@short	Get the physic system frequency.
		@return (Float) Physic system frequency in hertz.
	*/
	function		GetPhysicFrequency()
	{	return SceneGetPhysicFrequency(handle); }

///	@}

/*!
	@name	Recording system.
	@note	These functions enables recording the scene execution, storing item
			transformation changes and replaying the scene at a later time.
	@{
*/

	/*!
		@short	Create a new scene record.
		@warning	As this is not a managed resource it is your responsibility
					to delete the record once you do not need it anymore.
		@see		Scene::RecordDelete().
	*/
	function		RecordNew()
	{	return Record(handle, SceneRecordNew());	}
	/*!
		@short	Delete a scene record.
		@param	record	(Record) The record to delete.
	*/
	function		RecordDelete(record)
	{	SceneRecordDelete(record.handle);	}

///	@}

/*!
	@name	I/O
	@{
*/

	/*!
		@short		Load/append scene from file.
		@param  path    (String) File path.
		@return	(Bool) true on success, false otherwise.
	*/
	function		FromNML(path)
	{	return SceneFromNML(handle, path);	}
	/*!
		@short		Load/append scene from file, store result as a group.
		@param  path    (String) File path.
		@param  flag    (Scene::IOFlag) I/O flags to control what to load.
		@return	(Group) A group containing all scene elements loaded.
	*/
	function		FromNMLStoreGroup(path, flag)
	{	return Group(SceneFromNMLStoreGroup(handle, path, flag));	}

/// @}

	function		GetHandle()
	{	return handle;	}
	constructor(h)
	{	handle = h;	}
}
