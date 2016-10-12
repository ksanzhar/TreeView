# TreeView
Read me: EzyTreeView: Three level
Using storyboard/nib or init with frame
Set customer class of UIView is EzyTreeView
Model: must have a variable isExpand.

EzyTreeView
- TableView
- TreeTableViewCell
- SubTreeTableViewCell
- ChildTreeTableViewCell
- ChildTreeTableViewCell: if no child
- ChildTreeTableViewCell: if no child

EzyTreeView	
// Color vertical line root cell (TreeTableViewCell)
var baseVerticalLineColor: UIColor		// màu line dọc ở cell ngoài cùng base
// Color vertical line sub cell (SubTreeTableViewCell)
var subBaseVerticalLineColor: UIColor	// màu line dọc ở cell cấp thứ 2

// Font for title label root cell
var mainTitleRootFont: UIFont			// Font của title label cell ngoài cùng
// Color for title label root cell
var mainTitleRootColor: UIColor			// Màu của title label cell ngoài cùng

// Font for value label root cell
var mainValueRootFont: UIFont			// Font của value label cell ngoài cùng

// Color for value label root cell
var mainValueRootColor: UIColor			// Màu của value label cell ngoài cùng

// Font for title label root cell
var mainTitleSubRootFont: UIFont		// Font của title label cell cấp thứ 2

// Color for title label root cell
var mainTitleSubRootColor: UIColor		// Màu của title label cell cấp thứ 2

// Font for value label root cell
var mainValueSubRootFont: UIFont		// Font của value label cell cấp thứ 2

// Color for value label root cell
var mainValueSubRootColor: UIColor		// Màu của value label cell cấp thứ 2

// Font for title label root cell
var mainTitleDetailFont: UIFont			// Font của title label cell cấp thứ 3

// Color for title label root cell		
var mainTitleDetailColor: UIColor		// Màu của title label cell cấp thứ 3

// Font for value label root cell
var mainValueDetailFont: UIFont			// Font của value label cell cấp thứ 3

// Color for value label root cell
var mainValueDetailColor: UIColor		// Màu của value label cell cấp thứ 3

// Data Source
dataSource: Data cho tableview

TreeTableViewCell:
// Khi touch vào Title label sẽ nhận được sự kiện ở hàm expandButtonPressed trong class TreeTableViewCell
// khi đó sẽ post 1 notification để bên ngoài bắt và handle việc reload lại tableview

SubTreeTableViewCell
// Khi touch vào Title label sẽ nhận được sự kiện ở hàm expandButtonPressed trong class SubTreeTableViewCell
// khi đó sẽ post 1 notification để bên ngoài bắt và handle việc reload lại tableview
