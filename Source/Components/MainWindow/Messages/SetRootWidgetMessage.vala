namespace  Aphelion {
    /*
    *   Request set root widget
    */
    public class SetRootWidgetMessage : Message {
        public Gtk.Widget Widget { get; private set;}

        /*
        *   Constructor
        */        
        public SetRootWidgetMessage (Gtk.Widget widget) {
            this.Widget = widget;
        }
    }
}