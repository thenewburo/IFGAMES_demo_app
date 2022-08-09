import Foundation

struct Constants {
    static let appName = "ImmerFilm"
    
    static let messageThreadCell = "MessageThreadCell"
    
    static let messageDetailCell = "MessageDetailCell"
    static let messageDetailCellNibName = "MessageItem"
    
    static let contactListCell = "ContactListCell"
    
    static let voicemailItemCell = "VoicemailItemCell"
    static let voicemailItemCellNibName = "VoicemailListItem"
    
    static let conversationListItem = "ConversationListItem"
    static let contactListItem = "ContactListItem"
    
    static let registerToVideoIntroSegue = "RegisterToVideoIntroSegue"
    static let loginToVideoIntroSegue = "LoginToVIdeoIntroSegue"
    static let videoIntroToHomeScreenSegue = "VideoIntroToHomeScreenSegue"
    
    
    static let messageDetailSegue = "MessageDetailSegue"
    static let messageDetailSegueNewConversation = "MessageDetailSegueNewConversation"
    static let registerToHomeScreenSegue = "RegisterToHomeScreenSegue"
    static let loginToHomeScreenSegue = "LoginToHomeScreenSegue"
    
    static let imageItemSegue = "ImageItemSegue"
    static let videoViewSegue = "VideoViewSegue"
    
    
    static let userMessageBubbleColour = "UserMessageBubbleColor"
    static let automatedMessageBubbleColour = "AutomatedMessageBubbleColor"
    static let messageShadowColour = "MessageShadowColor"
    
    static let mediaLibraryCell = "MediaLibraryCell"

    struct FireStoreData {
        static let firebaseLoginCollectionName = "logins"
        static let userEmail = "userEmail"
        
        static let firebaseMessageSelectionCollectionName = "messageSelections"
        static let replySelection = "replySelection"
    }
   


}



