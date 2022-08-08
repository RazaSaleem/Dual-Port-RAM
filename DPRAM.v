// Code your design here
// Code your design here

/****************************************************************/
// MODULE:                Dual Port RAM
//

//
// CODE TYPE : 			  Behavioral and RTL 

// DESRIPTION : 	This module defines a Synchronous Dual Port
// Random Access Memory.
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
module DPRAM (clk,
             data_in,
             rd_address,
             read,
             data_out,
             wr_address,
             write
            );
//  INPUTS
  input						clk;		// RAM clock
  input [`RAM_WIDTH-1:0]	data_in		// RAM data input
  input [`ADDR_SZ-1:0]		rd_address	// RAM read address
  input 					read;		// Read control
  input [`ADDR_SZ-1:0]		wr_address;	//RAM write address
  input 					write;		// Write control
  
//  OUTPUTS
  
  output [`RAM_WIDTH-1:0]	data_out;	// RAM data output
  
//  INOUTS
  
//  SIGNAL DECLARATIONS
  
  wire						clk;
  wire [`RAM_WIDTH-1:0]		data_in;
  wire [`ADDR_SZ-1:0]		rd_address;
  wire 						read;
  wire [`ADDR_SZ-1:0]		wr_address;
  wire						write;
  wire [`RAM_WIDTH-1:0]		data_out;
  
  
  reg [`RAM_WIDTH-1:0]		mem [`RAM_DEPTH-1:0];		// The RAM
  
//  PARAMETERS
  
//  ASSIGN STATEMENTS
  
//  MAIN CODE
  
//  Look at the rising edge of the clock
  always @(posedge clk) begin
    if (write)
      mem[wr_address] <= #`DEL data_in;
    
    if(read)
      data_out <= #`DEL mem [rd_address];
    
  end
endmodule		// DPRAM
