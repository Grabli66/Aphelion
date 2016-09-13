using Gtk;

namespace Aphelion {
    /*
    *   Visual component that has one or more gtk widget
    */
    internal abstract class VisualComponent : Component {
        public const string DEFAULT_ID = "VisualComponent";

        /*
        *   Constructor
        */
        public VisualComponent (string id = DEFAULT_ID) {
            base (id);
        }

        /*
        *   Place all visual items to other components
        */
        public virtual void OnLayout () {}

        /*
        *   Return root widget of component
        */        
        public abstract Widget GetRootWidget ();
    }
}