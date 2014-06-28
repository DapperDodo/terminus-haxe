package core;

import interfaces.IBit;

class BitHelper implements IBitHelper
{
	public function new(){}

	public function swapBits(byte : Int, bitIdx1 : Int, bitIdx2 : Int)
	{
		var bit1 : Int = getBit(byte, bitIdx1);
		var bit2 : Int = getBit(byte, bitIdx2);
		byte = setBit(byte, bitIdx2, bit1);
		byte = setBit(byte, bitIdx1, bit2);
		return byte;
	}

	public function getBit(byte : Int, bitIdx : Int) : Int
	{
		return ((byte >> bitIdx) & 1);
	}

	// untested!
	public function getBitBool(byte : Int, bitIdx : Int) : Bool
	{
		return (((byte >> bitIdx) & 1) == 1);
	}

	public function setBit(byte : Int, bitIdx : Int, bitVal : Int) : Int
	{
		if(bitVal == 1)
		{
			return (byte | (1 << bitIdx));
		}
		else
		{
			return (byte & ~(1 << bitIdx));
		}
	}

	public function setBitBool(byte : Int, bitIdx : Int, bitVal : Bool) : Int
	{
		if(bitVal)
		{
			return (byte | (1 << bitIdx));
		}
		else
		{
			return (byte & ~(1 << bitIdx));
		}
	}

	// untested!
	public function toggleBit(byte : Int, bitIdx : Int)
	{
		return byte ^ (1 << bitIdx);
	}
}