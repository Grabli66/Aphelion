namespace Aphelion {
    /*
    *   Component that holds other items, recieve and send messages
    */
    public abstract class Component : Object {
        /*
        *   Create component items
        */
        public virtual void Init () {}

        /*
        *   Install component
        */
        public async virtual void Install () {}

        /*
        *   After install all components
        */
        public async virtual void AfterInstall () {}
    }
}