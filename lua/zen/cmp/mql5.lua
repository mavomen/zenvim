local source = {}

local K = vim.lsp.protocol.CompletionItemKind

local MQL5_KEYWORDS = {
	-- Types
	{ label = "bool", kind = K.Type, detail = "Logical type (true/false)" },
	{ label = "char", kind = K.Type, detail = "Signed 1-byte integer (-128..127)" },
	{ label = "uchar", kind = K.Type, detail = "Unsigned 1-byte integer (0..255)" },
	{ label = "short", kind = K.Type, detail = "Signed 2-byte integer" },
	{ label = "ushort", kind = K.Type, detail = "Unsigned 2-byte integer" },
	{ label = "int", kind = K.Type, detail = "Signed 4-byte integer" },
	{ label = "uint", kind = K.Type, detail = "Unsigned 4-byte integer" },
	{ label = "long", kind = K.Type, detail = "Signed 8-byte integer" },
	{ label = "ulong", kind = K.Type, detail = "Unsigned 8-byte integer" },
	{ label = "float", kind = K.Type, detail = "Single-precision float (4 bytes)" },
	{ label = "double", kind = K.Type, detail = "Double-precision float (8 bytes)" },
	{ label = "string", kind = K.Type, detail = "Unicode character string" },
	{ label = "color", kind = K.Type, detail = "RGB color value (0x00BBGGRR)" },
	{ label = "datetime", kind = K.Type, detail = "Date and time (seconds since 1970)" },
	{ label = "void", kind = K.Type, detail = "No return value" },
	{ label = "complex", kind = K.Type, detail = "Complex number (two doubles)" },
	{ label = "vector", kind = K.Type, detail = "One-dimensional array" },
	{ label = "matrix", kind = K.Type, detail = "Two-dimensional array" },

	-- Keywords
	{ label = "input", kind = K.Keyword, detail = "Input parameter declaration" },
	{ label = "input_color", kind = K.Keyword, detail = "Color input parameter" },
	{ label = "input_group", kind = K.Keyword, detail = "Input parameter group" },
	{ label = "sinput", kind = K.Keyword, detail = "Static input parameter" },
	{ label = "export", kind = K.Keyword, detail = "Export from DLL" },
	{ label = "sinput string", kind = K.Keyword, detail = "Static string input" },
	{ label = "sinput int", kind = K.Keyword, detail = "Static int input" },
	{ label = "sinput double", kind = K.Keyword, detail = "Static double input" },
	{ label = "sinput bool", kind = K.Keyword, detail = "Static bool input" },
	{ label = "sinput color", kind = K.Keyword, detail = "Static color input" },
	{ label = "sinput datetime", kind = K.Keyword, detail = "Static datetime input" },

	-- Modifiers
	{ label = "const", kind = K.Keyword, detail = "Constant qualifier" },
	{ label = "static", kind = K.Keyword, detail = "Static storage" },
	{ label = "extern", kind = K.Keyword, detail = "External linkage" },
	{ label = "virtual", kind = K.Keyword, detail = "Virtual method" },
	{ label = "override", kind = K.Keyword, detail = "Override virtual method" },
	{ label = "private", kind = K.Keyword, detail = "Private access" },
	{ label = "protected", kind = K.Keyword, detail = "Protected access" },
	{ label = "public", kind = K.Keyword, detail = "Public access" },

	-- Control flow
	{ label = "if", kind = K.Keyword, detail = "Conditional" },
	{ label = "else", kind = K.Keyword, detail = "Else branch" },
	{ label = "switch", kind = K.Keyword, detail = "Switch statement" },
	{ label = "case", kind = K.Keyword, detail = "Case branch" },
	{ label = "default", kind = K.Keyword, detail = "Default case" },
	{ label = "for", kind = K.Keyword, detail = "For loop" },
	{ label = "while", kind = K.Keyword, detail = "While loop" },
	{ label = "do", kind = K.Keyword, detail = "Do-while loop" },
	{ label = "break", kind = K.Keyword, detail = "Break loop" },
	{ label = "continue", kind = K.Keyword, detail = "Continue loop" },
	{ label = "return", kind = K.Keyword, detail = "Return from function" },
	{ label = "try", kind = K.Keyword, detail = "Try block" },
	{ label = "catch", kind = K.Keyword, detail = "Catch exception" },
	{ label = "throw", kind = K.Keyword, detail = "Throw exception" },

	-- Class/struct
	{ label = "class", kind = K.Keyword, detail = "Class declaration" },
	{ label = "struct", kind = K.Keyword, detail = "Struct declaration" },
	{ label = "enum", kind = K.Keyword, detail = "Enum declaration" },
	{ label = "union", kind = K.Keyword, detail = "Union declaration" },
	{ label = "typedef", kind = K.Keyword, detail = "Type alias" },
	{ label = "template", kind = K.Keyword, detail = "Template declaration" },
	{ label = "namespace", kind = K.Keyword, detail = "Namespace" },
	{ label = "new", kind = K.Keyword, detail = "Heap allocation" },
	{ label = "delete", kind = K.Keyword, detail = "Heap deallocation" },
	{ label = "sizeof", kind = K.Keyword, detail = "Size in bytes" },

	-- Event functions
	{ label = "OnInit", kind = K.Function, detail = "Initialization (EA/Indicator)" },
	{ label = "OnDeinit", kind = K.Function, detail = "Deinitialization" },
	{ label = "OnStart", kind = K.Function, detail = "Script/Service entry" },
	{ label = "OnTick", kind = K.Function, detail = "New quote (EA)" },
	{ label = "OnCalculate", kind = K.Function, detail = "Indicator recalculation" },
	{ label = "OnTimer", kind = K.Function, detail = "Timer event" },
	{ label = "OnTrade", kind = K.Function, detail = "Trade completed (EA)" },
	{ label = "OnTradeTransaction", kind = K.Function, detail = "Trade state change" },
	{ label = "OnChartEvent", kind = K.Function, detail = "Chart change event" },
	{ label = "OnBookEvent", kind = K.Function, detail = "Depth of Market change" },
	{ label = "OnTester", kind = K.Function, detail = "End of tester pass" },
	{ label = "OnTesterInit", kind = K.Function, detail = "Before optimization" },
	{ label = "OnTesterDeinit", kind = K.Function, detail = "After optimization" },
	{ label = "OnTesterPass", kind = K.Function, detail = "Optimization data from agent" },

	-- Indicator functions
	{ label = "SetIndexBuffer", kind = K.Function, detail = "Bind array as indicator buffer" },
	{ label = "PlotIndexSetInteger", kind = K.Function, detail = "Set integer plot property" },
	{ label = "PlotIndexSetDouble", kind = K.Function, detail = "Set double plot property" },
	{ label = "PlotIndexSetString", kind = K.Function, detail = "Set string plot property" },
	{ label = "PlotIndexGetInteger", kind = K.Function, detail = "Get integer plot property" },
	{ label = "IndicatorSetInteger", kind = K.Function, detail = "Set integer indicator property" },
	{ label = "IndicatorSetDouble", kind = K.Function, detail = "Set double indicator property" },
	{ label = "IndicatorSetString", kind = K.Function, detail = "Set string indicator property" },
	{ label = "IndicatorCreate", kind = K.Function, detail = "Create indicator by MqlParam" },
	{ label = "IndicatorRelease", kind = K.Function, detail = "Release indicator handle" },
	{ label = "BarsCalculated", kind = K.Function, detail = "Number of calculated bars" },

	-- Technical indicators
	{ label = "iMA", kind = K.Function, detail = "Moving Average" },
	{ label = "iMACD", kind = K.Function, detail = "MACD" },
	{ label = "iRSI", kind = K.Function, detail = "Relative Strength Index" },
	{ label = "iStochastic", kind = K.Function, detail = "Stochastic Oscillator" },
	{ label = "iBands", kind = K.Function, detail = "Bollinger Bands" },
	{ label = "iATR", kind = K.Function, detail = "Average True Range" },
	{ label = "iADX", kind = K.Function, detail = "Average Directional Index" },
	{ label = "iCCI", kind = K.Function, detail = "Commodity Channel Index" },
	{ label = "iIchimoku", kind = K.Function, detail = "Ichimoku Kinko Hyo" },
	{ label = "iEnvelopes", kind = K.Function, detail = "Envelopes" },
	{ label = "iDeMarker", kind = K.Function, detail = "DeMarker" },
	{ label = "iForce", kind = K.Function, detail = "Force Index" },
	{ label = "iFractals", kind = K.Function, detail = "Fractals" },
	{ label = "iMomentum", kind = K.Function, detail = "Momentum" },
	{ label = "iMFI", kind = K.Function, detail = "Money Flow Index" },
	{ label = "iOBV", kind = K.Function, detail = "On Balance Volume" },
	{ label = "iSAR", kind = K.Function, detail = "Parabolic SAR" },
	{ label = "iStdDev", kind = K.Function, detail = "Standard Deviation" },
	{ label = "iWPR", kind = K.Function, detail = "Williams Percent Range" },
	{ label = "iAC", kind = K.Function, detail = "Accelerator Oscillator" },
	{ label = "iAD", kind = K.Function, detail = "Accumulation/Distribution" },
	{ label = "iAO", kind = K.Function, detail = "Awesome Oscillator" },
	{ label = "iBearsPower", kind = K.Function, detail = "Bears Power" },
	{ label = "iBullsPower", kind = K.Function, detail = "Bulls Power" },
	{ label = "iCustom", kind = K.Function, detail = "Custom indicator" },
	{ label = "iDEMA", kind = K.Function, detail = "Double Exponential MA" },
	{ label = "iTEMA", kind = K.Function, detail = "Triple Exponential MA" },
	{ label = "iAMA", kind = K.Function, detail = "Adaptive Moving Average" },
	{ label = "iFrAMA", kind = K.Function, detail = "Fractal Adaptive MA" },
	{ label = "iVIDyA", kind = K.Function, detail = "Variable Index Dynamic Avg" },

	-- Copy functions
	{ label = "CopyBuffer", kind = K.Function, detail = "Copy indicator buffer data" },
	{ label = "CopyRates", kind = K.Function, detail = "Copy MqlRates array" },
	{ label = "CopyTime", kind = K.Function, detail = "Copy bar times" },
	{ label = "CopyOpen", kind = K.Function, detail = "Copy open prices" },
	{ label = "CopyHigh", kind = K.Function, detail = "Copy high prices" },
	{ label = "CopyLow", kind = K.Function, detail = "Copy low prices" },
	{ label = "CopyClose", kind = K.Function, detail = "Copy close prices" },
	{ label = "CopyTickVolume", kind = K.Function, detail = "Copy tick volumes" },
	{ label = "CopyRealVolume", kind = K.Function, detail = "Copy real volumes" },
	{ label = "CopySpread", kind = K.Function, detail = "Copy spreads" },
	{ label = "CopyTicks", kind = K.Function, detail = "Copy ticks" },
	{ label = "CopyTicksRange", kind = K.Function, detail = "Copy ticks in range" },

	-- Trade functions
	{ label = "OrderSend", kind = K.Function, detail = "Execute trade operation" },
	{ label = "OrderCheck", kind = K.Function, detail = "Check trade request" },
	{ label = "OrderCalcMargin", kind = K.Function, detail = "Calculate order margin" },
	{ label = "OrderCalcProfit", kind = K.Function, detail = "Calculate order profit" },
	{ label = "OrderSelect", kind = K.Function, detail = "Select order by ticket" },
	{ label = "OrderGetTicket", kind = K.Function, detail = "Get order ticket" },
	{ label = "OrderGetInteger", kind = K.Function, detail = "Get order integer property" },
	{ label = "OrderGetDouble", kind = K.Function, detail = "Get order double property" },
	{ label = "OrderGetString", kind = K.Function, detail = "Get order string property" },
	{ label = "OrdersTotal", kind = K.Function, detail = "Total active orders" },
	{ label = "OrdersHistoryTotal", kind = K.Function, detail = "Total history orders" },
	{ label = "PositionSelect", kind = K.Function, detail = "Select position by symbol" },
	{ label = "PositionSelectByTicket", kind = K.Function, detail = "Select position by ticket" },
	{ label = "PositionGetTicket", kind = K.Function, detail = "Get position ticket" },
	{ label = "PositionGetInteger", kind = K.Function, detail = "Get position integer property" },
	{ label = "PositionGetDouble", kind = K.Function, detail = "Get position double property" },
	{ label = "PositionGetString", kind = K.Function, detail = "Get position string property" },
	{ label = "PositionsTotal", kind = K.Function, detail = "Total open positions" },
	{ label = "HistorySelect", kind = K.Function, detail = "Select deal history" },
	{ label = "HistoryDealsTotal", kind = K.Function, detail = "Total deals in history" },

	-- Common functions
	{ label = "Print", kind = K.Function, detail = "Log message" },
	{ label = "PrintFormat", kind = K.Function, detail = "Formatted log message" },
	{ label = "Alert", kind = K.Function, detail = "Alert window message" },
	{ label = "Comment", kind = K.Function, detail = "Chart comment" },
	{ label = "PlaySound", kind = K.Function, detail = "Play sound file" },
	{ label = "Sleep", kind = K.Function, detail = "Suspend execution" },
	{ label = "GetTickCount", kind = K.Function, detail = "Milliseconds since start" },
	{ label = "GetTickCount64", kind = K.Function, detail = "Milliseconds since start (64-bit)" },
	{ label = "GetMicrosecondCount", kind = K.Function, detail = "Microseconds since start" },
	{ label = "ExpertRemove", kind = K.Function, detail = "Terminate EA from code" },
	{ label = "TerminalClose", kind = K.Function, detail = "Close terminal" },
	{ label = "ResetLastError", kind = K.Function, detail = "Clear _LastError" },
	{ label = "SetUserError", kind = K.Function, detail = "Set user error code" },
	{ label = "ZeroMemory", kind = K.Function, detail = "Reset variable to zero" },
	{ label = "MessageBox", kind = K.Function, detail = "Show message box" },
	{ label = "PeriodSeconds", kind = K.Function, detail = "Seconds in timeframe" },
	{ label = "Bars", kind = K.Function, detail = "Number of bars in history" },
	{ label = "iBarShift", kind = K.Function, detail = "Bar index by time" },
	{ label = "iBars", kind = K.Function, detail = "Bar count in history" },
	{ label = "iHighest", kind = K.Function, detail = "Index of highest value" },
	{ label = "iLowest", kind = K.Function, detail = "Index of lowest value" },
	{ label = "ArrayResize", kind = K.Function, detail = "Resize array" },
	{ label = "ArraySize", kind = K.Function, detail = "Array size" },
	{ label = "ArrayRange", kind = K.Function, detail = "Array dimension size" },
	{ label = "ArrayFree", kind = K.Function, detail = "Free array memory" },
	{ label = "ArrayFill", kind = K.Function, detail = "Fill array with value" },
	{ label = "ArrayCopy", kind = K.Function, detail = "Copy array" },
	{ label = "ArrayInitialize", kind = K.Function, detail = "Initialize array elements" },
	{ label = "ArraySetAsSeries", kind = K.Function, detail = "Set array as timeseries" },
	{ label = "TimeToStruct", kind = K.Function, detail = "Convert datetime to MqlDateTime" },
	{ label = "StructToTime", kind = K.Function, detail = "Convert MqlDateTime to datetime" },

	-- Indicator drawing types
	{ label = "DRAW_NONE", kind = K.Enum, detail = "Not drawn (DataWindow only)" },
	{ label = "DRAW_LINE", kind = K.Enum, detail = "Curved line" },
	{ label = "DRAW_SECTION", kind = K.Enum, detail = "Straight polyline segments" },
	{ label = "DRAW_HISTOGRAM", kind = K.Enum, detail = "Histogram from zero line" },
	{ label = "DRAW_HISTOGRAM2", kind = K.Enum, detail = "Histogram between two buffers" },
	{ label = "DRAW_ARROW", kind = K.Enum, detail = "Arrow symbols" },
	{ label = "DRAW_ZIGZAG", kind = K.Enum, detail = "Zigzag (allows vertical segments)" },
	{ label = "DRAW_FILLING", kind = K.Enum, detail = "Color fill between levels" },
	{ label = "DRAW_BARS", kind = K.Enum, detail = "Sequence of bars (OHLC)" },
	{ label = "DRAW_CANDLES", kind = K.Enum, detail = "Sequence of candlesticks" },
	{ label = "DRAW_COLOR_LINE", kind = K.Enum, detail = "Multicolored line" },
	{ label = "DRAW_COLOR_SECTION", kind = K.Enum, detail = "Multicolored section" },
	{ label = "DRAW_COLOR_HISTOGRAM", kind = K.Enum, detail = "Multicolored histogram" },
	{ label = "DRAW_COLOR_HISTOGRAM2", kind = K.Enum, detail = "Multicolored two-buffer histogram" },
	{ label = "DRAW_COLOR_ARROW", kind = K.Enum, detail = "Multicolored arrows" },
	{ label = "DRAW_COLOR_ZIGZAG", kind = K.Enum, detail = "Multicolored zigzag" },
	{ label = "DRAW_COLOR_BARS", kind = K.Enum, detail = "Multicolored bars" },
	{ label = "DRAW_COLOR_CANDLES", kind = K.Enum, detail = "Multicolored candlesticks" },

	-- Line styles
	{ label = "STYLE_SOLID", kind = K.Enum, detail = "Solid line" },
	{ label = "STYLE_DASH", kind = K.Enum, detail = "Dashed line" },
	{ label = "STYLE_DOT", kind = K.Enum, detail = "Dotted line" },
	{ label = "STYLE_DASHDOT", kind = K.Enum, detail = "Dash-dot line" },
	{ label = "STYLE_DASHDOTDOT", kind = K.Enum, detail = "Dash-two dots" },

	-- Plot properties
	{ label = "PLOT_ARROW", kind = K.Enum, detail = "Arrow code for DRAW_ARROW" },
	{ label = "PLOT_ARROW_SHIFT", kind = K.Enum, detail = "Vertical arrow shift" },
	{ label = "PLOT_DRAW_BEGIN", kind = K.Enum, detail = "Initial bars without drawing" },
	{ label = "PLOT_DRAW_TYPE", kind = K.Enum, detail = "Drawing type" },
	{ label = "PLOT_SHOW_DATA", kind = K.Enum, detail = "Display in DataWindow" },
	{ label = "PLOT_SHIFT", kind = K.Enum, detail = "Shift along time axis" },
	{ label = "PLOT_LINE_STYLE", kind = K.Enum, detail = "Line style" },
	{ label = "PLOT_LINE_WIDTH", kind = K.Enum, detail = "Line thickness" },
	{ label = "PLOT_COLOR_INDEXES", kind = K.Enum, detail = "Number of colors" },
	{ label = "PLOT_LINE_COLOR", kind = K.Enum, detail = "Rendering color" },

	-- Buffer types
	{ label = "INDICATOR_DATA", kind = K.Enum, detail = "Buffer for indicator values" },
	{ label = "INDICATOR_CALCULATIONS", kind = K.Enum, detail = "Buffer for calculations" },
	{ label = "INDICATOR_COLOR_INDEX", kind = K.Enum, detail = "Buffer for color indexes" },

	-- Indicator properties
	{ label = "INDICATOR_DIGITS", kind = K.Enum, detail = "Number of decimal digits" },
	{ label = "INDICATOR_DRAWTYPE", kind = K.Enum, detail = "Drawing type" },
	{ label = "INDICATOR_COLOR", kind = K.Enum, detail = "Line color" },
	{ label = "INDICATOR_STYLE", kind = K.Enum, detail = "Line style" },
	{ label = "INDICATOR_WIDTH", kind = K.Enum, detail = "Line width" },
	{ label = "INDICATOR_LEVELS", kind = K.Enum, detail = "Number of levels" },
	{ label = "INDICATOR_LEVELVALUE", kind = K.Enum, detail = "Level value" },
	{ label = "INDICATOR_LEVELCOLOR", kind = K.Enum, detail = "Level color" },
	{ label = "INDICATOR_LEVELSTYLE", kind = K.Enum, detail = "Level style" },
	{ label = "INDICATOR_LEVELWIDTH", kind = K.Enum, detail = "Level width" },
	{ label = "INDICATOR_MINIMUM", kind = K.Enum, detail = "Minimum in separate window" },
	{ label = "INDICATOR_MAXIMUM", kind = K.Enum, detail = "Maximum in separate window" },

	-- Timeframes
	{ label = "PERIOD_CURRENT", kind = K.Enum, detail = "Current chart period" },
	{ label = "PERIOD_M1", kind = K.Enum, detail = "1 minute" },
	{ label = "PERIOD_M2", kind = K.Enum, detail = "2 minutes" },
	{ label = "PERIOD_M3", kind = K.Enum, detail = "3 minutes" },
	{ label = "PERIOD_M4", kind = K.Enum, detail = "4 minutes" },
	{ label = "PERIOD_M5", kind = K.Enum, detail = "5 minutes" },
	{ label = "PERIOD_M6", kind = K.Enum, detail = "6 minutes" },
	{ label = "PERIOD_M10", kind = K.Enum, detail = "10 minutes" },
	{ label = "PERIOD_M12", kind = K.Enum, detail = "12 minutes" },
	{ label = "PERIOD_M15", kind = K.Enum, detail = "15 minutes" },
	{ label = "PERIOD_M20", kind = K.Enum, detail = "20 minutes" },
	{ label = "PERIOD_M30", kind = K.Enum, detail = "30 minutes" },
	{ label = "PERIOD_H1", kind = K.Enum, detail = "1 hour" },
	{ label = "PERIOD_H2", kind = K.Enum, detail = "2 hours" },
	{ label = "PERIOD_H3", kind = K.Enum, detail = "3 hours" },
	{ label = "PERIOD_H4", kind = K.Enum, detail = "4 hours" },
	{ label = "PERIOD_H6", kind = K.Enum, detail = "6 hours" },
	{ label = "PERIOD_H8", kind = K.Enum, detail = "8 hours" },
	{ label = "PERIOD_H12", kind = K.Enum, detail = "12 hours" },
	{ label = "PERIOD_D1", kind = K.Enum, detail = "1 day" },
	{ label = "PERIOD_W1", kind = K.Enum, detail = "1 week" },
	{ label = "PERIOD_MN1", kind = K.Enum, detail = "1 month" },

	-- Applied prices
	{ label = "PRICE_CLOSE", kind = K.Enum, detail = "Close price" },
	{ label = "PRICE_OPEN", kind = K.Enum, detail = "Open price" },
	{ label = "PRICE_HIGH", kind = K.Enum, detail = "High price" },
	{ label = "PRICE_LOW", kind = K.Enum, detail = "Low price" },
	{ label = "PRICE_MEDIAN", kind = K.Enum, detail = "(high + low) / 2" },
	{ label = "PRICE_TYPICAL", kind = K.Enum, detail = "(high + low + close) / 3" },
	{ label = "PRICE_WEIGHTED", kind = K.Enum, detail = "(high + low + close + close) / 4" },

	-- MA methods
	{ label = "MODE_SMA", kind = K.Enum, detail = "Simple averaging" },
	{ label = "MODE_EMA", kind = K.Enum, detail = "Exponential averaging" },
	{ label = "MODE_SMMA", kind = K.Enum, detail = "Smoothed averaging" },
	{ label = "MODE_LWMA", kind = K.Enum, detail = "Linear-weighted averaging" },

	-- Order types
	{ label = "ORDER_TYPE_BUY", kind = K.Enum, detail = "Market buy" },
	{ label = "ORDER_TYPE_SELL", kind = K.Enum, detail = "Market sell" },
	{ label = "ORDER_TYPE_BUY_LIMIT", kind = K.Enum, detail = "Buy Limit pending" },
	{ label = "ORDER_TYPE_SELL_LIMIT", kind = K.Enum, detail = "Sell Limit pending" },
	{ label = "ORDER_TYPE_BUY_STOP", kind = K.Enum, detail = "Buy Stop pending" },
	{ label = "ORDER_TYPE_SELL_STOP", kind = K.Enum, detail = "Sell Stop pending" },
	{ label = "ORDER_TYPE_BUY_STOP_LIMIT", kind = K.Enum, detail = "Buy Stop-Limit pending" },
	{ label = "ORDER_TYPE_SELL_STOP_LIMIT", kind = K.Enum, detail = "Sell Stop-Limit pending" },

	-- Order filling
	{ label = "ORDER_FILLING_FOK", kind = K.Enum, detail = "Fill or Kill" },
	{ label = "ORDER_FILLING_IOC", kind = K.Enum, detail = "Immediate or Cancel" },
	{ label = "ORDER_FILLING_RETURN", kind = K.Enum, detail = "Return (partial fills)" },

	-- Order time
	{ label = "ORDER_TIME_GTC", kind = K.Enum, detail = "Good till cancel" },
	{ label = "ORDER_TIME_DAY", kind = K.Enum, detail = "Good till trade day" },
	{ label = "ORDER_TIME_SPECIFIED", kind = K.Enum, detail = "Good till expired" },
	{ label = "ORDER_TIME_SPECIFIED_DAY", kind = K.Enum, detail = "Till 23:59:59 of day" },

	-- Position types
	{ label = "POSITION_TYPE_BUY", kind = K.Enum, detail = "Buy position" },
	{ label = "POSITION_TYPE_SELL", kind = K.Enum, detail = "Sell position" },

	-- Trade actions
	{ label = "TRADE_ACTION_DEAL", kind = K.Enum, detail = "Market order (instant)" },
	{ label = "TRADE_ACTION_PENDING", kind = K.Enum, detail = "Place pending order" },
	{ label = "TRADE_ACTION_SLTP", kind = K.Enum, detail = "Modify SL/TP" },
	{ label = "TRADE_ACTION_MODIFY", kind = K.Enum, detail = "Modify pending order" },
	{ label = "TRADE_ACTION_REMOVE", kind = K.Enum, detail = "Delete pending order" },
	{ label = "TRADE_ACTION_CLOSE_BY", kind = K.Enum, detail = "Close by opposite" },

	-- Init return codes
	{ label = "INIT_SUCCEEDED", kind = K.Enum, detail = "Initialization successful" },
	{ label = "INIT_FAILED", kind = K.Enum, detail = "Initialization failed" },
	{ label = "INIT_PARAMETERS_INCORRECT", kind = K.Enum, detail = "Incorrect parameters" },

	-- Deinit reasons
	{ label = "REASON_PROGRAM", kind = K.Enum, detail = "EA stopped via ExpertRemove()" },
	{ label = "REASON_REMOVE", kind = K.Enum, detail = "Program deleted from chart" },
	{ label = "REASON_RECOMPILE", kind = K.Enum, detail = "Program recompiled" },
	{ label = "REASON_CHARTCHANGE", kind = K.Enum, detail = "Symbol or period changed" },
	{ label = "REASON_CHARTCLOSE", kind = K.Enum, detail = "Chart closed" },
	{ label = "REASON_PARAMETERS", kind = K.Enum, detail = "Parameters changed by user" },
	{ label = "REASON_ACCOUNT", kind = K.Enum, detail = "Account changed" },
	{ label = "REASON_TEMPLATE", kind = K.Enum, detail = "New template applied" },
	{ label = "REASON_INITFAILED", kind = K.Enum, detail = "OnInit() returned nonzero" },
	{ label = "REASON_CLOSE", kind = K.Enum, detail = "Terminal closed" },

	-- Volumes
	{ label = "VOLUME_TICK", kind = K.Enum, detail = "Tick volume" },
	{ label = "VOLUME_REAL", kind = K.Enum, detail = "Trade (real) volume" },

	-- Day of week
	{ label = "SUNDAY", kind = K.Enum, detail = "Day 0" },
	{ label = "MONDAY", kind = K.Enum, detail = "Day 1" },
	{ label = "TUESDAY", kind = K.Enum, detail = "Day 2" },
	{ label = "WEDNESDAY", kind = K.Enum, detail = "Day 3" },
	{ label = "THURSDAY", kind = K.Enum, detail = "Day 4" },
	{ label = "FRIDAY", kind = K.Enum, detail = "Day 5" },
	{ label = "SATURDAY", kind = K.Enum, detail = "Day 6" },

	-- Built-in constants
	{ label = "NULL", kind = K.Constant, detail = "Zero for any type" },
	{ label = "EMPTY_VALUE", kind = K.Constant, detail = "Empty indicator value (DBL_MAX)" },
	{ label = "INVALID_HANDLE", kind = K.Constant, detail = "Invalid handle (-1)" },
	{ label = "WRONG_VALUE", kind = K.Constant, detail = "Wrong enumeration (-1)" },
	{ label = "WHOLE_ARRAY", kind = K.Constant, detail = "Process entire array" },
	{ label = "true", kind = K.Constant, detail = "Logical true" },
	{ label = "false", kind = K.Constant, detail = "Logical false" },
	{ label = "INT_MAX", kind = K.Constant, detail = "2147483647" },
	{ label = "INT_MIN", kind = K.Constant, detail = "-2147483648" },
	{ label = "DBL_MAX", kind = K.Constant, detail = "Maximum double" },
	{ label = "DBL_MIN", kind = K.Constant, detail = "Minimum positive double" },

	-- Chart events
	{ label = "CHARTEVENT_CLICK", kind = K.Enum, detail = "Mouse click on chart" },
	{ label = "CHARTEVENT_MOUSE_MOVE", kind = K.Enum, detail = "Mouse movement" },
	{ label = "CHARTEVENT_MOUSE_WHEEL", kind = K.Enum, detail = "Mouse wheel scroll" },
	{ label = "CHARTEVENT_KEYDOWN", kind = K.Enum, detail = "Key press" },
	{ label = "CHARTEVENT_CHART_CHANGE", kind = K.Enum, detail = "Chart resized/changed" },
	{ label = "CHARTEVENT_OBJECT_CLICK", kind = K.Enum, detail = "Object click" },
	{ label = "CHARTEVENT_OBJECT_CREATE", kind = K.Enum, detail = "Object created" },
	{ label = "CHARTEVENT_OBJECT_DELETE", kind = K.Enum, detail = "Object deleted" },
	{ label = "CHARTEVENT_OBJECT_CHANGE", kind = K.Enum, detail = "Object changed" },
	{ label = "CHARTEVENT_OBJECT_DRAG", kind = K.Enum, detail = "Object dragged" },
	{ label = "CHARTEVENT_OBJECT_ENDEDIT", kind = K.Enum, detail = "Edit field changed" },
	{ label = "CHARTEVENT_CUSTOM", kind = K.Enum, detail = "Custom event start" },
	{ label = "CHARTEVENT_CUSTOM_LAST", kind = K.Enum, detail = "Custom event end" },

	-- Web colors (common subset)
	{ label = "clrBlack", kind = K.Color, detail = "Black" },
	{ label = "clrWhite", kind = K.Color, detail = "White" },
	{ label = "clrRed", kind = K.Color, detail = "Red" },
	{ label = "clrGreen", kind = K.Color, detail = "Green" },
	{ label = "clrBlue", kind = K.Color, detail = "Blue" },
	{ label = "clrYellow", kind = K.Color, detail = "Yellow" },
	{ label = "clrMagenta", kind = K.Color, detail = "Magenta" },
	{ label = "clrCyan", kind = K.Color, detail = "Cyan" },
	{ label = "clrGray", kind = K.Color, detail = "Gray" },
	{ label = "clrDarkRed", kind = K.Color, detail = "Dark Red" },
	{ label = "clrDarkGreen", kind = K.Color, detail = "Dark Green" },
	{ label = "clrDarkBlue", kind = K.Color, detail = "Dark Blue" },
	{ label = "clrOrange", kind = K.Color, detail = "Orange" },
	{ label = "clrOrangeRed", kind = K.Color, detail = "Orange Red" },
	{ label = "clrBrown", kind = K.Color, detail = "Brown" },
	{ label = "clrGold", kind = K.Color, detail = "Gold" },
	{ label = "clrSilver", kind = K.Color, detail = "Silver" },
	{ label = "clrNavy", kind = K.Color, detail = "Navy" },
	{ label = "clrTeal", kind = K.Color, detail = "Teal" },
	{ label = "clrMaroon", kind = K.Color, detail = "Maroon" },
	{ label = "clrPurple", kind = K.Color, detail = "Purple" },
	{ label = "clrLime", kind = K.Color, detail = "Lime" },
	{ label = "clrAqua", kind = K.Color, detail = "Aqua" },
	{ label = "clrFuchsia", kind = K.Color, detail = "Fuchsia" },
	{ label = "clrDodgerBlue", kind = K.Color, detail = "Dodger Blue" },
	{ label = "clrSteelBlue", kind = K.Color, detail = "Steel Blue" },
	{ label = "clrRoyalBlue", kind = K.Color, detail = "Royal Blue" },
	{ label = "clrCornflowerBlue", kind = K.Color, detail = "Cornflower Blue" },
	{ label = "clrTomato", kind = K.Color, detail = "Tomato" },
	{ label = "clrCoral", kind = K.Color, detail = "Coral" },
	{ label = "clrSalmon", kind = K.Color, detail = "Salmon" },
	{ label = "clrKhaki", kind = K.Color, detail = "Khaki" },
	{ label = "clrWheat", kind = K.Color, detail = "Wheat" },
	{ label = "clrIvory", kind = K.Color, detail = "Ivory" },
	{ label = "clrPink", kind = K.Color, detail = "Pink" },
	{ label = "clrHotPink", kind = K.Color, detail = "Hot Pink" },
	{ label = "clrDeepPink", kind = K.Color, detail = "Deep Pink" },
	{ label = "clrForestGreen", kind = K.Color, detail = "Forest Green" },
	{ label = "clrLimeGreen", kind = K.Color, detail = "Lime Green" },
	{ label = "clrSpringGreen", kind = K.Color, detail = "Spring Green" },
	{ label = "clrTurquoise", kind = K.Color, detail = "Turquoise" },
	{ label = "clrSlateGray", kind = K.Color, detail = "Slate Gray" },
	{ label = "clrPeru", kind = K.Color, detail = "Peru" },
	{ label = "clrSienna", kind = K.Color, detail = "Sienna" },
	{ label = "clrChocolate", kind = K.Color, detail = "Chocolate" },
	{ label = "clrSandyBrown", kind = K.Color, detail = "Sandy Brown" },

	-- Structures
	{ label = "MqlRates", kind = K.Struct, detail = "Price/volume/spread per bar" },
	{ label = "MqlDateTime", kind = K.Struct, detail = "Date and time struct" },
	{ label = "MqlParam", kind = K.Struct, detail = "Indicator parameters" },
	{ label = "MqlTradeRequest", kind = K.Struct, detail = "Trade request" },
	{ label = "MqlTradeResult", kind = K.Struct, detail = "Trade result" },
	{ label = "MqlTradeCheckResult", kind = K.Struct, detail = "Trade check result" },
	{ label = "MqlTradeTransaction", kind = K.Struct, detail = "Trade transaction" },
	{ label = "MqlTick", kind = K.Struct, detail = "Current price data" },
	{ label = "MqlBookInfo", kind = K.Struct, detail = "Depth of Market info" },
}

source.new = function()
	return setmetatable({}, { __index = source })
end

function source:is_available()
	local ft = vim.bo.filetype
	return ft == "mql5" or ft == "mq5" or ft == "mqh"
end

function source:get_trigger_characters()
	return {}
end

function source:get_keyword_pattern(_params)
	return [[\h\w*]]
end

function source:complete(params, callback)
	local input = string.sub(params.context.cursor_before_line, params.offset)
	local items = {}
	local input_lower = input:lower()

	for _, kw in ipairs(MQL5_KEYWORDS) do
		if input_lower == "" or kw.label:lower():sub(1, #input_lower) == input_lower then
			items[#items + 1] = {
				label = kw.label,
				kind = kw.kind,
				detail = kw.detail or "",
			}
		end
	end

	callback({ items = items, isIncomplete = false })
end

return source
