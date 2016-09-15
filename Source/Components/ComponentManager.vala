namespace Aphelion {
    /*
    *   Manage components: add, get, remove
    */
    public class ComponentManager : Object {
        /*
        *   Instance of manager
        */
        private static inline ComponentManager _instance;        

        /*
        *   Return instance of manager
        */
        public static ComponentManager GetInstance () {
            if (_instance == null) {
                _instance = new ComponentManager();
            }
            return _instance;
        }

        /*
        *   All components
        */
        private Gee.HashMap<string, Component?> _components;
        
        /*
        *   Is components loaded
        */
        private bool _isLoaded;

        /*
        *   Init loaded component
        */
        private void Init () {
            foreach (var comp in _components.values) {
                comp.OnInit ();
            }
        }

        /*
        *   Post init components
        */
        private void PostInit () {
            foreach (var comp in _components.values) {
                comp.OnPostInit ();
            }
        }

        /*
        *   Init loaded component
        */
        private void Layout () {
            foreach (var comp in _components.values) {
                var visualComp = comp as VisualComponent;
                if (visualComp != null) visualComp.OnLayout ();
            }
        }

        /*
        *   Constructor
        */
        private ComponentManager () {
            _components = new Gee.HashMap<string, Component?> ();
        }

        /*
        *   Load all component
        */
        public void LoadComponents () {
            if (_isLoaded) return;

            // TODO Load from plugins
            Add (new MainWindow());
            Add (new Workspace());
            Add (new FileDialog ());
            Add (new SourceEditor ());
            Add (new ShortcutManager());
            Add (new ActionManager());
            Add (new SettingsManager());
            Init ();
            PostInit ();
            Layout ();
        }        

        /*
        *   Add component
        */
        public void Add (Component component) {
            _components[component.Id] = component;
        }

        /*
        *   Get component by Id
        */
        public Component Get (string id) {
            var component = _components[id];
            if (component == null) throw new AphelionErrors.Common ("Component not found");
            return component;
        }

        /*
        *   Remove component
        */
        public void Remove (Component component) {
            _components.remove (component.Id);
        }
    }
}