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
        *   Filter for list model
        */
        private Gtk.TreeModelFilter _filter;

        /*
        *   Main box
        */
        private Gtk.Box _panelBox;

        /*
        *   Is panel visible
        */
        private bool _isVisible = false;

        /*
        *   Entered command text
        */
        private string _commandText = "";

        /*
        *   List model
        */
        private Gtk.ListStore _listStore;

        /*
        *   Process SwitchVisibilityMessage
        */
        private Message? ShowHide (Type sender, Message data) {
            _isVisible = !_isVisible;

            if (_isVisible) {
                _panelBox.show_all ();
                _commandEntry.grab_focus ();

            } else {
                _commandEntry.text = "";
                _panelBox.hide ();
            }

            return null;
        }

        /*
        *   Filter list
        */
        private bool FilterFunc (Gtk.TreeModel model, Gtk.TreeIter iter) {
            if (_commandText == "") return true;

            string dat;
            model.@get (iter, 0, out dat);
            var d1 = dat.down ();            
            return d1.contains (_commandText);            
        }

        /*
        *   On row selected
        */
        private void RowSelected (Gtk.TreePath path, Gtk.TreeViewColumn column) {
            /*Gtk.TreeModel model;
            Gtk.TreeIter iter;

            selection.get_selected (out model, out iter);
            string dat;
            model.@get (iter, 0, out dat);            
            message (dat);*/

            message (path.to_string ());            
        }

        /*
        *   Process _commandEntry Change signal
        */
        private void OnTextChange () {
            _commandText = _commandEntry.text.down ();
            _filter.refilter ();
        }

        /*
        *   Create component items
        */
        public override void Init () {
            _panelBox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);            
            var left = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            var right = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);                     

            _listStore = new Gtk.ListStore (1, typeof (string));                              
            
            _filter = new Gtk.TreeModelFilter(_listStore, null);
            _filter.set_visible_func(FilterFunc);

            var commandBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            commandBox.get_style_context ().add_class ("command-panel"); 
            _commandEntry = new Gtk.Entry ();
            _commandEntry.margin = 5;
            _commandEntry.set_size_request (WIDTH, 28);
            _commandEntry.changed.connect (OnTextChange);            

            var scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.set_size_request (WIDTH, 350);            

            var commandList = new Gtk.TreeView.with_model (_filter);            
            var cell = new Gtk.CellRendererText ();
		    commandList.insert_column_with_attributes (-1, "Name", cell, "text", 0);                   
            commandList.headers_visible = false;
            commandList.override_background_color (Gtk.StateFlags.NORMAL, { 0.15f,0.15f,0.15f, 1.0f });
            commandList.hover_selection = true;
            commandList.activate_on_single_click = true;
            commandList.row_activated.connect (RowSelected);
            scrolled.margin_left = 5;
            scrolled.margin_right = 5;            
            scrolled.margin_bottom = 10;

            scrolled.add (commandList); 

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

            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages            
            dispatcher.Register (this, typeof (SwitchVisibilityMessage), ShowHide);
        }

        /*
        *   Install command
        */
        public override async void Install () {
            yield MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (MainWindow), new SetOverlayWidgetMessage (_panelBox));
        }

        /*
        *   After install all components
        */
        public override async void AfterInstall () {            
            var messa = (ReturnCommandsMessage) yield MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (CommandManager), new GetCommandsMessage ());            
            foreach (var item in messa.Commands) {
                Gtk.TreeIter iter;
                _listStore.append (out iter);
                _listStore.set (iter, 0, item.Name);                
            }
        }
    }
}