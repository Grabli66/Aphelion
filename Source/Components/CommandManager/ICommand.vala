namespace  Aphelion {
    /*
    *   Interface of command
    */
    public interface ICommand : Object {
        /*
        *   Init command
        */
        public virtual void Init () {}

        /*
        *   Run command
        */        
        public async abstract void Run ();

        /*
        *   Return description of command
        */
        //public abstract string GetDescription ();    
    }   
}