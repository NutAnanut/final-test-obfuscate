#!/bin/sh
file="obfuscator.js"
echo "const getAllFilesSync = require('get-all-files') 
const initialPath = './'
obfuscate(initialPath)

function obfuscate(initialPath){
    const fs = require('fs')
    const JavaScriptObfuscator = require('javascript-obfuscator');  
    for (const filename of getAllFilesSync.getAllFilesSync(initialPath)) {
        if(!filename.includes('node_modules')&&filename.includes('.js')){
            if(!filename.includes('.json')&&!filename.includes('obfuscator')){
                fs.readFile(filename,'utf-8',function(err,data){
                    if (err){
                        throw err;
                    }
                    const obfuscationResult = JavaScriptObfuscator.obfuscate(data,{
                        compact: true,
                        controlFlowFlattening: true,
                        controlFlowFlatteningThreshold: 1,
                        deadCodeInjection: true,
                        deadCodeInjectionThreshold: 1,
                        debugProtection: true,
                        debugProtectionInterval: 0,
                        disableConsoleOutput: true,
                        identifierNamesGenerator: 'hexadecimal',
                        log: false,
                        numbersToExpressions: true,
                        renameGlobals: true,
                        selfDefending: true,
                        simplify: false,
                        splitStrings: true,
                        stringArray: true,
                        stringArrayCallsTransform: true,
                        stringArrayEncoding: [],
                        stringArrayIndexShift: true,
                        stringArrayRotate: true,
                        stringArrayShuffle: true,
                        stringArrayWrappersCount: 1,
                        stringArrayWrappersChainedCalls: true,
                        stringArrayWrappersType: 'variable',
                        unicodeEscapeSequence: true
                    });
                    fs.writeFile(filename,obfuscationResult.getObfuscatedCode(),function(err){
                        if(err){
                            throw console.log(err);
                        }else{
                            console.log("Obfuscate => "+filename+" success.")
                        }
                    })
                })
            }
        }
    }
   
}" > $file
echo "Create obfuscator.js file success"


#get branch name from input to create a new branch
read -p  "Please enter new branch name: " inputBranchName
if [ -z "$inputBranchName" ]
then 
    branchName='obfuscate-code-for-production'
else
    branchName=$inputBranchName 
    string=$inputBranchName 
    for reqsubstr in ' ';
    do
        if [ -z "${string##*$reqsubstr*}" ] ;
        then
            branchName='obfuscate-code-for-production'
            break
        fi
    done
fi

git checkout -b $branchName
git push origin $branchName
echo "Check out to branch $branchName success"

#install javascript obfuscator and get-all-files library
npm install --save-dev javascript-obfuscator
npm i get-all-files
echo "install library success"

#run script to obfuscate code
node obfuscator.js
echo "obfuscate code success"

#remove package
npm uninstall -d javascript-obfuscator
npm uninstall -d get-all-files  

#delete obfuscator file
rm -f obfuscator.js
echo "remove library and delete obfuscator.js success"
#push git in new branch
git add .
git commit -m "Obfuscated code"
git push origin $branchName
echo "push git to new branch success"

echo "=============================="
echo "obfuscate code done."