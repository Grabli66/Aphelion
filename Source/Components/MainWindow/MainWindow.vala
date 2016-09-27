namespace  Aphelion {
    /*
    *   Main window component
    */
    public class MainWindow : Component {
        public const string DEFAULT_ID = "MainWindow";

        // TODO: load theme from settings
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

        .button-icon:hover {
            background: #353840;
        }
        """;

        /*
        *   Root widget
        */        
        private Gtk.Window _mainWindow;
       
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
        private void SetHeaderWidget (SetHeaderWidgetMessage message) {
            _mainWindow.set_titlebar (message.Header);
            message.Header.show_all ();
        }

        /*
        *   Set root widget of window
        */
        private void SetRootWidget (SetRootWidgetMessage message) {
            _mainWindow.add (message.Widget);
            message.Widget.show_all ();
        }

        /*
        *   Return self
        */
        private void GetMainWindow (Object sender) {
            MessageDispatcher.GetInstance ().Send (this, sender.get_type (), new ReturnWindowMessage (_mainWindow));
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
            SetWindowSettings ();            
            SetMainStyle ();            

            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages
            dispatcher.Register (typeof (SetHeaderWidgetMessage), this);
            dispatcher.Register (typeof (SetRootWidgetMessage), this);
            dispatcher.Register (typeof (GetMainWindowMessage), this);
        }

        /*
        *   Place all visual items to other components
        */
        public override void Install () {            
            /*
            *   Emit keyboard events
            */
            _mainWindow.key_press_event.connect ((e) => {
                var isCtrl = (e.state & Gdk.ModifierType.CONTROL_MASK) > 0;
                var isShift = (e.state & Gdk.ModifierType.SHIFT_MASK) > 0;
                var isAlt = (e.state & Gdk.ModifierType.MOD1_MASK) > 0;
                MessageDispatcher.GetInstance ().SendBroadcast (this, new KeyPressMessage (e.hardware_keycode, isCtrl, isShift, isAlt));
                return false;
            });

            _mainWindow.show_all ();
        }

        /*
        *   On receive message
        */
        public override void OnMessage (Object sender, Message data) {            
            if (data is SetHeaderWidgetMessage) SetHeaderWidget ((SetHeaderWidgetMessage)data);
            if (data is SetRootWidgetMessage) SetRootWidget ((SetRootWidgetMessage)data);                        
            if (data is GetMainWindowMessage) GetMainWindow (sender);
        } 
    }
}