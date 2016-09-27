namespace  Aphelion {
    /*
    *   Standard scene manager
    */
    public class Workspace : Component { 
        /*
        *   Root widget
        */
        private Gtk.Box _rootBox;

        /*
        *   Place widget to some place 
        */
        private void PlaceWidget (PlaceWidgetMessage message) {
            _rootBox.pack_start (message.Widget);
        }

        /*
        *   Create component items
        */
        public override void Init () {
            _rootBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages
            dispatcher.Register (typeof (PlaceWidgetMessage), this);
        }

        /*
        *   Install component
        */
        public override void Install () {
            MessageDispatcher.GetInstance ().Send (this, typeof (MainWindow), new SetRootWidgetMessage (_rootBox));          
        }

        /*
        *   On receive message
        */
        public override void OnMessage (Object sender, Message data) {            
            if (data is PlaceWidgetMessage) PlaceWidget ((PlaceWidgetMessage)data);                                    
        } 
    }
}