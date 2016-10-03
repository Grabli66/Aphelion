namespace  Aphelion {
    /*
    *   Save as command 
    */
    public class SaveAsCommand : Object, ICommand {
        /*
        *   Content sender
        */
        private Type _contentSender;

        /*
        *   Process GetFileContentHandlerMessage
        */
        private void RecieveFileContentMessage (Type sender, Message data) {
            var message = (ReturnFileContentMessage) data;
            _contentSender = sender;
            var content = message.Content as Content;
            //MessageDispatcher.GetInstance ().Send (this.get_type (), typeof(FileDialog), new SaveAsFileMessage (content));
        }
        
        /*
        *   Process FileSavedMessage
        */
        private void FileSaved (Type sender, Message data) {
            var message = (FileSavedMessage) data;
            MessageDispatcher.GetInstance ().Send (this.get_type (), _contentSender, message); 
        }     

        /*
        *   Init command
        */
        public void Init () {
            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages
            dispatcher.Register (this, typeof (ReturnFileContentMessage), RecieveFileContentMessage);   
            dispatcher.Register (this, typeof (FileSavedMessage), FileSaved);
        }

        /*
        *   Run command
        */        
        public void Run () {
            MessageDispatcher.GetInstance ().SendBroadcast (this.get_type (), new GetFileContentMessage ()); 
        }          
    }   
}