part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialSliderCssClasses {

    final String IE_CONTAINER = 'wsk-slider__ie-container';

    final String SLIDER_CONTAINER = 'wsk-slider__container';

    final String BACKGROUND_FLEX = 'wsk-slider__background-flex';

    final String BACKGROUND_LOWER = 'wsk-slider__background-lower';

    final String BACKGROUND_UPPER = 'wsk-slider__background-upper';

    final String IS_LOWEST_VALUE = 'is-lowest-value';

    final String IS_UPGRADED = 'is-upgraded';

    const _MaterialSliderCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialSliderConstant {
    const _MaterialSliderConstant();
}

/// creates WskConfig for MaterialSlider
WskConfig materialSliderConfig() => new WskWidgetConfig<MaterialSlider>(
    "wsk-js-slider", (final html.HtmlElement element) => new MaterialSlider.fromElement(element));

/// registration-Helper
void registerMaterialSlider() => componenthandler.register(materialSliderConfig());

class MaterialSlider extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialSlider');

    static const _MaterialSliderConstant _constant = const _MaterialSliderConstant();
    static const _MaterialSliderCssClasses _cssClasses = const _MaterialSliderCssClasses();

    // Browser feature detection.
    final bool _isIE = browser.isIe;

    html.DivElement _backgroundLower = null;
    html.DivElement _backgroundUpper = null;

    MaterialSlider.fromElement(final html.HtmlElement element) : super(element) {
        _init();
    }

    static MaterialSlider widget(final html.HtmlElement element) => wskComponent(element) as MaterialSlider;

    html.RangeInputElement get slider => super.element as html.RangeInputElement;

    /// Disable slider.
    void disable() {

        slider.disabled = true;
    }

    /// Enable slider.
    void enable() {

        slider.disabled = false;
    }

    /// Update slider value.
    void set value(final int value) {
        slider.value = value.toString();
        _updateValueStyles();
    }

    int get value => int.parse(slider.value);

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialSlider - init");

        if (element != null) {
            if (_isIE) {

                // Since we need to specify a very large height in IE due to
                // implementation limitations, we add a parent here that trims it down to
                // a reasonable size.
                final html.DivElement containerIE = new html.DivElement();
                containerIE.classes.add(_cssClasses.IE_CONTAINER);
                element.parent.insertBefore(containerIE, element);
                element.remove();
                containerIE.append(element);

            } else {
                // For non-IE browsers, we need a div structure that sits behind the
                // slider and allows us to style the left and right sides of it with
                // different colors.

                final html.DivElement container = new html.DivElement();
                container.classes.add(_cssClasses.SLIDER_CONTAINER);
                element.parent.insertBefore(container, element);
                element.remove();
                container.append(element);

                final html.DivElement backgroundFlex = new html.DivElement();
                backgroundFlex.classes.add(_cssClasses.BACKGROUND_FLEX);
                container.append(backgroundFlex);

                _backgroundLower = new html.DivElement();
                _backgroundLower.classes.add(_cssClasses.BACKGROUND_LOWER);
                backgroundFlex.append(_backgroundLower);

                _backgroundUpper = new html.DivElement();
                _backgroundUpper.classes.add(_cssClasses.BACKGROUND_UPPER);
                backgroundFlex.append(_backgroundUpper);
            }

            element.onInput.listen( _onInput );

            element.onChange.listen( _onChange );

            element.onMouseUp.listen( _onMouseUp );

            _updateValueStyles();
            element.classes.add(_cssClasses.IS_UPGRADED);
        }
    }

    /// Handle input on element.
    void _onInput(final html.Event event) {
        _updateValueStyles();
    }

    /// Handle change on element.
    void _onChange(final html.Event event) {
        _updateValueStyles();
    }

    /// Handle mouseup on element.
    void _onMouseUp(final html.MouseEvent event) {
        element.blur();
    }

    /// Handle updating of values.
    void _updateValueStyles() {

        // Calculate and apply percentages to div structure behind slider.
        final num fraction = (int.parse(slider.value) - int.parse(slider.min)) /
        (int.parse(slider.max) - int.parse(slider.min));

        if (fraction == 0) {
            element.classes.add(_cssClasses.IS_LOWEST_VALUE);

        } else {
            element.classes.remove(_cssClasses.IS_LOWEST_VALUE);
        }

        if (! _isIE ) {
            _backgroundLower.style.flex = fraction.toString();
            _backgroundUpper.style.flex = (1 - fraction).toString();
        }
    }
}

