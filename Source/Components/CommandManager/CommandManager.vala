namespace  Aphelion {
    /*
    *   Shortcut + Command
    */
    internal class CommandValue : Object {
        /*
        *   Command
        */
        public ICommand Command { get; private set; }

        /*
        *   Shortcut
        */
        public Shortcut Shortcut { get; private set; }

        /*
        *   Constructor
        */
        public CommandValue (ICommand command, Shortcut shortcut) {
            this.Command = command;
            this.Shortcut = shortcut;
        }
    }


    /*
    *   Manage commands
    */
    public class CommandManager : Component {
        /*
        *   Commands
        */
        private Gee.HashMap<uint, CommandValue?> _commands = new Gee.HashMap<uint, CommandValue?> ();

        /*
        *   Process key press
        */
        private void KeyPress (KeyPressMessage message) {  
            stderr.printf (@"KeyPressed: $(message.KeyCode)\n");
            var hash = Shortcut.CalcHash (message.KeyCode, message.IsCtrl, message.IsShift, message.IsAlt);
            var command = _commands[hash];
            if (command == null) return;
            command.Command.Run ();
        }

        /*
        *   Add built in commands
        */
        private void AddBuiltInCommands () {
            var openShortcut = new Shortcut(32, true);
            var saveShortcut = new Shortcut(39, true); 
            var saveAsShortcut = new Shortcut(39, true, true);
            var closeShortcut = new Shortcut(25, true);
            var quitShortcut = new Shortcut(24, true);
            _commands[openShortcut.hash ()] = new CommandValue (new OpenCommand (), openShortcut);
            _commands[saveShortcut.hash ()] = new CommandValue (new SaveCommand (), saveShortcut);
            _commands[saveAsShortcut.hash ()] = new CommandValue (new SaveAsCommand (), saveAsShortcut);
            _commands[closeShortcut.hash ()] = new CommandValue (new CloseCommand (), closeShortcut);
            _commands[quitShortcut.hash ()] = new CommandValue (new QuitCommand (), quitShortcut);

            foreach (var command in _commands.values) {
                command.Command.Init ();
            }
        }

        /*
        *   Create component items
        */
        public override void Init () {
            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages
            dispatcher.Register (typeof (KeyPressMessage), this);
            dispatcher.Register (typeof (AddCommandMessage), this);

            AddBuiltInCommands ();
        }

        /*
        *   On receive message
        */
        public override void OnMessage (Object sender, Message data) {            
            if (data is KeyPressMessage) KeyPress ((KeyPressMessage)data);                                    
        }
    }
}