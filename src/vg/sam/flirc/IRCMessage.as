package vg.sam.flirc
{
	public class IRCMessage
	{
		protected var _raw:String;
		protected var _prefix:String;
		protected var _command:String;
		protected var _params:Array;
		
		public function IRCMessage()
		{
			
		}
		
		public static function fromRaw(value:String):IRCMessage
		{
			var message:IRCMessage = new IRCMessage();
			message.raw = value;
			return message;
		}
		
		public static function fromCommand(command:String, params:Array = null):IRCMessage
		{
			var message:IRCMessage = new IRCMessage();
			message.command = command;
			message.params = params;
			return message;
		}
		
		public static function fromCommandWithPrefix(prefix:String, command:String, params:Array = null):IRCMessage
		{
			var message:IRCMessage = new IRCMessage();
			message.prefix = prefix;
			message.command = command;
			message.params = params;
			return message;
		}
		
		public function set raw(value:String):void
		{
			_raw = value;
			
			parseRaw();
		}
		
		public function get raw():String
		{
			return _raw;
		}
		
		public function set prefix(value:String):void
		{
			_prefix = value;
			
			buildRaw();
		}
		
		public function get prefix():String
		{
			return _prefix;
		}
		
		public function set command(value:String):void
		{
			_command = value;
			
			buildRaw();
		}
		
		public function get command():String
		{
			return _command;
		}
		
		public function set params(value:Array):void
		{
			_params = value;
			
			buildRaw();
		}
		
		public function get params():Array
		{
			return _params.concat();
		}
		
		protected function buildRaw():void
		{
			_raw = "";
			
			if (_prefix)
			{
				_raw += ":" + _prefix + " ";
			}
			
			_raw += _command;
			
			if (_params && _params.length > 0)
			{
				_raw += " " + _params.join(" ");
			}
		}
		
		protected function parseRaw():void
		{
			var components:Array = _raw.split(" ");
			var value:String;
			
			if (_raw.charAt(0) == ":")
			{
				value = components[0];
				_prefix = value.substr(1);
				
				components.shift();
			}
			
			_command = components.shift();
			
			_params = components;
		}
	}
}