`timescale 1ns/1ps

module parking_system_tb;

    // ------------------------------------------------
    // Testbench signals
    // ------------------------------------------------
    reg clk;
    reg reset;
    reg entry_sensor;
    reg exit_sensor;

    wire [2:0] occupied_slots;
    wire [2:0] available_slots;
    wire parking_full;
    wire vehicle_entered;
    wire vehicle_exited;

    // ------------------------------------------------
    // Instantiate parking system
    // ------------------------------------------------
    parking_system #(
        .MAX_SLOTS(4)
    ) uut (
        .clk(clk),
        .reset(reset),
        .entry_sensor(entry_sensor),
        .exit_sensor(exit_sensor),
        .occupied_slots(occupied_slots),
        .available_slots(available_slots),
        .parking_full(parking_full),
        .vehicle_entered(vehicle_entered),
        .vehicle_exited(vehicle_exited)
    );

    // ------------------------------------------------
    // Clock generation
    // 10 ns clock period
    // ------------------------------------------------
    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end

    // ------------------------------------------------
    // Monitor outputs
    // ------------------------------------------------
    initial begin
        $monitor(
            "Time=%0t ns | Entry=%b | Exit=%b | Occupied=%d | Available=%d | Full=%b | Entered=%b | Exited=%b",
            $time,
            entry_sensor,
            exit_sensor,
            occupied_slots,
            available_slots,
            parking_full,
            vehicle_entered,
            vehicle_exited
        );
    end

    // ------------------------------------------------
    // Test sequence
    // ------------------------------------------------
    initial begin

        // Initial values
        reset = 1'b1;
        entry_sensor = 1'b0;
        exit_sensor = 1'b0;

        // Reset system
        #20;
        reset = 1'b0;

        // --------------------------------------------
        // Vehicle 1 enters
        // --------------------------------------------
        #10;
        entry_sensor = 1'b1;

        #10;
        entry_sensor = 1'b0;

        // --------------------------------------------
        // Vehicle 2 enters
        // --------------------------------------------
        #20;
        entry_sensor = 1'b1;

        #10;
        entry_sensor = 1'b0;

        // --------------------------------------------
        // Vehicle 3 enters
        // --------------------------------------------
        #20;
        entry_sensor = 1'b1;

        #10;
        entry_sensor = 1'b0;

        // --------------------------------------------
        // Vehicle 4 enters
        // Parking becomes FULL
        // --------------------------------------------
        #20;
        entry_sensor = 1'b1;

        #10;
        entry_sensor = 1'b0;

        // --------------------------------------------
        // Try vehicle 5
        // Should NOT enter
        // --------------------------------------------
        #20;
        entry_sensor = 1'b1;

        #10;
        entry_sensor = 1'b0;

        // --------------------------------------------
        // Vehicle exits
        // --------------------------------------------
        #20;
        exit_sensor = 1'b1;

        #10;
        exit_sensor = 1'b0;

        // --------------------------------------------
        // Another vehicle enters
        // --------------------------------------------
        #20;
        entry_sensor = 1'b1;

        #10;
        entry_sensor = 1'b0;

        // --------------------------------------------
        // Finish simulation
        // --------------------------------------------
        #30;

        $display("======================================");
        $display("     PARKING SYSTEM SIMULATION");
        $display("          TEST FINISHED");
        $display("======================================");

        $finish;
    end

endmodule
