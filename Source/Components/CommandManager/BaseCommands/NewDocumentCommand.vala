namespace  Aphelion {
    /*
    *   Command for something new 
    */
    public class NewDocumentCommand : Component {   
        /*
        *   Command name
        */  
        private const string NAME = "Create new document";

        /*
        *   Command description
        */  
        private const string DESCRIPTION = "Create new document";

        /*
        *   Run internal
        */
        private async void RunInternal () {
            yield MessageDispatcher.Send (this.get_type (), typeof (SourceEditor), new NewMessage ());
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
            yield MessageDispatcher.Send (thisType, typeof (CommandManager), new BindShortcutMessage (new Shortcut(57, true), thisType));
        }
    }   
}