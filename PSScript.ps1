git config --global --list

git config --global user.name "Hubert Kudyba"
git config --global user.email huberthk@hotmail.co.uk

git config --list --show-origin
git config --list

#many more other settings https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
git config --global init.defaultBranch main #this is very common to use instead of master

code .\testfile.txt

git add .

git status
git diff --cached #Difference between staged and waht is commited
git commit -m "Initial testfile.txt commit"
#We have two new objects created!

#Note Could combine the add and commit
git commit -am "Initial testfile.txt commit"
#or even
git commit -a -m "Initial testfile.txt commit"

#Look at the full commit.
git log

#look at the type
git cat-file -t <first 7 of the hash shown for the commit>
#look at the content
git cat-file -p <first 7 of the hash shown for the commit>

#look at the type
git cat-file -t <first 5 (to show just needs to be unique) of the hash shown for the tree in commit file>

#look at the content. Notice here it points the blob we saw created before and now has a file name
git cat-file -p <first 5 of the hash shown for the tree in commit file>

#look at the type
git cat-file -t <first 5 of the hash shown for the blog in tree file>

#look at the content. Notice here it points the blob we saw created before and now has a file name
git cat-file -p <first 5 of the hash shown for the blob in tree file>

#lets prove a point about in only storing unique content
Copy-Item .\testfile.txt .\testfile2.txt
git add .

#what new object do we have? Nothing.
git status
git commit -m "testfile2.txt added"
#we have new files. Look again

git log --oneline --graph --decorate --all #I will be using this a lot
git cat-file -p <new commit> #Note it references the parent coomit hash, again, can't change history as hash would not match

#I'm going to go ahead and create a function for my nice git log command. This may vry based on your CLI

function gitgraph {git log --oneline --graph --decorate --all}
#could add this to your profile
code $profile

#Note when you create a new repo you can override the default initial branch
git init --initial-branch=main
git init -b main

#WB06
#Modify a file and stage
code .\testfile.txt
git add testfile.txt
git status
#add a 3rd file but don't stage
code .\testfile3.txt
git status

git commit -m "updated testfile.txt"
git status

git log -p #also shows the diff/patch between the commits :q

gitgraph
git diff <commit>..<commit>
#remember the complete snapshot is stored. All diffs are generated at time of command execution

#WB07
git status
git add .\testfile3.txt
code testfile.txt #make change
git status
#between what is staged and the HEAD commit (i.e. the REPO). Could also use --staged which is synonym of --cached
git diff --cached
#And what is working to staged
git diff
#Between working and the last commit (i.e. HEAD)
git diff HEAD #Basically the sum of teh above two

#To remove contect WB08
#stage the removal (which will also delete from working)
git rm <file>
#it only stage the remove ()
git rm --cached <file>
#could also just delete from working then "add" all changes
git add .

#then you need to commit as normal
git commit -m "Removed file x"


#Example
code testfile4.txt
git add testfile4.txt
git commit -m "added testfile4.txt"
git status
git rm testfile4.txt
git status #note delete is staged"
ls #it's gone from stage AND my working
git commit -m "removed testfile4.txt"

#Resetting WB09
#remove all staged content. This is actually using --mixed which is default.
git reset
#it does this by setting staged to match the last commit
#it does NOT change your working dir
git reset --hard
#would also change your working dir to match!

#Can reset individual files
code testfile.txt
git add testfile.txt
git status
#Restore version is staged (from last commit HEAD) but NOT working
git restore --staged testfile.txt
git status
#restore working from stage
git restore testfile.txt
git status
code testfile.txt
#restore to stage and working from last commit
git restore --staged -worktree testfile.txt
#Full version but not required is to say from where by this is default anyway but could specify different
git restore --source=HEAD --staged --worktree testfile.txt

#Branches WB10
#What if you want to undo Commit
git log
gitpraph

#A branch is just a pointer to a commit which points to its parent
#we can just move the pointer backwards!
#move back 1 but do not change staging or working. Could go back 2, 3 etc ~2, ~3
git reset HEAD~1 --soft
gitpraph
#notice we have moved back but did not change staging or working
git status
#so staging still has the change that was part ofthe last commit that is no longer referenced

#could also reset by a specific commit ID
git reset <first x characters of commit> --soft

#to also reset staging. note as I'm not specifying a commit its resetting working to the current commit which I've rolled back already
#--mixed is actually the default, i.e. same as git reset which we did before to reset staging!
git reset --mixed
git status

#Now to also reset working. again since no commit specified its just setting to match current commit. this should look familiar!
#--hard changes staging and working
git reset --hard
git status

#could do all in one go
gitgraph
git reset HEAD~1 --hard
gitgraph
git status
#all clean since --hard reset all levels back

#the now unreferenced commit will eventually be garbage collected

#TAGS WB11
gitgraph
#remember commits just form a chain as they point to their parent.
#notice I'm using HEAD which just points to a reference which points to a commit!
git cat-file -t HEAD
git cat-file -p HEAD

#i CAN CREATE A TAG AT THE CURRENT LOCATION
git tag v1.0.0
gitgraph
git tag v0.9.1 <previous commit> # or git tag v0.9.0 HEAD~2
gitgraph
git tag --list

#lets look at a commit that is tagged. show gives information about an object. for a commit the log message and diff
git show v1.0.0
#we just see commit object

#these are lightweight tags. there is also an annotated type which is a full object with its own message
git tag -a v0.0.1 9ff57e6 -m "first version"
git show v0.0.1
#we see the tag information and then the commit it references
git cat-file -t v0.0.1
git cat-file -t v1.0.0

#note tags have to be pushed to a remote origin for them to be visible there.
git push --tag

#WB12
#Remote origin Part 1
cd $devopsmc
git remote -v

cd $scratch\test-repo-01
git remote -v

#Create an empty repo on GitHub under your account called test-repo-02
#it has help about next steps

#Add it as the remote origin. Origin is just a name but common standard
git remote add origin https://github.com/huberthk/test-repo-01
git remote -v
gitgraph

#push to the remote referenced as origin
git push -u origin main
#look at it on github. All there. Except tags
git push --tag

#Make a change in GitHub
gitgraph
git status

#Pull down remote origin
git pull
#Can specify where to pull from and branch
git pull origin main
#pull from all remotes
git pull --all
#it pulled down the changes and MERGED with a fast-forward. Remember that
git status
gitgraph

#git pull actually is doing two things
#to just get remote content
git fetch
#can be explicit
git fetch origin main 

git cat-file -p origin/main
#content is now on our box, just not merged
gitgraph
git status
#we can see its just ahead as a direct child of our commit so a straight line to it
git merge
#fast forward again
gitgraph

#WB14
#Likewise if we change locally we need to push to the remote
#As a best practice pull first (fetch and merge) to ensure all clean
git pull
#make a change
code .\testfile.txt
git commit -am "updated testfile.txt"
git status 
gitgraph
git push
#git push --tags

#gitignore
code .gitignore #add *.log /debug/*
git add .
git commit -m "added ignore file"
git push
git status
code test.log
code debug\file.txt
ls
git status 

#Branches!
#start fresh
cd ..
mkdir JLRepo
cd JLRepo
git init
git status 
#we see main which remember just references a commit (that won't exist yet)

code jl.csv
git add jl.csv
git commit -m "Initial JL roster CSV"
#wb15blac (down)
#view all branches
git branch --list
#view remotes
git branch -r
#view all (local and remote)
git branch -a

#WB15-orange
#create new branch pointing to where we are colled branch1
git branch branch1
gitgraph
#notice point to same commit at this time

#WB15-red
git branch --list
git checkout branch1
#or better move to new switch that is based around movement to separate commands
#switch only allows a branch to be specified. Checkout allows a commit hash (so could checkout a detached head)
git switch branch1
git branch --list
gitgraph
#when we switch it also updates the staging and working dir for the checked out branch

#to create and checkout in one step:
git checkout -c branch1

#to push a branch to a remote
#the -u sets up tracking between local and remote branch. allows argumentless git pull in future. will do later
git push -u <remote repo, e.g. origin> <branch name>

#check which branch we are on
git branch

#WB16
#make change to jl.csv adding Diana
code .\jl.csv
git add -p
#yep the above shows the actual changed chunks and can select parts! Now commit
git commit -m "Added Wonder Woman"
gitgraph
#Notice the branch is now ahead of main
#Make another change adding Barry
code .\jl.csv
git add .
git commit -m "Added Barry"
gitgraph
git status
#all clean

git switch main
type .\jl.csv
git status
git switch branch1
type jl.csv
git status
#Notice as I switch it does that update of not only the branch but gets the stage and working dir to same state

gitgraph
#the branch1 is now 2 ahead but its a straight line from main

#WB16b
#Now we want to merge the changes into main
#make sure evertying clean
git status
#move to main
git switch main
#we can look at the differences
git diff main..branch1
#if happy let's merge them. remember we already switched to main. we are going to merge into this from branch1
git merge branch1
#done. Notice was a fast-forward. lets look at the merge branches
git branch --merged

gitgraph

#We no longer need branch1. Remember use tags if you want some long lived reference
#This would only delete locally
#remember to ALWAYS check it has been merged first before deleting
git branch --merged
git branch -d branch1
#to delete on a remote
git push origin --delete branch1

#You may not want fast-forward.maybe in the history you want to see it was a separate branch that got merged in
#I am now going to mess around with time. Remember a branch is nothing more than a pointer to a commit
#I can go backwards. in this case i'm going to move main BACK to before I made the last two changes
gitgraph
#Remember --hard also updates staging and working dir
git reset --hard HEAD~1
gitgraph
#the other two commits are still out there but nothing references them. they will eventually get cleaned up
#We can look and still see via the reference logs
git reflog

#Lets do it all again
#WB17
git branch branch1
git switch branch1
code .\jl.csv
git add .
git commit -m "Added the flash"
gitgraph
git status
#looks familiar and all clean

#this time specify NOT to perform a fast forward
git switch main
git diff main..branch1
git merge --no-ff branch1
git branch --merged

gitgraph
#notice the merge was a new commit

#We can still delete branch1 as its still merged
git branch --merged
git branch -d branch1
#History is kept there was a branch
gitgraph

#WD18
#lets make it more complicated
#rewind time again (only doing this so our view is simpler)
#Note using ^ instead of ~. this is because NOW main has two parents
#I'm saying go back to the first parent instead of ~ for number of generations
git reset --hard HEAD^1
gitgraph

#make the branch1 again with two commits
git branch branch1
git switch branch1
code .\jl.csv
git add .
git commit -m "added Wonder Woman"
code .\jl.csv
git add .
git commit -m "added the Flash"
gitgraph
git status

#switch to main
git switch main
code .\jl.csv
git add .
git commit -m "Added Cyborg"
gitgraph
#more interesting, there in now NOT a direct path from branch1 to main
git status
#we will have conflicts given the changes we made
git merge branch1
#we need to fix them by editing the file it tells us and conflicts have been marked
code .\jl.csv
#we are in conflict status:
git status
git add .
git commit -m "Merged with branch1"

gitgraph
#shows the 3-way merge is complete
#take a little screen shot of this and paste next to 3-way merge picture

git branch --merged
#could delete the branch now BUT I DON'T WANT TO
#git branch -d branch1
gitgraph

#there is another option. Rebase
#lets rewind before the merge by going back 1
git reset --hard HEAD~1
gitgraph

#WD19
#Need to be ON the branch we are performing the action on. we are rebasing branch1
git switch branch1
#check its clean
git status
#lets rebase off main
git rebase main
#we will get conflicts as it replays each of the changes so each time will need to address and continue
code .\jl.csv
git add .\jl.csv
git rebase --continue

gitgraph
#cleaner path. copy next to the rebase whiteboard to compare!

#if now merge would just be a fast forward since now a straight line from main and NOW 3-way merge
git status
git switch main
git merge branch1
#cleanup
git branch --merged
git branch -d branch1
#note if the remote master has changes you don't have and want to base on can git pull --rebase


#interactive changes
#change message of last commit
git commit --amend
gitgraph
#Add new files to staging but don't update the message
git commit --amend --no-edit
#these will all mean a new hash as we are changing history and commits are immutable!
#can modify in a interactive way
#lets go back 3 changes!
git rebase -i HEAD~3
#s to squash commits together, d to drop. many other options

#protect a branch in github
#WB20
#Create a new github repo
git remote add origin https://github.com/huberthk/jlrepo.git
git push -u origin main

#Now Clark in GitHub create a fork of the repo
#on clark's machine we could now clone OUR copy
git clone https://github.com/clarkthesuper/JLRepo.git
cd JLRepo
#Look at the remotes
git remote -v
#we may want to add John's as an origin so we could pull down any changes they may have occured
git remote add upstream https://github.com/huberthk/JLRepo.git
git remote -v
#now we have Clark's origin and John's upstream
#could pull from John, e.g.
git fetch upstream
function gitgraph{git log --oneline --graph --decorate --all}
gitgraph
git branch branch1
git switch branch1
code .\jl.csv
git add .
git commit -m "changed who the flash is"

#push the branch to our origin
git push -u origin branch1

#In Clarks repo can change to branch1 and uder contribute select Open pull request
#it shows the planned submit, i.e. to main on John's repo

#Now as John will see the pull request and can accept
#this is a nice status and shows no conflicts and I can accept
#note if there were problems I could reject, maybe I had moved main up so Clark would need to rebase and submit again
#Once confirmed will auto update on Clarks repo that is was merged and closed

#on john's machine
git pull
gitgraph

#At this point on Clark's repo would pull down from upstream, delete the branch
gitgraph
#knows nothing yet
git fetch upstream
git switch main
#merge in the changes from John's repo (upstream)
git merge upstream/main
gitgraph
#check we are merged and delete branch1
git branch --merged
git branch -d branch1
git status
#Update our copy of the repo in GitHub by pushing up to it
git push origin main
git status
#push to our copy then remove of branch1
git push origin --delete branch1

#aannnndddd done!


