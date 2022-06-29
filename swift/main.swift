type file;

# ------ INPUTS / OUTPUTS -------#

int nsim   = toInt(arg("nsim"));
int steps  = toInt(arg("steps"));
int range  = toInt(arg("range"));
int values = toInt(arg("values"));

file stats 			<arg("average")>;

file sim_script		<"simulate.sh">;
file stats_script	<"stats.sh">;


# ------- APP DEFINITIONS -------#

app (file o,file e) simulation (file sim_script, int sim_steps, int sim_range, int sim_values)
{
  bash filename(sim_script) "--timesteps" sim_steps "--range" sim_range "--nvalues" sim_values stdout=filename(o) stderr=filename(e);
}

app (file o) analyze (file stats_script, file s[])
{
  bash filename(stats_script) filenames(s) stdout=filename(o);
}


# ----- WORKFLOW ELEMENTS ------#

file sims[];

foreach i in [0:nsim-1] {
  file simout <strcat("output/sim_",i,".out")>;
  file simerr <strcat("output/sim_",i,".err")>;
  (simout,simerr) = simulation(sim_script,steps,range,values);
  sims[i] = simout;
}

stats = analyze(stats_script,sims);

