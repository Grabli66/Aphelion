namespace  Aphelion {
    /*
    *   Save command 
    */
    public class SaveCommand : Object, ICommand, IMessageRecepient {
        /*
        *   Content sender
        */
        private Object _contentSender;

        /*
        *   Process GetFileContentHandlerMessage
        */
        private void RecieveFileContentMessage (Object sender, ReturnFileContentMessage message) {
            _contentSender = sender;
            if (message.Content is TextFileContent) {
                // TODO: send to component that save file
                var content = message.Content as TextFileContent;                
                FileUtils.set_contents (content.FilePath, content.Content);
                MessageDispatcher.GetInstance ().Send (this, sender.get_type (), new FileSavedMessage (content)); 
            } else if (message.Content is TextContent) {
                var content = message.Content as TextContent;
                MessageDispatcher.GetInstance ().Send (this, typeof(FileDialog), new SaveAsFileMessage (content));
            }
        }

        /*
        *   Process FileSavedMessage
        */
        private void FileSaved (FileSavedMessage data) {
            MessageDispatcher.GetInstance ().Send (this, _contentSender.get_type (), data); 
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
            // Get content for save
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