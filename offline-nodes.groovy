int offlineNodes = 0

println("------------------------------------------------------------\n");
println ("Checking for offline slaves ... \n");

for (slave in hudson.model.Hudson.instance.slaves) {
    if (slave.getComputer().isOffline().toString() == "true"){
        println(' - ' + slave.name + ' is offline!'); 
        offlineNodes++;
    }
}

if (offlineNodes > 0){
    println("\nThere are exactly " + offlineNodes + " offline nodes");
}
println("------------------------------------------------------------\n");
