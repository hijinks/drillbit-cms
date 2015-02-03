define(['aloha', 'jquery', 'aloha/contenthandlermanager'],
(Aloha, jQuery, ContentHandlerManager)->
    "use strict";
 
    MyContentHandler = ContentHandlerManager.createHandler
        handleContent: ( content )->
            return content.trim()
    return MyContentHandler;
});