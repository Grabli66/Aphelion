namespace  Aphelion {
    /*
    *   Component for showing commands
    */
    public class CommandPanel : Component {
        /*
        *   Width of command panel
        */
        private const int WIDTH = 500;

        /*
        *   Entry for command
        */
        private Gtk.Entry _commandEntry;        

        /*
        *   Entered command text
        */
        private string _commandText = "";

        /*
        *   Main box
        */
        private Gtk.Box _panelBox;

        /*
        *   Is panel visible
        */
        private bool _isVisible = false;                

        /*
        *   List for commands
        */
        private CommandList _commandList;

        /*
        *   Show hide panel
        */
        private void ShowHideInternal () {
            _isVisible = !_isVisible;

            if (_isVisible) {
                _panelBox.show_all ();
                _commandEntry.grab_focus ();

            } else {
                _commandEntry.text = "";
                _panelBox.hide ();
            }
        }

        /*
        *   Process SwitchVisibilityMessage
        */
        private Message? ShowHide (Type sender, Message data) {            
            ShowHideInternal ();
            return null;
        }       

        /*
        *   Process _commandEntry Change signal
        */
        private void OnTextChange () {
            _commandText = _commandEntry.text.down ();
            _commandList.Filter (_commandText);
        }    

        /*
        *   Process _commandList row_selected signal
        */
        private void RowSelected (Gtk.ListBoxRow? row) {           
            var commandRow = row as CommandListRow;
            if (commandRow == null) return;                
            var command = commandRow.UserData as CommandInfo;
            if (command == null) return;
            ShowHideInternal ();
            MessageDispatcher.Send.begin (this.get_type (), command.Command, new RunCommandMessage ());                        
        }    

        /*
        *   Create component items
        */
        public override void Init () {
            _panelBox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);            
            var left = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            var right = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);

            var commandBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            commandBox.get_style_context ().add_class ("command-panel"); 
            _commandEntry = new Gtk.Entry ();
            _commandEntry.margin = 5;
            _commandEntry.set_size_request (WIDTH, 28);
            _commandEntry.changed.connect (OnTextChange);            

            var scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.set_size_request (WIDTH, 200);            
            
            scrolled.margin_left = 2;
            scrolled.margin_right = 2;            
            scrolled.margin_bottom = 10;

            _commandList = new CommandList ();
            _commandList.row_selected.connect(RowSelected);

            scrolled.add (_commandList);

            commandBox.pack_start (_commandEntry, true, true, 0);
            commandBox.pack_start (scrolled, true, true, 0);
            commandBox.override_background_color (Gtk.StateFlags.NORMAL, { 0.15f,0.15f,0.15f, 1.0f });             
                                                          
            _panelBox.pack_start (left, true, true, 0);
            _panelBox.pack_start (commandBox, false, false, 0);
            _panelBox.pack_start (right, true, true, 0);
            _panelBox.set_baseline_position (Gtk.BaselinePosition.TOP);

            commandBox.valign = Gtk.Align.START;
            _commandEntry.valign = Gtk.Align.START;
            scrolled.valign = Gtk.Align.START; 

            // Register messages            
            MessageDispatcher.Register (this, typeof (SwitchVisibilityMessage), ShowHide);
        }

        /*
        *   Install command
        */
        public override async void Install () {
            yield MessageDispatcher.Send (this.get_type (), typeof (MainWindow), new SetOverlayWidgetMessage (_panelBox));
        }

        /*
        *   After install all components
        */
        public override async void AfterInstall () {            
            var messa = (ReturnCommandsMessage) yield MessageDispatcher.Send (this.get_type (), typeof (CommandManager), new GetCommandsMessage ());            
            foreach (var item in messa.Commands) {
                _commandList.Append (item.Name, item);
            }
        }
    }
}