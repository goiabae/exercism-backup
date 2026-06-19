class CalculatorConundrum {
    public String calculate(int operand1, int operand2, String operation) {
        if (operation == null) {
            throw new IllegalArgumentException("Operation cannot be null");
        } else if (operation == "") {
            throw new IllegalArgumentException("Operation cannot be empty");
        } else if (operation == "+") {
            int result = operand1 + operand2;
            return String.format("%d + %d = %d", operand1, operand2, result);
        } else if (operation == "*") {
            int result = operand1 * operand2;
            return String.format("%d * %d = %d", operand1, operand2, result);
        } else if (operation == "/") {
            int result;
            try {
                result = operand1 / operand2;
            } catch (ArithmeticException e) {
                throw new IllegalOperationException("Division by zero is not allowed", e);
            }
            return String.format("%d / %d = %d", operand1, operand2, result);
        }
        throw new IllegalOperationException("Operation '" + operation + "' does not exist");
    }
}
