namespace  Aphelion {
    /*
    *   Request for set header
    */
    public class PlaceWidgetMessage : Message {
        public Gtk.Widget Widget { get; private set;}

        /*
        *   Constructor
        */        
        public PlaceWidgetMessage (Gtk.Widget widget) {
            this.Widget = widget;
        }
    }
}