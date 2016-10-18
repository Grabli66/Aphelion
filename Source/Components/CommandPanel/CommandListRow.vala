namespace  Aphelion {
    /*
    *   Command list row
    */
    public class CommandListRow : Gtk.ListBoxRow {
        /*
        *   Visible row name 
        */
        public string Name { get; private set; }

        /*
        *   Some object to store
        */
        public Object UserData { get; private set; }

        /*
        *   Box for all items
        */
        private Gtk.Box _itemBox;

        /*
        *   Label for command name
        */
        private Gtk.Label _nameLabel;

        /*
        *   Constructor
        */
        public CommandListRow (string name, Object userData) {            
            this.Name = name;
            this.UserData = userData;

            _itemBox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            _nameLabel = new Gtk.Label (name);
            _nameLabel.halign = Gtk.Align.START;           
            _itemBox.pack_start (_nameLabel, true, true);

            add (_itemBox);
        }
    }
}