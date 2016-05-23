# What is Syclops? #

 Syclops is a collabrative tool which allows us to access remote system ssh connection by using web browser. It has so many features such as

  - User management 
  - Connection management
  - Project management
  - Session playback
  - Activity logs
  - SSH-Key management

 In today IT world, sharing ssh-key is a big problem. For instance, you have two team in your office, one is developement and second is IT infrastructure. You have a web application which is running in AWS. The IT infrastructure team manages the server uptime, firewall, log management, networking and so on. The developement team will update latest code changes weekly once in that application. So both team might have ssh key. Here is the problem, how do you watch both team ssh connection activity???. The tradtional ssh server don't have ssh connection activitiy logging. so that we don't know who did connect with server and when did they connect and why did they connect?. We took this issue and disigned tool to fix the issue. What Syclops does is to kill sharing ssh key. It keeps the ssh-key and give access to server. It acts like intermediate ssh proxy. Syclops logs each user ssh connection activity and record each session. It has powerfull user management features so that we can give remote system access if it is any works on server. Otherwise we can revoke connection access to the remote system.

