package
{
	import flash.geom.Matrix3D;

	public class Matrix3DUtils
	{

		public static function makeMatrix3D(x:Number, y:Number, z:Number, rx:Number, ry:Number, rz:Number, sx:Number = 1, sy:Number = 1, sz:Number = 1):Matrix3D
		{
			var matrix3D:Matrix3D = new Matrix3D(Vector.<Number>([ //
				cos(ry) * cos(rz) * sx, cos(ry) * sin(rz) * sy, -sin(ry) * sz, 0, //
				sin(rx) * sin(ry) * cos(rz) * sx - cos(rx) * sin(rz) * sx, sin(rx) * sin(ry) * sin(rz) * sy + cos(rx) * cos(rz) * sy, sin(rx) * cos(ry) * sz, 0, //
				cos(rx) * sin(ry) * cos(rz) * sx + sin(rx) * sin(rz) * sx, cos(rx) * sin(ry) * sin(rz) * sy - sin(rx) * cos(rz) * sy, cos(rx) * cos(ry) * sz, 0, //
				x, y, z, 1, //
				//
				]));

			return matrix3D;
		}

		public static function makeMatrix3D1(x:Number, y:Number, z:Number, rx:Number, ry:Number, rz:Number, sx:Number = 1, sy:Number = 1, sz:Number = 1):Matrix3D
		{
			var matrix3D:Matrix3D = new Matrix3D(Vector.<Number>([ //
				cos(ry) * cos(rz) * sx, cos(ry) * sin(rz) * sx, -sin(ry) * sx, 0, //
				sin(rx) * sin(ry) * cos(rz) * sy - cos(rx) * sin(rz) * sy, sin(rx) * sin(ry) * sin(rz) * sy + cos(rx) * cos(rz) * sy, sin(rx) * cos(ry) * sy, 0, //
				cos(rx) * sin(ry) * cos(rz) * sz + sin(rx) * sin(rz) * sz, cos(rx) * sin(ry) * sin(rz) * sz - sin(rx) * cos(rz) * sz, cos(rx) * cos(ry) * sz, 0, //
				x, y, z, 1, //
				//
				]));

			return matrix3D;
		}

		public static function appendRotationXYZ(rx:Number, ry:Number, rz:Number):Matrix3D
		{
			var matrix3D:Matrix3D = new Matrix3D(Vector.<Number>([ //
				cos(ry) * cos(rz), cos(ry) * sin(rz), -sin(ry), 0, //
				sin(rx) * sin(ry) * cos(rz) - cos(rx) * sin(rz), sin(rx) * sin(ry) * sin(rz) + cos(rx) * cos(rz), sin(rx) * cos(ry), 0, //
				cos(rx) * sin(ry) * cos(rz) + sin(rx) * sin(rz), cos(rx) * sin(ry) * sin(rz) - sin(rx) * cos(rz), cos(rx) * cos(ry), 0, //
				0, 0, 0, 1, //
				//
				]));

			return matrix3D;
		}

		public static function appendRotationXY(rx:Number, ry:Number):Matrix3D
		{
			var matrix3D:Matrix3D = new Matrix3D(Vector.<Number>([ //
				cos(ry), 0, -sin(ry), 0, //
				sin(rx) * sin(ry), cos(rx), sin(rx) * cos(ry), 0, //
				cos(rx) * sin(ry), -sin(rx), cos(rx) * cos(ry), 0, //
				0, 0, 0, 1, //
				//
				]));

			return matrix3D;
		}


		public static function appendRotationX(rx:Number):Matrix3D
		{
			var matrix3D:Matrix3D = new Matrix3D(Vector.<Number>([ //
				1, 0, 0, 0, //
				0, cos(rx), sin(rx), 0, //
				0, -sin(rx), cos(rx), 0, //
				0, 0, 0, 1, //
				//
				]));

			return matrix3D;
		}

		public static function appendRotationY(ry:Number):Matrix3D
		{
			var matrix3D:Matrix3D = new Matrix3D(Vector.<Number>([ //
				cos(ry), 0, -sin(ry), 0, //
				0, 1, 0, 0, //
				sin(ry), 0, cos(ry), 0, //
				0, 0, 0, 1, //
				//
				]));

			return matrix3D;
		}

		public static function appendRotationZ(rz:Number):Matrix3D
		{
			var matrix3D:Matrix3D = new Matrix3D(Vector.<Number>([ //
				cos(rz), sin(rz), 0, 0, //
				-sin(rz), cos(rz), 0, 0, //
				0, 0, 1, 0, //
				0, 0, 0, 1, //
				//
				]));

			return matrix3D;
		}

		/**
		 * 比较矩阵是否相等
		 */
		public static function compare(matrix3D:Matrix3D, matrix3D1:Matrix3D, precision:Number = 0.0001):Boolean
		{
			var r2:Vector.<Number> = matrix3D.rawData;
			for (var i:int = 0; i < 16; ++i)
			{
				if (Math.abs(matrix3D1.rawData[i] - r2[i]) > precision)
					return false;
			}

			return true;
		}

		public static function sin(rx:Number):Number
		{
			return Math.sin(rx / 180 * Math.PI);
		}

		public static function cos(rx:Number):Number
		{
			return Math.cos(rx / 180 * Math.PI);
		}
	}
}
