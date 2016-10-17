namespace  Aphelion {
    /*
    *   Save command 
    */
    public class SaveCommand : Component {
        /*
        *   Command name
        */  
        private const string NAME = "Save document";

        /*
        *   Command description
        */  
        private const string DESCRIPTION = "Save document";

        /*
        *   Run internal
        */
        private async void RunInternal () {
            // Get content for save
            var arr = yield MessageDispatcher.GetInstance ().SendBroadcast (this.get_type (), new GetFileContentMessage (true));
            var recepient = arr[0].Sender;
            var contentMessage = (ReturnFileContentMessage) (arr[0]).Message;

            FileContent? fileContent = null;

            if (contentMessage.Content is FileContent) {
                fileContent = contentMessage.Content as FileContent;                                
            } else if (contentMessage.Content is Content) {                
                var fpm = (ReturnFilePathMessage) yield MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (FileDialog), new ShowFileDialogMessage (DialogOperation.SAVE));
                if (fpm == null) return; 
                var content = contentMessage.Content as Content;
                fileContent = new FileContent (content.Id, fpm.FilePath, content.Content);                
            }

            if (fileContent == null) return;
            var fsm = (FileSavedMessage) yield MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (FileOperations), new SaveFileMessage (fileContent));
            yield MessageDispatcher.GetInstance ().Send (this.get_type (), recepient, fsm);  
        }

        /*
        *   Run command
        */        
        private Message? Run (Type sender, Message data) {
            RunInternal.begin ();
            return null;                       
        }  

        /*
        *   Create component items
        */
        public override void Init () {
            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages            
            dispatcher.Register (this, typeof (RunCommandMessage), Run);
        }

        /*
        *   Install command
        */
        public override async void Install () {
            var thisType = this.get_type ();
            yield MessageDispatcher.GetInstance ().Send (thisType, typeof (CommandManager), 
                                    new RegisterCommandMessage (new CommandInfo (thisType, NAME, DESCRIPTION)));
            // Todo bind from settings
            yield MessageDispatcher.GetInstance ().Send (thisType, typeof (CommandManager), new BindShortcutMessage (new Shortcut(39, true), thisType));
        }      
    }   
}