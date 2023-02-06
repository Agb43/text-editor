#!/bin/bash

overall=true






 ####### OPENING STATEMNT INTRODUCING PERSON TO THE PROGRAM ###########

  echo "welcome to the interactive text editor, improved edition. Please provide the files that you would like to edit. Type them in the format /path/to/file with a space in between for multiple files. Be aware that this program does not support dynamic loading of files. Also please take extra care to make sure the file you entered does exist. Some files may require root access. It is therefore adviseable to run this program as root"
  echo ""
  read -r files
  mapfile -t EXISTENCECHECK < <( echo "$files" | tr ' ' '\n' )
    while true; do
      for existcheck in "${EXISTENCECHECK[@]}"; do
        if [[ ! -e "$existcheck" ]]; then
          echo "one or more of the files specified do not exist, please verify they have been typed correctly. Some files may require root access. In this case the script must be run with sudo -i"
          exit
        fi  
      break
      done
    break
    done

  
  
 ###### LISTS FILES AND USES TR TO MAKE THE OUTPUT MORE USER FRIENDLY TO READ. FILES ARE ALSO LOADED INTO AN ARRAY TO BE USED FOR BATCH OPERATIONS ##########
LISTOFILES=$(echo "$files" | tr ' ' '\n')
mapfile -t FILESTOEDIT < <(echo "$files" | tr ' ' '\n')
echo "here are the file you have decided to edit:"
echo ""
echo "$LISTOFILES"
echo ""


 ######## OVERALL MASTER LOOP #########
 
while $overall; do
  echo "please choose between single or batch mode: enter single or batch"
  echo ""
  read -r singleorbatch

          ############## SINGLE FILE MODE ENABLED BY SETTING FLAG. SINGLE IS SET TO TRUE ALLOWING FOR FUNCTIONAL WHILE TRUE LOOP WHICH GOVERNS SINGLE MODE OPERATIONS #########

      if [[ "$singleorbatch" == "single" ]]; then 
        single=true
          while $single; do
            echo ""
            echo "you have entered single mode, here is the list of files to edit once again, select a specific file to edit from the list in the format /path/to/file"
            echo ""
            echo "$LISTOFILES"
            read -r file
            echo ""
            echo "choose an operation, for example, to redact, simply type redacter. Inputting return will return will send you back to the previous menu whilst toggle will allow to switch to batch and vice versa"
            echo ""
            echo "1) redacter 2) word count 3) word finder 4) word counter 5) return 6) toggle"
            echo ""
            read -r input
             
  ########### THIS ALLOWS THE USER TO RETURN TO SELECTING A FILE IN SINGLE MODE BY TYPING RETURN, ALTERNAITVELY TYPING TOGGLE BREAKS OUT OF THE LOOP AND BY TO THE OVERALL GOVERNING LOOP ########## 

              if [[ "$input" == "toggle" ]]; then
                single=false
                batch=false
              fi
          done
              if [[ "$input" == "return" ]]; then
                continue       
              fi

    ########## REDACTER MODE ################

              if [[ "$input" == "redacter" ]]; then
                redact_another_word=true
                  while $redact_another_word; do
                    echo "here is a preview of the file"
                    echo ""
                    cat "$file"
                    echo ""
                    echo "what is the word you would like to redact. punctuation is also allowed"
                    echo ""
                    read -r rans1
                    echo "would you like to replace the redacted word with another word, otherwise the word will be replaced with REDACTED. simply press enter if you do not want a custom word. Punctuation is also allowed"
                    echo ""
                    read -r rans2
                      if [[ -z "$rans2" ]]; then
                        echo "here is what the file would look like"
                        echo ""
                        cat "$file" | sed -e "s/$rans1/REDACTED/g"
                        echo "please confirm your choice by typing y or n"
                        echo ""
                        read -r rans3 
                          if [[ "$rans3" == "y" ]]; then
                            sed -i "s/$rans1/REDACTED/g" "$file"
                            echo "would you like to redact another word. Answere y or n"
                            read -r rans4
                              if [[ "$rans4" == "y" ]]; then
                                continue 
                              else
                                redact_another_word=false
                              fi
                          fi
                      fi
                  
                      if [[ -n "$rans2" ]]; then
                        echo "here is what the file would look like"
                        echo ""
                        cat "$file" | sed -e "s/$rans1/$rans2/g"
                        echo "please confirm your choice"
                        read -r rans5          
                          if [[ "$rans5" == "y" ]]; then
                            sed -i "s/$rans1/$rans2/g" "file"
                            echo "would you like to redact another word, answer y or n"
                            read -r rans6
                              if [[ "$rans6" == "y" ]]; then
                                continue
                              else
                                redact_another_word=false
                              fi
                          fi
                      fi
                  
                  
                  done
              fi         
           
  ######### WORD COUNT FUNCTION ############

              if [[ "$input" == "word count" ]]; then
                words=$(cat "$file" | tr ' ' '\n' | wc -l)
                echo "there are $words in this doc"
              fi
                
 ########## INDIVIDUAL WORD COUNTER #####################

              if [[ "$input" == "word counter" ]]; then
                count_another_word=true
                  while $count_another_word; do
                    echo "please choose a word to count"
                    read -r wcinput
                    mapfile -t  WORDTOCOUNTARRAY < <(echo "$file" | sed -e "s/.//g" | tr ' ' '\n')
                    total_count=0
                      for wordtocountt in "${WORDTOCOUNTARRAY[@]}"; do
                        FINCOUNT=$(echo "$wordtocountt" | grep -o "$wcinput")
                          if [[ -n "$FINCOUNT" ]]; then
                            total_count=$(( "$total_count" +1 ))
                            echo "there are $total_count instances of this word in the doc"
                            echo "would you like to count another word (y/n)"
                            read -r wcinput3
                              if [[ "$wcinput3" == "y" ]]; then
                                continue 
                              else
                                count_another_word=false
                              fi
                          fi 
                      
                          if [[ -z "$FINCOUNT" ]]; then
                            echo "there no 0 counts of this word in this doc"
                            
                            echo "would you like to count another word"
                            read -r wcinput4
                              if [[ "$wcinput4" == "y" ]]; then
                                continue 
                              else
                                count_another_word=false
                              fi
                          fi                                            
                      done
                  done
              fi

   ########### WORD FINDER #####################

              if [[ "$input" == "word finder" ]]; then
                grep_another_word=true
                  while $grep_another_word; do
                    echo "please enter the word you would like to grep"
                    read -r gword
                    GREPPEDWORD=$(grep "$gword" "$file")
                      if [[ -n "$GREPPEDWORD" ]]; then
                        echo "the word was found in this document and here is its correpsonding line: $GREPPEDWORD"
                        echo "would you like to search for another word (y/n)"
                        read -r ginput1
                          if [[ "$ginput1" == "y" ]]; then
                            continue 
                          else
                            grep_another_word=false
                          fi
                      elif [[ -z "$GREPPEDWORD" ]]; then
                        echo "the word was not found in this document, would you like to search for another word (y/n)"
                        read -r ginput2
                          if [[ "$ginput2" == "n" ]]; then
                            grep_another_word=false
                          else
                            continue
                          fi
                      fi
                  done
              fi  


              

#----------------------------------------------------------------batch mode
      fi 

      if [[ "$singleorbatch" == "batch" ]]; then
        batch=true
          while $batch; do
            echo "you have entered batch mode, please choose from a list of operations, for example for the batch redacter function, simply type batch redacter. Toggle will allow you to switch between modes"
            
            echo "1) batch redacter 2) toggle 3) sha256 checksum generator 4) batch encrypt 5) uploader via scp 6) archiver"
            read -r btinput

              if [[ "$btinput" == "toggle" ]]; then
                  single=false
                  batch=false
              fi

             
  ###################### BATCH REDACTER ##############################
             
              if [[ "$btinput" == "batch redacter" ]]; then
                batch_redact_another_word=true
                  while $batch_redact_another_word; do
                    
                      for brfile4 in "${FILESTOEDIT[@]}"; do
                        echo "this is the contents of $brfile4:"
                        echo ""
                        cat "$brfile4"
                      done
                        
                        echo "here is a preview of the contents of the files as shown above"

                        echo "please choose a word to redact"
                        read -r brans1
                        echo "would you like a cutsom word, if so please type the word, otherwise simply press enter"
                        read -r brans2
                          if [[ -n "$brans2" ]]; then
                          
                              for brfile in "${FILESTOEDIT[@]}"; do
                                echo "here is the contents of $brfile:"
                                echo ""
                                cat "$brfile" | sed -e "s/$brans1/$brans2/g"
                              done
                            
                            echo "here is a preview of the file, please confirm with y or n"
                            
                            read -r brans3
                              if [[ "$brans3" == "y" ]]; then
                                for brfile in "${FILESTOEDIT[@]}"; do
                                  sed -i "s/$brans1/$brans2/g" "$brfile"
                                done
                                  echo "would you like to redact another word (y/n)"
                                  read -r brans4 
                                    if [[ "$brans4" == "y" ]]; then
                                      continue
                                    else
                                      batch_redact_another_word=false
                                    fi
                        
                              fi
                          fi

                          if [[ -z "$brans2" ]]; then
                              for brfile2 in "${FILESTOEDIT[@]}"; do
                                echo "this is the contents of $brfile2"
                                echo ""
                                cat "$brfile2" | sed -e "s/$brans1/REDACTED/g"
                              done 
                                
                                echo "here is a preview of the files as shown above, please confirm with y or n"
                                read -r brans5
                                  if [[ "$brans5" == "y" ]]; then
                                    for brfile3 in "${FILESTOEDIT[@]}"; do
                                      sed -i "s/$brans1/REDACTED/g" "$brfile3"
                                    done
                                      echo "would you like to redact another word (y/n)"
                                      read -r brans6
                                        if [[ "$brans6" == "y" ]]; then
                                          continue 
                                        else
                                          batch_redact_another_word=false
                                        fi  
                                  fi 
                          fi
                  done
              fi

##################################### SHA-256 checksum gen #######################################

              if [[ "$btinput" == "MD5 checksum generator" ]]; then
                CHECKSUMM=true
                  while $CHECKSUMM; do
                    echo "A list of checksums with their corresponding file will be stored as a file, provide the full path to where you would like the file to be stored in the format /path/to/file. Alternatively simply press enter to print to the terminal"
                    read -r checksumm1
                      if [[ -z "$checksumm1" ]]; then
                        for CHECKSUMMEDFILE2 in "${FILESTOEDIT[@]}"; do
                          sha256sum "$CHECKSUMMEDFILE2"
                        done
                      else
                        for CHECKSUMMEDFILE in "${FILESTOEDIT[@]}"; do
                        touch "$checksumm1"
                        sha256sum "$CHECKSUMMEDFILE" >> "$checksumm1"
                        done
                      fi
                        echo "checksums generated"
                        CHECKSUMM=false
                  done
              fi


   

  #################################### BATCH ENCRYPTION #######################


              if [[ "$btinput" == "batch encrypt" ]]; then
                encryptorr=true
                  while $encryptorr; do
                    echo "would you like to use a passphrase (not reccommended), if yes, then please type the password you would like to use, otherwise, simply type enter"
                    read -r encrypans1
                      if [[ -n "$encrypans1" ]]; then
                        for filetoencrypt in "${FILESTOEDIT[@]}"; do
                          gpg --encrypt --asymetric "$encrypans1" "$filetoencrypt"
                        done

                      fi  
                      if [[ -z "$encrypans1" ]]; then
                        
                          if [[ $(find / -name "*.pub") == "1" ]]; then
                            echo "a public key could not be found in your system, it is possible that your public keyring is in the root directory and this script should subsewuently be executed as root"
                            encryptorr=false
                          else
                            echo "please specify an email adress/public key"
                              read -r encrypans2
                                for filetoencrypt2 in "${FILESTOEDIT[@]}"; do
                                  gpg --encrypt --recipient "$encrypans2" "$filetoencrypt2"
                                done
                              encryptorr=false                          
                          fi
                      fi
                  done
                fi              

  ########################################### BATCH UPLOADER ############################
                                  
              if [[ "$btinput" == "uploader via scp" ]]; then
                scper=true
                  while $scper; do  
                    if [[  -z "$( find / -name "*.pub" )" ]]; then
                      echo "no public keys were found in the system, a keypair is rquired for scp to work correctly.....exiting"
                      scper=false
                    fi

                    echo "please specify a user"
                    read -r scpinput1
                    echo ""
                    echo "please specify an address"
                    read -r scpinput2
                    echo ""
                    echo "please specify a path in the format path/to/file"
                    read -r scpinput3
                    echo ""
                    echo "now copying"
                      for scpfile in "${FILESTOEDIT[@]}"; do
                        scp "$scpfile" "$scpinput1"@"$scpinput2":"$scpinput3"
                      done
                    scper=false
                  done
              fi

  ############################################### BATCH ARCHIVER #####################################

              if [[ "$btinput" == "archiver" ]]; then
                archiver=true
                  while $archiver; do
                    echo "what is the name you would like for the archive"
                    echo ""
                    read -r archivename
                    echo ""
                    echo "please specify a compression level from 0-9. 0 indicates no compression"
                    read -r complevel2
                    echo ""
                    echo "would you like in place encrytion. Answer y or n"
                    echo ""
                    read -r inplace2
                      if [[ "$inplace2" == "y" ]]; then
                        echo "please specify the recipient"
                        echo ""
                        read -r archivepubkey
                          for filetoarchive3 in "${FILESTOEDIT[@]}"; do
                            zip -"$complevel2" -y -r "$filetoarchive3" | gpg --encrypt --recipient "$archivepubkey" "$archivename".zip.gpg
                          done
                          archiver=false
                      fi

                      if [[ "$inplace2" == "n" ]]; then
                        for filetoarchive4 in "${FILESTOEDIT[@]}"; do
                          zip -"$complevel2" -y -r ~/"$archivename".zip "$filetoarchive4"
                        done
                        archiver=false
                      fi
                          
                       

                      
                  done              
              fi    

  
 
 
          done
      fi
       
    
done      
