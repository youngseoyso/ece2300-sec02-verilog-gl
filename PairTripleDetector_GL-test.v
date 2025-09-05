//========================================================================
// PairTripleDetector_GL-test
//========================================================================

`include "ece2300-test.v"
`include "PairTripleDetector_GL.v"

module Top();

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  ece2300_CombinationalTestUtils t();

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic in0;
  logic in1;
  logic in2;
  logic out;

  PairTripleDetector_GL dut
  (
    .in0 (in0),
    .in1 (in1),
    .in2 (in2),
    .out (out)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // We set the inputs, wait 8 tau, check the outputs, wait 2 tau. Each
  // check will take a total of 10 tau.

  task check
  (
    input logic in0_,
    input logic in1_,
    input logic in2_,
    input logic out_
  );
    if ( !t.failed ) begin

      in0 = in0_;
      in1 = in1_;
      in2 = in2_;

      #8;

      if ( t.n != 0 )
        $display( "%3d: %b %b %b > %b", t.cycles, in0, in1, in2, out );

      `ECE2300_CHECK_EQ( out, out_ );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0 in1 in2 out
    check( 0,  0,  0,  0 );
    check( 0,  1,  1,  1 );
    check( 0,  1,  0,  0 );
    check( 1,  1,  1,  1 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_exhaustive
  //----------------------------------------------------------------------

  task test_case_2_exhaustive();
    t.test_case_begin( "test_case_2_exhaustive" );

    //     in0 in1 in2 out
    check( 0,  0,  0,  0 );
    check( 0,  0,  1,  0 );
    check( 0,  1,  0,  0 );
    check( 0,  1,  1,  1 );
    check( 1,  0,  0,  0 );
    check( 1,  0,  1,  1 );
    check( 1,  1,  0,  1 );
    check( 1,  1,  1,  1 );
   
   
    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_xprop
  //----------------------------------------------------------------------

  task test_case_3_xprop();
    t.test_case_begin( "test_case_3_xprop" );

    //     in0 in1 in2 out
    check( 'x, 'x, 'x, 'x );
    check( 'x,  1,  0, 'x );
    check(  1,  1, 'x,  1 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_exhaustive();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_xprop();

    t.test_bench_end();
  end

endmodule
