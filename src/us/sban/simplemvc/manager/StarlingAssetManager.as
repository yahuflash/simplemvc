package us.sban.simplemvc.manager
{
	import flash.display.Bitmap;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * 
	 * 使用纹理图集是优化的有效方法之一
	 * 建议使用位图字体
	 * 
	 *以Application.getDefinition() ，ApplicationDomain.getQualifiedDefinitionNames()方法获取类定义，完成初始化操作。
	 * 而不是由用户初始化，用户按照约定的名称正确定义即可。
	 *  
	 * @author sban
	 * 
	 */	
	public class StarlingAssetManager
	{
		private static var instance :StarlingAssetManager;
		public static function getInstance():StarlingAssetManager
		{
			return (instance ||= new StarlingAssetManager);
		}
		public function StarlingAssetManager()
		{
		}
		
		public var textureAtlas:TextureAtlas;
		
		/**必须在Starling初始化之后进行设置*/
		public function init(AtlasTexture_Class:Class,AtlasXml_Class:Class):void
		{
			// TODO Auto Generated method stub
			var bitmap:Bitmap = new AtlasTexture_Class();
			var texture:Texture = Texture.fromBitmap(bitmap);
			var xml:XML = XML(new AtlasXml_Class());
			textureAtlas=new TextureAtlas(texture, xml);
		}
	}
}