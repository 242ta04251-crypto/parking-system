`timescale 1ns/1ps

module parking_system #(
    parameter MAX_SLOTS = 4
)(
    input  wire clk,
    input  wire reset,

    // Vehicle sensors
    input  wire entry_sensor,
    input  wire exit_sensor,

    // Outputs
    output reg [2:0] occupied_slots,
    output wire [2:0] available_slots,
    output reg parking_full,
    output reg vehicle_entered,
    output reg vehicle_exited
);

    // ------------------------------------------------
    // Calculate available parking slots
    // ------------------------------------------------
    assign available_slots = MAX_SLOTS - occupied_slots;

    // ------------------------------------------------
    // Parking system logic
    // ------------------------------------------------
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            occupied_slots <= 3'd0;
            parking_full   <= 1'b0;
            vehicle_entered <= 1'b0;
            vehicle_exited  <= 1'b0;
        end
        else begin

            // Default pulse outputs
            vehicle_entered <= 1'b0;
            vehicle_exited  <= 1'b0;

            // ----------------------------------------
            // Vehicle enters parking
            // ----------------------------------------
            if (entry_sensor && !exit_sensor) begin

                if (occupied_slots < MAX_SLOTS) begin
                    occupied_slots <= occupied_slots + 1'b1;
                    vehicle_entered <= 1'b1;
                end
            end

            // ----------------------------------------
            // Vehicle exits parking
            // ----------------------------------------
            else if (exit_sensor && !entry_sensor) begin

                if (occupied_slots > 0) begin
                    occupied_slots <= occupied_slots - 1'b1;
                    vehicle_exited <= 1'b1;
                end
            end

            // ----------------------------------------
            // Parking full indication
            // ----------------------------------------
            if (occupied_slots >= MAX_SLOTS)
                parking_full <= 1'b1;
            else
                parking_full <= 1'b0;
        end
    end

endmodule
