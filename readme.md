# VoterAid

*Stop voter intimidation at the source.*

## What it does

**VoterAid** is a technology solution designed to address the threat of voter intimidation. We aim to accomplish the following:

- Register On-The-Ground Responders for Election Day
- Inform voters of their rights
- Report potential instances of voter suppression
- Respond to instances of voter suppression immediately
- Analyze reported incidents to influence policy

## Our Wishlist

Keep an eye out on the list of extra stuff we want to add here. You can see them on our [Projects Board](https://github.com/Voter-Aid/voteraid/projects/2).

## The Brains



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
