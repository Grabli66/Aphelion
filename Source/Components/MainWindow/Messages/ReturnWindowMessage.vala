namespace  Aphelion {
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