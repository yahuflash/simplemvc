package us.sban.simplemvc.core.injection
{
	import flash.utils.Dictionary;
	
	import us.sban.simplemvc.core.ISimpleEventDispatcher;
	import us.sban.simplemvc.core.simplemvc_internal;
	
	use namespace simplemvc_internal;

	public class BeanEventHandlerProcessor extends BeanProcessor
	{
		public function BeanEventHandlerProcessor() {}
		
		private var handlers:Dictionary = new Dictionary(true);
		private var _dispatchers:Vector.<ISimpleEventDispatcher>;

		override public function setUp(targetBean:SimpleBean, beans:SimpleBeanSet):void
		{
			var target:Object = targetBean.instance;
			if (!target) return;

			var classDescriptor:SimpleClassDescriptor = $.injection.classDescriptor(target);
			var eventHandlers:Array = classDescriptor.membersByMetaTag(MetaTagKind.EVENT_HANDLER);

			for each(var method:ClassMemberDescriptor in eventHandlers)
			{
				var metaTag:MetaTagDescriptor = method.tagByName(MetaTagKind.EVENT_HANDLER);
				var arg:MetaTagArgDescriptor = metaTag.argByKey(MetaTagArgKind.EVENT);

				var eventName:String = getEventName(arg);

				var eventHandler:EventHandler = addToDispatchers(eventName, target[method.name], metaTag);

				if (handlers[target] == null)
				{
					handlers[target] = [];
				}

				handlers[target].push(eventHandler);
			}
		}

		override public function tearDown(bean:SimpleBean):void
		{
			if (handlers[bean.instance] == null)
				return;

			for each(var handler:EventHandler in handlers[bean.instance]){
				$.globalDispatcher.removeEventListener(handler.type, handler.handleEvent);
			}

			handlers[bean] = [];
		}

		private function getEventName(arg:MetaTagArgDescriptor):String
		{
			var dots:Array = arg.value.split(".");

			if (dots.length == 1)
			{
				return arg.value;
			}
			else
			{
				throw new Error("invalid event type");
			}
		}

		public function addToDispatchers(event:String, handler:Function, tag:MetaTagDescriptor):EventHandler
		{
			var eventHandler:EventHandler = new EventHandler(event, handler, tag);

			$.globalDispatcher.addEventListener(event, eventHandler.handleEvent);

			return eventHandler;
		}
	}
}

import starling.events.Event;

import us.sban.simplemvc.core.injection.MetaTagArgDescriptor;
import us.sban.simplemvc.core.injection.MetaTagArgKind;
import us.sban.simplemvc.core.injection.MetaTagDescriptor;
import us.sban.simplemvc.util.StringUtil;

class EventHandler
{
	public var type:String;

	private var handler:Function;
	private var args:Array;

	public function EventHandler(type:String, handler:Function, tag:MetaTagDescriptor)
	{
		this.type = type;
		this.handler = handler;

		var arg:MetaTagArgDescriptor = tag.argByKey(MetaTagArgKind.PROPERTIES);

		if (arg)
			args = String(arg.value).split(",");
	}

	public function handleEvent(event:Event):void
	{
		var handlerArgs:Array = [];

		for each(var arg:String in args)
		{
			arg = StringUtil.removeWhitespace(arg);

			if (event.hasOwnProperty(arg))
			{
				handlerArgs.push(event[arg]);
			}
			else
			{
				throw new Error("property not found:"+arg);
			}
		}

		if (handlerArgs.length > 0)
		{
			handler.apply(null, handlerArgs);
		}
		else
		{
			handler(event);
		}
	}
}
