namespace  Aphelion {
    /*
    *   Result from message dialog
    */
    public class MessageDialogResult {
        public const int OK = 0;
        public const int CANCEL = 1;
        public const int CLOSE = 2;

        /*
        *   Return string description
        */
        public static string GetDescription (int data) {
            switch (data) {
                case OK:
                    return "OK";
                case CANCEL:
                    return "Cancel";
                case CLOSE:
                    return "Close";
            default:
                return "";
            }
        }
    }
}