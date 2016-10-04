namespace  Aphelion {
    /*
    *   Save as command 
    */
    public class SaveAsCommand : Object, ICommand {
        /*
        *   Init command
        */
        public void Init () {           
        }

        /*
        *   Run command
        */        
        public async void Run () {
            // Get content for save
            var arr = yield MessageDispatcher.GetInstance ().SendBroadcast (this.get_type (), new GetFileContentMessage ());
            var recepient = arr[0].Sender;
            var contentMessage = (ReturnFileContentMessage) (arr[0]).Message;
            
            var content = contentMessage.Content as Content;
            var fpm = (ReturnFilePathMessage) yield MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (FileDialog), new ShowFileDialogMessage (DialogOperation.SAVE));                                
            var newContent = new FileContent (content.Id, fpm.FilePath, content.Content);
            var fsm = (FileSavedMessage) yield MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (FileOperations), new SaveFileMessage (newContent));
            yield MessageDispatcher.GetInstance ().Send (this.get_type (), recepient, fsm);             
        }          
    }   
}