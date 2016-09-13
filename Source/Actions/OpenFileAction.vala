namespace Aphelion {
    /*
    *   Action for open file
    */
    internal class OpenFileAction : Action {
        /*
        *   Process shortcut
        */
        private void OnShortcut (EventData data) {
            Run ();
        }

        public OpenFileAction() {
            base ();
            EventDispatcher.Subscribe (typeof(ShortcutEvent), OnShortcut);            
        }        

        /*
        *   Run command
        */
        public override void Run () {
            var compManager = ComponentManager.GetInstance ();

            var source = compManager.Get (SourceEditor.DEFAULT_ID) as SourceEditor;
            var filedialog = compManager.Get (FileDialog.DEFAULT_ID) as FileDialog;
            var data = filedialog.ShowOpen ();
            if (data == null) return;
            source.AddSource (data);
        }
    }
}