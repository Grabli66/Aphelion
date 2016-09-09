namespace Aphelion {
    /*
    *   Action for open file
    */
    internal class OpenFileAction : Action {
        /*
        *   Process key
        */
        private void OnKeyPressed (EventData data) {
            var key = data as KeyPressEvent;
            if ((key.KeyCode == KeyPressEvent.O_KEY) && (key.ControlDown)) {
                Run ();
            } 
        }

        public OpenFileAction() {
            base ();
            EventDispatcher.Subscribe (typeof(KeyPressEvent), OnKeyPressed);            
        }        

        /*
        *   Run command
        */
        public override void Run () {
            var source = MainWindow.GetComponent (SourceEditor.DEFAULT_ID) as SourceEditor;
            var filedialog = MainWindow.GetComponent (FileDialog.DEFAULT_ID) as FileDialog;
            var data = filedialog.ShowOpen ();
            source.AddSource (data);
        }
    }
}