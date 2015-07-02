<?php
    /**
     * Description of DBBaseClass
     * This class wil encapsulate the base functions and objects for DB access
     *
     * @author Danie du Toit
     */
    include_once "settings.inc.php";
    if (!class_exists('BaseDB')) {
        class BaseDB
        {
            /**
             * Closes the current SQL connection
             */
            public function close()
            {
                sqlsrv_close(Database::getInstance()->getConnection());
            }

            /**
             * Starts a sql transaction.
             *
             * @return boolean
             */
            function dbTransactionBegin()
            {
                return sqlsrv_begin_transaction(Database::getInstance()->getConnection()); // Begins a transaction.
            }

            /**
             * Commits the sql transaction.
             *
             * @return boolean (Returns TRUE on success or FALSE on failure.)
             */
            function dbTransactionCommit()
            {
                return sqlsrv_commit(Database::getInstance()->getConnection()); // Commits a transaction.
            }

            /**
             * Rolls back the sql transaction.
             *
             * @return boolean (Returns TRUE on success or FALSE on failure.)
             */
            function dbTransactionRollback()
            {
                return sqlsrv_rollback(Database::getInstance()->getConnection()); // Rolls back a transaction.
            }

            /**
             * Executes the passed sql and returns the result set.
             *
             * @param $sql
             * @return bool|resource: a statement resource on success and FALSE if an error occurred.
             */
            function dbQuery($sql)
            {
                if (empty($sql)) {
                    return false;
                }
                $result = sqlsrv_query(Database::getInstance()->getConnection(), $sql); // Prepares and executes a Transact-SQL query.
                return $result;
            }

            /**
             * Executes the passed Stored Procedure and returns the result set.
             *
             * @param $sql
             * @param $params - IN & OUT parameters
             * @return bool|resource: a statement resource on success and FALSE if an error occurred.
             */
            function dbCallSP($storedProcedure, $params)
            {
                if (empty($storedProcedure)) {
                    return false;
                }
                $result = sqlsrv_query(Database::getInstance()->getConnection(), $storedProcedure, $params); // Prepares and executes a Stored Procedure.
                return $result;
            }

            /**
             * Get all fields of all the records for the specified table
             * @param $tableName : The table of which all data is needed
             * @return bool|resource
             */
            function getAll($tableName, $filter = "")
            {
                if (empty($tableName)) {
                    return false;
                }
                $sql    = "BEGIN SELECT * FROM $tableName $filter END";
                $result = $this->dbQuery($sql);
                return $result;
            }

            /**Get all fields of all the records that are equal to the  $searchValue and value for the specified table
             *
             * @param $tableName : string - name of the table
             * @param $searchFieldName : The $searchFieldName of the records you want to do the search on
             * @param $searchValue : either integer(only) or alphanumeric
             * @return bool|resource
             *
             * Returns a statement resource on success and FALSE if an error occurred.
             */
            function getAllByFieldName($tableName, $searchFieldName, $searchValue)
            {
                $sql    = "BEGIN SELECT * FROM $tableName WHERE $searchFieldName = $searchValue END";
                $result = $this->dbQuery($sql); // Executes the passed sql and returns the result set.
                return $result;
            }

            /**
             * @param $tableName : string - name of the table
             * @param $searchFieldName : The fieldname of the records you want to do the search on
             * @param $searchValue : either integer(only) or alphanumeric
             * @param $fieldNames : The fields that you want to be returned
             * @return bool|resource: a statement resource on success and FALSE if an error occurred.
             */
            function getFieldsByFieldName($tableName, $searchFieldName, $searchValue, $fieldNames)
            {
                if (!is_array($fieldNames)) {
                    return array();
                }
                $fields = implode(",", $fieldNames);
                $sql    = 'SELECT ' . $fields . ' FROM ' . $tableName . ' WHERE ' . $searchFieldName . " like '%" . $searchValue . "%'";
                $result = $this->dbQuery($sql); // Executes the passed sql and returns the result set.
                return $result;
            }

            /**
             * @param $tableName : string - name of the table
             * @param $searchFieldName : The fieldname of the records you want to do the search on
             * @param $searchValue : either integer(only) or alphanumeric
             * @param $fieldNames : The fields that you want to be returned
             * @return bool|resource: a statement resource on success and FALSE if an error occurred.
             */
            function getFieldsByFilter($tableName, $fieldNames, $filter = "")
            {
                if (!is_array($fieldNames)) {
                    return array();
                }
                $fields = implode(",", $fieldNames);
                $sql    = "SELECT " . $fields . " FROM $tableName $filter";
                $result = $this->dbQuery($sql); // Executes the passed sql and returns the result set.
                return $result;
            }

            /**
             * @param $tableName :  string - name of the table
             * @param $fieldNames : (ARRAY): The fieldnames of the fields of the records
             * @return bool|resource: Returns a statement resource on success and FALSE if an error occurred.
             */
            function getFieldsForAll($tableName, $fieldNames, $filter = "")
            {
                if (!is_array($fieldNames)) { // Finds whether a variable is an array
                    $fields = $fieldNames;
                } else {
                    $fields = implode(",", $fieldNames); // Join array elements with a string
                }
                $sql    = 'SELECT ' . $fields . " FROM $tableName $filter";
                $result = $this->dbQuery($sql); // Executes the passed sql and returns the result set.
                return $result;
            }

            /**
             * @param $tableName : string - name of the table
             * @param $searchFieldName : The fieldname of the record you want to do the search on
             * @param $searchValue : either integer(only) or alphanumeric
             * @return bool: Returns TRUE or FALSE.
             */
            function deleteRecords($tableName, $searchFieldName, $searchValue)
            {
                if (ctype_digit($searchValue)) {
                    $sql = "BEGIN DELETE FROM $tableName WHERE $searchFieldName = $searchValue END";
                } else {
                    $sql = "BEGIN DELETE FROM $tableName WHERE $searchFieldName = $searchValue END";
                }
                // Prepare the statement
                $stmt = sqlsrv_prepare(Database::getInstance()->getConnection(), $sql); // Prepares a Transact-SQL query without executing it. Implicitly binds parameters.
                if (!$stmt) {
                    return false;
                }
                $result = sqlsrv_execute($stmt); // Executes a prepared statement.
                return $result;
            }

            /**
             * Get the record from the specified table using the given $tableName, $searchFieldName and $searchValue
             *  and set the "Active" field to $value
             * @param $tableName :  string - name of the table
             * @param $searchFieldName :  The fieldname of the record you want to do the search on
             * @param $searchValue : either integer(only) or alphanumeric
             * @param $Active : Sets the 'Active' field to TRUE or FALSE
             * @return bool: Returns TRUE or FALSE.
             */
            function setActive($tableName, $searchFieldName, $searchValue, $Active)
            {
                if ($Active === true) {
                    $active = 'TRUE';
                } else {
                    $active = 'FALSE';
                }
                if (is_numeric($searchValue)) { // Finds whether a variable is a number or a numeric string
                    $sql = 'UPDATE' . $tableName . 'SET Active =' . $active . 'WHERE' . $searchFieldName . ' = ' . $searchValue;
                } else {
                    $sql = 'UPDATE' . $tableName . 'SET Active =' . $active . 'WHERE' . $searchFieldName . " = '" . $searchValue . "'";
                }
                //prepare statement
                $stmt = sqlsrv_prepare(Database::getInstance()->getConnection(), $sql);
                if (!$stmt) {
                    return false;
                }
                $result = sqlsrv_execute($stmt);
                return $result;
            }

            public function Free($stmnt)
            {
                sqlsrv_free_stmt($stmnt);
            }
        }
    }