namespace  Aphelion {
    /*
    *   File dialog component for open/save files
    */
    public class FileDialog : Component {
        public const string OPEN_FILE_NAME = "Open File";
        public const string SAVE_FILE_NAME = "Save File";

        /*
        *   Main window
        */
        private Gtk.Window _mainWindow;

        /*
        *   Recieve main window widget
        */
        private void RecieveMainWindow (ReturnWindowMessage message) {
            _mainWindow = message.MainWindow;
        }

        /*
        *   Show open file dialog
        */
        public void OpenFile (Object sender, OpenFileMessage message) {
            var fileChooser = new Gtk.FileChooserDialog (OPEN_FILE_NAME, _mainWindow,
                                      Gtk.FileChooserAction.OPEN, 
                                      "_Cancel",
				                      Gtk.ResponseType.CANCEL,
				                      "_Open",
				                      Gtk.ResponseType.ACCEPT);            
                                    
            fileChooser.window_position = Gtk.WindowPosition.CENTER;
            fileChooser.set_transient_for (_mainWindow);
            
            // TODO: filter from message
            var filter = new Gtk.FileFilter ();
	        filter.set_filter_name ("Vala source");
	        filter.add_pattern ("*.vala");
            fileChooser.add_filter (filter);

            if (fileChooser.run () == Gtk.ResponseType.ACCEPT) {
                var filePath = fileChooser.get_filename ();
                stderr.printf (filePath + "\n");
                string data;
                size_t size;
                FileUtils.get_contents (filePath, out data, out size);                
                var res = new TextFileContent (filePath, data);
                MessageDispatcher.GetInstance ().Send (this, sender.get_type (), new FilesOpenedMessage ( { res } ));                
            }   

            fileChooser.destroy ();
        }
         
        /*
        *   Create component items
        */
        public override void Init () {
            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages
            dispatcher.Register (typeof (ReturnWindowMessage), this);
            dispatcher.Register (typeof (OpenFileMessage), this);
        }

        /*
        *   Place all visual items to other components
        */
        public override void Install () {
             MessageDispatcher.GetInstance ().Send (this, typeof (MainWindow), new GetMainWindowMessage ());
        }

        /*
        *   On receive message
        */
        public override void OnMessage (Object sender, Message data) {
            if (data is ReturnWindowMessage) RecieveMainWindow ((ReturnWindowMessage)data);            
            if (data is OpenFileMessage) OpenFile (sender, (OpenFileMessage)data);                                    
        }
    }
}