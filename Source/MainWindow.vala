using Gtk;

namespace Aphelion {
    /*
    *   Main window of IDE
    */
    internal class MainWindow : Window {    
        private const string CSS_MAIN = """
        *.sourceview {
            font-family: 'Courier New';
            font-size: 8.5pt;                       
        }

        menuitem {
            font-size: 8pt;
        }
        """;

        /*
        *   Main window instance
        */
        private static MainWindow _mainWindow;

        /*
        *   All components
        */
        private static Gee.HashMap<string, Component?> _components;

        /*
        *   All actions
        */
        private static Gee.HashMap<string, Action?> _actions;

        /*
        *   Set main window settings
        */
        private void SetWindowSettings () {
            title = "Aphelion IDE";
            border_width = 0;
            window_position = WindowPosition.CENTER;
            set_default_size (1024, 800);
            destroy.connect (Gtk.main_quit);
        }

        /*
        *   Create header bar
        */
        private void CreatHeaderBar () {
            var header = new Gtk.HeaderBar ();
            header.show_close_button = true;
            set_titlebar (header);
        }

        /*
        *   Set main css style
        */
        private void SetMainStyle () {
            var cssProvider = new CssProvider();
            cssProvider.load_from_data(CSS_MAIN, CSS_MAIN.length);
            var screen = get_screen();
            StyleContext.add_provider_for_screen(screen, cssProvider, STYLE_PROVIDER_PRIORITY_USER);
        }

        /*
        *   Get component by name
        */
        public static Component GetComponent (string name) {
            var comp = _components[name];
            if (comp == null) throw new AphelionErrors.Common ("Component not found");
            return comp;
        }

        /*
        *   Add component
        */
        public static void AddComponent (Component component) {
            component.OnEnter ();            
            _components[component.Id] = component;
        }

        /*
        *   Add action
        */
        public static void AddAction (Action action) {
            var name = action.get_type ().name ();
            _actions[name] = action;
        }

        /*
        *   Execute action
        */
        public static void ExecuteAction (Type actionType) {
            var name = actionType.name ();
            var action = _actions[name];
            if (action == null) return;
            action.Run ();
        }

        /*
        *   Return instance of MainWindow
        */
        public static inline MainWindow GetInstance () {
            return _mainWindow;
        }

        /*
        *   Constructor
        */
        public MainWindow () {
            _mainWindow = this;
            _components = new Gee.HashMap<string, Component?> ();
            _actions = new Gee.HashMap<string, Action?> ();

            AddComponent (new MainPanel());
            AddComponent (new FileDialog ());
            AddComponent (new SourceEditor ());
            AddComponent (new Keyboard());
            
            AddAction (new OpenFileAction ());
            AddAction (new SaveFileAction ());

            SetWindowSettings ();            
            // Create header
            CreatHeaderBar ();

            SetMainStyle ();
        }        
    }
}