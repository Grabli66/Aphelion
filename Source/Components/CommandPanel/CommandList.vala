namespace  Aphelion {
    /*
    *   List for commands
    */
    public class CommandList : Gtk.ListBox {
        /*
        * Text for filter
        */
        private string _filterText = "";

        /*
        *   Filter list
        */
        private bool FilterFunc (Gtk.ListBoxRow row) {
            if (_filterText == "") return true;
            var commandRow = row as CommandListRow;
            if (commandRow == null) return false;
            var down = commandRow.Name.down ();
            return down.contains (_filterText);
        }

        /*
        *   Sort func
        */
        private int SortFunc(Gtk.ListBoxRow row1, Gtk.ListBoxRow row2) {
            var r1 = row1 as CommandListRow;
            var r2 = row2 as CommandListRow;
            if (r1 == null || r2 == null) return -1;
            return r1.Name.collate (r2.Name); 
        }        

        /*
        *   Constructor
        */
        public CommandList () {
            set_filter_func (FilterFunc);
            set_sort_func (SortFunc);            
        }

        /*
        *   Append command
        */
        public void Append (string name, Object userData) {
            this.prepend (new CommandListRow (name, userData));
            this.show_all ();
        }

        /*
        *   Filter command by text
        */
        public void Filter (string text) {
            _filterText = text;            
            invalidate_filter ();
        }
    }
}