using Gtk;

namespace Aphelion {
    /*
    *   Main window of IDE
    */
    public class MainWindow : VisualComponent { 
        public const string DEFAULT_ID = "MainWindow";

        private const string CSS_MAIN = """
        GtkSourceView {
            font-family: 'Courier New';
            font-size: 8.5pt;                       
        }        
        """;

        /*
        *   Root widget
        */        
        private Window _mainWindow;
       
        /*
        *   Set main window settings
        */
        private void SetWindowSettings () {
            Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = true;
            _mainWindow.title = "Aphelion IDE";
            _mainWindow.border_width = 0;
            _mainWindow.window_position = WindowPosition.CENTER;
            _mainWindow.set_default_size (1024, 800);
            _mainWindow.destroy.connect (Gtk.main_quit);
        }

        /*
        *   Create header bar
        */
        private void CreatHeaderBar () {
            var header = new Gtk.HeaderBar ();
            header.show_close_button = true;
            _mainWindow.set_titlebar (header);
        }

        /*
        *   Set main css style
        */
        private void SetMainStyle () {
            var cssProvider = new CssProvider ();
            cssProvider.load_from_data (CSS_MAIN, CSS_MAIN.length);
            var screen = _mainWindow.get_screen ();
            StyleContext.add_provider_for_screen (screen, cssProvider, STYLE_PROVIDER_PRIORITY_USER);
        }

        /*
        *   Constructor
        */
        public MainWindow (string id = DEFAULT_ID) {
            base (id);            
        }

        /*
        *   Call when component add
        */
        public override void OnInit () {
            _mainWindow =  new Window ();                        
            SetWindowSettings ();            
            CreatHeaderBar ();
            SetMainStyle ();                        
        }

        /*
        *   Place all visual items to other components
        */
        public override void OnLayout () {
            _mainWindow.show_all ();
        }

        /*
        *   Return root widget of component
        */        
        public override Gtk.Widget GetRootWidget () {
            return _mainWindow;
        }
    }
}