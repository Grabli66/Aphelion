namespace  Aphelion {
    /*
    *   File dialog component for open/save files
    */
    public class FileDialog : Component {
        public const string OPEN_FILE_NAME = "Open File";
        public const string SAVE_FILE_NAME = "Save File";
        public const string SAVE_AS_FILE_NAME = "Save As File";

        /*
        *   Main window
        */
        private Gtk.Window _mainWindow;

        /*
        *   Process ShowFileDialogMessage
        */
        private Message? ShowDialog (Type sender, Message data) {            
            var message = (ShowFileDialogMessage) data;
            switch (message.Operation) {
                case DialogOperation.OPEN:
                    return OpenFile (sender, message); 
                    break;
                case DialogOperation.SAVE:
                    return SaveFile (sender, message);
                    break;
            default:
                break;
            }
            return null;
        }

        /*
        *   Show open file dialog
        */
        private Message? OpenFile (Type sender, ShowFileDialogMessage message) {
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

            Message? res = null;

            if (fileChooser.run () == Gtk.ResponseType.ACCEPT) {
                var filePath = fileChooser.get_filename ();                
                res = new ReturnFilePathMessage (filePath, DialogOperation.OPEN);
            }   

            fileChooser.destroy ();
            return res;
        }

        /*
        *   Show save as dialog
        */
        private Message? SaveFile (Type sender, ShowFileDialogMessage message) {
            var fileChooser = new Gtk.FileChooserDialog (SAVE_AS_FILE_NAME, _mainWindow,
                                      Gtk.FileChooserAction.SAVE, 
                                      "_Cancel",
				                      Gtk.ResponseType.CANCEL,
				                      "_Save",
				                      Gtk.ResponseType.ACCEPT);
            
            fileChooser.window_position = Gtk.WindowPosition.CENTER;
            fileChooser.set_transient_for (_mainWindow);

            // TODO: filter from content
            var filter = new Gtk.FileFilter ();
	        filter.set_filter_name ("Vala source");
	        filter.add_pattern ("*.vala");
            fileChooser.add_filter (filter);

            Message? res = null;

            if (fileChooser.run () == Gtk.ResponseType.ACCEPT) {
                var filePath = fileChooser.get_filename ();                   
                res = new ReturnFilePathMessage (filePath, DialogOperation.SAVE);                                                                                        
            }   

            fileChooser.destroy ();
            return res;
        }
         
        /*
        *   Create component items
        */
        public override void Init () {
            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages            
            dispatcher.Register (this, typeof (ShowFileDialogMessage), ShowDialog);
        }

        /*
        *   Place all visual items to other components
        */
        public override async void Install () {
             var res = (ReturnWindowMessage) yield MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (MainWindow), new GetMainWindowMessage ());
             _mainWindow = res.MainWindow;
        }
    }
}