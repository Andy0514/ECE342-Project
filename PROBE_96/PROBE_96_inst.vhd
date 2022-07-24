	component PROBE_96 is
		port (
			source     : out std_logic_vector(95 downto 0);        -- source
			source_clk : in  std_logic                     := 'X'  -- clk
		);
	end component PROBE_96;

	u0 : component PROBE_96
		port map (
			source     => CONNECTED_TO_source,     --    sources.source
			source_clk => CONNECTED_TO_source_clk  -- source_clk.clk
		);

