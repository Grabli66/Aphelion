namespace Aphelion {
    /*
    *   Page with content
    */
    public class SourcePage {
        /*
        *   Content file name
        */
        public string FileName { get; private set; }

        /*
        *   Content file name
        */
        public string? FilePath { get; private set; }

        /*
        *   Source view widget
        */
        public Gtk.SourceView SourceWidget { get; private set; }

        /*
        *   Constructor
        */
        public SourcePage (string fileName, string? filePath, Gtk.SourceView source) {
            FileName = fileName;
            FilePath = filePath;
            SourceWidget = source;
        }
    }

    /*
    *   Source editor component with tabs
    */
    public class SourceEditor : VisualComponent, IContentContainer {
        public const string DEFAULT_ID = "SourceEditor";
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
        *   Root widget
        */
        private Gtk.Notebook _rootNotebook;                                                    

        /*
        *   Known pages
        */
        private Gee.HashMap<string, SourcePage> _pages = new Gee.HashMap<string, SourcePage>(); 

        /*
        *   Source view that focused
        */
        public SourcePage? FocusedPage;

        /*
        *   Constructor
        */
        public SourceEditor (string id = DEFAULT_ID) {
            base (id);            
        }

        /*
        *   Return current source view
        */
        public Gtk.Widget GetCurrentTabWidget () {
            var currIndex = _rootNotebook.get_current_page ();
            var currWidget = _rootNotebook.get_nth_page (currIndex);            
            return currWidget;
        }

        /*
        *   Return current source view
        */
        public Gtk.SourceView GetCurrentSourceView () {
            var currIndex = _rootNotebook.get_current_page ();
            var currWidget = _rootNotebook.get_nth_page (currIndex) as Gtk.Bin;
            var currSourceView = currWidget.get_child () as Gtk.SourceView;
            return currSourceView;
        }

        /*
        *   Call when component init
        */
        public override void OnInit () {
            _rootNotebook = new Gtk.Notebook ();
            AddSource (new TextFileData.FromFileName("Empty.vala", ""));
            EventDispatcher.Subscribe (typeof (ContentRequestEvent), (e) => {
                if (FocusedPage != null) EventDispatcher.Emit (new ContentResponseEvent (this));
            });
        }

        /*
        *   Place all visual items to other components
        */
        public override void OnLayout () {
            var compManager = ComponentManager.GetInstance ();
            var workspace = compManager.Get (Workspace.DEFAULT_ID) as Workspace;
            workspace.PlaceCenter (this);
        }

        /*
        *   Call when component removed
        */
        public override void OnRemove () {
        }

        /*
        *   Return root widget of component
        */ 
        public override Gtk.Widget GetRootWidget () {
            return _rootNotebook;
        }

        /*
        *   Return content if exists
        */
        public TextFileData? GetContentData () {
            if (FocusedPage == null) return null;
            var buffer = FocusedPage.SourceWidget.buffer;
            TextFileData res;
            if (FocusedPage.FilePath == null) {
                res = new TextFileData.FromFileName (FocusedPage.FileName, buffer.text);
            } else {
               res = new TextFileData.FromFilePath (FocusedPage.FilePath, buffer.text);
            }

            return res;
        }

        /*
        *   Add source
        */
        public void AddSource (TextFileData data) {
            if (_pages.has_key (data.FilePath)) return;            

            var langManager = new Gtk.SourceLanguageManager();
            var lang = langManager.get_language ("vala");
            var buffer = new Gtk.SourceBuffer.with_language (lang);
            var styleManager = new Gtk.SourceStyleSchemeManager ();
            styleManager.append_search_path (".");
            var styleScheme = styleManager.get_scheme ("vscode");
            buffer.set_style_scheme (styleScheme);
            buffer.set_text (data.Content);

            var view = new Gtk.SourceView.with_buffer (buffer);
            view.highlight_current_line = true;
            view.auto_indent = true;
            view.show_line_numbers = true;
            view.left_margin = LEFT_MARGIN;
            view.pixels_above_lines = LINE_MARGIN;
            view.tab_width = DEFAULT_TAB_WIDTH;

            var newPage = new SourcePage (data.FileName, data.FilePath, view);

            view.focus_in_event.connect ((e) => {
                var localPage = newPage;
                FocusedPage = localPage;                
                return false;
            });

            view.focus_out_event.connect ((e) => {
                FocusedPage = null;              
                return false;
            });

            var sw = new Gtk.ScrolledWindow (null, null);
            sw.add (view);

            _rootNotebook.append_page (sw, new Gtk.Label (data.FileName));
            _pages[data.FilePath] = newPage;
            _rootNotebook.show_all ();
        }
    }
}