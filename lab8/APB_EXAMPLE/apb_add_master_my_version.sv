module apb_add_master (
    input logic PCLK,
    input logic PRESET_N,

    input  logic[1:0] op,

    output logic[31:0] PWDATA_M_INF,
    output logic PWRITE_M_INF,
    output logic PENABLE_M_INF,
    output logic PSEL_M_INF,
    output logic PADDR_M_INF,

    input logic  PREADY_S_INF,
    input logic[31:0] PRDATA
);

//===============================
//   APB interfaces
//===============================
// States
typedef enum logic[1:0] {ST_IDLE,ST_SETUP,ST_ACCESS} apb_state_t;
apb_state_t current_state_ff;
apb_state_t next_state;

// Input process mode
wire op_nop   = op[0] == 1'b0;
wire op_read  = op == 2'b01;
wire op_write = op == 2'b11;

// APB interface state
wire apb_state_idle  = (current_state_ff == ST_IDLE);
wire apb_state_setup = (current_state_ff == ST_SETUP);
wire apb_state_access = (current_state_ff == ST_ACCESS);

//===============================
//   Received data and address
//===============================
logic [31:0] read_data_ff;
logic pwrite_f_ff;

//===============================
//   APB interfaces
//===============================
always_ff @( posedge PCLK or negedge PRESET_N ) begin : StateReg
    if(~PRESET_N)
    begin
        current_state_ff <= ST_IDLE;
    end
    else
    begin
        current_state_ff <= next_state;
    end
end

always_comb begin: NEXT_STATE_BLOCK
    PSEL_M_INF    = 1'b0;
    PENABLE_M_INF = 1'b0;

    case(current_state_ff)
    ST_IDLE:begin
        if(op_read || op_write)
        begin
            next_state = ST_SETUP;
        end
        else
        begin
            next_state = ST_IDLE;
        end
    end
    ST_SETUP:begin
        PSEL_M_INF = 1;
        next_state = ST_ACCESS;
    end
    ST_ACCESS:begin
        PSEL_M_INF = 1;
        PENABLE_M_INF = 1;

        if(~PREADY_S_INF)
        begin
            //Waiting for the slave to send value
            next_state = ST_ACCESS;
        end
        else if(PREADY_S_INF && (op_read | op_write))
        begin
            next_state = ST_SETUP;
        end
        else
        begin
            next_state = ST_IDLE;
        end
    end
    default:begin
        next_state = ST_IDLE;
    end
    endcase
end

// Note we can only do these operation in ACCESS MODE
// Write or read the data from this address and to this address
assign PADDR_M_INF  = apb_state_access ? 32'h1000 : 32'd0;

// Write enable and the data you want to write, note we can only access
assign PWRITE_M_INF = apb_state_access ? pwrite_f_ff : 1'b0;
assign PWDATA_M_INF = apb_state_access ? read_data_ff + 1 : 32'd0;

// Receiving the value for processing
always_ff @( posedge PCLK or negedge PRESET_N ) begin
    if(~PRESET_N)
    begin
        read_data_ff <= 0;
        pwrite_f_ff  <= 0;
    end
    else if(apb_state_access && PREADY_S_INF && op_read)
    begin
        read_data_ff <= PRDATA;
        pwrite_f_ff  <= 0;
    end
    else if(apb_state_access && PREADY_S_INF && op_write)
    begin
        pwrite_f_ff  <= 1;
    end
    else
    begin

    end
end

endmodule