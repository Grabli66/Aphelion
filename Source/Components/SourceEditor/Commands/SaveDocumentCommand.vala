namespace  Aphelion {
    /*
    *   Save document command 
    */
    public class SaveDocumentCommand : Component {
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
            var recepient = typeof (SourceEditor);
            var contentMessage = (ReturnFileContentMessage) yield MessageDispatcher.Send (this.get_type (), recepient, new GetFileContentMessage (true));                        

            FileContent? fileContent = null;

            if (contentMessage.Content is FileContent) {
                fileContent = contentMessage.Content as FileContent;                                
            } else if (contentMessage.Content is Content) {                
                var fpm = (ReturnFilePathMessage) yield MessageDispatcher.Send (this.get_type (), typeof (Dialogs), 
                                                                                                new ShowFileDialogMessage (FileDialogOperation.SAVE));
                if (fpm == null) return; 
                var content = contentMessage.Content as Content;
                fileContent = new FileContent (content.Id, fpm.FilePath, content.Content);                
            }

            if (fileContent == null) return;
            var fsm = (FileSavedMessage) yield MessageDispatcher.Send (this.get_type (), typeof (FileOperations), new SaveFileMessage (fileContent));
            yield MessageDispatcher.Send (this.get_type (), recepient, fsm);  
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
            // Register messages            
            MessageDispatcher.Register (this, typeof (RunCommandMessage), Run);
        }

        /*
        *   Install command
        */
        public override async void Install () {
            var thisType = this.get_type ();
            yield MessageDispatcher.Send (thisType, typeof (CommandManager), 
                                    new RegisterCommandMessage (new CommandInfo (thisType, NAME, DESCRIPTION)));
            // Todo bind from settings
            yield MessageDispatcher.Send (thisType, typeof (CommandManager), new BindShortcutMessage (new Shortcut(39, true), thisType));
        }      
    }   
}