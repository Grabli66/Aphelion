namespace  Aphelion {
    /*
    *   Request for set header
    */
    public class SetHeaderWidgetMessage : Message {
        public Gtk.Widget Header { get; private set;}

        /*
        *   Constructor
        */        
        public SetHeaderWidgetMessage (Gtk.Widget header) {
            this.Header = header;
        }
    }
}