namespace  Aphelion {
    /*
    *   Command for something new 
    */
    public class NewCommand : Object, ICommand {                
        /*
        *   Run command
        */        
        public void Run () {
             MessageDispatcher.GetInstance ().SendBroadcast (this, new NewMessage ()); 
        }
    }   
}