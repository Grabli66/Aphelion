namespace  Aphelion {
    /*
    *   Save as command 
    */
    public class SaveAsCommand : Object, ICommand, IMessageRecepient {
        /*
        *   Content sender
        */
        private Object _contentSender;

        /*
        *   Process GetFileContentHandlerMessage
        */
        private void RecieveFileContentMessage (Object sender, ReturnFileContentMessage message) {
            _contentSender = sender;
            var content = message.Content as TextContent;
            MessageDispatcher.GetInstance ().Send (this, typeof(FileDialog), new SaveAsFileMessage (content));
        }
        
        /*
        *   Process FileSavedMessage
        */
        private void FileSaved (FileSavedMessage message) {
            MessageDispatcher.GetInstance ().Send (this, _contentSender.get_type (), message); 
        }     

        /*
        *   Init command
        */
        public void Init () {
            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages
            dispatcher.Register (typeof (ReturnFileContentMessage), this);   
            dispatcher.Register (typeof (FileSavedMessage), this);
        }

        /*
        *   Run command
        */        
        public void Run () {
            MessageDispatcher.GetInstance ().SendBroadcast (this, new GetFileContentMessage ()); 
        }   

        /*
        *   On receive message
        */
        public void OnMessage (Object sender, Message data) {    
            if (data is ReturnFileContentMessage) RecieveFileContentMessage (sender, (ReturnFileContentMessage)data);                     
            if (data is FileSavedMessage) FileSaved ((FileSavedMessage)data);
        }     
    }   
}