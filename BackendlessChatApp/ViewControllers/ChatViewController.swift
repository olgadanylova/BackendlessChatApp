
import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageInputField: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
        setupMessageField()
        clearMessageField()
    }
    
    func setupMessageField() {
        self.messageInputField.delegate = self
        self.messageInputField.layer.borderColor = UIColor.lightText.cgColor
        self.messageInputField.layer.borderWidth = 1
        self.messageInputField.layer.cornerRadius = 10
        self.messageInputField.translatesAutoresizingMaskIntoConstraints = false
        self.messageInputField.isScrollEnabled = false
    }
    
    func clearMessageField() {
        self.sendButton.isEnabled = false
        self.messageInputField.text = "Message"
        self.messageInputField.textColor = UIColor.lightGray
        self.messageInputField.constraints.forEach({ (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = 35
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.toolbar.isHidden = false
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        let infoValue = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = infoValue.cgRectValue.size
        UIView.animate(withDuration: 0.3, animations: {
            var viewFrame = self.view.frame
            viewFrame.size.height -= keyboardSize.height
            self.view.frame = viewFrame
        })
        scrollToBottom()
    }
    
    func scrollToBottom()  {
        DispatchQueue.main.async {
            let point = CGPoint(x: 0, y: self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.frame.height)
            if point.y >= 0{
                self.tableView.setContentOffset(point, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.3, animations: {
            let screenFrame = UIScreen.main.bounds
            var viewFrame = CGRect(x: 0, y: 0, width: screenFrame.size.width, height: screenFrame.size.height)
            viewFrame.origin.y = 0
            self.view.frame = viewFrame
        })
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollToBottom()
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            self.sendButton.isEnabled = false
        }
        else {
            self.sendButton.isEnabled = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollToBottom()
        if textView.text.isEmpty {
            textView.text = "Message"
            textView.textColor = UIColor.lightGray
            self.sendButton.isEnabled = false
        }
        else {
            self.sendButton.isEnabled = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.sendButton.isEnabled = false
        }
        else {
            self.sendButton.isEnabled = true
        }
        if textView.layoutManager.numberOfLines <= 10 {
            textView.isScrollEnabled = false
            let size = CGSize(width: textView.frame.width, height: .infinity)
            let estimatedSize = textView.sizeThatFits(size)
            textView.constraints.forEach({ (constraint) in
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            })
            scrollToBottom()
        }
        else {
            textView.isScrollEnabled = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    @IBAction func longPress(press: UILongPressGestureRecognizer) {
        press.view?.backgroundColor = UIColor.blue
    }
    
    @IBAction func pressedSend(_ sender: Any) {
        clearMessageField()
    }
}

