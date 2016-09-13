namespace Aphelion {
    /*
    *   Action for save file
    */
    internal class SaveAsFileAction : Action { 
        /*
        *   Process key
        */
        private void OnKeyPressed (EventData data) {
            /*var key = data as KeyPressEvent;
            if ((key.KeyCode == KeyPressEvent.S_KEY) && (key.ControlDown)) {
                Run ();
            } */
        }

        public SaveAsFileAction() {
            base ();
            //EventDispatcher.Subscribe (typeof(KeyPressEvent), OnKeyPressed);
        }

        /*
        *   Run command
        */
        public override void Run () {
           /* var source = MainWindow.GetComponent (SourceEditor.DEFAULT_ID) as SourceEditor;
            var filedialog = MainWindow.GetComponent (FileDialog.DEFAULT_ID) as FileDialog;
            filedialog.ShowSave ();*/            
        }
    }
}