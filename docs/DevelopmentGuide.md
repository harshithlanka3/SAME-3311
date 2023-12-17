# Setting up GitHub
## Cloning Repository
you can clone the repository into any directory by simply doing:
`git clone https://github.com/harshithlanka3/S.A.M.E.git`
Currently, the repo has a backend, docs, and frontend directory. 

## Contributing to the Repository
Lets try creating a file called test.txt and pushing those changes to the main branch. We get the following error:
<img width="1222" alt="Screenshot 2023-12-17 at 11 52 07" src="https://github.com/harshithlanka3/S.A.M.E/assets/98058276/41f635db-e63f-4ee2-a7c5-977501706b3d">


This error occurs because github has changes its policy such that you now need to create your own access token to be able to push changes to a given repository. We can do this by doing the following:

Go to the main github page and click on your profile on the top right. A sidebar will appear on the right that will look something like this:
<img width="1434" alt="Screenshot 2023-12-17 at 11 54 07" src="https://github.com/harshithlanka3/S.A.M.E/assets/98058276/567efef0-1dbb-413f-bd5e-48a9979a5e0f">


From there, click on settings and scroll all the way down until you see the developer settings button on the left sidebar:
<img width="385" alt="Screenshot 2023-12-17 at 11 55 19" src="https://github.com/harshithlanka3/S.A.M.E/assets/98058276/be03f08f-3761-44b2-acc0-33517fc0954c">


Click on that button which will take you to a page that looks like this:
<img width="1266" alt="Screenshot 2023-12-17 at 11 55 52" src="https://github.com/harshithlanka3/S.A.M.E/assets/98058276/9854cdf3-4e70-49c9-927d-8763b72d4842">


Click on personal access tokens and click on `Tokens (classic)` at which point your page should look like this:
<img width="1207" alt="Screenshot 2023-12-17 at 11 56 35" src="https://github.com/harshithlanka3/S.A.M.E/assets/98058276/20b001eb-2c6e-4078-8caa-29b88eadae5f">


From there click on generate new token and in the drop down click on Generate new token (classic):
<img width="314" alt="Screenshot 2023-12-17 at 11 57 27" src="https://github.com/harshithlanka3/S.A.M.E/assets/98058276/7c2b41e7-8ad7-409c-ac8c-a9233933ed4e">


From there click on whichever permissions you think you will need and set whatever expiration date you need. Once your token is created make sure to note down your token somewhere as you won't be able to see it ever again. We will use this token as our password instead to push changes onto any repository we want.


Now, lets go back to the example of pushing the test.txt file onto the repo.
Now I put in my username as usual and put the token in (you can paste the token directly) instead of the password to get a successul push
<img width="1220" alt="Screenshot 2023-12-17 at 12 00 38" src="https://github.com/harshithlanka3/S.A.M.E/assets/98058276/33b03cdf-77af-4b31-a340-d8b72f892c54">




# MongoDB

For now, we are using MongoDB's Atlas platform to host our database. As such, I have created a generic username and password. This means that wherever we want to connect to the database in the backend, we will have a variable called `uri` which is usually equal to something along the lines of `process.env.MONGODB_URI;`

This means in your local copy of the repo in the backend directory you have to create a file called `.env` and put in the following line:
<img width="1440" alt="Screenshot 2023-12-17 at 12 26 21" src="https://github.com/harshithlanka3/S.A.M.E/assets/98058276/6a23e3ae-0ee6-4a4a-be18-2c1221fadce0">
As I have setup the .gitignore to ignore .env files you can put sensitive data such as your personal MongoDB atlas username and password URI without pushing that information to the repo for everyone else to see.




# Backend

For the backend we are using Node.js and some packages like express, mongoose, and dotenv. We are bound to use other packages in the future as well so keep that in mind. To install all the packages we are currently using cd to the our backend directory. Once you are there run the following command: `npm install`. This will automatically install all the packages specified in package-lock.json with the exact versions specified. Once that is done you can make whatever changes you want to the backend. The current structure of the backend is clear with models, controllers, and routes with everything being collated together in app.js. In its current state, if you want to run the server locally you can just do `node app.js` and the server is now running locally on `http://localhost:3000/`. The terminal should also output ```Server is running on port 3000
Connected to MongoDB Cloud```
Showing that it has successfully connected to MongoDB atlas. 


# Frontend

Make sure that flutter is installed and run `flutter doctor` to ensure everything is installed as it should be. From there, you can just do flutter run in the frontend/s_a_m_e directory or if you are using visual studio code (You should its infinitely better) then you can just go to the main.dart file under the lib directory, make sure your simulator for iPhone or android is running, and click on run on the top right. If the backend server is running, the frontend should be able to access the server locally and pull symptoms and a bunch of other stuff that way as well. In all honesty, our understanding of flutter right now is very low and I highly recommend everyone learn it as much as possible. 
