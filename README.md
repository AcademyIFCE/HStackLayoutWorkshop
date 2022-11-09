## The HStackLayout Algorithm

```
HStackLayout(spacing: 7.5) {
    Color.red.frame(minWidth: 100)
    Color.green.frame(width: 30)
    Color.blue.frame(maxWidth: 50)
}
.frame(width: 150, height: 100)
```

**1. The layout receives a proposed size**

First the layout receives a proposed size. In the above example the proposed size has a width of `150` and a height of `100`.

**2. Calculating the available width**

The available width to propose to its subviews is the full proposed width minus the spacing between subviews.

`availableWidth = fullWidth - (numberOfSubviews - 1) x spacing`

In the above example the layout the spacing is 7.5 and there are 3 subviews so the available width is `150 - 2 x 7.5 = 135`

**3. Sorting the subviews**

Each subview has a range of min and max width and the difference between these values is the flexibility of a subview. Before available width is allocated, the subviews are sorted from least flexible to most flexible.

In the above example the subviews have the following flexibilities:

- Color.red.frame(minWidth: 100) `100 ... inf` -> flexibility is `inf-100`
- Color.green.frame(width: 30) `30 ... 30` -> flexibility is `0`
- Color.blue.frame(maxWidth: 50) `0 ... 50` -> flexibility is `50`

They will be sorted to propose in the following order:

`green, blue, red`

**4. Proposing size to subviews**

The proposed width for each subview is given by the following algorithm:

```
for subview in subviews
    proposedHeight = fullHeight
    proposedWidth = availableWidth / numberOfSubviewsRemainingToPropose
    proposedSize = ProposedViewSize(proposedWidth, proposedHeight)
    size = subview.sizeThatFits(proposedSize)
    availableWidth -= size.width
    numberOfSubviewsRemainingToPropose -= 1
```

**5. Running the algorithm**

```
subviewsOrderedByFlexibility = [green, blue, red]

availableWidth = 135

for green
    proposedHeight = 100
    proposedWidth = 135 / 3 = 45
    proposedSize = ProposedViewSize(45, 100)
    size = subview.sizeThatFits(proposedSize) = (30, 100) // width = 30
    availableWidth = 135 - 30 = 105
    numberOfSubviewsRemainingToPropose = 2
    
for blue
    proposedHeight = 100
    proposedWidth = 105 / 2 = 52.5
    proposedSize = ProposedViewSize(52.5, 100)
    size = subview.sizeThatFits(proposedSize) = (50, 100) // width = 50
    availableWidth = 105 - 50 = 55
    numberOfSubviewsRemainingToPropose = 1
    
for red
    proposedHeight = 100
    proposedWidth = 55 / 1 = 55
    proposedSize = ProposedViewSize(55, 100)
    size = subview.sizeThatFits(proposedSize) = (100, 100) // width = 100
    availableWidth = 0
    numberOfSubviewsRemainingToPropose = 0
    
```

**6. Positioning the subviews**

Finally, the subviews are positioned side by side, in the same order they were declared, considering the width that were previously computed plus the layout spacing. The last subview to be placed does not take spacing into account.

In our example the subviews have been declared in the following order:

- Color.red.frame(minWidth: 100)
- Color.green.frame(width: 30)
- Color.blue.frame(maxWidth: 50)

They will be placed in the same order:

`red, green, blue`

**7. Adding position to the algorithm**

Continuing the algorithm to compute position for all subviews:

```
var position = CGPoint(x: bounds.minX, y: bounds.midY)

for subview in subviews
    // computing size
    proposedHeight = fullHeight
    proposedWidth = availableWidth / numberOfSubviewsRemainingToPropose
    proposedSize = ProposedViewSize(proposedWidth, proposedHeight)
    size = subview.sizeThatFits(proposedSize)
    availableWidth -= size.width
    numberOfSubviewsRemainingToPlace -= 1

    // computing position
    subview.place(at: position, anchor: .leading, proposal: size)
    position.x += size.width + spacing
    
```

**8. Running the algorithm again:**

```
subviewsOrderedByDeclaration = [red, green, blue]

position = CGPoint(x: 0, y: 50)

for red
    // computing size 
    // ... size.width is 100

    // computing position
    subview.place(at: CGPoint(x: 0, y: 50), anchor: .leading, proposal: CGSize(width: 100, heigth: 100))
    position.x += 100 + 7.5


for green
    // computing size 
    // ... size is 30

    // computing position
    subview.place(at: CGPoint(x: 107.5, y: 50), anchor: .leading, proposal: CGSize(width: 30, heigth: 100))
    position.x += 30 + 7.5
    
for blue
    // computing size 
    // ... size is 50
    
    // computing position
    subview.place(at: CGPoint(x: 138, y: 50), anchor: .leading, proposal: CGSize(width: 50, heigth: 100))
    position.x += 50 + 7.5 // which is not used because this was the last view
```
    
### Challenge

Modify the implementation of `MyHStackLayout` to match the described behavior. The currently implementation simply proposes the same width of `fullWidth/numberOfSubviews` without taking account spacing, 

**Tips**

- Begin by changing the algorithm to take the spacing account
- Then change it to subtract the width of each subview from the width available for the next ones
- Finally calculate the flexibility of the subview and sort them before propose sizes


**"And while I can honestly say I have told you the truth, I may not have told you all of it"**

There's one thing left to truly match the HStackLayout, the effect of the `layoutPriority` modifier. Unfortunately, that's a history for another day...

