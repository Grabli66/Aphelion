namespace  Aphelion {
    /*
    *   Manage components: add, get, remove
    */
    public class ComponentManager : GLib.Object { 
        /*
        *   Instance of manager
        */
        private static inline ComponentManager _instance;        

        /*
        *   Return instance of manager
        */
        public static ComponentManager GetInstance () {
            if (_instance == null) _instance = new ComponentManager();            
            return _instance;
        }

        /*
        *   All components
        */
        private Gee.HashMap<string, Component?> _components;
        
        /*
        *   Constructor
        */
        private ComponentManager() {
            _components = new Gee.HashMap<string, Component?> ();         
        }

        /*
        *   Init components
        */
        private void Init () {
            var dispatcher = MessageDispatcher.GetInstance ();
            foreach (var comp in _components.values) {
                comp.Init ();                
            }
        }

        /*
        *   Add component
        */
        public void Add (Component component) {
            var name = component.get_type ().name ();
            _components[name] = component;
        }

        /*
        *   Get component by Id
        */
        public Component Get (Type type) throws AphelionErrors.Common {
            var name = type.name ();
            var component = _components[name];
            if (component == null) throw new AphelionErrors.Common (@"Component $name not found");
            return component;
        }

        /*
        *   Install component
        */
        public void Install (Type type) {            
            var component = Get (type);
            component.Install ();
        }

        /*
        *   Install all known components
        */
        public void InstallAll () {
            foreach (var comp in _components.values) {
                comp.Install ();
            }

            foreach (var comp in _components.values) {
                comp.AfterInstall ();
            }
        }

        /*
        *   Load all components and start scene manager 
        */
        public void Load () {
            // TODO load from lib 
            Add (new SceneManager ());
            Add (new MainWindow ());
            Add (new Header ());
            Add (new Workspace ());
            Add (new SourceEditor ());
            Add (new CommandManager ());
            Add (new CommandPanel ());
            Add (new Dialogs ());
            Add (new FileOperations ());
            Add (new Completion ());

            // Commands
            // TODO register commands
            Add (new NewDocumentCommand ());
            Add (new OpenCommand ());
            Add (new SaveDocumentCommand ());
            Add (new SaveAsCommand ());
            Add (new CloseCommand ());
            Add (new QuitCommand ());
            Add (new ShowHideCommandPanelCommand ());

            Init ();
            
            var scene = Get (typeof (SceneManager)) as SceneManager;            
            scene.Install ();
        }
    }
}