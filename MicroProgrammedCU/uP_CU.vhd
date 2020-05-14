----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.05.2020 10:22:48
-- Design Name: 
-- Module Name: uP_CU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.myTypes.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uP_CU is
 port (
              -- FIRST PIPE STAGE OUTPUTS
              EN1    : out std_logic;               -- enables the register file and the pipeline registers
              RF1    : out std_logic;               -- enables the read port 1 of the register file
              RF2    : out std_logic;               -- enables the read port 2 of the register file
              -- SECOND PIPE STAGE OUTPUTS
              EN2    : out std_logic;               -- enables the pipe registers
              S1     : out std_logic;               -- input selection of the first multiplexer
              S2     : out std_logic;               -- input selection of the second multiplexer
              ALU1   : out std_logic;               -- alu control bit
              ALU2   : out std_logic;               -- alu control bit
              -- THIRD PIPE STAGE OUTPUTS
              EN3    : out std_logic;               -- enables the memory and the pipeline registers
              RM     : out std_logic;               -- enables the read-out of the memory
              WM     : out std_logic;               -- enables the write-in of the memory
              S3     : out std_logic;               -- input selection of the multiplexer
              WF1    : out std_logic;              -- enables the write port of the register file
              -- INPUTS
              OPCODE : in  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
              FUNC   : in  std_logic_vector(FUNC_SIZE - 1 downto 0);              
              Clk : in std_logic;
              Rst : in std_logic);                  -- Active Low
end uP_CU;

architecture Behavioral of uP_CU is
component uPLUT is
 port (
      control_word: out std_logic_vector(12 downto 0);
      -- INPUTS
      OPCODE : in  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
      FUNC   : in  std_logic_vector(FUNC_SIZE - 1 downto 0));              
end component;

signal control_word: std_logic_vector(12 downto 0);
signal lut_op_in: std_logic_vector(OP_CODE_SIZE - 1 downto 0);
type statetype is (s0, st0, st1, st2);
signal c_state, n_state: statetype;
begin

LUT: uPLUT port map(control_word, lut_op_in, FUNC); --LUT instantiation.

    process(clk)
    begin
        if (clk='1'and clk'event) then
            if(rst = '0') then
                c_state <= s0;
            else
                c_state <= n_state;
            end if;
        end if;
    end process;
    
    process(c_state, OPCODE, FUNC)
    begin
        case c_state is 
            when st0 => 
            	-- Store the opcode.
                lut_op_in <= OPCODE;
                n_state <= st1;
            when st1 =>
            	--Add one.
                lut_op_in <= std_logic_vector(unsigned(lut_op_in)+1);
                n_state <= st2;
            when st2 => 
            	--Add one.
                lut_op_in <= std_logic_vector(unsigned(lut_op_in)+1);
                n_state <= st0;
            when others =>  
            	--Reset state.    
                lut_op_in <= "111111";     --Gives out all zeros.
                n_state <= st0;
        end case;
    end process;
    
WF1 <= control_word(0);
S3 <= control_word(1);
WM <= control_word(2); 
RM <= control_word(3);
EN3 <= control_word(4);
ALU2 <= control_word(5);
ALU1 <= control_word(6);
S2 <= control_word(7);
S1 <= control_word(8);
EN2 <= control_word(9);
RF2 <= control_word(10);
RF1 <= control_word(11);
EN1 <= control_word(12);  
end Behavioral;
