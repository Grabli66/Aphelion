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

    /*
    *   Get main window
    */
    public class GetMainWindowMessage : Message {        
    }

    /*
    *   Return main window
    */
    public class ReturnWindowMessage : Message {
        /*
        *   Main window
        */
        public Gtk.Window MainWindow { get; private set; }

        /*
        *   Constructor
        */
        public ReturnWindowMessage (Gtk.Window mainWindow) {
            MainWindow = mainWindow;
        }         
    }
}