package vg.sam.flirc
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	
	import vg.sam.flirc.events.IRCConnectionEvent;
	
	public class IRCConnection extends EventDispatcher
	{
		private static const DISCONNECTED:int = -1;
		private static const NOT_CONNECTED:int = 0;
		private static const CONNECTED:int = 1;
		private static const REGISTERED:int = 2;
		private static const COMPLETE:int = 3;
		
		public var host:String;
		public var port:int = 6667;
		public var useSSL:Boolean;
		public var nickname:String;
		public var username:String;
		public var password:String;
		public var realName:String;
		
		protected var socket:Socket;
		protected var socketBuffer:String;
		protected var state:int;
		
		public function IRCConnection()
		{
			state = NOT_CONNECTED;
			
			addEventListener(IRCConnectionEvent.MESSAGE_RECIEVED, onMessageReceived);
		}

		public function connect():void
		{
			disconnect();
			
			socketBuffer = "";
			socket = new Socket();
			
			socket.addEventListener(Event.CONNECT, onSocketConnect);
			socket.addEventListener(Event.CLOSE, onSocketClose);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketIOError);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketSecurityError);
			
			socket.connect(host, port);
		}
		
		public function disconnect():void
		{
			if (socket)
			{
				if (socket.connected) socket.close();
				
				socket.removeEventListener(Event.CONNECT, onSocketConnect);
				socket.removeEventListener(Event.CLOSE, onSocketClose);
				socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
				socket.removeEventListener(IOErrorEvent.IO_ERROR, onSocketIOError);
				socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketSecurityError);
			}
			
			socket = null;
		}
		
		public function get connected():Boolean
		{
			return socket && socket.connected;
		}
		
		public function sendLine(command:String):void
		{
			send(IRCMessage.fromRaw(command));
		}
		
		public function send(message:IRCMessage):void
		{
			dispatchEvent(new IRCConnectionEvent(IRCConnectionEvent.MESSAGE_SENT, message));
			
			socket.writeUTFBytes(message.raw + "\r\n");
			socket.flush();
		}
		
		private function onMessageReceived(event:IRCConnectionEvent):void
		{
			if (event.message.command == "PING")
			{
				send(IRCMessage.fromCommand(IRCMessage.PONG, event.message.params));
			}
		}
		
		private function onSocketConnect(event:Event):void
		{
			trace("onSocketConnect :" + event);
			
			state = CONNECTED;
			
			if (password) send(IRCMessage.fromCommand(IRCMessage.PASS, [password]));
			
			send(IRCMessage.fromCommand(IRCMessage.NICK, [nickname]));
			send(IRCMessage.fromCommand(IRCMessage.USER, [username, "8", "*", realName]));
		}

		private function onSocketClose(event:Event):void
		{
			trace("onSocketClose :" + event);
			
			disconnect();
		}
		
		private function onSocketData(event:ProgressEvent):void
		{
			processSocketData();
		}
		
		private function onSocketIOError(event:IOErrorEvent):void
		{
			throw event;
		}
		
		private function onSocketSecurityError(event:SecurityErrorEvent):void
		{
			throw event;
		}
		
		private function processSocketData():void
		{
			var line:String;
			var message:IRCMessage;
			
			while (line = readLine())
			{
				message = IRCMessage.fromRaw(line);
				dispatchEvent(new IRCConnectionEvent(IRCConnectionEvent.MESSAGE_RECIEVED, message));
			}
		}
		
		private function readLine():String
		{
			socketBuffer = socketBuffer.concat(socket.readUTFBytes(socket.bytesAvailable));
			
			var lineEnd:int = socketBuffer.indexOf("\r\n");
			var line:String = null;
			
			if (lineEnd > 0)
			{
				line = socketBuffer.substring(0, lineEnd);
				socketBuffer = socketBuffer.slice(lineEnd + 2);
			}
			
			return line;
		}
	}
}