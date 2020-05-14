----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.05.2020 09:23:31
-- Design Name: 
-- Module Name: uPLUT - Behavioral
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

entity uPLUT is
 port (
      control_word: out std_logic_vector(12 downto 0);
      -- INPUTS
      OPCODE : in  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
      FUNC   : in  std_logic_vector(FUNC_SIZE - 1 downto 0));                  -- Active Low
end uPLUT;

architecture Behavioral of uPLUT is

begin
Lookup_table:
    process(OPCODE, FUNC)
    begin
       case (OPCODE) is 

            --ADDI1 R1,R2,INP1
            when "000000"=> control_word <= "1010000000000";
            when "000001"=> control_word <= "0001000000000";
            when "000010"=> control_word <= "0000000010011";

            --SUBI1 R1,R2,INP1
            when "000100"=> control_word <= "1010000000000";
            when "000101"=> control_word <= "0001000100000";
            when "000110"=> control_word <= "0000000010011";
            
            --ANDI1 R1,R2,INP1 
            when "001000"=> control_word <= "1010000000000";
            when "001001"=> control_word <= "0001001000000";
            when "001010"=> control_word <= "0000000010011";
            
            --ORI1 R1,R2,INP1
            when "001100"=> control_word <= "1010000000000";
            when "001101"=> control_word <= "0001001100000";
            when "001110"=> control_word <= "0000000010011";
            
            --ADDI2 R1,R2,INP2 
            when "010000"=> control_word <= "1100000000000";
            when "010001"=> control_word <= "0001110000000";
            when "010010"=> control_word <= "0000000010011";

			--SUBI2 R1,R2,INP2 
            when "010100"=> control_word <= "1100000000000";
            when "010101"=> control_word <= "0001110100000";
            when "010110"=> control_word <= "0000000010011";

            --ANDI2 R1,R2,INP2 
            when "011000"=> control_word <= "1100000000000";
            when "011001"=> control_word <= "0001111000000";
            when "011010"=> control_word <= "0000000010011";
            
            --ORI2 R1,R2,INP2 
            when "011100"=> control_word <= "1100000000000";
            when "011101"=> control_word <= "0001111100000";
            when "011110"=> control_word <= "0000000010011";
            
            --MOV R1,R2
            when "100000"=> control_word <= "1100000000000";
            when "100001"=> control_word <= "0001110000000";
            when "100010"=> control_word <= "0000000010011";
            
            --S_REG1 R2,INP1 
            when "100100"=> control_word <= "1010000000000";
            when "100101"=> control_word <= "0001000000000";
            when "100110"=> control_word <= "0000000010011";
            
            --S_REG2 R2,INP2 
            when "101000"=> control_word <= "1100000000000";
            when "101001"=> control_word <= "0001110000000";
            when "101010"=> control_word <= "0000000010011";
            
            --S_MEM2 R1,R2,INP2 
            when "101100"=> control_word <= "1110000000000";
            when "101101"=> control_word <= "0001110000000";
            when "101110"=> control_word <= "0000000010110";
            
            --L_MEM1 R1,R2,INP1 
            when "110000"=> control_word <= "1010000000000";
            when "110001"=> control_word <= "0001000000000";
            when "110010"=> control_word <= "0000000011001";
            
            --L_MEM2 R1,R2,INP2 
            when "110100"=> control_word <= "1100000000000";
            when "110101"=> control_word <= "0001110000000";
            when "110110"=> control_word <= "0000000011001";
            
            
            when "111000"=> case(FUNC (1 downto 0)) is 
                              when "00" => control_word <= "1110000000000";--ADD R1,R2,R3
                              when "01" => control_word <= "1110000000000";--SUB R1,R2,R3
                              when "10" => control_word <= "1110000000000";--AND R1,R2,R3
                              when "11" => control_word <= "1110000000000";--OR  R1,R2,R3
                              when others => control_word <= (others=>'0');
                          end case;
            when "111001"=> case(FUNC (1 downto 0)) is 
                              when "00" => control_word <= "0001100000000";--ADD R1,R2,R3
                              when "01" => control_word <= "0001100100000";--SUB R1,R2,R3
                              when "10" => control_word <= "0001101000000";--AND R1,R2,R3
                              when "11" => control_word <= "0001101100000";--OR  R1,R2,R3
                              when others => control_word <= (others=>'0');
                          end case;
            when "111010"=> case(FUNC (1 downto 0)) is 
                              when "00" => control_word <= "0000000010011";--ADD R1,R2,R3
                              when "01" => control_word <= "0000000010011";--SUB R1,R2,R3
                              when "10" => control_word <= "0000000010011";--AND R1,R2,R3
                              when "11" => control_word <= "0000000010011";--OR  R1,R2,R3
                              when others => control_word <= (others=>'0');
                          end case;
            when others => control_word <= (others=>'0');
       end case;
    end process;
end Behavioral;
