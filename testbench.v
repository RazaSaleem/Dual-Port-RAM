// Code your testbench here
// or browse Examples

/****************************************************************/
// MODULE:                Dual Port RAM Simulation
//

// CODE TYPE : 			  Simulation 

// DESRIPTION : 	This module provides stimuli for simulating
// a Dual Port Random Access Memory. It writes unique values to 
// each location then reads them back and checks for correctness.
// Read back of the RAM begins before writing has finished to 
// check that both can occur simutaneously.
//
/*****************************************************************/

//  DEFINES
`define DEL		1				// Clock-to-output delay. zero
								// time delays can be confusing
								// and sometimes cause problems.

`define RAM_WIDTH	8			// Width of RAM (number of bits)
`define RAM_DEPTH	16			// Depth of RAM (number of bytes)
`define ADDR_SZ		4			// Number of bits required to 
								// represent the RAM address

//  TOP MODULE
module DPRAM_tb ();
  	`	
//  INPUTS

//  OUTPUTS
    
//  INOUTS
  
//  SIGNAL DECLARATIONS
  
  reg						clk;
  reg [`RAM_WIDTH-1:0]		data_in;
  reg [`ADDR_SZ-1:0]		rd_address;
  reg 						read;
  reg [`ADDR_SZ-1:0]		wr_address;
  reg						write;
  wire [`RAM_WIDTH-1:0]		data_out;
  
  
  reg [`RAM_WIDTH-1:0]		data_exp;		// Expected output data
  integer					cyc_count; 		// Cycle counter
  
//  PARAMETERS
  
//  ASSIGN STATEMENTS
  
// MAIN CODE
  
  
// Instantiate the Design
  
  DPRAM Dut (.clk(clk),
             .data_in(data_in),
             .rd_address(rd_address),
             .read(read),
             .data_out(data_out),
             .wr_address(wr_address),
             .write(write)
            );
  
//  Initialize inputs
  initial begin
    data_in = 0;
    data_exp = 0;
    rd_address = 0;
    wr_address = 0;
    clk = 1;
    cyc_count = 0;
    write = 1;		// Start writing
    read = 0;		// Start reading later
  end
  
  
//  Generate the clock
  always #100 clk = ~clk;
  
//  Simulate
//  Write the RAM
  
  always @ (posedge clk) begin
    // Give a delay for outputs to settle
    #`DEL;
    #`DEL;
    if (write) begin
      // Set up the write address for the next write
      wr_address = wr_address + 1;
      if (wr_address === 0) begin
        // If the address is 0, we've written the entire RAM
        // Deasssert the write control
        write = 0;
      end
      else begin
        // Otherwise set up the data for the next write
        // We decrement data while incrementing address
        // so that we know we are writing the data, not
        // the address into memory
        data_in = data_in - 1;
      end
    end
    if (read) begin
      // Read the data and compare
      if (data_out !== data_exp) begin
        $display("\nERROR at time %0t:", $time);
        $display("	Data read		= %h", data_out);
        $display("	Data expected	= %h\n", data_exp);
        
        
        // Use $stop for debugging
        $stop
      end
      
      // Increment the read adddress
      rd_address = rd_address + 1;
      if (rd_address === 0) begin
        // If the address is 0, we've read the entire RAM
        $display("\nSimulation complete - no errors\n");
        $finish;
      end
      
      // Decrement the expected data
      data_exp <= data_exp - 1;
    end
    
    // Increment the cycle counter
    cyc_count = cyc_count + 1;
    
    // Start reading at some point
    if (cyc_count == (`RAM_DEPTH/2 + 2 )) begin
      // Assert the read control
      read = 1;
    end
  end
  
endmodule		// DPRAM_tb
