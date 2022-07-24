	component PROBE_1 is
		port (
			source     : out std_logic_vector(0 downto 0);                    -- source
			probe      : in  std_logic_vector(0 downto 0) := (others => 'X'); -- probe
			source_clk : in  std_logic                    := 'X'              -- clk
		);
	end component PROBE_1;

	u0 : component PROBE_1
		port map (
			source     => CONNECTED_TO_source,     --    sources.source
			probe      => CONNECTED_TO_probe,      --     probes.probe
			source_clk => CONNECTED_TO_source_clk  -- source_clk.clk
		);

