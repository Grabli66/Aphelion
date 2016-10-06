namespace  Aphelion {
    /*
    *   Shortcut + Command
    */
    internal class CommandValue : Object {
        /*
        *   Command
        */
        public Type Command { get; private set; }

        /*
        *   Shortcut
        */
        public Shortcut Shortcut { get; private set; }

        /*
        *   Constructor
        */
        public CommandValue (Type command, Shortcut shortcut) {
            this.Command = command;
            this.Shortcut = shortcut;
        }
    }


    /*
    *   Manage commands
    */
    public class CommandManager : Component {
        /*
        *   Binded commands to shortcut
        */
        private Gee.HashMap<uint, CommandValue?> _bindedCommands = new Gee.HashMap<uint, CommandValue?> ();

        /*
        *   Registered commands
        */
        private Gee.HashSet<Type> _registeredCommands = new Gee.HashSet<Type> ();

        /*
        *   Process key press
        */
        private Message? KeyPress (Type sender, Message data) {
            var messa = (KeyPressMessage) data;
            var hash = Shortcut.CalcHash (messa.KeyCode, messa.IsCtrl, messa.IsShift, messa.IsAlt);
            var command = _bindedCommands[hash];
            if (command != null) {            
                MessageDispatcher.GetInstance ().Send.begin (this.get_type (), command.Command, new RunCommandMessage ());
            }
            return null;
        }

        /*
        *   Process RegisterCommandMessage
        */
        private Message? RegisterCommand (Type sender, Message data) {
            var messa = (RegisterCommandMessage) data;
            _registeredCommands.add (messa.Command);
            return null;
        }

        /*
        *   Process BindShortcutMessage
        */
        private Message? BindShortcut (Type sender, Message data) {
            var messa = (BindShortcutMessage) data;
            if (_registeredCommands.contains (messa.Command)) {
                _bindedCommands[messa.Shortcut.hash ()] = new CommandValue (messa.Command, messa.Shortcut);
            }                        
            return null;
        }

        /*
        *   Add built in commands
        */
        /*private void AddBuiltInCommands () {
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
        }*/

        /*
        *   Create component items
        */
        public override void Init () {
            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages
            dispatcher.Register (this, typeof (KeyPressMessage), KeyPress);
            dispatcher.Register (this, typeof (RegisterCommandMessage), RegisterCommand);
            dispatcher.Register (this, typeof (BindShortcutMessage), BindShortcut);
        }
    }
}