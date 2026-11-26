# Interaction physics

Start with native navigation or presentation. If reference behavior requires continuous custom control, define two endpoints and measure travel in the stationary parent’s coordinate space. For directed travel D greater than zero, compute progress as clamp(startProgress + signedTranslation / D, 0, 1). Resolve direction for the actual layout, including right-to-left where applicable. On size change, rebase at the current position or settle to a valid endpoint.

While tracking, derive displacement and dependent visual changes from the same progress. On release, use direction, remaining distance and signed velocity to choose a destination. Tune on the target device. Animate settling once with a native spring. On cancellation return to the starting stable state. On interruption take ownership at the visible position and prevent an obsolete completion from committing navigation.

Define who owns an edge drag before recognition. Test diagonal entry, vertical scrolling, selection handles and repeated reversals. Expose the same endpoint through an existing accessible control. With Reduce Motion enabled, shorten or remove spatial settling while preserving the destination and focus.

[Pan translation and velocity](https://developer.apple.com/documentation/uikit/uipangesturerecognizer) · [Reduce Motion](https://developer.apple.com/documentation/swiftui/environmentvalues/accessibilityreducemotion)
