namespace  Aphelion {
    /*
    *   Save as command 
    */
    public class SaveAsCommand : Component {
        /*
        *   Command name
        */  
        private const string NAME = "Save as document";

        /*
        *   Command description
        */  
        private const string DESCRIPTION = "Save as document";

        /*
        *   Run internal
        */
        private async void RunInternal () {
            // Get content for save
            var arr = yield MessageDispatcher.GetInstance ().SendBroadcast (this.get_type (), new GetFileContentMessage (false));
            var recepient = arr[0].Sender;
            var contentMessage = (ReturnFileContentMessage) (arr[0]).Message;
            
            var content = contentMessage.Content as Content;
            var fpm = (ReturnFilePathMessage) yield MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (Dialogs), 
                                                                                            new ShowFileDialogMessage (FileDialogOperation.SAVE));
            if (fpm == null) return;

            var newContent = new FileContent (content.Id, fpm.FilePath, content.Content);
            var fsm = (FileSavedMessage) yield MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (FileOperations), new SaveFileMessage (newContent));
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
            yield MessageDispatcher.GetInstance ().Send (thisType, typeof (CommandManager), new BindShortcutMessage (new Shortcut(39, true, true), thisType));
        }          
    }   
}