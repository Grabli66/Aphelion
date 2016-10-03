namespace  Aphelion {
    /*
    *   Save command 
    */
    public class SaveCommand : Object, ICommand {
        /*
        *   Content sender
        */
        private Type _contentSender;

        /*
        *   Content to save
        */
        private Content _content;

        /*
        *   Process GetFileContentHandlerMessage
        */
        private void RecieveFileContentMessage (Type sender, Message data) {
            var messa = (ReturnFileContentMessage) data;
            _contentSender = sender;
            if (messa.Content is FileContent) {
                var content = messa.Content as FileContent;
                MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (FileOperations), new SaveFileMessage (content)); 
            } else if (messa.Content is Content) {
                _content = messa.Content as Content;
                MessageDispatcher.GetInstance ().Send (this.get_type (), typeof(FileDialog), new ShowFileDialogMessage (DialogOperation.SAVE));
            }
        }

        /*
        *   Process ReturnFilePathMessage
        */
        private void RecieveFilePath (Type sender, Message data) {
            var messa = (ReturnFilePathMessage) data;
            var content = new FileContent (_content.Id, messa.FilePath, _content.Content);
            MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (FileOperations), new SaveFileMessage (content));
        }

        /*
        *   Process FileSavedMessage
        */
        private void FileSaved (Type sender, Message data) {
            var message = (FileSavedMessage) data;
            MessageDispatcher.GetInstance ().Send (this.get_type (), _contentSender, data);
        }

        /*
        *   Init command
        */
        public void Init () {
            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages
            dispatcher.Register (this, typeof (ReturnFileContentMessage), RecieveFileContentMessage);
            dispatcher.Register (this, typeof (FileSavedMessage), FileSaved);
            dispatcher.Register (this, typeof (ReturnFilePathMessage), RecieveFilePath);
        }
        
        /*
        *   Run command
        */        
        public void Run () {
            // Get content for save
            MessageDispatcher.GetInstance ().SendBroadcast (this.get_type (), new GetFileContentMessage ());             
        }        
    }   
}