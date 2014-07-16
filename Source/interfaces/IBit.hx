package interfaces;

/*
	interface

	bithelper

	purpose: helper functions for bit<>Int encoding/decoding
*/
interface IBitHelper
{
	/*
		byte    : the byte of which you want to set a bit
		bitIdx  : index of the bit to set (right [0] to left [n])
		bitVal  : value of the bit to set; must be 0 or 1
		returns : the byte with the bit set
	*/
	public function setBit(byte : Int, bitIdx : Int, bitVal : Int) : Int;

	/*
		byte    : the byte of which you want to get a bit
		bitIdx  : index of the bit to set (right [0] to left [n])
		returns : the bit as an Int (0 or 1)
	*/
	public function getBit(byte : Int, bitIdx : Int) : Int;


	/*
		byte    : the byte of which you want to set a bit
		bitIdx  : index of the bit to set (right [0] to left [n])
		bitVal  : value of the bit to set; true = 1, false = 0
		returns : the byte with the bit set
	*/
	public function setBitBool(byte : Int, bitIdx : Int, bitVal : Bool) : Int;

	/*
		byte    : the byte of which you want to get a bit
		bitIdx  : index of the bit to set (right [0] to left [n])
		returns : the bit as a Bool (true = 1, false = 0)
	*/
	public function getBitBool(byte : Int, bitIdx : Int) : Bool;

	/*
		byte    : the byte in which you want to swap two bits
		bitIdx1 : index of the first bit of the pair to swap (right [0] to left [n])
		bitIdx2 : index of the second bit of the pair to swap (right [0] to left [n])
		returns : the byte with the two bits swapped
	*/
	public function swapBits(byte : Int, bitIdx1 : Int, bitIdx2 : Int) : Int;
}