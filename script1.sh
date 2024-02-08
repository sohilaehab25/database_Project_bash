#!/bin/bash

mkdir -p "$HOME/main" 2> "$HOME/.errors"

function welcome {
    echo -e "\t\t\t\t\t\t\t Welcome to our database"
    echo -e "\t\t\t\t\t\t\t Enjoy with our features dealing with database management system"
    echo -e "\t\t\t\t\t\t\t This database is made by Naglaa Saad and Sohils Ehab"
}

#----------------------------------------menu_database---------------------------------
function menu {
    echo "_______your options_________"
    echo "1- Create database"
    echo "2- List databases"
    echo "3- Connect to a database"
    echo "4- Drop a database"
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
        mkdir -p "$HOME/main/$database_name" 2> "$HOME/.errors"
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
        cd "$HOME/main/$database_name" || return
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
                    rm -r "$HOME/main/$database_name" 2> "$HOME/.errors"
                    if [[ ! -d "$HOME/main/$database_name" ]]; then
                        echo "Your database $database_name is deleted successfully :)"
                    else
                        echo "Database $database_name could not be deleted."
                    fi
                    break ;;
                "no")
                    echo "Database $database_name was not deleted."
                    break ;;
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
    echo "* 2. List Tables          *"
    echo "* 3. Drop Table           *"
    echo "* 4. Insert Into Table    *"
    echo "* 5. Clear                *" 
    echo "* 6. Select All Data      *" 
    echo "* 7. Select From Table    *"
    echo "* 8. Delete From Table    *"
    echo "* 9. Update Table         *"
    echo "* 10. Back to Main Menu   *"
    echo "* 11. Exit                *"
    echo "---------------------------"

    echo -e "Enter your choice : \c"
    read -r choice
    case $choice in
        1) create_table ;;
        2) list_tables ;;
        3) drop_table ;;
        4) insert_into_table ;;
        5) clear; echo -e "\n Welcome to table menu :)" ;;
        6) select_all_tabledata ;;
        7) Select_specific_row ;;
        8) Delete ;;
        9) Table_update ;;
        10) clear; welcome; menu ;;
        11) exit 1; clear ;;
        *) echo "Invalid choice" ;;
    esac

    table_Menu
}

#-------------------------------------create_table-------------------------------------

function create_table {
    read -p "Enter the name of the table: " table_name

    while [[ ! "$table_name" =~ ^[A-Za-z][A-Za-z1-9]*$ ]]; do
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

        # Array to store used column names
        declare -a used_column_names

        until [ $column_primary_key -gt $column_number ]; do
            read -p "Enter the name of column $column_primary_key: " column_name

            # Validate column name
            while ! [[ "$column_name" =~ ^[A-Za-z][A-Za-z1-9]*$ ]]; do
                echo "Column name must start with a letter and can contain letters or numbers."
                read -p "Enter a valid column name: " column_name
            done

            # Check if the column name is already used
            while [[ " ${used_column_names[@]} " =~ " $column_name " ]]; do
                echo "Column name '$column_name' is already used. Please enter a different name."
                read -p "Enter a valid column name: " column_name
            done

            used_column_names+=("$column_name")

            data+="$column_name" 
            Info="$column_name" 

            echo "Type of Column $column_name:"
            select col_type in "string" "int"; do
                case $col_type in
                    "string") type_string="string"; break ;;
                    "int") type_int="int"; break ;;
                    *) echo "Please enter a valid choice." ;;
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

#--------------------------list_tables--------------------------------
function list_tables {
    ls "$HOME/main/$database_name"
}

#--------------------------drop_table---------------------------------
function drop_table {
    echo -e "Enter the name of the table: \c"
    read -r table_name

    if [ -f "$HOME/main/$database_name/$table_name" ]; then
        echo -e "Are you sure you want to drop the table '$table_name'?\n"

        select opt in "yes" "no"; do
            case $opt in
                "yes")
                    rm -r "$HOME/main/$database_name/$table_name" 2> "$HOME/.errors"
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
#--------------------------------insert table---------------------
function insert_into_table {
    read -p "Enter your table name: " table_name

    if [[ -f "$PWD/$table_name" ]]; then
        while true; do
            column_number=$(awk 'END{ print NR }' ".$table_name")
            typeset -i i
            i=1
            row=""

            while ((i <= column_number)); do
                name=$(awk -F'|' '{if(NR=='$i') {print $1}}' ".$table_name")
                type=$(awk -F'|' '{if(NR=='$i') {print $2}}' ".$table_name")
                primarykey=$(awk -F'|' '{if(NR=='$i') {print $3}}' ".$table_name")

                read -p "Enter the data of $name ($type): " data_user

                # Validate input based on data type
                while true; do
                    if [[ "$type" == "int" ]]; then
                        if [[ "$data_user" =~ ^[0-9]+$ ]]; then
                            break
                        else
                            echo "Your data $data_user must be an integer. Please enter a valid value!"
                            read -p "Enter $name ($type): " data_user
                        fi
                    elif [[ "$type" == "string" ]]; then
                        if [[ "$data_user" =~ ^[A-Za-z]+[A-Za-z1-9]*$ ]]; then
                            break
                        else
                            echo "Your data $data_user is invalid. It must be of type $type! "
                            read -p "Enter $name ($type): " data_user
                        fi
                    fi
                done

                # Check for primary key constraint
                if [[ $primarykey == "primary_key" ]]; then
                    while grep -q "^$data_user|" "$PWD/$table_name"; do
                        echo "Invalid input for Primary Key!"
                        read -p "Enter $name ($type): " data_user
                    done
                fi

                if [ "$i" -eq "$column_number" ]; then
                    row="$row$data_user|"
                else
                    row="$row$data_user|"
                fi
                ((i++))
            done

            echo "$row" >> "$PWD/$table_name"
            if [[ $? == 0 ]]; then
                echo "Data Inserted Successfully :)"
            else
                echo "Error Inserting Data into Table $table_name :("
            fi

            read -p "Do you want to insert another row? (yes/no): " insert_again
            case $insert_again in
                [Yy]*)
                    continue ;;
                [Nn]*)
                    break ;;
                *)
                    echo "Invalid choice. Please enter 'yes' or 'no'."
                    ;;
            esac
        done
    else
        echo "File $table_name does not exist!"
    fi
}


#-------------------------------------update_table-------------------------------------
function Table_update {

    read -p "Enter your table name: " table_name

    if [[ -f "$PWD/$table_name" ]]; then
        while true; do
            column_number=$(awk 'END{ print NR }' ".$table_name")
            typeset -i i
            i=1

            # Ask for primary key column name and value
            read -p "Enter the primary key column name: " pk_column
            pk_value=""
            if grep -q "^$pk_column|" "$PWD/$table_name"; then
                read -p "Enter the value of the primary key to update: " pk_value
                if ! grep -q "^$pk_value|" "$PWD/$table_name"; then
                    echo "Record with $pk_column = $pk_value does not exist in the table."
                    continue
                fi
            else
                echo "Primary key column '$pk_column' does not exist in the table."
                continue
            fi

            row=""

            while ((i <= column_number)); do
                name=$(awk -F'|' '{if(NR=='$i') {print $1}}' ".$table_name")
                type=$(awk -F'|' '{if(NR=='$i') {print $2}}' ".$table_name")
                primarykey=$(awk -F'|' '{if(NR=='$i') {print $3}}' ".$table_name")

                # Skip primary key column
                if [[ "$name" == "$pk_column" ]]; then
                    ((i++))
                    continue
                fi

                read -p "Enter the new value of $name ($type): " data_user

                # Validate input based on data type
                while true; do
                    if [[ "$type" == "int" ]]; then
                        if [[ "$data_user" =~ ^[0-9]+$ ]]; then
                            break
                        else
                            echo "Your data $data_user must be an integer. Please enter a valid value!"
                            read -p "Enter $name ($type): " data_user
                        fi
                    elif [[ "$type" == "string" ]]; then
                        if [[ "$data_user" =~ ^[A-Za-z]+[A-Za-z1-9]*$ ]]; then
                            break
                        else
                            echo "Your data $data_user is invalid. It must be of type $type! "
                            read -p "Enter $name ($type): " data_user
                        fi
                    fi
                done

                if [ "$i" -eq "$column_number" ]; then
                    row="$row$data_user|"
                else
                    row="$row$data_user|"
                fi
                ((i++))
            done

            # Update the record
            if [[ -n "$pk_value" ]]; then
                sed -i "/^$pk_value/s/^[^|]*/$row/" "$PWD/$table_name"
                if [[ $? == 0 ]]; then
                    echo "Data Updated Successfully :)"
                else
                    echo "Error Updating Data in Table $table_name :("
                fi
            fi

            read -p "Do you want to update another row? (yes/no): " update_again
            case $update_again in
                [Yy]*)
                    continue ;;
                [Nn]*)
                    break ;;
                *)
                    echo "Invalid choice. Please enter 'yes' or 'no'."
                    ;;
            esac
        done
    else
        echo "File $table_name does not exist!"
    fi
}

#------------------------------select all from Table ------------------------------------
function select_all_tabledata {
    read -p "Enter your table name please: " table_name

    if [ -f "$HOME/main/$database_name/$table_name" ]; then
        echo "Your data inside the table '$table_name' is: "
        awk '{print}' "$HOME/main/$database_name/$table_name" | grep -n "|"
        table_Menu
    else
        echo "Table $table_name does not exist"
        table_Menu
    fi
}

#---------------------------------Select_specific_row----------------------

function Select_specific_row {
    while true; do
        read -p "Enter the table name: " table_name

        if [ -f "$PWD/$table_name" ]; then
            break
        else
            echo "Table doesn't exist!"
            table_Menu
        fi
    done

    while true; do
        read -p "Enter condition column name: " field_name

        res1=$(awk 'BEGIN{FS="|"} NR==1{for(i=1;i<=NF;i++) if($i=="'$field_name'") print i}' "$PWD/$table_name")

        if [[ -z $res1 ]]; then
            echo "Field name doesn't exist."
            table_Menu
        else
            break
        fi
    done

    while true; do
        read -p "Enter value of condition column: " value

        res2=$(cut -d'|' -f$res1 "$PWD/$table_name" | grep -n "^$value$")
        if [[ -z $res2 ]]; then
            echo "The value of the condition column doesn't exist!"
            continue  # Loop back to prompt for a new value
        else
            number_record=$(cut -d'|' -f$res1 "$PWD/$table_name" | grep -n "^$value$" | cut -d':' -f1)

            if ! [[ "$number_record" == "" ]]; then
                if (( $(echo "$number_record" | wc -l) > 1 )); then
                    echo "Multiple occurrences of $field_name = $value"
                    awk 'NR > 1 { print }' "$PWD/$table_name" | grep -n "$value"
                else
                    data=$(awk 'NR=='$number_record' {print}' "$PWD/$table_name")
                    echo "Selected Row:-"
                    echo "$data"
                fi
            else
                echo "Record with $field_name = $value not found in $table_name."
            fi
            table_Menu
            break
        fi
    done
}


#----------------------------delete from table -----------------------------
function Delete {
    read -p "Enter Table name: " table_name
     
    table_path="$HOME/main/$database_name/$table_name"

    # Check if the table exists
    if [[ ! -f "$table_path" ]]; then
        echo "Table '$table_name' does not exist in database '$database_name'."
        return
    fi

    # Check if the table is empty (contains only the header)
    if [[ $(wc -l < "$table_path") -eq 1 ]]; then
        echo "The table '$table_name' is empty (contains only the header)."
        return
    fi

    while true; do
        # Display the contents of the table
        cat "$table_path"

        # Prompt the user for the primary key column
        read -p "Enter the primary key column name: " pk_column

        # Validate if the primary key column exists
        if ! head -n 1 "$table_path" | grep -qw "$pk_column"; then
            echo "Primary key column '$pk_column' does not exist in the table header."
            continue
        fi

        # Prompt the user for the primary key value to delete
        read -p "Enter the value of the primary key to delete record: " pk_value

        # Check if the record with the specified primary key value exists
        if ! grep -q "^$pk_value" "$table_path"; then
            echo "Record with $pk_column = $pk_value not found in the table."
            continue
        fi

        # Delete the record from the table
        sed -i "/^$pk_value|/d" "$table_path"
        echo "Record with $pk_column = $pk_value deleted successfully from $table_name."

        # Check if the table has only one line (the header) after deletion
        if [[ $(wc -l < "$table_path") -eq 1 ]]; then
            echo "The table '$table_name' is now empty. Exiting..."
            return
        fi

        # Prompt the user if they want to delete another record or column
        read -p "Do you want to delete another record or column in '$table_name'? (yes/no): " choice
        case $choice in
            [Yy]*)
                continue ;;
            [Nn]*)
                break ;;
            *)
                echo "Invalid choice. Please enter 'yes' or 'no'."
                ;;
        esac
    done
}

welcome
menu

