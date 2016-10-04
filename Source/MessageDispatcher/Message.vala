namespace  Aphelion {
    /*
    *   Delegate for get message
    */
    public delegate Message? OnMessageDelegate (Type sender, Message message);

    /*
    *   Abstract request
    */
    public abstract class Message : Object {
    }    
}