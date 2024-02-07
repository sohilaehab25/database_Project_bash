#!/bin/bash

mkdir -p $HOME/main 2> $HOME/.errors

function welcome {
    echo -e "\t\t\t\t\t\t\t Welcome to our database"
    echo -e "\t\t\t\t\t\t\t enjoy with our features dealing with database management system"
    echo -e "\t\t\t\t\t\t\t this database made by Naglaa Saad and Sohils Ehab"
}
#----------------------------------------menu_database---------------------------------
function menu {
    echo "_______your options_________"
    echo "1- create database"
    echo "2- list database"
    echo "3- connect to database"
    echo "4- drop database"
    echo "5- Exit"
    echo "_____________________________"

    read -p "Please enter your choice: " choice

    case $choice in
        1) create_database ;;
        2) list_database ;;
        3) connect_to_database ;;
        4) drop_database ;;
        5) exit 1 ;;
        *) echo "Please choose a valid number" ;;
    esac
    menu
}
#----------------------------------------create_database---------------------------------

function create_database {
    read -p "Enter the name of the database: " database_name
   
    while [[ ! "$database_name" =~ ^[A-Za-z]+$ ]]; do
        echo "Please enter a valid string name for your database :D"
        read -p "Enter your database name: " database_name
    done

    if [[ -d "$HOME/main/$database_name" ]]; then
        echo "Your database '$database_name' already exists :D"
    else
        mkdir -p "$HOME/main/$database_name" 2> "$HOME/.error"
        echo "Database '$database_name' created successfully :)"
    fi
}

#----------------------------------list_database-----------------------------------
function list_database {
    ls "$HOME/main"
}
#--------------------------------connect_to_database-------------------------------
function connect_to_database {
    read -p "Enter your database name: " database_name

    if [[ -d "$HOME/main/$database_name" ]]; then
        cd "$HOME/main/$database_name"
        clear
        echo -e "\t Welcome to $database_name :) \n\n"
        table_Menu
    else
        echo "Your database $database_name does not exist! :D"
    fi
}
#----------------------------------------drop_database---------------------------------
function drop_database {
    read -p "Please enter your database name: " database_name

    if [[ -d "$HOME/main/$database_name" ]]; then
        echo "Are you sure you want to drop database $database_name?"
        select confirm in "yes" "no"; do
            case $confirm in
                "yes")
                    rm -r "$HOME/main/$database_name"
                    if [[ ! -d "$HOME/main/$database_name" ]]; then
                        echo "Your database $database_name is deleted successfully :)"
                    else
                        echo "Database $database_name could not be deleted."
                    fi
                    break 
                    ;;
                "no")
                    echo "Database $database_name was not deleted."
                    break  
                    ;;
                *)
                    echo "Please enter a valid input. $database_name was not deleted :(. "
                    ;;
            esac
        done
    else
        echo "Database $database_name does not exist."
    fi
}
#-------------------------------------table_menu---------------------------------------
function table_Menu {
    echo "-------- Main Menu --------"
    echo "* 1. Create Table         *"
    echo "* 2. List Table           *"
    echo "* 3. Drop Table           *"
    echo "* 4. Insert Into Table    *"
    echo "* 5. Clear                *" 
    echo "* 6. select all data      *" 
    echo "* 7. Select From Table    *"
    echo "* 8. Delete From Table    *"
    echo "* 9. Update Table         *"
    echo "* 10. Back to Main Menu   *"
    echo "* 11. Exit                *"
    echo "---------------------------"

    echo -e "Enter your choice : \c"
    read choice
    case $choice in
        1) create_table ;;
        2) ls $HOME/main/$database_name ;;
        3) drop_table ;;
        4) insert_into_table ;;
        5) clear; echo -e "\n Welcome to table menu :)" ;;
        6) select_all_tabledata ;;
        7) Select From Table ;;
        8) Delete ;;
        9) Table_update ;;
        10) clear; welcome; menu ;;
        11) exit 1; clear ;;
        *) echo "Invalid choice" ;;
    esac

    table_Menu
}


#------------------------------create_table-------------------------------------------
function create_table {
    read -p "Enter the name of the table: " table_name

    while ! [[ "$table_name" =~ ^[A-Za-z][A-Za-z1-9]*$ ]]; do
        echo "Please enter a valid string name for your table :D"
        read -p "Enter your table name: " table_name
    done

    if [ -f "$HOME/main/$database_name/$table_name" ]; then
        echo "The table $table_name already exists. Please enter another name."
        table_Menu
    fi

    typeset -i column_primary_key
    typeset -i col
    col=1

    read -p "Enter the number of table columns: " column_number

    while [[ $column_number -lt 2 ]]; do
        echo "You entered a very few number of columns."
        read -p "Enter a valid number of columns: " column_number
    done

    if [ $? == 0 ] && [ ! -f "$HOME/main/$database_name/$table_name" ]; then
        touch "$HOME/main/$database_name/$table_name"
        touch "$HOME/main/$database_name/.$table_name"
        column_primary_key=1
        data=""
        echo "note: you need to make your primary key the first column :)."

        until [ $column_primary_key -gt $column_number ]; do
            read -p "Enter the name of column $column_primary_key: " column_name

            # Validate column name
            while ! [[ "$column_name" =~ ^[A-Za-z][A-Za-z1-9]*$ ]]; do
                echo "Column name must start with a letter and can contain letters or numbers."
                read -p "Enter a valid column name: " column_name
            done

            data+="$column_name" 
            Info="$column_name" 

            echo "Type of Column $column_name:"
            select col_type in "string" "int"; do
                case $col_type in
                    "string") type_string="string"; break;;
                    "int") type_int="int"; break ;;
                    *) echo "Please enter a valid choice.";;
                esac
            done

            Info+="|$col_type"

            # Validate primary key selection
            if [ "$column_primary_key" -eq 1 ]; then
                while true; do
                    read -p "Do you want to make $column_name a primary key? [y/n] " check
                    if [ "$check" = "y" ]; then
                        Info+="|primary_key|"
                        echo "Your column $column_name became the primary key for $table_name table."
                        break
                    elif [ "$check" = "n" ]; then
                        echo "The first column must be the primary key. Please make a selection."
                    else
                        echo "Please enter 'y' for yes or 'n' for no."
                    fi
                done
            fi

            data+="|"

            echo "$data" > "$HOME/main/$database_name/$table_name"
            echo "$Info" >> "$HOME/main/$database_name/.$table_name"
            column_primary_key+=1
        done

        echo "Your table $table_name is created successfully (:"
        cat "$HOME/main/$database_name/$table_name"
    fi
}



#-------------------------- drop_table_funciotn -----------------------------
function drop_table {
    echo -e "Enter the name of the table: \c"
    read -r table_name

    if [ -f "$PWD/$table_name" ]; then
        echo -e "Are you sure you want to drop the table '$table_name'?\n"

        select opt in "yes" "no"; do
            case $opt in
                "yes")
                    rm -r "$PWD/$table_name" 2> "$HOME/.errors"
                    
                    if [  $? == 0 ]; then
                        echo "The table '$table_name' has been deleted successfully."
                        table_Menu
                       
                    fi
                    ;;
                "no")
                    break
                    ;;
                *)
                    echo "Please enter a valid option :D."
                    ;;
            esac
        done
    else
        echo "The table '$table_name' does not exist."
    fi
}
#---------------------------- Update Table function ---------------------------------


#------------------------------select all from Table ------------------------------------
function select_all_tabledata {
    read -p "Enter your table name please: " table_name

    if [ -f "$PWD/$table_name" ]; then
    echo "your data inside the table '$table_name' is: "
        awk '{print}' "$PWD/$table_name" | grep -n "|"
        table_Menu
    else
        echo "Table $table_name does not exist"
        table_Menu
    fi
}

#-------------------------------insert_into_table-----------------------------------------
function insert_into_table {
    read -p "Enter your table name: " table_name
    if [[ -f "$table_name" ]]; then 
        column_number=$(awk 'END{ print NR }' ".$table_name")
        typeset -i i
        i=1
        row=""
        while ((i <= column_number)); do 
            name=$(awk -F'|' '{if(NR=='$i') {print $1}}' ".$table_name")
            type=$(awk -F'|' '{if(NR=='$i') {print $2}}' ".$table_name")
            primarykey=$(awk -F'|' '{if(NR=='$i') {print $3}}' ".$table_name")
            read -p "Enter the data of $name ($type): " data_user

            if [[ "$type" == "int" ]]; then 
                while ! [[ "$data_user" =~ ^[0-9]*$ ]]; do 
                    echo "Your data $data_user must be an integer. Please enter a valid value!"
                    read -p "Enter $name ($type): " data_user
                done
                while [[ -z $data_user ]]; do 
                    echo "Your data must not be empty."
                    read -p "Enter valid data for $name ($type): " data_user
                done
            fi

            if [[ "$type" == "string" ]]; then
               while ! [[ "$data_user" =~ ^[A-Za-z]+[A-Za-z1-9]*$ ]]; do
                    echo "Your data $data_user is invalid. It must be of type $type! "
                    read -p "Enter $name ($type): " data_user
                done
            fi

            if [[ $primarykey == "primary_key" ]]; then
                while true; do
                    if grep -q "^$data_user|" "$table_name"; then
                        echo "Invalid input for Primary Key!"
                        read -p "Enter $name ($type): " data_user
                    else
                        break
                    fi
                done
            fi

            if [ "$i" -eq "$column_number" ]; then
                row="$row$data_user|"
            else
                row="$row$data_user|"
            fi
            ((i++))
        done

        echo "$row" >> "$table_name"
        if [[ $? == 0 ]]; then    
            echo "Data Inserted Successfully :)"
        else
            echo "Error Inserting Data into Table $tableName :("
        fi
    else
        echo "File $table_name does not exist!"
    fi
}



		

		

welcome
menu

