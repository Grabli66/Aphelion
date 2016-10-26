namespace  Aphelion {
    /*
    *   Save document command 
    */
    public class OpenProjectCommand : Component {
        /*
        *   Command name
        */  
        private const string NAME = "Open project";

        /*
        *   Command description
        */  
        private const string DESCRIPTION = "Open project";

        /*
        *   Run internal
        */
        private async void RunInternal () {
            // TODO: get caption and filter from other? source
            var res = yield MessageDispatcher.Send (this.get_type (), typeof (Dialogs), 
                      new ShowFileDialogMessage (FileDialogOperation.OPEN).
                      AddFilter ("Embrace project", "*.vprj"));
            if (res == null) return;
            var mes2 = (ReturnFilePathMessage) res;            
            res = yield MessageDispatcher.Send (this.get_type (), typeof (FileOperations), new OpenFileMessage (mes2.FilePath));
            var content = ((FileOpenedMessage) res).Content;
        }

        /*
        *   Create component items
        */
        public override void Init () {
            // Register messages            
            MessageDispatcher.Register (this, typeof (RunCommandMessage), Run);
        }

        /*
        *   Run command
        */        
        private Message? Run (Type sender, Message data) {
            RunInternal.begin ();
            return null;                       
        }

        /*
        *   Install command
        */
        public override async void Install () {
            var thisType = this.get_type ();
            yield MessageDispatcher.Send (thisType, typeof (CommandManager), 
                                    new RegisterCommandMessage (new CommandInfo (thisType, NAME, DESCRIPTION)));
            // Todo bind from settings
            yield MessageDispatcher.Send (thisType, typeof (CommandManager), new BindShortcutMessage (new Shortcut(32, true, true), thisType));
        }
    }
}