//
//  ShareViewController.swift
//  shareExtent
//
//  Created by 余柠 on 2022/5/18.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {
    
    override func viewDidLoad() {
      super.viewDidLoad()
        
        let attachments = (self.extensionContext!.inputItems.first as? NSExtensionItem)?.attachments ?? []
        for provider in attachments {
            switch provider.registeredTypeIdentifiers.first {
            case "public.plain-text":
                print(provider)
                provider.loadItem(forTypeIdentifier: kUTTypePlainText, options: nil, completionHandler: { (string, error) -> Void in
                    if let string = (string as? String), let shareURL = URL(string) {
                        // send url to server to share the link
                        print (shareURL.absoluteString!)
                        
                    }
                    
                }
            case "public.url":
                print(provider)
                provider.loadItem(forTypeIdentifier: "public.url",options: nil){(data, error) in
                    // Handle the error here if you want
                    guard error == nil else { return }
                    let url = data as? URL
                    print(url)
                }
            case .none:
                print("None")
            case .some(_):
                print("Some")
            }
        }
      
    }

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
