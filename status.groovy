thisInstance = jenkins.model.Jenkins.instance
def jobs = thisInstance.items

def queued = new ArrayList()
def building = new ArrayList()

for (int i=0; i<jobs.size(); i++) {
    if (jobs[i].isBuildable() && jobs[i].isBuilding()) {
        building.add(jobs[i].name)
    } else if (jobs[i].isBuildable() && jobs[i].isInQueue()) {
        queued.add(jobs[i].name)
    }
}

if (building.size() > 0 || queued.size() > 0) {
    println("WAIT_MORE")
    println("Jobs queued: " + queued.size())
    for (int i = 0; i < queued.size(); i++)
        println (" #" + (i+1) + ". " + queued[i])
    println("Jobs building: " + building.size())
    for (int i = 0; i < building.size(); i++)
        println (" #" + (i+1) + ". " + building[i])
} else {
    println("SHUTDOWN")
}
