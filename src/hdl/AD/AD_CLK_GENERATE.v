`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/05/28 16:01:24
// Design Name: 
// Module Name: AD_CLK_GENERATE
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AD_CLK_GENERATE
(
    input       dco        ,
    input       dly_clk    ,
    input       rst_in     ,
    input       re_sync_in ,
    output      dly_rdy    ,
    output[4:0] tap_out    ,
    output      clk_out    ,
    output      clk_div_out
);
    
    (* keep="true" *)reg [8:0] judge_cnt=0;
    (* keep="true" *)reg [4:0] delay_tap=0;
    (* keep="true" *)reg load_en=0;
    (* keep="true" *)reg get_data_en=0;    
    // ������ʱ�Ӿ���IBUFDSģ��õ�����ʱ��
    (* keep="true" *)reg [4:0] delay_tap_dly=0;
    (* keep="true" *)reg load_en_dly=0;
    //1. ����ʱ�Ӿ���IDELAYģ��
//    (* IODELAY_GROUP = IODELAY_GROUP *) // Specifies group name for associated IDELAYs/ODELAYs and IDELAYCTRL
    
       IDELAYCTRL IDELAYCTRL_inst (
          .RDY(dly_rdy),       // 1-bit output: Ready output
          .REFCLK(dly_clk), // 1-bit input: Reference clock input
          .RST(rst_in)        // 1-bit input: Active high reset input
       );
//    (* IODELAY_GROUP = IODELAY_GROUP *) // Specifies group name for associated IDELAYs/ODELAYs and IDELAYCTRL
       
       wire dco_dly;
       wire clk_out_serdes;
       IDELAYE2 #(
          .CINVCTRL_SEL("FALSE"),          // Enable dynamic clock inversion (FALSE, TRUE)
          .DELAY_SRC("IDATAIN"),           // Delay input (IDATAIN, DATAIN)
          .HIGH_PERFORMANCE_MODE("TRUE"), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
          .IDELAY_TYPE("VAR_LOAD"),           // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
          .IDELAY_VALUE(0),                // Input delay tap setting (0-31)
          .PIPE_SEL("FALSE"),              // Select pipelined mode, FALSE, TRUE
          .REFCLK_FREQUENCY(200.0),        // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
          .SIGNAL_PATTERN("CLOCK")          // DATA, CLOCK input signal
       )
       IDELAYE2_inst (
          .CNTVALUEOUT(tap_out), // 5-bit output: Counter value output
          .DATAOUT(dco_dly),         // 1-bit output: Delayed data output
          .C(dly_clk),                     // 1-bit input: Clock input
          .CE(0),                   // 1-bit input: Active high enable increment/decrement input
          .CINVCTRL(0),       // 1-bit input: Dynamic clock inversion input
          .CNTVALUEIN(delay_tap_dly),   // 5-bit input: Counter value input
          .DATAIN(0),           // 1-bit input: Internal delay data input
          .IDATAIN(dco),         // 1-bit input: Data input from the I/O
          .INC(0),                 // 1-bit input: Increment / Decrement tap delay input
          .LD(load_en_dly),                   // 1-bit input: Load IDELAY_VALUE input
          .LDPIPEEN(0),       // 1-bit input: Enable PIPELINE register to load data input
          .REGRST(rst_in)            // 1-bit input: Active-high reset tap-delay input
       );
    //2. IDELAYģ����������BUFIO��BUFR������ʱ��ʱ�Ӻͷ�Ƶʱ�ӣ���ʱʱ�����Ƶʱ����Ϊ����λ�����
         /*(* keep="true" *)*/ wire clk_out_bufr;
         /*(* keep="true" *)*/ wire clk_out_bufio;
      BUFR #(
          .BUFR_DIVIDE("4"),   // Values: "BYPASS, 1, 2, 3, 4, 5, 6, 7, 8" 
          .SIM_DEVICE("7SERIES")  // Must be set to "7SERIES" 
       )
       BUFR_inst (
          .O(clk_out_bufr),     // 1-bit output: Clock output port
          .CE(1),   // 1-bit input: Active high, clock enable (Divided modes only)
          .CLR(rst_in), // 1-bit input: Active high, asynchronous clear (Divided modes only)
          .I(clk_out_serdes)      // 1-bit input: Clock buffer input driven by an IBUF, MMCM or local interconnect
       );
       BUFIO BUFIO_inst (
             .O(clk_out_bufio), // 1-bit output: Clock output (connect to I/O clock loads).
             .I(clk_out_serdes)  // 1-bit input: Clock input (connect to an IBUF or BUFMR).
          );
    //3. ����ʱ�ӽ���ISERDESģ���D�ˣ�
    //   BUFIO��BUFR�����ʱ�ӽ���ISERDESģ���ʱ�Ӻͷ�Ƶʱ�Ӷ�
    wire [7:0] clk_serdes_out;
       ISERDESE2 #(
          .DATA_RATE("DDR"),           // DDR, SDR
          .DATA_WIDTH(8),              // Parallel data width (2-8,10,14)
          .DYN_CLKDIV_INV_EN("FALSE"), // Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
          .DYN_CLK_INV_EN("FALSE"),    // Enable DYNCLKINVSEL inversion (FALSE, TRUE)
          // INIT_Q1 - INIT_Q4: Initial value on the Q outputs (0/1)
          .INIT_Q1(1'b0),
          .INIT_Q2(1'b0),
          .INIT_Q3(1'b0),
          .INIT_Q4(1'b0),
          .INTERFACE_TYPE("NETWORKING"),   // MEMORY, MEMORY_DDR3, MEMORY_QDR, NETWORKING, OVERSAMPLE
          .IOBDELAY("IBUF"),           // NONE, BOTH, IBUF, IFD
          .NUM_CE(2),                  // Number of clock enables (1,2)
          .OFB_USED("FALSE"),          // Select OFB path (FALSE, TRUE)
          .SERDES_MODE("MASTER"),      // MASTER, SLAVE
          // SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
          .SRVAL_Q1(1'b0),
          .SRVAL_Q2(1'b0),
          .SRVAL_Q3(1'b0),
          .SRVAL_Q4(1'b0) 
       )
       ISERDESE2_inst (
          .O(clk_out_serdes),                       // 1-bit output: Combinatorial output
          // Q1 - Q8: 1-bit (each) output: Registered data outputs
          .Q1(clk_serdes_out[0]),
          .Q2(clk_serdes_out[1]),
          .Q3(clk_serdes_out[2]),
          .Q4(clk_serdes_out[3]),
          .Q5(clk_serdes_out[4]),
          .Q6(clk_serdes_out[5]),
          .Q7(clk_serdes_out[6]),
          .Q8(clk_serdes_out[7]),
          // SHIFTOUT1, SHIFTOUT2: 1-bit (each) output: Data width expansion output ports
          .SHIFTOUT1(),
          .SHIFTOUT2(),
          .BITSLIP(0),           // 1-bit input: The BITSLIP pin performs a Bitslip operation synchronous to
                                       // CLKDIV when asserted (active High). Subsequently, the data seen on the Q1
                                       // to Q8 output ports will shift, as in a barrel-shifter operation, one
                                       // position every time Bitslip is invoked (DDR operation is different from
                                       // SDR).
    
          // CE1, CE2: 1-bit (each) input: Data register clock enable inputs
          .CE1(1),
          .CE2(1),
          .CLKDIVP(0),           // 1-bit input: TBD
          // Clocks: 1-bit (each) input: ISERDESE2 clock input ports
          .CLK(clk_out_bufio),                   // 1-bit input: High-speed clock
          .CLKB(~clk_out_bufio),                 // 1-bit input: High-speed secondary clock
          .CLKDIV(clk_out_bufr),             // 1-bit input: Divided clock
          .OCLK(),                 // 1-bit input: High speed output clock used when INTERFACE_TYPE="MEMORY" 
          // Dynamic Clock Inversions: 1-bit (each) input: Dynamic clock inversion pins to switch clock polarity
          .DYNCLKDIVSEL(0), // 1-bit input: Dynamic CLKDIV inversion
          .DYNCLKSEL(0),       // 1-bit input: Dynamic CLK/CLKB inversion
          // Input Data: 1-bit (each) input: ISERDESE2 data input ports
          .D(dco),                       // 1-bit input: Data input
          .DDLY(dco_dly),                 // 1-bit input: Serial data from IDELAYE2
          .OFB(0),                   // 1-bit input: Data feedback from OSERDESE2
          .OCLKB(),               // 1-bit input: High speed negative edge output clock
          .RST(rst_in),                   // 1-bit input: Active high asynchronous reset
          // SHIFTIN1, SHIFTIN2: 1-bit (each) input: Data width expansion input ports
          .SHIFTIN1(0),
          .SHIFTIN2(0) 
       );
    
    //4. ��λ�����ж�
    //   ����ʱ��ʱ�Ӳ�����˿�ʱ�ӣ����ݲɼ����������ж���ʱ���ʱ���Ƿ�������ʱ�Ӷ��룬
    //   ���û�У��͵���IDELAYģ�����ʱ��ֱ����ʱ���ʱ��������ʱ�Ӷ���
    
    (* keep="true" *)wire       find_f_start;
    (* keep="true" *)wire       find_r_start;
    (* keep="true" *)wire       find_f_stop;
    (* keep="true" *)wire       find_r_stop;
    (* keep="true" *)reg       lock_f_start=0;
    (* keep="true" *)reg       lock_r_start=0;
    (* keep="true" *)reg       lock_f_stop=0;
    (* keep="true" *)reg       lock_r_stop=0;
    (* keep="true" *)reg [4:0] lock_f_start_tap=0;
    (* keep="true" *)reg [4:0] lock_r_start_tap=0;
    (* keep="true" *)reg [4:0] lock_f_stop_tap=0;
    (* keep="true" *)reg [4:0] lock_r_stop_tap=0;
   
//   (* keep="true" *) reg [7:0] not_aligned_cnt=0;
   (* keep="true" *) reg running_align=0;
   (* keep="true" *) reg finished_align=0;
   
   (* keep="true" *)reg [5:0] delta_r=0;
   (* keep="true" *)reg [5:0] delta_f=0;
   (* keep="true" *)reg [3:0] delta=0;
   (* keep="true" *)wire [4:0] final_tap;
   
   (* keep="true" *)reg gen_final_tap;  
   (* keep="true" *)reg all_aa = 0;
   (* keep="true" *)reg pre_all_aa = 0;
   (* keep="true" *)reg all_55 = 0;
   (* keep="true" *)reg pre_all_55 = 0;
   (* keep="true" *)wire delay_stable;
   (* keep="true" *)wire align_finished;
   assign delay_stable = (judge_cnt[3:0] == 8) ? 1 : 0;
   assign find_f_start = !all_aa & pre_all_aa;
   assign find_r_stop  = all_aa & !pre_all_aa;
   reg [7:0] clk_serdes_out_reg;
   always @(posedge clk_out_bufr) begin
       clk_serdes_out_reg  <= clk_serdes_out;
   end      
   always @(posedge clk_out_bufr) begin
       if(clk_serdes_out_reg == 8'hAA)begin
          if(running_align == 0 || (running_align == 1 && delay_stable == 1))
            all_aa   <= 1;
       end
       else begin
          if(running_align == 0 || (running_align == 1 && delay_stable == 1))
            all_aa   <= 0;
       end
       pre_all_aa  <= all_aa;
   end
   
   assign find_r_start = !all_55 & pre_all_55;
   assign find_f_stop  = all_55 & !pre_all_55;

   always @(posedge clk_out_bufr) begin
       if(clk_serdes_out_reg == 8'h55) begin
          if(running_align == 0 || (running_align == 1 && delay_stable == 1))
            all_55   <= 1;
       end
       else begin
          if(running_align == 0 || (running_align == 1 && delay_stable == 1))
            all_55   <= 0;
       end
       pre_all_55  <= all_55;
   end
   
//   always @(posedge clk_out_bufr) begin
//       if((all_55 ==1 || all_aa == 1) && running_align == 0)
//          not_aligned_cnt   <= not_aligned_cnt + 1;
//       else
//          not_aligned_cnt   <= 0;
//   end
   //���ƶ������б�־
   //������û����ʱ���������б�־��Ϊ1
   //�����ֶ������ʱ���������б�־���� 
   always @(posedge clk_out_bufr) begin
       if(rst_in == 1 )
          running_align   <= 1;
       else if(align_finished == 1)
          running_align   <= 0;
   end   
   
   reg align_finished_d1;
   always @(posedge clk_out_bufr) begin
       align_finished_d1 <= align_finished;
       if(align_finished) begin
          delay_tap       <= final_tap[4:0];
          load_en         <= !align_finished_d1 & align_finished; 
       end
       else begin
          if(judge_cnt[3:0] == 0)
             load_en     <= 1; 
          else
             load_en     <= 0; 
          delay_tap       <= judge_cnt[8:4];
       end
   end     
   //�������������  
   //������δ����ʱ��������������
   //����������ʱ��������������� 
   reg re_sync_in_d1;
   reg re_sync_in_d2;
   wire re_sync;
   assign re_sync = !re_sync_in_d2 & re_sync_in_d1;
   always @(posedge clk_out_bufr) begin

       if(re_sync == 1 || rst_in == 1)
          judge_cnt   <= 0;
       else if(running_align == 1)
          judge_cnt   <= judge_cnt + 1;
   end      
   
   //ʹ�ö���������ĸ�5λ��IDELAY����ʱ���룬��3λ����ʱ���ú���ȶ�ʱ���ж�
   //�����λΪ0ʱ������ʱֵ������λΪ6ʱ��ʱģ���Ѿ��ȶ�
   (* keep="true" *) reg compare_ena;
   always @(posedge clk_out_bufr) begin
     compare_ena <= judge_cnt[8:4] > 0  ? 1 : 0;
     if(compare_ena == 1) begin
        lock_f_start    <= find_f_start | lock_f_start;
        lock_r_start    <= find_r_start | lock_r_start;
        lock_f_stop     <= find_f_stop |lock_f_stop;
        lock_r_stop     <= find_r_stop |lock_r_stop;
     end
     else begin
        lock_f_start    <= 0;
        lock_r_start    <= 0;
        lock_f_stop    <= 0;
        lock_r_stop    <= 0;                   
     end    
   end
     
   always @(posedge clk_out_bufr) begin
      lock_r_start_tap <= (find_f_start & compare_ena) ? judge_cnt[8:4] : lock_r_start_tap;
      lock_f_start_tap <= (find_f_start & compare_ena) ? judge_cnt[8:4] : lock_f_start_tap;
      lock_r_stop_tap <= (find_r_stop & compare_ena) ? judge_cnt[8:4] : lock_r_stop_tap;
      lock_f_stop_tap <= (find_f_stop & compare_ena) ? judge_cnt[8:4] : lock_f_stop_tap;
   end
   assign align_finished  = lock_f_start & lock_f_stop & lock_r_start & lock_r_stop;
   assign final_tap = lock_r_start_tap;
   
   
   always @(posedge dly_clk) begin
//      delay_tap_dly <= delay_tap;
//      load_en_dly   <= load_en;   
       re_sync_in_d1    <= re_sync_in;
       re_sync_in_d2    <= re_sync_in_d1;
      if(re_sync == 1) begin
          delay_tap_dly <= 14;
          load_en_dly   <= 1;
      end
      else begin
          load_en_dly   <= 0;
      end 
   end     
   
   assign clk_out       = clk_out_bufio;
   assign clk_div_out   = clk_out_bufr;
endmodule
