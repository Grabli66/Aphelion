using Gtk;

namespace Aphelion {
    /*
    *   Source editor component with tabs
    */
    internal class SourceEditor : VisualComponent {
        public const string DEFAULT_ID = "SourceEditor";

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
        private Gee.HashSet<string> _pages = new Gee.HashSet<string>(); 

        /*
        *   Constructor
        */
        public SourceEditor (string id = DEFAULT_ID) {
            base (id);            
        }

        /*
        *   Return current source view
        */
        public Widget GetCurrentTabWidget () {
            var currIndex = _rootNotebook.get_current_page ();
            var currWidget = _rootNotebook.get_nth_page (currIndex);            
            return currWidget;
        }

        /*
        *   Return current source view
        */
        public SourceView GetCurrentSourceView () {
            var currIndex = _rootNotebook.get_current_page ();
            var currWidget = _rootNotebook.get_nth_page (currIndex) as Gtk.Bin;
            var currSourceView = currWidget.get_child () as SourceView;
            return currSourceView;
        }

        /*
        *   Call when component add
        */
        public override void OnEnter () {
            _rootNotebook = new Gtk.Notebook ();                    

            var langManager = new Gtk.SourceLanguageManager();                
            var lang = langManager.get_language ("vala");        
            var buffer = new Gtk.SourceBuffer.with_language (lang);
            var styleManager = new SourceStyleSchemeManager ();
            styleManager.append_search_path (".");        
            var styleScheme = styleManager.get_scheme ("vscode");
            buffer.set_style_scheme (styleScheme);                    

            var view = new Gtk.SourceView.with_buffer (buffer);
            view.highlight_current_line = true;
            view.auto_indent = true;
            view.show_line_numbers = true;    
            view.left_margin = LEFT_MARGIN;
            view.pixels_above_lines = LINE_MARGIN;

            var sw = new Gtk.ScrolledWindow (null, null);                        
            sw.add (view);

            _rootNotebook.append_page (sw, new Gtk.Label ("Empty.vala"));            

            var mainPanel = MainWindow.GetComponent ("MainPanel") as MainPanel;
            mainPanel.PlaceCenter (this);
        }

        /*
        *   Call when component leave window
        */
        public override void OnLeave () {
            
        }

        /*
        *   Return root widget of component
        */        
        public override Gtk.Widget GetRootWidget () {
            return _rootNotebook;
        }

        /*
        *   Add source
        */        
        public void AddSource (TextFileData data) {
            if (_pages.contains (data.FilePath)) return;            
            _pages.add (data.FilePath);

            var langManager = new Gtk.SourceLanguageManager();                
            var lang = langManager.get_language ("vala");        
            var buffer = new Gtk.SourceBuffer.with_language (lang);
            var styleManager = new SourceStyleSchemeManager ();
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

            var sw = new Gtk.ScrolledWindow (null, null);                        
            sw.add (view);

            _rootNotebook.append_page (sw, new Gtk.Label (data.FileName));
            _rootNotebook.show_all ();                        
        }               
    }
}