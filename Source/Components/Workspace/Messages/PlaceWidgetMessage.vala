namespace  Aphelion {
    /*
    *   Request for set header
    */
    public class PlaceWidgetMessage : Message {
        /*
        *   Where to place widget
        */
        public WorkspacePlace Place { get; private set; } 

        /*
        *   Widget to place
        */
        public Gtk.Widget Widget { get; private set; }

        /*
        *   Constructor
        */
        public PlaceWidgetMessage (Gtk.Widget widget, WorkspacePlace place) {
            this.Widget = widget;
            this.Place = place;
        }
    }
}