import pyodbc
from util.db_property_util import get_connection_string
from exception.custom_exceptions import DBConnectionException

class DBConnUtil:
    @staticmethod
    def get_connection(prop_file):
        try:
            conn_str = get_connection_string(prop_file)
            return pyodbc.connect(conn_str)
        except Exception as e:
            raise DBConnectionException("DB Connection Failed: " + str(e))
