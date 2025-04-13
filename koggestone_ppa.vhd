library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity koggestone_ppa is
    Port (
        a     : in  std_logic_vector(63 downto 0);
        b     : in  std_logic_vector(63 downto 0);
        c_in  : in  std_logic;
        sum   : out std_logic_vector(63 downto 0);
        c_out : out std_logic
    );
end entity koggestone_ppa;

architecture structural of koggestone_ppa is
    component half_adder is
        Port (
            x, y : in  std_logic;
            p, g : out std_logic
        );
    end component half_adder;
    
    component full_carry_operator is
        Port (
            gl, pl, gh, ph : in  std_logic;
            go, po         : out std_logic
        );
    end component full_carry_operator;

    -- Internal individual g,p signals
    signal g_in : std_logic_vector(63 downto 0);
    signal p_in : std_logic_vector(63 downto 0);
    
    -- Stage 1 g,p outputs
    signal g_1 : std_logic_vector(63 downto 0);
    signal p_1 : std_logic_vector(63 downto 0);
    -- Stage 2 1 g,p outputs
    signal g_2 : std_logic_vector(63 downto 0);
    signal p_2 : std_logic_vector(63 downto 0);
    -- Stage 3 1 g,p outputs
    signal g_3 : std_logic_vector(63 downto 0);
    signal p_3 : std_logic_vector(63 downto 0);
    -- Stage 4 1 g,p outputs
    signal g_4 : std_logic_vector(63 downto 0);
    signal p_4 : std_logic_vector(63 downto 0);
    -- Stage 5 1 g,p outputs
    signal g_5 : std_logic_vector(63 downto 0);
    signal p_5 : std_logic_vector(63 downto 0);
    -- Stage 6 1 g,p outputs
    signal g_6 : std_logic_vector(63 downto 0);
    signal p_6 : std_logic_vector(63 downto 0);
    
    -- Internal carries
    signal c : std_logic_vector(63 downto 0);
    
begin
    -- g,p signal generators  
    generators: for i in 0 to 63 generate
        HA: half_adder port map (
            x => a(i), 
            y => b(i), 
            g => g_in(i), 
            p => p_in(i)
        );
    end generate generators;
            
    -- Stage 1 straight connections
    stage_1_connections: block
    begin
        g_1(0) <= g_in(0);
        p_1(0) <= p_in(0);
    end block stage_1_connections;
    
    -- Stage 1 carry operators
    stage_1_carryops: for i in 0 to 62 generate
        FCO: full_carry_operator port map (
            gl => g_in(i), 
            pl => p_in(i), 
            gh => g_in(i+1), 
            ph => p_in(i+1), 
            go => g_1(i+1), 
            po => p_1(i+1)
        );
    end generate stage_1_carryops;    
            
    -- Stage 2 straight connections
    stage_2_connections: for i in 0 to 1 generate
        g_2(i) <= g_1(i);
        p_2(i) <= p_1(i);
    end generate stage_2_connections;
    
    -- Stage 2 carry operators
    stage_2_carryops: for i in 0 to 61 generate
        FCO: full_carry_operator port map (
            gl => g_1(i), 
            pl => p_1(i), 
            gh => g_1(i+2), 
            ph => p_1(i+2), 
            go => g_2(i+2), 
            po => p_2(i+2)
        );
    end generate stage_2_carryops;
            
    -- Stage 3 straight connections
    stage_3_connections: for i in 0 to 3 generate
        g_3(i) <= g_2(i);
        p_3(i) <= p_2(i);
    end generate stage_3_connections;
    
    -- Stage 3 carry operators
    stage_3_carryops: for i in 0 to 59 generate
        FCO: full_carry_operator port map (
            gl => g_2(i), 
            pl => p_2(i), 
            gh => g_2(i+4), 
            ph => p_2(i+4), 
            go => g_3(i+4), 
            po => p_3(i+4)
        );
    end generate stage_3_carryops;

    -- Stage 4 straight connections
    stage_4_connections: for i in 0 to 7 generate
        g_4(i) <= g_3(i);
        p_4(i) <= p_3(i);
    end generate stage_4_connections;
    
    -- Stage 4 carry operators
    stage_4_carryops: for i in 0 to 55 generate
        FCO: full_carry_operator port map (
            gl => g_3(i), 
            pl => p_3(i), 
            gh => g_3(i+8), 
            ph => p_3(i+8), 
            go => g_4(i+8), 
            po => p_4(i+8)
        );
    end generate stage_4_carryops;
            
    -- Stage 5 straight connections
    stage_5_connections: for i in 0 to 15 generate
        g_5(i) <= g_4(i);
        p_5(i) <= p_4(i);
    end generate stage_5_connections;
    
    -- Stage 5 carry operators
    stage_5_carryops: for i in 0 to 47 generate
        FCO: full_carry_operator port map (
            gl => g_4(i), 
            pl => p_4(i), 
            gh => g_4(i+16), 
            ph => p_4(i+16), 
            go => g_5(i+16), 
            po => p_5(i+16)
        );
    end generate stage_5_carryops;
            
    -- Stage 6 straight connections
    stage_6_connections: for i in 0 to 31 generate
        g_6(i) <= g_5(i);
        p_6(i) <= p_5(i);
    end generate stage_6_connections;
    
    -- Stage 6 carry operators
    stage_6_carryops: for i in 0 to 31 generate
        FCO: full_carry_operator port map (
            gl => g_5(i), 
            pl => p_5(i), 
            gh => g_5(i+32), 
            ph => p_5(i+32), 
            go => g_6(i+32), 
            po => p_6(i+32)
        );
    end generate stage_6_carryops;
            
    -- Final carry generators
    carry_generators: for i in 0 to 63 generate
        c(i) <= g_6(i) OR (c_in and p_6(i)) after 2 ns;
    end generate carry_generators;
    
    c_out <= c(63);
    -- Final sum generators
    sum(0) <= c_in XOR p_in(0) after 1 ns;
    
    sum_generators: for i in 1 to 63 generate
        sum(i) <= c(i-1) XOR p_in(i) after 1 ns;
    end generate sum_generators;
    
end architecture structural;