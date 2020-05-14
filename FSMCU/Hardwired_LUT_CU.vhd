----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.05.2020 14:09:52
-- Design Name: 
-- Module Name: Hardwired_CU - Behavioral
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

entity Hardwired_LUT_CU is
 port (
      control_word: out std_logic_vector(12 downto 0);
      -- INPUTS
      OPCODE : in  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
      FUNC   : in  std_logic_vector(FUNC_SIZE - 1 downto 0));                  -- Active Low
end Hardwired_LUT_CU;

architecture Behavioral of Hardwired_LUT_CU is

--signal control_word: std_logic_vector(12 downto 0);
--signal control_word_tmp1: std_logic_vector(9 downto 0);
--signal control_word_tmp2: std_logic_vector(4 downto 0);
--signal WF1_tmp, S3_tmp, WM_tmp, RM_tmp, EN3_tmp, ALU2_tmp, ALU1_tmp, S2_tmp, S1_tmp, EN2_tmp: std_logic;
begin
Lookup_table:
    process(OPCODE, FUNC)
    begin
       case (OPCODE(3 downto 0)) is 
            when "0000"=> control_word <= "1011000010011";
            when "0001"=> control_word <= "1011000110011";
            when "0010"=> control_word <= "1011001010011";
            when "0011"=> control_word <= "1011001110011";
            when "0100"=> control_word <= "1101110010011";
            when "0101"=> control_word <= "1101110110011";
            when "0110"=> control_word <= "1101111010011";
            when "0111"=> control_word <= "1101111110011";
            when "1000"=> control_word <= "1101110010011";
            when "1001"=> control_word <= "1011000010011";
            when "1010"=> control_word <= "1101110010011";
            when "1011"=> control_word <= "1111110010110";
            when "1100"=> control_word <= "1011000011001";
            when "1101"=> control_word <= "1101110011001";
            when "1110"=> case(FUNC (1 downto 0)) is 
                              when "00" => control_word <= "1111100010011";
                              when "01" => control_word <= "1111100110011";
                              when "10" => control_word <= "1111101010011";
                              when "11" => control_word <= "1111101110011";
                              when others => control_word <= (others=>'0');
                          end case;
            when others => control_word <= (others=>'0');
       end case;
    end process;

--WF1 <= control_word(0);
--S3 <= control_word(1);
--WM <= control_word(2); 
--RM <= control_word(3);
--EN3 <= control_word(4);
--ALU2 <= control_word(5);
--ALU1 <= control_word(6);
--S2 <= control_word(7);
--S1 <= control_word(8);
--EN2 <= control_word(9);
--RF2 <= control_word(10);
--RF1 <= control_word(11);
--EN1 <= control_word(12);

end Behavioral;
