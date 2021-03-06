--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:42:22 10/10/2017
-- Design Name:   
-- Module Name:   C:/Git/AppleIISd/VHDL/AddressDecoder_Test.vhd
-- Project Name:  AppleIISd
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: AddressDecoder
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY AddressDecoder_old_Test IS
END AddressDecoder_old_Test;
 
ARCHITECTURE behavior OF AddressDecoder_old_Test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT AddressDecoder_old
    PORT(
         A8 : IN std_logic;
         A9 : IN std_logic;
         A10 : IN std_logic;
         B8 : OUT std_logic;
         B9 : OUT std_logic;
         B10 : OUT std_logic;
         RNW : IN  std_logic;
         CLK : IN std_logic;
         NDEV_SEL : IN  std_logic;
         NIO_SEL : IN  std_logic;
         NIO_STB : IN  std_logic;
         NOE : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(10 downto 8) := "101";
   signal RNW : std_logic := '1';
   signal NDEV_SEL : std_logic := '1';
   signal NIO_SEL : std_logic := '1';
   signal NIO_STB : std_logic := '1';
   signal NRESET : std_logic := '1';
   signal CLK : std_logic := '0';
   signal PHI0 : std_logic := '1';

 	--Outputs
   signal B : std_logic_vector(10 downto 8);
   signal DATA_EN : std_logic;
   signal NG : std_logic;
   signal NOE : std_logic;
   
   -- Clock period definitions
   constant CLK_period : time := 142 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AddressDecoder_old PORT MAP (
          A8 => A(8),
          A9 => A(9),
          A10 => A(10),
          B8 => B(8),
          B9 => B(9),
          B10 => B(10),
          RNW => RNW,
          CLK => CLK,
          NDEV_SEL => NDEV_SEL,
          NIO_SEL => NIO_SEL,
          NIO_STB => NIO_STB,
          NOE => NOE
        );
 
   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 
   PHI0_process :process(CLK)
   variable counter : integer range 0 to 7;
   begin
        if rising_edge(CLK) or falling_edge(CLK) then
            counter := counter + 1;
            if counter = 7 then
                PHI0 <= not PHI0;
                counter := 0;
            end if;
        end if;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state.
      wait for CLK_period * 10;
      NRESET <= '0';
      wait for CLK_period * 20;
      NRESET <= '1';
      wait for CLK_period * 10;

      -- insert stimulus here 
      -- CPLD access
      wait until rising_edge(PHI0);
      NDEV_SEL <= '0';
      wait until falling_edge(PHI0);
      NDEV_SEL <= '1';
      wait until rising_edge(PHI0);
      wait until rising_edge(PHI0);
      -- CnXX access
      NIO_SEL <= '0';
      wait until falling_edge(PHI0);
      NIO_SEL <= '1';
      wait until rising_edge(PHI0);
      wait until rising_edge(PHI0);
      -- C8xx access, selected
      NIO_STB <= '0';
      wait until falling_edge(PHI0);
      NIO_STB <= '1';
      wait until rising_edge(PHI0);
      wait until rising_edge(PHI0);
      -- CPLD access
      NDEV_SEL <= '0';
      wait until falling_edge(PHI0);
      NDEV_SEL <= '1';
      wait until rising_edge(PHI0);
      wait until rising_edge(PHI0);
      -- CFFF access
      A <= "111";
      NIO_STB <= '0';
      wait until falling_edge(PHI0);
      A <= "000";
      NIO_STB <= '1';
      wait until rising_edge(PHI0);
      wait until rising_edge(PHI0);
      -- C8xx access, unselected
      NIO_STB <= '0';
      wait until falling_edge(PHI0);
      NIO_STB <= '1';
      wait until rising_edge(PHI0);
      wait until rising_edge(PHI0);

      wait;
   end process;

END;
