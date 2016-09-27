namespace  Aphelion {
    /*
    *   Save command 
    */
    public class SaveCommand : Object, ICommand, IMessageRecepient {
        /*
        *   Process GetFileContentHandlerMessage
        */
        private void RecieveFileContentMessage (Object sender, ReturnFileContentMessage message) {
            if (message.Content is TextFileContent) {
                // TODO: send to component that save file
                var content = message.Content as TextFileContent;
                FileUtils.set_contents (content.FilePath, content.Content);
                MessageDispatcher.GetInstance ().Send (this, sender.get_type (), new ContentSavedMessage (content)); 
            }
        }

        /*
        *   Init command
        */
        public void Init () {
            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages
            dispatcher.Register (typeof (ReturnFileContentMessage), this);            
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
        }
    }   
}