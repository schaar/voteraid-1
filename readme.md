# note: this repo is deprecated. all future work is taking place at https://github.com/Voter-Aid/voteraid

# VoterAid

*Stop voter intimidation before it starts.*

## Roadmap

![](https://cloud.githubusercontent.com/assets/3597934/21071690/99a72dc4-be5d-11e6-94bf-e93fbba36e02.JPG)


## Setup
1. Install ruby 2.3.0. Highly suggested that you do this using a version manager such as rbenv, with the example below
```
    brew install rbenv
    rbenv init
    rbenv install 2.3.0
    rbenv global 2.3.0
```

2. Install bundler, which is the package manager for ruby 
`gem install bundler`

3. Install database **TODO UPON DECIDING DB**

4. Clone and change directory into the application
```
    git clone [REPO_URL]
    cd voteraid
```

5. Install dependencies
`bundle install`

6. Run!
`rails s`
