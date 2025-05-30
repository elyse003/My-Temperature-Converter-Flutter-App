import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const TemperatureConverterApp());
}

/// Main application widget that sets up the theme and home page
class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch:
            Colors.orange, // Changed from blue to orange (warm temperature)
        scaffoldBackgroundColor: const Color(
          0xFFFFF8E1,
        ), // Warm cream background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF6F00), // Warm orange
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF8F00), // Warm orange
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(8),
          color: Colors.white, // Keep cards white for contrast
        ),
      ),
      home: const TemperatureConverterPage(),
    );
  }
}

/// Model class to represent a conversion history entry
class ConversionHistory {
  final String operation;
  final double inputValue;
  final double resultValue;
  final DateTime timestamp;

  ConversionHistory({
    required this.operation,
    required this.inputValue,
    required this.resultValue,
    required this.timestamp,
  });

  /// Formats the history entry for display
  String get formattedEntry {
    return '$operation: ${inputValue.toStringAsFixed(1)} => ${resultValue.toStringAsFixed(1)}';
  }
}

/// Enum to represent conversion types
enum ConversionType { fahrenheitToCelsius, celsiusToFahrenheit }

/// Main page widget containing the temperature converter functionality
class TemperatureConverterPage extends StatefulWidget {
  const TemperatureConverterPage({super.key});

  @override
  State<TemperatureConverterPage> createState() =>
      _TemperatureConverterPageState();
}

class _TemperatureConverterPageState extends State<TemperatureConverterPage> {
  // State variables for managing the app's data
  final TextEditingController _temperatureController = TextEditingController();
  ConversionType _selectedConversion = ConversionType.fahrenheitToCelsius;
  double? _result;
  final List<ConversionHistory> _history = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _temperatureController.dispose();
    super.dispose();
  }

  /// Converts Fahrenheit to Celsius using the formula: °C = (°F - 32) × 5/9
  double _fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  /// Converts Celsius to Fahrenheit using the formula: °F = °C × 9/5 + 32
  double _celsiusToFahrenheit(double celsius) {
    return celsius * 9 / 5 + 32;
  }

  /// Performs the temperature conversion and updates the state
  void _convertTemperature() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final inputValue = double.parse(_temperatureController.text);
    double result;
    String operation;

    // Perform conversion based on selected type
    if (_selectedConversion == ConversionType.fahrenheitToCelsius) {
      result = _fahrenheitToCelsius(inputValue);
      operation = 'F to C';
    } else {
      result = _celsiusToFahrenheit(inputValue);
      operation = 'C to F';
    }

    // Update state with new result and add to history
    setState(() {
      _result = result;
      _history.insert(
        0,
        ConversionHistory(
          operation: operation,
          inputValue: inputValue,
          resultValue: result,
          timestamp: DateTime.now(),
        ),
      );
    });

    // Provide haptic feedback for better user experience
    HapticFeedback.lightImpact();
  }

  /// Clears all input and results
  void _clearAll() {
    setState(() {
      _temperatureController.clear();
      _result = null;
    });
  }

  /// Clears the conversion history
  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  /// Validates the temperature input
  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a temperature value';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    return null;
  }

  /// Builds the main conversion interface
  Widget _buildConversionInterface() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(
          MediaQuery.of(context).orientation == Orientation.landscape ? 12 : 20,
        ), // Reduced padding in landscape
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                'Temperature Converter',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height:
                    MediaQuery.of(context).orientation == Orientation.landscape
                    ? 12
                    : 24,
              ), // Reduced spacing in landscape
              // Conversion type selection
              _buildConversionTypeSelector(),
              SizedBox(
                height:
                    MediaQuery.of(context).orientation == Orientation.landscape
                    ? 12
                    : 20,
              ), // Reduced spacing in landscape
              // Temperature input field
              _buildTemperatureInput(),
              SizedBox(
                height:
                    MediaQuery.of(context).orientation == Orientation.landscape
                    ? 12
                    : 20,
              ), // Reduced spacing in landscape
              // Convert button
              _buildConvertButton(),
              SizedBox(
                height:
                    MediaQuery.of(context).orientation == Orientation.landscape
                    ? 12
                    : 20,
              ), // Reduced spacing in landscape
              // Result display
              if (_result != null) _buildResultDisplay(),

              // Action buttons
              SizedBox(
                height:
                    MediaQuery.of(context).orientation == Orientation.landscape
                    ? 8
                    : 16,
              ), // Reduced spacing in landscape
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the conversion type selector (radio buttons)
  Widget _buildConversionTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Conversion Type:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFFE65100), // Dark orange
          ),
        ),
        const SizedBox(height: 8),
        RadioListTile<ConversionType>(
          title: const Text('Fahrenheit to Celsius (°F → °C)'),
          value: ConversionType.fahrenheitToCelsius,
          groupValue: _selectedConversion,
          onChanged: (value) {
            setState(() {
              _selectedConversion = value!;
              _result = null;
            });
          },
          activeColor: const Color(0xFFFF6F00), // Warm orange
        ),
        RadioListTile<ConversionType>(
          title: const Text('Celsius to Fahrenheit (°C → °F)'),
          value: ConversionType.celsiusToFahrenheit,
          groupValue: _selectedConversion,
          onChanged: (value) {
            setState(() {
              _selectedConversion = value!;
              _result = null;
            });
          },
          activeColor: const Color(0xFFFF6F00), // Warm orange
        ),
      ],
    );
  }

  /// Builds the temperature input field
  Widget _buildTemperatureInput() {
    return TextFormField(
      controller: _temperatureController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: _validateInput,
      decoration: InputDecoration(
        labelText: _selectedConversion == ConversionType.fahrenheitToCelsius
            ? 'Enter temperature in Fahrenheit'
            : 'Enter temperature in Celsius',
        hintText: 'e.g., 32.0',
        prefixIcon: Icon(
          Icons.thermostat,
          color: _getTemperatureColor(), // Dynamic color based on conversion
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _getTemperatureColor(), width: 2),
        ),
        labelStyle: TextStyle(color: _getTemperatureColor()),
      ),
      onChanged: (value) {
        if (_result != null) {
          setState(() {
            _result = null;
          });
        }
      },
    );
  }

  /// Gets temperature-related color based on conversion type
  Color _getTemperatureColor() {
    return _selectedConversion == ConversionType.fahrenheitToCelsius
        ? const Color(0xFFFF6F00) // Warm orange for Fahrenheit (hot)
        : const Color(0xFF1976D2); // Cool blue for Celsius (cold)
  }

  /// Builds the Convert button
  Widget _buildConvertButton() {
    return ElevatedButton.icon(
      onPressed: _convertTemperature,
      icon: const Icon(Icons.swap_horiz),
      label: const Text('Convert'),
    );
  }

  /// Builds the result display section
  Widget _buildResultDisplay() {
    final bool isHot =
        _selectedConversion == ConversionType.celsiusToFahrenheit ||
        (_result != null &&
            _result! > 20); // Hot if converting to F or result > 20°C

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHot
            ? const Color(0xFFFFF3E0)
            : const Color(0xFFE3F2FD), // Warm/cool background
        border: Border.all(
          color: isHot ? const Color(0xFFFF8F00) : const Color(0xFF2196F3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle,
            color: isHot ? const Color(0xFFE65100) : const Color(0xFF1976D2),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Result:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isHot ? const Color(0xFFE65100) : const Color(0xFF1976D2),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_result!.toStringAsFixed(2)}°${_selectedConversion == ConversionType.fahrenheitToCelsius ? 'C' : 'F'}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: isHot ? const Color(0xFFE65100) : const Color(0xFF1976D2),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the action buttons (Clear, Clear History)
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _clearAll,
            icon: const Icon(Icons.clear),
            label: const Text('Clear'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFFF6F00), // Warm orange
              side: const BorderSide(color: Color(0xFFFF6F00)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _history.isNotEmpty ? _clearHistory : null,
            icon: const Icon(Icons.history),
            label: const Text('Clear History'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(
                0xFFD32F2F,
              ), // Red for destructive action
              side: const BorderSide(color: Color(0xFFD32F2F)),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the conversion history section
  Widget _buildHistorySection() {
    if (_history.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.history, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No conversions yet',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'Perform a conversion to see history here',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.history,
                  color: const Color(0xFFFF6F00),
                ), // Warm orange
                const SizedBox(width: 8),
                Text(
                  'Conversion History',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE65100), // Dark orange
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...(_history.take(10).map((entry) => _buildHistoryItem(entry))),
            if (_history.length > 10)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Showing latest 10 conversions',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds individual history item
  Widget _buildHistoryItem(ConversionHistory entry) {
    final bool isFahrenheitConversion = entry.operation == 'C to F';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isFahrenheitConversion
            ? const Color(0xFFFFF3E0) // Warm background for F conversions
            : const Color(0xFFE3F2FD), // Cool background for C conversions
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isFahrenheitConversion
              ? const Color(0xFFFFCC80)
              : const Color(0xFFBBDEFB),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isFahrenheitConversion
                  ? const Color(0xFFFFB74D) // Warm orange
                  : const Color(0xFF90CAF9), // Cool blue
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              entry.operation,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isFahrenheitConversion
                    ? Colors.brown[800]
                    : Colors.blue[800],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${entry.inputValue.toStringAsFixed(1)} => ${entry.resultValue.toStringAsFixed(1)}',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        centerTitle: true,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          // Responsive layout for portrait and landscape orientations
          if (orientation == Orientation.portrait) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildConversionInterface(),
                  const SizedBox(height: 16),
                  _buildHistorySection(),
                ],
              ),
            );
          } else {
            // Landscape layout: side-by-side arrangement with proper scrolling
            return Padding(
              padding: const EdgeInsets.all(8), // Reduced padding for landscape
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildConversionInterface(),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(left: 8),
                      child: _buildHistorySection(),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
