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
        private void KeyPress (Type sender, Message data) {
            var messa = (KeyPressMessage) data;  
            //message (@"KeyPressed: $(messa.KeyCode)");
            var hash = Shortcut.CalcHash (messa.KeyCode, messa.IsCtrl, messa.IsShift, messa.IsAlt);
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
            var newShortcut = new Shortcut(57, true);
            _commands[openShortcut.hash ()] = new CommandValue (new OpenCommand (), openShortcut);
            _commands[saveShortcut.hash ()] = new CommandValue (new SaveCommand (), saveShortcut);
            _commands[saveAsShortcut.hash ()] = new CommandValue (new SaveAsCommand (), saveAsShortcut);
            _commands[closeShortcut.hash ()] = new CommandValue (new CloseCommand (), closeShortcut);
            _commands[quitShortcut.hash ()] = new CommandValue (new QuitCommand (), quitShortcut);
            _commands[newShortcut.hash ()] = new CommandValue (new NewCommand (), newShortcut);

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
            dispatcher.Register (this, typeof (KeyPressMessage), KeyPress);            

            AddBuiltInCommands ();
        }        
    }
}