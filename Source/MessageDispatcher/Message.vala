namespace  Aphelion {  
    /*
    *   Abstract request
    */
    public abstract class Message : Object, ILogObject {  
        /*
        *   Return string description 
        */
        public virtual string ToLog () {
            return this.get_type ().name (); 
        }    
    }    
}