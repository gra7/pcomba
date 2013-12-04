using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace WaterDemo
{
	class Rock
	{
		public Vector2 Position, Velocity;
		static readonly Vector2 Gravity = new Vector2(0, 0.3f);

		public void Update(Water water)
		{
			if (Position.Y > water.GetHeight(Position.X))
				Velocity *= 0.84f;

			Position += Velocity;
			Velocity += Gravity;
		}

		public void Draw(SpriteBatch spriteBatch, Texture2D texture)
		{
			Vector2 origin = new Vector2(texture.Width, texture.Height) / 2f;
			spriteBatch.Draw(texture, Position, null, Color.White, 0f, origin, 1f, 0, 0);
		}
	}
}
