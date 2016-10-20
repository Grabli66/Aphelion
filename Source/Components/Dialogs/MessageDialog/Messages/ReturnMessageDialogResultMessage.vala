namespace  Aphelion {
    /*
    *   Result from message dialog message
    */
    public class ReturnMessageDialogResultMessage : Message {
        /*
        *   Result from dialog
        */
        public MessageDialogResult Result { get; private set; }

        /*
        *   Constructor
        */
        public ReturnMessageDialogResultMessage (MessageDialogResult result) {
            this.Result = result;            
        }

        /*
        *   Return log message
        */
        public override string ToLog () {
            var descr = MessageDialogResult.GetDescription (Result);
            return @"ReturnMessageDialogResultMessage : { Result : $descr }";
        }
    }
}