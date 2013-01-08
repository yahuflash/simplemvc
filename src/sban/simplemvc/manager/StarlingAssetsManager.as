package sban.simplemvc.manager
{
	import flash.display.Bitmap;
	
	import sban.simplemvc.core.IInitializable;
	import sban.simplemvc.core.StarlingApplication;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * This class holds all embedded textures, fonts and sounds and other embedded files.  
	 * By using static access methods, only one instance of the asset file is instantiated. This 
	 * means that all Image types that use the same bitmap will use the same Texture on the video card.
	 * 
	 * @author hsharma
	 * 
	 */
	public class StarlingAssetsManager implements IInitializable
	{
		public static const single :StarlingAssetsManager = new StarlingAssetsManager;
		
		public function StarlingAssetsManager()
		{
		}
		
		private var textureAtlas:TextureAtlas;
		
		/**必须在Starling初始化之后进行设置*/
		public function initialize():void
		{
			var atlasTextureClass:Class = StarlingApplication.application.AtlasTexture_Class;
			var atlasXmlClass:Class = StarlingApplication.application.AtlasXml_Class;
			// TODO Auto Generated method stub
			var bitmap:Bitmap = new atlasTextureClass();
			var texture:Texture = Texture.fromBitmap(bitmap);
			var xml:XML = XML(new atlasXmlClass());
			textureAtlas=new TextureAtlas(texture, xml);
		}
		
		public function getTexture(name :String):Texture
		{
			return textureAtlas.getTexture(name);
		}
	}
}
