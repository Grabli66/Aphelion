namespace Aphelion {
    /*
    *   Action for save file
    */
    internal class SaveFileAction : Action {
        public SaveFileAction() {
            base ();
            EventDispatcher.Subscribe (typeof(ContentResponseEvent), (e) => {                
                var contentEvent = (ContentResponseEvent) e;
                var data = contentEvent.Content.GetContentData ();
                if (data.FilePath == null) {
                    // Save as
                    return;
                } else {
                    FileUtils.set_contents (data.FilePath, data.Content);
                }                
            });
        }

        /*
        *   Run command
        */
        public override void Run () {
            EventDispatcher.Emit (new ContentRequestEvent ());                       
        }
    }
}