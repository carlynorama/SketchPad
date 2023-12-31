# Repo Setup Meta

## New Project SetUp

done 2023-07-11

        ```zsh
        mkdir $NAME
        cd $NAME
        git init
        git branch -M main
        touch README.md
        swift package init --type executable
        touch .gitattributes
        #touch .env #<- not used every repo
        swift run
        ## Update .gitignore and .gitattributes
        git add .

        git commit -m "hello project"
        ## Options for making a remote:
        ## https://cli.github.com/manual/gh_repo_create  (brew install gh)
        #gh repo create $NAME --public
        #git remote add origin $REPO_URL  ## <- links an existing repo to git
        #git remote -v #checks to see if it worked
        ## Potential GOTCHAs - https://docs.github.com/en/authentication/troubleshooting-ssh/error-permission-denied-publickey#make-sure-you-have-a-key-that-is-being-used
        git push -u origin main
        ```

#### .gitignore

```
# ------ generated by package init.
.DS_Store
/.build
/Packages
/*.xcodeproj
xcuserdata/
DerivedData/
.swiftpm/config/registries.json
.swiftpm/xcode/package.xcworkspace/contents.xcworkspacedata
.netrc

## ----------- added

# VSCode
.vscode

# Secrets & Environment
.env

# Swift additional
Package.resolved

# Python
__pycache__/
*.py[cod]
*$py.class
```

#### .gitattributes

```
# Auto detect text files and perform LF normalization
* text=auto
```

## References

- https://github.com/apple/swift-package-manager/blob/main/Documentation/PackageDescription.md