namespace  Aphelion {
    /*
    *   Open command 
    */
    public class OpenCommand : Object, ICommand, IMessageRecepient {
        /*
        *   File handler
        */
        private Type _handler;        

        /*
        *   Process GetFileContentHandlerMessage
        */
        private void RecieveFileContentHandler (ReturnContentHandlerMessage message) {
            _handler = message.Handler;
            MessageDispatcher.GetInstance ().Send (this, typeof (FileDialog), new OpenFileMessage ());
        }

        /*
        *   Process FilesOpenedMessage
        */
        private void RecieveFilesOpened (FilesOpenedMessage message) {            
            MessageDispatcher.GetInstance ().Send (this, _handler, new SetFileContentMessage (message.Files));
        }        

        /*
        *   Init command
        */
        public void Init () {
            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages
            dispatcher.Register (typeof (ReturnContentHandlerMessage), this);
            dispatcher.Register (typeof (FilesOpenedMessage), this);
        }

        /*
        *   Run command
        */        
        public void Run () {
            // Request for file content
            MessageDispatcher.GetInstance ().SendBroadcast (this, new GetFileContentHandlerMessage ());
        }

        /*
        *   On receive message
        */
        public void OnMessage (Object sender, Message data) {
            if (data is ReturnContentHandlerMessage) RecieveFileContentHandler ((ReturnContentHandlerMessage)data);                                                
            if (data is FilesOpenedMessage) RecieveFilesOpened ((FilesOpenedMessage)data);
        }
    }   
}