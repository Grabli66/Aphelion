namespace  Aphelion {
    /*
    *   Set overlay widget
    */
    public class SetOverlayWidgetMessage : Message {
        public Gtk.Widget Widget { get; private set;}

        /*
        *   Constructor
        */        
        public SetOverlayWidgetMessage (Gtk.Widget widget) {
            this.Widget = widget;
        }
    }
}