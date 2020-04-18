getCodeByName(name:="",DB:=0){
	if(!name){
		return
	}
	  if(!DB){
                MsgBox can not get db
                Return
            }
            sql:="select code from stock where name='"  name   "'"
            resultSet := DB.OpenRecordSet(sql)
            if(!IsObject(resultSet)){
                MsgBox error resultSet is not Object
                Return
            }
            if(!is(resultSet, DBA.RecordSet))
                throw Exception("RecordSet Object expected! resultSet was of type: " typeof(resultSet) ,-1)
            columns := resultSet.getColumnNames()
            columnCount := columns.Count()
            while(!resultSet.EOF){	
                code:=resultSet[1]
                resultSet.MoveNext()
            }
	    return code
}
