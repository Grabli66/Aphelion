namespace  Aphelion {
    /*
    *   Component for show different dialogs
    */
    public class Dialogs : Component {        
        /*
        *   Main window
        */
        private Gtk.Window _mainWindow;

        /*
        *   Process ShowFileDialogMessage
        */
        private Message? ShowFileDialog (Type sender, Message data) {
            var messa = (ShowFileDialogMessage) data;
            var dialog = new FileDialog (_mainWindow, messa);
            return dialog.ShowWithResult ();
        }    

        /*
        *   Process ShowMessageDialogMessage
        */
        private Message? ShowMessageDialog (Type sender, Message data) {
            var messa = (ShowMessageDialogMessage) data;
            var dialog = new MessageDialog (_mainWindow, messa);
            return dialog.ShowWithResult ();
        }     
         
        /*
        *   Create component items
        */
        public override void Init () {            
            // Register messages            
            MessageDispatcher.Register (this, typeof (ShowFileDialogMessage), ShowFileDialog);
            MessageDispatcher.Register (this, typeof (ShowMessageDialogMessage), ShowMessageDialog);
        }

        /*
        *   Place all visual items to other components
        */
        public override async void Install () {
             var res = (ReturnWindowMessage) yield MessageDispatcher.Send (this.get_type (), typeof (MainWindow), new GetMainWindowMessage ());
             _mainWindow = res.MainWindow;
        }
    }
}