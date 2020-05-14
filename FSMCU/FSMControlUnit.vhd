----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.05.2020 17:11:03
-- Design Name: 
-- Module Name: FSMControlUnit - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSMControlUnit is
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
              WF1    : out std_logic;               -- enables the write port of the register file
              -- INPUTS
              OPCODE : in  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
              FUNC   : in  std_logic_vector(FUNC_SIZE - 1 downto 0);              
              Clk : in std_logic;
              Rst : in std_logic);                  -- Active Low
end FSMControlUnit;

architecture Behavioral of FSMControlUnit is

Type statetype is (s0, fetch, decode , execute, memWB);
signal c_state, n_state : statetype;

component Hardwired_LUT_CU is
 port (
      control_word: out std_logic_vector(12 downto 0);
      -- INPUTS
      OPCODE : in  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
      FUNC   : in  std_logic_vector(FUNC_SIZE - 1 downto 0));                  -- Active Low
end component;

signal control_word: std_logic_vector(12 downto 0);

begin
LUT: Hardwired_LUT_CU port map (control_word ,OPCODE, FUNC);

--The entity uses a lookuptable to retrive output control word as a combinational network, the FSM handles only the ENABLE signals of the stages. 

    process (clk)
    begin
        if (clk = '1'and clk'event) then
            if (rst = '0') then
                c_state <= s0;
            else 
                c_state <= n_state;
            end if;
        end if;
    end process;
    
    process (c_state, control_word)
    begin
        case c_state is 
            when fetch=>
                n_state <= decode;
                EN1 <= '0';
                EN2 <= '0';
                EN3 <= '0';
            when decode=>
                n_state <= execute;
                EN1 <= '1';
                EN2 <= '0';
                EN3 <= '0';   
            when execute=>
                n_state <= memWB;
                EN1 <= '0';
                EN2 <= '1';
                EN3 <= '0';
            when memWb=>  
                n_state <= fetch;
                EN1 <= '0';
                EN2 <= '0';
                EN3 <= '1';
            when others=>
                n_state <= fetch;
                EN1 <= '0';
                EN2 <= '0';
                EN3 <= '0';
        end case;
    end process;
    
WF1 <= control_word(0);
S3 <= control_word(1);
WM <= control_word(2); 
RM <= control_word(3);
ALU2 <= control_word(5);
ALU1 <= control_word(6);
S2 <= control_word(7);
S1 <= control_word(8);
RF2 <= control_word(10);
RF1 <= control_word(11);

end Behavioral;
