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

3. Install and start postgres
```
    brew install postgresql
    brew services start postgresql
```

4. Clone and change into the application directory
```
    git clone [REPO_URL]
    cd voteraid
```

5. Install dependencies
`bundle install`

6. Create and migrate app database
```
    rails db:create
    rails db:migrate
```

7. Run!
`rails s`
