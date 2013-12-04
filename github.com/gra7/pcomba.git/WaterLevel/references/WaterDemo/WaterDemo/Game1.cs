using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.GamerServices;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Media;

namespace WaterDemo
{
	/// <summary>
	/// This is the main type for your game
	/// </summary>
	public class Game1 : Microsoft.Xna.Framework.Game
	{
		GraphicsDeviceManager graphics;
		SpriteBatch spriteBatch;
		Water water;
		KeyboardState keyState, lastKeyState;
		MouseState mouseState, lastMouseState;
		SpriteFont font;
		Texture2D particleImage, backgroundImage, rockImage;

		Rock rock;

		public Game1()
		{
			graphics = new GraphicsDeviceManager(this);
			Content.RootDirectory = "Content";
			graphics.PreferMultiSampling = true;
			IsMouseVisible = true;
		}

		protected override void Initialize()
		{
			base.Initialize();
		}

		protected override void LoadContent()
		{
			spriteBatch = new SpriteBatch(GraphicsDevice);
			font = Content.Load<SpriteFont>("Font");
			particleImage = Content.Load<Texture2D>("metaparticle");
			backgroundImage = Content.Load<Texture2D>("sky");
			rockImage = Content.Load<Texture2D>("rock");
			water = new Water(GraphicsDevice, particleImage);
		}

		protected override void Update(GameTime gameTime)
		{
			if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed)
				this.Exit();

			lastKeyState = keyState;
			keyState = Keyboard.GetState();
			lastMouseState = mouseState;
			mouseState = Mouse.GetState();

			water.Update();

			// Allow user to adjust the water's properties
			const float factor = 63f / 64f;
			if (keyState.IsKeyDown(Keys.Q))
				water.Tension *= factor;
			if (keyState.IsKeyDown(Keys.W))
				water.Tension /= factor;
			if (keyState.IsKeyDown(Keys.A))
				water.Dampening *= factor;
			if (keyState.IsKeyDown(Keys.S))
				water.Dampening /= factor;
			if (keyState.IsKeyDown(Keys.Z))
				water.Spread *= factor;
			if (keyState.IsKeyDown(Keys.X))
				water.Spread /= factor;

			Vector2 mousePos = new Vector2(mouseState.X, mouseState.Y);
			// if the user clicked down, create a rock.
			if (lastMouseState.LeftButton == ButtonState.Released && mouseState.LeftButton == ButtonState.Pressed)
			{
				rock = new Rock
					{
						Position = mousePos,
						Velocity = (mousePos - new Vector2(lastMouseState.X, lastMouseState.Y)) / 5f
					};
			}

			// update the rock if it exists
			if (rock != null)
			{
				if (rock.Position.Y < 240 && rock.Position.Y + rock.Velocity.Y >= 240)
					water.Splash(rock.Position.X, rock.Velocity.Y * rock.Velocity.Y * 5);

				rock.Update(water);

				if (rock.Position.Y > GraphicsDevice.Viewport.Height + rockImage.Height)
					rock = null;
			}

			base.Update(gameTime);
		}

		bool WasPressed(Keys key)
		{
			return keyState.IsKeyDown(key) && !lastKeyState.IsKeyDown(key);
		}

		protected override void Draw(GameTime gameTime)
		{
			// We must draw to render targets before we start drawing to the backbuffer. You can't draw some
			// stuff to the backbuffer, switch to a render target, and then switch back to the backbuffer. The
			// backbuffer won't be preserved. (Technically you could use RenderTargetUsage.PreserveContents, 
			// but this is slow on some platforms and has no benefit over our current method.)
			water.DrawToRenderTargets();
			
			spriteBatch.Begin();
			spriteBatch.Draw(backgroundImage, Vector2.Zero, Color.White);

			if (rock != null)
				rock.Draw(spriteBatch, rockImage);

			spriteBatch.End();

			water.Draw();

			spriteBatch.Begin();
			spriteBatch.DrawString(font, "Use Q, W, A, S, Z, and X to adjust the water's properties", new Vector2(5), Color.Black);
			spriteBatch.DrawString(font, "Tension: " + water.Tension.ToString("g2"), new Vector2(5, 25), Color.Black);
			spriteBatch.DrawString(font, "Dampening: " + water.Dampening.ToString("g2"), new Vector2(5, 45), Color.Black);
			spriteBatch.DrawString(font, "Spread: " + water.Spread.ToString("g2"), new Vector2(5, 65), Color.Black);
			spriteBatch.End();

			base.Draw(gameTime);
		}
	}
}
