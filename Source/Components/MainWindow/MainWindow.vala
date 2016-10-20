namespace  Aphelion {
    /*
    *   Main window component
    */
    public class MainWindow : Component {
        public const string DEFAULT_ID = "MainWindow";

        // TODO: load theme from settings
        // TODO: get custom styles from components
        private const string CSS_MAIN = """
        GtkSourceView {
            font-family: 'Courier New';
            font-size: 8pt;                       
        }   

        GtkNotebook tab {
            border-radius: 0px;
        }

        GtkNotebook GtkLabel {
            padding: 4px 10px 4px 10px;
        }
       
        notebook tab:active label,
        notebook .active-page,
        notebook tab .active-page label,
        .notebook tab:active GtkLabel,
        .notebook .active-page,
        .notebook tab .active-page GtkLabel {
            color: #FAFAFA;
        }

        .button-icon {
            border-style: none;
            box-shadow: none;
            padding: 5px;
        }        

        .command-panel {
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.3), 0 5px 5px rgba(0, 0, 0, 0.22);
            border: 1px solid #151515;
            font-size: 10px;
        }

        .command-panel GtkListBox {
            background: rgb (38, 38, 38);
        }

        .command-panel .list-row {
            padding: 5px 5px 5px 10px;
        }

        """;

        /*
        *   Root widget
        */        
        private Gtk.Window _mainWindow;

        /*
        *   Overlay
        */
        private Gtk.Overlay _mainOverlay;

        /*
        *   Set main window settings
        */
        private void SetWindowSettings () {
            Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = true;
            _mainWindow.title = "Aphelion IDE";
            _mainWindow.border_width = 0;
            _mainWindow.window_position = Gtk.WindowPosition.CENTER;
            _mainWindow.set_default_size (1600, 1000);
            _mainWindow.destroy.connect (Gtk.main_quit);
        }

        /*
        *   Set main css style
        */
        private void SetMainStyle () {
            var cssProvider = new Gtk.CssProvider ();
            cssProvider.load_from_data (CSS_MAIN, CSS_MAIN.length);
            var screen = _mainWindow.get_screen ();
            Gtk.StyleContext.add_provider_for_screen (screen, cssProvider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
        }

        /*
        *   Set header of window
        */
        private Message? SetHeaderWidget (Type sender, Message data) {
            var message = (SetHeaderWidgetMessage)data;
            _mainWindow.set_titlebar (message.Header);
            message.Header.show_all ();  
            return null;          
        }
        
        /*
        *   Set root widget of window
        */
        private Message? SetRootWidget (Type sender,Message data) {            
            var messa = (SetRootWidgetMessage)data;
            _mainOverlay.add (messa.Widget);                        
            messa.Widget.show_all ();            
            return null;            
        }

        /*
        *   Process SetOverlayWidgetMessage
        */
        private Message? SetOverlayWindow (Type sender, Message data) {
            var messa = (SetOverlayWidgetMessage)data;
            _mainOverlay.add_overlay (messa.Widget);
            //_mainOverlay.set_overlay_pass_through (messa.Widget, true);
            return null;
        }

        /*
        *   Return self
        */
        private Message? GetMainWindow (Type sender, Message data) {            
            return new ReturnWindowMessage (_mainWindow);            
        }

        /*
        *   Constructor
        */
        public MainWindow () {}

        /*
        *   Create component items
        */
        public override void Init () {
            _mainWindow =  new Gtk.Window ();
            _mainOverlay = new Gtk.Overlay ();
            _mainWindow.add (_mainOverlay);

            SetWindowSettings ();            
            SetMainStyle ();

            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages
            dispatcher.Register (this, typeof (SetHeaderWidgetMessage), SetHeaderWidget);
            dispatcher.Register (this, typeof (SetRootWidgetMessage), SetRootWidget);
            dispatcher.Register (this, typeof (GetMainWindowMessage), GetMainWindow);
            dispatcher.Register (this, typeof (SetOverlayWidgetMessage), SetOverlayWindow);
        }

        /*
        *   Place all visual items to other components
        */
        public override async void Install () {            
            /*
            *   Emit keyboard events
            */
            _mainWindow.key_press_event.connect ((e) => {
                var isCtrl = (e.state & Gdk.ModifierType.CONTROL_MASK) > 0;
                var isShift = (e.state & Gdk.ModifierType.SHIFT_MASK) > 0;
                var isAlt = (e.state & Gdk.ModifierType.MOD1_MASK) > 0;
                MessageDispatcher.GetInstance ().SendBroadcast (this.get_type (), new KeyPressMessage (e.hardware_keycode, isCtrl, isShift, isAlt));
                return false;
            });

            _mainWindow.show_all ();
        }
    }
}