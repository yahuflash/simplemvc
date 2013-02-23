package us.sban.simplemvc.core
{
	/**
	 * 树的结构
	 *  
	 * @author sban
	 * 
	 */	
	public class TreeNode implements IDisposable
	{
		public function TreeNode(name :String)
		{
			this._name = name;
		}
		
		protected var _name :String;
		protected var _parent :TreeNode;
		protected var _nodes :Array = [];

		public function get children():Array
		{
			return _nodes;
		}

		public function get parent():TreeNode
		{
			return _parent;
		}

		public function get name():String
		{
			return _name;
		}
		
		public function get path():String
		{
			if(!_parent)
				return this.name;
			return _parent.name + " " + this.name;
		}
		
		public function find(path :String):TreeNode
		{
			if(!path)
				return null;
			
			if(path == this.name)
				return this;
			
			if(path.indexOf(" ") < 0)
				return this.getChild(path);
			
			var names :Array = path.split(" ");
			var nextName :String = names.shift();
			var next :TreeNode = this.getChild(nextName);
			if(next)
				return next.find( names.join(" ") );
			
			return null;
		}
		
		public function getChild(name :String):TreeNode
		{
			var r :TreeNode;
			_nodes.some(
				function(item :TreeNode, index:int=-1, arr:Array = null): Boolean
				{
					if(item.name == name)
					{
						r = item;
						return true;
					}
					return false;
				}
			);
			return r;
		}
		
		public function addChild(node :TreeNode):Boolean
		{
			if(this._nodes.indexOf(node) < 0)
			{
				this._nodes.push(node);
				node._parent = this;
				return true;
			}
			return false;
		}
		
		public function removeChild(node :TreeNode):Boolean
		{
			var index :int = this._nodes.indexOf(node);
			if(index > -1)
			{
				this._nodes.splice(index,1);
				node._parent = null;
				return true;
			}
			return false;
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			this._parent = null;
			this._nodes = null;
		}
		
	}
}