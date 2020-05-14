----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.05.2020 18:01:20
-- Design Name: 
-- Module Name: Hardwired_Control_Unit - Behavioral
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

entity Hardwired_Control_Unit is
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
end Hardwired_Control_Unit;

architecture Behavioral of Hardwired_Control_Unit is
component Hardwired_LUT_CU is 
 port (
      control_word: out std_logic_vector(12 downto 0);
      -- INPUTS
      OPCODE : in  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
      FUNC   : in  std_logic_vector(FUNC_SIZE - 1 downto 0));  
end component; 

--signal control_word: std_logic_vector(12 downto 0);
signal current_control_word_pipe1, next_control_word_pipe1: std_logic_vector(12 downto 0); --First stage register.
signal current_control_word_pipe2, next_control_word_pipe2: std_logic_vector(9 downto 0);  --Second stage register.
signal current_control_word_pipe3, next_control_word_pipe3 : std_logic_vector(4 downto 0); --Third stage register.
begin


LUT: Hardwired_LUT_CU port map(next_control_word_pipe1 ,OPCODE, FUNC); --LUT instantiation.
    
    process (Clk)
    begin
        if (Clk='1'and Clk'event) then
            if (rst = '0') then
                current_control_word_pipe1 <= (others => '0');
                current_control_word_pipe2 <= (others => '0');
                current_control_word_pipe3 <= (others => '0');
            else
                current_control_word_pipe1 <= next_control_word_pipe1;
                current_control_word_pipe2 <= next_control_word_pipe2;
                current_control_word_pipe3 <= next_control_word_pipe3;
            end if;
        end if;
    end process;

    process (current_control_word_pipe2, current_control_word_pipe3, current_control_word_pipe1)
    begin
       next_control_word_pipe2 <= current_control_word_pipe1(9 downto 0);
       next_control_word_pipe3 <= current_control_word_pipe2(4 downto 0);
    end process;
    
  
WF1 <= current_control_word_pipe3(0);
S3 <= current_control_word_pipe3(1);
WM <= current_control_word_pipe3(2); 
RM <= current_control_word_pipe3(3);
EN3 <= current_control_word_pipe3(4);
ALU2 <= current_control_word_pipe2(5);
ALU1 <= current_control_word_pipe2(6);
S2 <= current_control_word_pipe2(7);
S1 <= current_control_word_pipe2(8);
EN2 <= current_control_word_pipe2(9);
RF2 <= current_control_word_pipe1(10);
RF1 <= current_control_word_pipe1(11);
EN1 <= current_control_word_pipe1(12);  
end Behavioral;
