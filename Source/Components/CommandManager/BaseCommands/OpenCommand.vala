namespace  Aphelion {
    /*
    *   Open command 
    */
    public class OpenCommand : Object, ICommand {
        /*
        *   File handler
        */
        private Type _handler;        

        /*
        *   Process ReturnContentHandlerMessage
        */
        private void RecieveFileContentHandler (Type sender, Message data) {
            var message = (ReturnContentHandlerMessage) data;
            _handler = message.Handler;
            MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (FileDialog), new ShowFileDialogMessage (DialogOperation.OPEN));
        }

        /*
        *   Process ReturnFilePathMessage
        */
        private void RecieveFilePath (Type sender, Message data) {
            var message = (ReturnFilePathMessage) data;
            MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (FileOperations), new OpenFileMessage (message.FilePath));
        }

        /*
        *   Process FileOpenedMessage
        */
        private void FileOpened (Type sender, Message data) {
            var message = (FileOpenedMessage) data;
            MessageDispatcher.GetInstance ().Send (this.get_type (), _handler, new SetFileContentMessage (message.Content));
        }

        /*
        *   Init command
        */
        public void Init () {
            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages
            dispatcher.Register (this, typeof (ReturnContentHandlerMessage), RecieveFileContentHandler);
            dispatcher.Register (this, typeof (ReturnFilePathMessage), RecieveFilePath);
            dispatcher.Register (this, typeof (FileOpenedMessage), FileOpened);
        }

        /*
        *   Run command
        */        
        public void Run () {
            // Request for file content
            MessageDispatcher.GetInstance ().SendBroadcast (this.get_type (), new GetFileContentHandlerMessage ());
        }       
    }   
}