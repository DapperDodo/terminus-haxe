package interfaces;

import openfl.display.BitmapData;

import interfaces.IVision;

/*
	manage instances of masks of bitmapdata identified by an edge shape
*/
interface IFogMaskFactory
{
	public function instance(shape : Int) : BitmapData;
}

/*
	project fog layers onto a background bitmap
*/
interface IFogTileProjector
{
	/*
		project a tile from the base image onto the destination image
		this is used where vision on this tile is uniform
	*/
	public function bake(tile : IVisionTile, dest : BitmapData, base : BitmapData) : Void;

	/*
		project a tile from the base image onto the destination image, with a masked overlay
		this is used for edge shapes, on tiles where there is a boundary between two vision types
	*/
	public function bakeEdge(tile : IVisionTile, dest : BitmapData, base : BitmapData, layer : BitmapData) : Void;
}