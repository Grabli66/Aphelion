using Gtk;

namespace Aphelion {
    internal abstract class VisualComponent : Component {

        public VisualComponent (string id = "VisualComponent") {
            base (id);
        }

        /*
        *   Return root widget of component
        */        
        public abstract Widget GetRootWidget ();
    }
}