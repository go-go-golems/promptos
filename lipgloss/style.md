This is a concise documentation for the charmbracelet lipgloss library.

{{ if .styling }}
# Lipgloss styling

Here is a concise list of the methods for lipgloss styling:

- `Bold(bool)`
- `Italic(bool)`
- `Underline(bool)`
- `Strikethrough(bool)`
- `Reverse(bool)`: Inverts foreground and background colors.
- `Blink(bool)`: Applies blinking to foreground text.
- `Faint(bool)`: Renders the foreground color in a dimmer shade.
- `Foreground(TerminalColor)`
- `Background(TerminalColor)`
- `Width(int)`: Sets the width of the block before applying margins.
- `Height(int)`: Sets the height of the block before applying margins.
- `Align(Position...)`: Sets horizontal and vertical alignment.
- `AlignHorizontal(Position)`: Sets horizontal text alignment.
- `AlignVertical(Position)`: Sets vertical text alignment.
- `Padding(int...)`: Sets padding, following CSS shorthand for multiple arguments.
- `PaddingLeft(int)`
- `PaddingRight(int)`
- `PaddingTop(int)`
- `PaddingBottom(int)`
- `ColorWhitespace(bool)`: Determines whether the background color should be applied to the padding.
- `Margin(int...)`: Sets margins (see CSS shorthand)
- `MarginLeft(int)`
- `MarginRight(int)`
- `MarginTop(int)`
- `MarginBottom(int)`
- `MarginBackground(TerminalColor)`: Sets the background color of the margin.
- `Border(Border, bool...)`: Sets the border style and which sides should have a border (CSS shorthand)
- `BorderStyle(Border)`: Defines the Border on a style.
- `BorderTop(bool)`
- `BorderRight(bool)`
- `BorderBottom(bool)`
- `BorderLeft(bool)`
- `BorderForeground(TerminalColor...)`: Sets all of the foreground colors (css shorthand)
- `BorderTopForeground(TerminalColor)`
- `BorderRightForeground(TerminalColor)`
- `BorderBottomForeground(TerminalColor)`
- `BorderLeftForeground(TerminalColor)`
- `BorderBackground(TerminalColor...)`: Sets all of the background colors (CSS shorthand)
- `BorderTopBackground(TerminalColor)`
- `BorderRightBackground(TerminalColor)`
- `BorderBottomBackground(TerminalColor)`
- `BorderLeftBackground(TerminalColor)`
- `Inline(bool)`: Makes rendering output one line and disables the rendering of margins, padding and borders.
- `MaxWidth(int)`: Applies a max width to a given style.
- `MaxHeight(int)`: Applies a max height to a given style.
- `TabWidth(int)`: Sets the number of spaces that a tab (/t) should be rendered as.
- `UnderlineSpaces(bool)`: Determines whether to underline spaces between words.
- `StrikethroughSpaces(bool)`: Determines whether to apply strikethroughs to spaces between words.
- `Renderer(*Renderer)`: Sets the renderer for the style.

For methods that take a variable number of arguments, the arguments are applied
based on the CSS shorthand rules for blocks like margin, padding, and borders.
For example, with one argument, the value is applied to all sides. With two
arguments, the value is applied to the vertical and horizontal sides, in that
order. With three arguments, the value is applied to the top side, the
horizontal sides, and the bottom side, in that order. With four arguments, the
value is applied clockwise starting from the top side, followed by the right
side, then the bottom, and finally the left. With more than four arguments, no
padding or margin will be added.

{{- end }}

{{ if .borders }}
## borders

- `NormalBorder()`: Returns standard-type border with normal weight, 90-degree corners.
- `RoundedBorder()`: Returns border with rounded corners.
- `BlockBorder()`: Returns border that takes whole block.
- `OuterHalfBlockBorder()`: Returns half-block border outside the frame.
- `InnerHalfBlockBorder()`: Returns half-block border inside the frame.
- `ThickBorder()`: Returns border thicker than `NormalBorder()`.
- `DoubleBorder()`: Returns border of two thin strokes.
- `HiddenBorder()`: Returns border as single-cell spaces, can apply background color.
- `GetTopSize()`: Returns width of top border, 0 if no border.
- `GetRightSize()`: Returns width of right border, 0 if no border.
- `GetBottomSize()`: Returns width of bottom border, 0 if no border.
- `GetLeftSize()`: Returns width of left border, 0 if no border.

For `Get*Size()` methods, if borders contain runes of varying widths, the widest rune is returned.
{{ end }}
