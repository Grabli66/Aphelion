namespace Aphelion {
    internal abstract class Component : Object {
        public string Id { get; private set; }

        /*
        *   Call when component add
        */
        public abstract void OnEnter ();

        /*
        *   Call when component leave window
        */
        public abstract void OnLeave ();

        public Component (string id = "Component") {
            Id = id;
        }
    }
}