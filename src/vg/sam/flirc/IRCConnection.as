package vg.sam.flirc
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TextEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
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
			trace('Sending line: "' + command + '"');
			socket.writeUTFBytes(command + "\r\n");
			socket.flush();
		}
		
		public function send(message:IRCMessage):void
		{
			sendLine(message.raw);
		}
		
		private function onSocketConnect(event:Event):void
		{
			trace("onSocketConnect :" + event);
			
			state = CONNECTED;
			
			if (password) sendLine("PASS " + password);
			
			sendLine("NICK " + nickname);
			sendLine("USER " + username + " 8 * :" + realName);
		}

		private function onSocketClose(event:Event):void
		{
			trace("onSocketClose :" + event);
			
			disconnect();
		}
		
		private function onSocketData(event:ProgressEvent):void
		{
			parseSocketData();
		}
		
		private function onSocketIOError(event:IOErrorEvent):void
		{
			trace("onSocketIOError :" + event);
		}
		
		private function onSocketSecurityError(event:SecurityErrorEvent):void
		{
			trace("onSocketSecurityError :" + event);
		}
		
		private function parseSocketData():void
		{
			var line:String;
			var message:IRCMessage;
			while (line = readLine())
			{
				parseLine(line);
				message = IRCMessage.fromRaw(line);
				
				if (message.command == "PING")
				{
					send(IRCMessage.fromCommand("PONG", message.params));
				}
				
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
		
		private function parseLine(line:String):void
		{
			trace('Parsing line: "' + line + '"');
			dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT, false, false, line));
		}
	}
}