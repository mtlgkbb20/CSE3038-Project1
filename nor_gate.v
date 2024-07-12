// Define the NOR gate module
module nor_gate (
    input wire a,  // First input
    input wire b,  // Second input
    output wire y  // Output
);

    // NOR gate logic
    assign y = ~(a | b);

endmodule
