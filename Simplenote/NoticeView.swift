import UIKit

protocol NoticeInteractionDelegate: class {
    func noticePressBegan()
    func noticePressEnded()
    func actionWasTapped()
}

class NoticeView: UIView {

    // MARK: Properties
    //
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var noticeLabel: UILabel!
    @IBOutlet private weak var noticeButton: UIButton!

    var message: String? {
        get {
            noticeLabel.text
        }
        set {
            noticeLabel.text = newValue
        }
    }
    var handler: (() -> Void)?
    var actionTitle: String? {
        get {
            noticeButton.title(for: .normal)
        }
        set {
            noticeButton.setTitle(newValue, for: .normal)
            noticeButton.isHidden = newValue == nil
        }
    }

    weak var delegate: NoticeInteractionDelegate?


    // MARK: Initialization
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    // MARK: View Layout
    //
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        setupViewStyles()
        setupGestureRecognizers()

        layoutIfNeeded()
    }

    private func setupGestureRecognizers() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(viewWasLongPressed(_:)))
        addGestureRecognizer(longPressGesture)
    }

    private func setupViewStyles() {
        backgroundColor = .clear

        backgroundView.backgroundColor = .simplenoteNoticeViewBackgroundColor
        backgroundView.layer.cornerRadius = Constants.cornerRadius

        noticeLabel.textColor = .simplenoteTextColor
        noticeButton.setTitleColor(.simplenoteTintColor, for: .normal)
        noticeButton.setTitleColor(.simplenoteCardDismissButtonHighlightedBackgroundColor, for: .highlighted)
        noticeButton.isHidden = true
        noticeButton.titleLabel?.font = UIFont.preferredFont(for: .subheadline, weight: .semibold)
        noticeButton.titleLabel?.adjustsFontForContentSizeCategory = true

    }

    // MARK: Action
    //
    @IBAction func noticeButtonWasTapped(_ sender: Any) {
        delegate?.actionWasTapped()
        handler?()
    }
}

// NOTE: long press recognizing has not been connected to anything yet
// Currently just prints to log that a press event happened.
extension NoticeView {

    // MARK: Long Press Gesture Recognizer
    //
    @objc private func viewWasLongPressed(_ gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            longPressBegan()
        case .ended:
            longPressEnded()
        default:
            return
        }
    }

    private func longPressBegan() {
        delegate?.noticePressBegan()
    }

    private func longPressEnded() {
        delegate?.noticePressEnded()
    }
}

private struct Constants {
    static let cornerRadius = CGFloat(25)
    static let nibName = "NoticeView"
}
