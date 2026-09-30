
-------------------------------------------------------------------------
-- Design unit: Memory
-- Description: Parameterizable data and address bus
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all; 
use std.textio.all;
use IEEE.math_real.ceil;
use work.Util_pkg.all;


entity Memory is
    generic (
        SIZE            : integer   := 100;    -- Memory depth
        imageFileName   : string    := "UNUSED"; -- Memory content to be loaded
        DATA_WIDTH      : integer   := 8;
        ADDR_WIDTH      : integer   := 8
    );
    port (  
        clock           : in std_logic;
        wr              : in std_logic;      -- Write enable
        write_address   : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
        read_address    : in std_logic_vector(ADDR_WIDTH - 1 downto 0); 
        data_i       : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        data_o          : out std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
end Memory;
