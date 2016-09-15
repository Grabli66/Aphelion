namespace Aphelion {
    /*
    *   Hold other components in place
    */
    public class Workspace : VisualComponent {
        public const string DEFAULT_ID = "Workspace";         

        /*
        *   Root widget
        */
        private Gtk.Box _rootBox;

        /*
        *   Constructor
        */
        public Workspace (string id = DEFAULT_ID) {
            base (id);                                    
        }

        /*
        *   Call when component add
        */
        public override void OnInit () {
            _rootBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);                        
        }

        /*
        *   Place all visual items to other components
        */
        public override void OnLayout () {
            var mainWindow = ComponentManagerHelper.GetMainWindowWidget ();
            mainWindow.add (_rootBox);
        }

        /*
        *   Call when component leave window
        */
        public override void OnRemove () {
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

        /*
        *   Place component to left
        */
        public void PlaceLeft (VisualComponent component) {            
        }

        /*
        *   Place component to right
        */
        public void PlaceRight (VisualComponent component) {            
        }

        /*
        *   Place component to top
        */
        public void PlaceTop (VisualComponent component) {            
        }

        /*
        *   Place component to bottom
        */
        public void PlaceBottom (VisualComponent component) {            
        }
    }
}