library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity BitEncoder is
    generic (
        DIMENSIONS  : integer := 8192;
        THRESHOLD   : integer := 0   
    );
    port ( 
        clk         : in std_logic;
        rst         : in std_logic;
        idx         : in std_logic_vector (15 downto 0);
        data        : in std_logic_vector (7 downto 0);
        x           : in std_logic_vector (5 downto 0);
        y           : in std_logic_vector (5 downto 0);
        data_av     : in std_logic;
        b           : out std_logic
    );
end BitEncoder;

architecture Behavioral of BitEncoder is

    signal hv_bit_f, hv_bit_x, hv_bit_y : std_logic;
    signal bind_fxy : std_logic;
    
    signal idx_f, idx_x, idx_y : SIGNED (15 downto 0);
    signal temp_idx_f, temp_idx_x, temp_idx_y : SIGNED (15 downto 0);
    
    signal count: UNSIGNED(9 downto 0);

begin
   
    -- Emulate roll right acording to 'data'
    temp_idx_f <= SIGNED(idx) - SIGNED('0' & data);
    
    -- Emulate roll right acording to 'x'
    temp_idx_x <= SIGNED(idx) - SIGNED(x);
    
    -- Emulate roll right acording to 'y'
    temp_idx_y <= SIGNED(idx) - SIGNED(y);
    
    D_NOT_8192: if DIMENSIONS /= 8192 generate        
        idx_f <= temp_idx_f when temp_idx_f >= 0 else temp_idx_f + TO_SIGNED(DIMENSIONS, temp_idx_f'length);
        idx_x <= temp_idx_x when temp_idx_x >= 0 else temp_idx_x + TO_SIGNED(DIMENSIONS, temp_idx_x'length);
        idx_y <= temp_idx_y when temp_idx_y >= 0 else temp_idx_y + TO_SIGNED(DIMENSIONS, temp_idx_y'length);
    end generate;    
    
    -- DIMENSIONS = 8192 is a power of 2 value
    -- 2 ** 13 = 8192
    D_8192: if DIMENSIONS = 8192 generate 
        idx_f <= "000" & temp_idx_f(12 downto 0);   -- Exploring wrap-around to find the reight index         
        idx_x <= "000" & temp_idx_x(12 downto 0);   -- Exploring wrap-around to find the reight index 
        idx_y <= "000" & temp_idx_y(12 downto 0);   -- Exploring wrap-around to find the reight index 
    end generate;
   
   
    BASE_HV_F: entity work.HVBits(MNIST_seed1) port map(
        t   => STD_LOGIC_VECTOR(idx_f),
        o   => hv_bit_f
    );
    
    BASE_HV_X: entity work.HVBits(MNIST_seed2) port map(
        t   => STD_LOGIC_VECTOR(idx_x),
        o   => hv_bit_x
    );
    
    BASE_HV_Y: entity work.HVBits(MNIST_seed3) port map(
        t   => STD_LOGIC_VECTOR(idx_y),
        o   => hv_bit_y
    );
    
    bind_fxy <= hv_bit_f xor hv_bit_x xor hv_bit_y;    
    
    process(clk, rst)
    begin
        if rst = '1' then
            count <= (others=>'0');
            
        elsif rising_edge(clk) then
            if data_av = '1' then
                count <= count + unsigned'("" & bind_fxy);
            end if;          
        end if;
    end process;
    
    b <= '1' when count > THRESHOLD else '0';
    


end Behavioral;
