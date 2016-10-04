namespace  Aphelion {
    /*
    *   Open command 
    */
    public class OpenCommand : Object, ICommand {
        /*
        *   Init command
        */
        public void Init () {
        }        

        /*
        *   Run command
        */        
        public async void Run () {
            var arr = yield MessageDispatcher.GetInstance ().SendBroadcast (this.get_type (), new GetFileContentHandlerMessage ());  
            var sender = (arr[0]).Sender;            
            var res = yield MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (FileDialog), new ShowFileDialogMessage (DialogOperation.OPEN));
            var mes2 = (ReturnFilePathMessage) res;            
            res = yield MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (FileOperations), new OpenFileMessage (mes2.FilePath));
            var content = ((FileOpenedMessage) res).Content;
            yield MessageDispatcher.GetInstance ().Send (this.get_type (), sender, new SetFileContentMessage (content));
        }       
    }   
}