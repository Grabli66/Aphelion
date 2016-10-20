namespace  Aphelion {
    /*
    *   Open command 
    */
    public class OpenCommand : Component { 
        /*
        *   Command name
        */  
        private const string NAME = "Open document";

        /*
        *   Command description
        */  
        private const string DESCRIPTION = "Open document";

        /*
        *   Run internal
        */
        private async void RunInternal () {
            //var arr = yield MessageDispatcher.GetInstance ().SendBroadcast (this.get_type (), new GetFileContentHandlerMessage ());  
            //var sender = (arr[0]).Sender;            
            var res = yield MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (Dialogs), new ShowFileDialogMessage (FileDialogOperation.OPEN));
            if (res == null) return;
            var mes2 = (ReturnFilePathMessage) res;            
            res = yield MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (FileOperations), new OpenFileMessage (mes2.FilePath));
            var content = ((FileOpenedMessage) res).Content;
            yield MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (SourceEditor), new SetFileContentMessage (content));
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
            yield MessageDispatcher.GetInstance ().Send (thisType, typeof (CommandManager), new BindShortcutMessage (new Shortcut(32, true), thisType));
        }       
    }   
}