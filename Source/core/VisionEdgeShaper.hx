package core;

import interfaces.IVision;
import interfaces.IBit;

class VisionEdgeShaper implements IVisionEdgeShaper
{
	var bitHelper : IBitHelper;

	public function new(bitHelper : IBitHelper)
	{
		this.bitHelper = bitHelper;
	}

	public function getShape(straightBefore : Bool, straightAfter : Bool, octant : Int) : IVisionTileShape
	{
		var shape : Int = 0;
		if(straightBefore && straightAfter)
		{
			//  	[v]
			// .	[?]
			// 		[v]
			// shape:
			// 	110
			// 	110
			// 	110
			// bin: 011011011
			shape = 0x0db;
		}
		else if(straightBefore && !straightAfter)
		{
			// .	[v]
			// 		[?]
			// 	 [v]
			// shape:
			// 	100
			// 	100
			// 	000
			// bin: 000001001
			shape = 0x009;
		}
		else if(!straightBefore && straightAfter)
		{
			// .	       [v]
			// 	 		[?]
			// 	 		[v]
			// shape:
			// 	111
			// 	110
			// 	110
			// bin: 011011111
			shape = 0x0df;
		}
		else if(!straightBefore && !straightAfter)
		{
			// .
			//	       [v]
			// 	 	[?]
			// 	 [v]
			// shape:
			// 	110
			// 	100
			// 	000
			// bin: 000001011
			shape = 0x00b;
		}		

		//	the above basic shapes are for octant 1, given these 8 octants:
		//
		//     6 7
		//   5     8
		//   4     1
		//     3 2
		//	now flip X or Y coords, or diagonally, to convert the shape to other octants

		switch(octant)
		{
			case 1: 
				return shape;
			case 2:
				return flipDiagonally(shape);
			case 3:
				return flipX(flipDiagonally(shape));
			case 4:
				return flipX(shape);
			case 5:
				return flipX(flipY(shape));
			case 6:
				return flipX(flipY(flipDiagonally(shape)));
			case 7:
				return flipY(flipDiagonally(shape));
			case 8:
				return flipY(shape);

			default:
				trace("VisionEdgeShaper encountered unknown octant: ["+octant+"]");
				return 0;
		}
	}

	////////////////////////////////////
	// private parts
	////////////////////////////////////

	private function flipDiagonally(shape : Int) : Int
	{
		shape = bitHelper.swapBits(shape, 1, 3);
		shape = bitHelper.swapBits(shape, 2, 6);
		shape = bitHelper.swapBits(shape, 5, 7);
		return shape;
	}

	private function flipX(shape : Int) : Int
	{
		shape = bitHelper.swapBits(shape, 0, 2);
		shape = bitHelper.swapBits(shape, 3, 5);
		shape = bitHelper.swapBits(shape, 6, 8);
		return shape;
	}

	private function flipY(shape : Int) : Int
	{
		shape = bitHelper.swapBits(shape, 0, 6);
		shape = bitHelper.swapBits(shape, 1, 7);
		shape = bitHelper.swapBits(shape, 2, 8);
		return shape;
	}
}