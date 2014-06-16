package core;

import interfaces.IVision;

/*
	structure for storing tracking data about vision-providing units
*/
typedef IUnit = 
{
	id : String,
	tx : Int, 
	ty : Int,
	radius : Float
};

class VisionUnitStore implements IVisionUnitStore
{
	// here's where we keep record of our tracked units
	private var unitsTracked : Map<String, IUnit>;

	public function new()
	{
		unitsTracked = new Map<String, IUnit>();
	}

	/*
		return true if unit has moved or has not yet been tracked
		return false if unit is still within the same tile
	*/
	public function update(unitId : String, tx : Int, ty : Int, radius : Float) : Bool
	{
		if(unitsTracked.exists(unitId))
		{
			var unit : IUnit = unitsTracked.get(unitId);
			if(unit.tx == tx && unit.ty == ty)
			{
				// has not moved
				return false;
			}
			else
			{
				// update position to new tile
				unit.tx = tx;
				unit.ty = ty;
			}
		}
		else
		{
			// track this unit
			unitsTracked.set(unitId, {id : unitId, tx : tx, ty : ty, radius : radius});
		}

		return true;
	}
}