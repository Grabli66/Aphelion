namespace Aphelion {
    /*
    *   Component that loads into component manager
    */
    public abstract class Component : Object {
        public const string DEFAULT_ID = "Component";

        /*
        *   Id of component
        */
        public string Id { get; private set; }

        /*
        *   Create all items in component.
        *   Must have no calls to ComponentManager, 
        *   cause component could not exist.
        */
        public virtual void OnInit () {}

        /*
        *   For actions after item created
        *   Can have calls of ComponentManager
        */
        public virtual void OnPostInit () {}

        /*
        *   Remove component and it items
        */
        public virtual void OnRemove () {}

        /*
        *   Constructor
        */
        public Component (string id = DEFAULT_ID) {
            Id = id;
        }
    }
}