package
{
	import com.bit101.components.Component;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import com.bit101.components.VBox;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import vg.sam.flirc.IRCConnection;
	import vg.sam.flirc.events.IRCConnectionEvent;
	
	[SWF(width="1024", height="350")]
	public class Flirc extends Sprite
	{
		private var connection:IRCConnection;
		
		private var hostInput:InputText;
		private var portInput:InputText;
		private var usernameInput:InputText;
		private var realnameInput:InputText;
		private var nicknameInput:InputText;
		private var passwordInput:InputText;
		private var sendInput:InputText;
		private var logText:TextArea;
		
		public function Flirc()
		{
			Component.initStage(stage);
			
			var connectContents:VBox = new VBox(this);
			connectContents.addChild(new Label(null, 0, 0, "Host"));
			connectContents.addChild(hostInput = new InputText(null, 0, 0, "irc.esper.net"));
			connectContents.addChild(new Label(null, 0, 0, "Port"));
			connectContents.addChild(portInput = new InputText(null, 0, 0, "6667"));
			connectContents.addChild(new Label(null, 0, 0, "Username"));
			connectContents.addChild(usernameInput = new InputText(null, 0, 0, "wqkmv"));
			connectContents.addChild(new Label(null, 0, 0, "Nickname"));
			connectContents.addChild(nicknameInput = new InputText(null, 0, 0, "Sam"));
			connectContents.addChild(new Label(null, 0, 0, "Realname"));
			connectContents.addChild(realnameInput = new InputText(null, 0, 0, "Sam Morrison"));
			connectContents.addChild(new Label(null, 0, 0, "Password"));
			connectContents.addChild(passwordInput = new InputText(null, 0, 0, ""));
			connectContents.addChild(new PushButton(null, 0, 0, "Connect", onConnectClick));
			addChild(connectContents);
			
			var logContents:VBox = new VBox(this, 100);
			logContents.addChild(logText = new TextArea());
			logContents.addChild(sendInput = new InputText());
			logContents.addChild(new PushButton(null, 0, 0, "Send", onSendClick));
			addChild(logContents);
			
			logText.width = 924;
			logText.height = 300;
			
			sendInput.width = 400;
			
			connection = new IRCConnection();
			connection.addEventListener(IRCConnectionEvent.MESSAGE_RECIEVED, onMessageReceived);
		}

		private function onMessageReceived(event:IRCConnectionEvent):void
		{
			logText.text += event.message.raw + "\n";
		}
		
		private function onConnectClick(e:Event):void
		{
			connection.host = hostInput.text;
			connection.port = int(portInput.text);
			connection.password = passwordInput.text;
			
			connection.username = usernameInput.text;
			connection.realName = realnameInput.text;
			connection.nickname = nicknameInput.text;
			
			connection.connect();
		}
		
		private function onSendClick(e:Event):void
		{
			connection.sendLine(sendInput.text);
			sendInput.text = "";
		}
	}
}