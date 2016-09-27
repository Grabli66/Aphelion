namespace  Aphelion {
    /*
    *   Tabbed source editor
    */
    public class SourceEditor : Component {
        /*
        *   Width of tab
        */
        public const uint DEFAULT_TAB_WIDTH = 4;
        
        /*
        *   Margin from left
        */
        public const int LEFT_MARGIN = 20;

        /*
        *   Margin between lines
        */        
        public const int LINE_MARGIN = 3;

        /*
        *   Notebook widget
        */
        private Gtk.Notebook _notebook;  

        /*
        *   Known pages; Path -> SourcePage
        */
        private Gee.HashMap<string, SourcePage?> _pages = new Gee.HashMap<string, SourcePage?>(); 

        /*
        *   Source view that focused
        */
        private SourcePage? _focusedPage;

        /*
        *   Return self type
        */
        private void ReturnGetFileContentHandler (Object sender, GetFileContentHandlerMessage message) {
            MessageDispatcher.GetInstance ().Send (this, sender.get_type (), new ReturnContentHandlerMessage (this.get_type ()));
        } 

        /*
        *   Return file content
        */
        private void ReturnGetFileContent (Object sender, GetFileContentMessage data) {
            if (_focusedPage == null) return;
            var content = _focusedPage.GetFileContent ();
            MessageDispatcher.GetInstance ().Send (this, sender.get_type (), new ReturnFileContentMessage (content));
        }

        /*
        *   Set file content
        */
        private void SetFileContent (SetFileContentMessage message) {
            var content = message.Content[0];
            AddSource (content.FilePath, content.Content);
        }

        /*
        *   On content saved
        */
        private void ContentSaved (ContentSavedMessage data) {
            // TODO compare content
            if (_focusedPage == null) return;
            _focusedPage.SetChanged (false);
        }

        /*
        *   Add source
        */
        private void AddSource (string path, string data, bool isTemp = false) {
            var page = _pages[path];
            if (page != null) return;
            page = new SourcePage (path, data, isTemp, _notebook);

            page.OnFocusIn.connect ((e) => {
                _focusedPage = e;
            });

            page.OnFocusOut.connect ((e) => {
                _focusedPage = null;
            });

            page.OnPageClose.connect ((e) => {
                _pages.remove (e.FilePath);
                e.RemovePage ();
            });

            _pages[path] = page;
            _notebook.show_all ();            
        }       

        /*
        *   Process CloseMessage
        */
        private void ClosePage (CloseMessage data) {
            if (_focusedPage == null) return;
            _pages.remove (_focusedPage.FilePath);
            _focusedPage.RemovePage ();
        }

        /*
        *   Create component items
        */
        public override void Init () {
            _notebook = new Gtk.Notebook ();
            AddSource ("Empty.vala", "", true);

            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages
            dispatcher.Register (typeof (GetFileContentHandlerMessage), this);
            dispatcher.Register (typeof (SetFileContentMessage), this);
            dispatcher.Register (typeof (GetFileContentMessage), this);
            dispatcher.Register (typeof (ContentSavedMessage), this);
            dispatcher.Register (typeof (CloseMessage), this);
        }

        /*
        *   Install component
        */
        public override void Install () {
            MessageDispatcher.GetInstance ().Send (this, typeof (Workspace), new PlaceWidgetMessage (_notebook));
        }

        /*
        *   On receive message
        */
        public override void OnMessage (Object sender, Message data) {
            if (data is GetFileContentHandlerMessage) ReturnGetFileContentHandler (sender, (GetFileContentHandlerMessage) data);            
            if (data is SetFileContentMessage) SetFileContent ((SetFileContentMessage)data);
            if (data is GetFileContentMessage) ReturnGetFileContent (sender, (GetFileContentMessage)data);
            if (data is ContentSavedMessage) ContentSaved ((ContentSavedMessage)data);
            if (data is CloseMessage) ClosePage ((CloseMessage)data);
        }
    }
}