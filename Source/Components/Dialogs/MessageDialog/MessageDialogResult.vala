namespace  Aphelion {
    /*
    *   Result from message dialog
    */
    public enum MessageDialogResult {
        OK,
        CANCEL;

        /*
        *   Return string description
        */
        public static string GetDescription (MessageDialogResult data) {
            switch (data) {
                case OK:
                    return "OK";
                case CANCEL:
                    return "Cancel";
            default:
                return "";
            }
        }
    }
}