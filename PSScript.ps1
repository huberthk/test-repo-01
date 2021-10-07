git config --global --list

git config --global user.name "Hubert Kudyba"
git config --global user.email huberthk@hotmail.co.uk

git config --list --show-origin
gi config --list

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

