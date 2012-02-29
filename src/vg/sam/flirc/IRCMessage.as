package vg.sam.flirc
{
	public class IRCMessage
	{
		public static const ADMIN:String = "ADMIN";
		public static const AWAY:String = "AWAY";
		public static const CONNECT:String = "CONNECT";
		public static const DIE:String = "DIE";
		public static const ERROR:String = "ERROR";
		public static const INFO:String = "INFO";
		public static const INVITE:String = "INVITE";
		public static const ISON:String = "ISON";
		public static const JOIN:String = "JOIN";
		public static const KICK:String = "KICK";
		public static const KILL:String = "KILL";
		public static const LINKS:String = "LINKS";
		public static const LIST:String = "LIST";
		public static const LUSERS:String = "LUSERS";
		public static const MODE:String = "MODE";
		public static const MOTD:String = "MOTD";
		public static const NAMES:String = "NAMES";
		public static const NICK:String = "NICK";
		public static const NOTICE:String = "NOTICE";
		public static const OPER:String = "OPER";
		public static const PART:String = "PART";
		public static const PASS:String = "PASS";
		public static const PING:String = "PING";
		public static const PONG:String = "PONG";
		public static const PRIVMSG:String = "PRIVMSG";
		public static const QUIT:String = "QUIT";
		public static const REHASH:String = "REHASH";
		public static const RESTART:String = "RESTART";
		public static const SERVICE:String = "SERVICE";
		public static const SERVLIST:String = "SERVLIST";
		public static const SERVER:String = "SERVER";
		public static const SQUERY:String = "SQUERY";
		public static const SQUIT:String = "SQUIT";
		public static const STATS:String = "STATS";
		public static const SUMMON:String = "SUMMON";
		public static const TIME:String = "TIME";
		public static const TOPIC:String = "TOPIC";
		public static const TRACE:String = "TRACE";
		public static const USER:String = "USER";
		public static const USERHOST:String = "USERHOST";
		public static const USERS:String = "USERS";
		public static const VERSION:String = "VERSION";
		public static const WALLOPS:String = "WALLOPS";
		public static const WHO:String = "WHO";
		public static const WHOIS:String = "WHOIS";
		public static const WHOWAS:String = "WHOWAS";
		
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