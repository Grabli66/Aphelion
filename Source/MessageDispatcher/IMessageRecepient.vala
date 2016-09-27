namespace  Aphelion {
    /*
    *   Interface for object that can receive messages 
    */    
    public interface IMessageRecepient : Object {
        /*
        *   On receive message
        */
        public abstract void OnMessage (Object sender, Message data);        
    }
}