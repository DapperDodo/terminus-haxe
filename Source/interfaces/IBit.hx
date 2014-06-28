package interfaces;

/*
	interface

	bithelper

	purpose: helper functions for bit<>Int encoding/decoding
*/
interface IBitHelper
{
	public function setBit(byte : Int, bitIdx : Int, bitVal : Int) : Int;

	public function setBitBool(byte : Int, bitIdx : Int, bitVal : Bool) : Int;

	public function getBit(byte : Int, bitIdx : Int) : Int;

	public function getBitBool(byte : Int, bitIdx : Int) : Bool;

	public function swapBits(byte : Int, bitIdx1 : Int, bitIdx2 : Int) : Int;
}