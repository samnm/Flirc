package
{
	import com.bit101.components.Component;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	
	import vg.sam.flirc.IRCConnection;
	
	public class Flirc extends Sprite
	{
		private var connection:IRCConnection;
		
		private var hostInput:InputText;
		private var portInput:InputText;
		private var passwordInput:InputText;
		private var sendInput:InputText;
		private var logText:TextArea;
		
		public function Flirc()
		{
			Component.initStage(stage);
			
			var connectContents:VBox = new VBox(this);
			connectContents.addChild(new Label(null, 0, 0, "Host"));
			connectContents.addChild(hostInput = new InputText(null, 0, 0, ""));
			connectContents.addChild(new Label(null, 0, 0, "Port"));
			connectContents.addChild(portInput = new InputText(null, 0, 0, ""));
			connectContents.addChild(new Label(null, 0, 0, "Password"));
			connectContents.addChild(passwordInput = new InputText(null, 0, 0, ""));
			connectContents.addChild(new PushButton(null, 0, 0, "Connect", onConnectClick));
			addChild(connectContents);
			
			var logContents:VBox = new VBox(this, 100);
			logContents.addChild(logText = new TextArea());
			logContents.addChild(sendInput = new InputText());
			logContents.addChild(new PushButton(null, 0, 0, "Send", onSendClick));
			addChild(logContents);
			
			connection = new IRCConnection();
			connection.addEventListener(TextEvent.TEXT_INPUT, onLineReceived);
		}
		
		private function onLineReceived(e:TextEvent):void
		{
			logText.text += e.text;
		}
		
		private function onConnectClick(e:Event):void
		{
			connection.host = hostInput.text;
			connection.port = int(portInput.text);
			connection.password = passwordInput.text;
			
			connection.connect();
		}
		
		private function onSendClick(e:Event):void
		{
			connection.sendLine(sendInput.text);
			sendInput.text = "";
		}
	}
}