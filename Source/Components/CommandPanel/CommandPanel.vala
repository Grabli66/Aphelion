namespace  Aphelion {
    /*
    *   Component for showing commands
    */
    public class CommandPanel : Component {
        /*
        *   Main box
        */
        private Gtk.Box _panelBox;

        /*
        *   Is panel visible
        */
        private bool _isVisible = false;

        /*
        *   Process SwitchVisibilityMessage
        */
        private Message? ShowHide (Type sender, Message data) {
            _isVisible = !_isVisible;

            if (_isVisible) {
                _panelBox.show_all ();
            } else {
                _panelBox.hide ();
            }

            return null;
        }

        /*
        *   Create component items
        */
        public override void Init () {
            _panelBox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            var left = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            var right = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);                     

            var list_store = new Gtk.ListStore (1, typeof (string));          
            Gtk.TreeIter iter;

            list_store.append (out iter);
            list_store.set (iter, 0, "Burgenland");
            list_store.append (out iter);
            list_store.set (iter, 0, "Carinthia");
            list_store.append (out iter);
            list_store.set (iter, 0, "Lower Austria");
            list_store.append (out iter);
            list_store.set (iter, 0, "Upper Austria");
            list_store.append (out iter);
            list_store.set (iter, 0, "Salzburg");
            list_store.append (out iter);
            list_store.set (iter, 0, "Styria");
            list_store.append (out iter);
            list_store.set (iter, 0, "Tyrol");
            list_store.append (out iter);
            list_store.set (iter, 0, "Vorarlberg");
            list_store.append (out iter);
            list_store.set (iter, 0, "Vienna");
            
            var commandBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0); 
            var commandEntry = new Gtk.Entry ();                 
            var commandList = new Gtk.TreeView.with_model (list_store);
            var cell = new Gtk.CellRendererText ();
		    commandList.insert_column_with_attributes (-1, "Name", cell, "text", 0);                   
            commandList.headers_visible = false;
            commandBox.pack_start (commandEntry, true, true, 0);
            commandBox.pack_start (commandList, true, true, 0);
            commandBox.override_background_color (Gtk.StateFlags.NORMAL, { 0.15f,0.15f,0.15f, 1.0f }); 
            commandList.override_background_color (Gtk.StateFlags.NORMAL, { 0.15f,0.15f,0.15f, 1.0f });
            commandEntry.margin = 3;           

            commandEntry.set_size_request (450, 28);
            _panelBox.pack_start (left, true, true, 0);
            _panelBox.pack_start (commandBox, false, false, 0);
            _panelBox.pack_start (right, true, true, 0);
            _panelBox.set_baseline_position (Gtk.BaselinePosition.TOP);
            commandBox.valign = Gtk.Align.START;
            commandEntry.valign = Gtk.Align.START;
            commandList.valign = Gtk.Align.START; 

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
    }
}