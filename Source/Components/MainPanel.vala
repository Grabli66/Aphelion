namespace Aphelion {
    internal class MainPanel : VisualComponent {
        public const string ID_DEFAULT = "MainPanel"; 

        private Gtk.Box _rootBox;

        /*
        *   Constructor
        */
        public MainPanel (string id = ID_DEFAULT) {
            base (id);                        
        }

        /*
        *   Call when component add
        */
        public override void OnEnter () {
            _rootBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            MainWindow.GetInstance ().add (_rootBox);
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
            return _rootBox;
        }

        /*
        *   Place component to center
        */
        public void PlaceCenter (VisualComponent component) {
            var place = component.GetRootWidget ();
            _rootBox.pack_start (place);
        }
    }
}