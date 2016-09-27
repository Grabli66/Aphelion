namespace  Aphelion {
    /*
    *   Close command 
    */
    public class CloseCommand : Object, ICommand {                
        /*
        *   Run command
        */        
        public void Run () {
            MessageDispatcher.GetInstance ().SendBroadcast (this, new CloseMessage ()); 
        }
    }   
}