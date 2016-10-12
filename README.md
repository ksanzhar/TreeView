# TreeView
Read me: EzyTreeView: Three level
Using storyboard/nib or init with frame
Set customer class of UIView is EzyTreeView

EzyTreeView
- TableView
    - TreeTableViewCell
        - SubTreeTableViewCell
            - ChildTreeTableViewCell
        - ChildTreeTableViewCell: if no child
    - ChildTreeTableViewCell: if no child

EzyTreeView	
// Color vertical line root cell (TreeTableViewCell)
var baseVerticalLineColor: UIColor		// base vertical line
// Color vertical line sub cell (SubTreeTableViewCell)
var subBaseVerticalLineColor: UIColor	// sub base vertical line

// Font for title label root cell
var mainTitleRootFont: UIFont			// Font of title label base cell
// Color for title label root cell
var mainTitleRootColor: UIColor			// Color of title label base cell

// Font for value label root cell
var mainValueRootFont: UIFont			// Font of value label base cell

// Color for value label root cell
var mainValueRootColor: UIColor			// Color of value label base cell

// Font for title label root cell
var mainTitleSubRootFont: UIFont		// Font of title label sub base cell

// Color for title label root cell
var mainTitleSubRootColor: UIColor		// Color of title label cell sub base cell

// Font for value label root cell
var mainValueSubRootFont: UIFont		// Font of value label sub base cell

// Color for value label root cell
var mainValueSubRootColor: UIColor		// Color of value label sub base cell

// Font for title label root cell
var mainTitleDetailFont: UIFont			// Font of title label detail sub base cell

// Color for title label root cell		
var mainTitleDetailColor: UIColor		// Color of title label detail sub base cell

// Font for value label root cell
var mainValueDetailFont: UIFont			// Font of value label detail sub base cell

// Color for value label root cell
var mainValueDetailColor: UIColor		// Color of value label detail sub base cell

// Data Source
dataSource: Data cho tableview
