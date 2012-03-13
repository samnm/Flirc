package vg.sam.flirc.events
{
	import flash.events.Event;
	
	import vg.sam.flirc.IRCMessage;
	
	public class IRCConnectionEvent extends Event
	{
		public static const MESSAGE_RECIEVED:String = "MESSAGE_RECIEVED";
		public static const MESSAGE_SENT:String = "MESSAGE_SENT";
		
		public static const CONNECTED:String = "CONNECTED";
		
		public var message:IRCMessage;
		
		public function IRCConnectionEvent(type:String, message:IRCMessage = null)
		{
			super(type, bubbles, cancelable);
			
			this.message = message;
		}
	}
}