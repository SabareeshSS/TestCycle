# Technical Architecture #

 ![alt text](/sshxy/sshxy-docs/raw/master/1_introduction/technical_architecture/syclops_technical_architecture.png)

 Syclops technical architecture is not so complicated. It is easy one. Anyone who know the LEMP workflow can easily understand this. We follow the same architecture which is being followed by LEMP but it is slightly different than LEMP. This document will help person who going to install and manage this Syclops stack. 

## Work flow ##

 As we mentioned before the Syclops is not a single system, It is a collabarative system. It has some subsystems. The each sub systems has one or more process. In this document, we are going to tell the each subsystem duties breifly. 

 First, We are going to see the subsystem is the Syclops UI. The Syclops UI consists of these system such 

 > * Drupal
 > * Nginx
 > * PHP5-FPM

 As We mentioned before that Drupal is a content management framework. We use the Drupal here to build the Syclops frontend and the Syclops business logics. Typically Drupal is three tier application, which means, It needs the Webserver, the Database server and FastCGI program inorder to work. It is being fully written by using PHP. The Drupal uses the Database server to store all user data, connection and session and grant. So that this sub system depends on the Syclops Data subsystem. Without the Syclops data subsystem, It will not work. The Syclops's user, project, connection, grants and session are being created by using this subsytems. The Syclops has own modules or extension to do following business logic such as user management, connection management and so on.

 We explained what nginx is and what it does in introduction section. Here we are going to see nginx duties in this subsystems. Nginx is mediator between user and drupal. It recieve the user request and pass to drupal. If user try to access the resource which is not in the system, It automatically ignores the requset. It also does some caching process so that number of requests can be reduced for Drupal. By doing this we can get more performance. This subsystems has two open ports such as 443 which is used for https and 80 which is used for http. you cant' see any other ports excepts these two.

 
 Now we are going to see the subsystem is the Syclops Data. This subsytem consists this system.

 > * Percona

 We know what percona is, Here I am going to tell percona usage in this subsystem. The percona is used to store all data which is used by the Syclops UI. It does not have any public port. If evil people or hacker try to access this system, they would not able to access this because it does have any open port. It is more secure than normal system. The Syclops UI subsystem only can access this. Because we only granted permission for that system. If the subsystem is shoutdown or crashed then other subsystem will not work because It is a backbone for all the Syclops subsystem.

 Last but not least, We are going to see the suubsystem is the Syclops Terminal. It consists these two system.

 > * GateOne 
 > * Playbackagent
 
 We discussed before about these tools in introduction section. Here, we are going to see each system usage in this section. The GateOne is used to make a ssh connection and make playback sessions. The Syclops has own plugin to intract the Syclops UI with the GateOne. The plugin controlls all request which is created from the Syclops UI subsystems. If user type exit command in Web terminal, It automatically creates session playback from the user session by using Playback agent. After finish the session playback construction. The playback agent will inform the status to the Syclops UI. The Syclops UI stores the session playback details of the logged in user.

## Syclops objects ##
 
 The Syclops system has two global object such as user and project. The each object has sub object. The below diagram shows the Syclops object hierachy. We are going to explain the each object details in a moment.

 > * User
 >  * Project creator
 >  * Project admin
 >  * Project member
 >
 > * Project
 > 	* Connection
 >  	* Grant
 >      	* Session

### User ###

You know that the Syclops is security tool. If you want to access the Syclops system, you have to have the account in it. In the Syclops, All the tasks and activities are being controlled by using user permission. The Syclops has great acl layer. By using this layer, All type of user permission is being created. The Syclops has four type of users that are mention below. The each user type has specific permission to access the Syclops project resource. If user does not have permission then, he would not access the project and sub objects.

> * Site admin
> * Project creator
> * Project admin
> * Project member

#### Site admin ####

 Site admin is a type of user who is the Administrator of the Syclops. Her task is to create and manage user and the Syclops extension so on. He has high privilege than other users.

#### Project creator ####

 It is a type of user who is going to create project and mange the project in the Syclops.

#### Project admin ####

 It is a type of user who has permission to manage the Project. He has a permission to give permission to access the connection for the Project member.

#### Project member ####

 It is a type of user who has member permission to access connection and grant. He is not able to modify any resource on the system.

### Project ###
 
  In the Syclops, The Project is a namespace. It has these objects connection, session and grant. The user who has the Project creator permission is only able to create this. User who does not have permission to access the project is not able to access the project and sub objects such as connection, grant and session so on.

#### Connection ####

  This object consists the SSH conection details such remote machine IP address, remote user name, remote machine ssh keys. All connection related task will be managed by using this object.

#### Grant #####
  
  This object consists user access permission of the connection. This object is being created by the Project admin. If user want to acces the connection inside the Project where user has membership, user must have grant permission to access the connection. The grant is also being created by the Project admin. By using this, The connection access permission is being controlled.

#### Session ####

  This object consists connection log and playback. Whenever user use the connection, the activities which are user doing on session are being recored and stored in this object. User who has the membership permission for the Project can see other user's connection activities.

