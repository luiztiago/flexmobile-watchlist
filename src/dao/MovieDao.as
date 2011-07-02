package dao
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	import vo.Movie;
	
	public class MovieDao
	{
		
		private var con:SQLConnection;
		
		public function MovieDao() {
			
			con = new SQLConnection();
			try
			{
				var file:File =
					File.applicationStorageDirectory.resolvePath("watchmovies.db");
				con.open(file);
				
			}
			catch(error:Error)
			{
				trace(error);
			}
			
			var stm:SQLStatement = new SQLStatement();
			stm.sqlConnection = con;
			
			var request:String = "" +
				"CREATE TABLE IF NOT EXISTS \"watchmovies\" " +
				"(\"id\" INTEGER PRIMARY KEY  NOT NULL ," +
				"\"title\" VARCHAR," +
				"\"rating\" VARCHAR," +
				"\"poster\" VARCHAR," +
				"\"plot\" TEXT," +
				"\"genre\" VARCHAR," +
				"\"year\" VARCHAR, " +
				"\"runtime\" VARCHAR);"
			
			stm.text = request;
			
			try {
				stm.execute();
			} catch(error:Error) {
				trace(error.message);
			}
			
		}
		
		public function checkExists(title:String):Boolean {
			var stm:SQLStatement = new SQLStatement();
			stm.sqlConnection = con;
			
			var sql:String = "SELECT * FROM watchmovies WHERE title=:title";
			stm.parameters[":title"] = title;
			stm.text = sql;
			stm.execute();
			
			var hasMovie:Boolean = false;
			
			var result:SQLResult = stm.getResult();
			
			if(result.data != null) {
				return true;
			}
			
			return hasMovie;
		}
		
		public function hasMovies():Boolean {
			var stm:SQLStatement = new SQLStatement();
			stm.sqlConnection = con;
			
			var sql:String = "SELECT * FROM watchmovies;";
			stm.text = sql;
			stm.execute();
			
			var hasMovies:Boolean = false;
			
			var result:SQLResult = stm.getResult();
			
			if(result.data != null) {
				return true;
			}
			
			return hasMovies;
		}
		
		public function addMovie(movie:Movie):void {
			var stm:SQLStatement = new SQLStatement();
			stm.sqlConnection = con;
			
			var hasMovie:Boolean = checkExists(movie.title);
			
			if(hasMovie == false) {
				var sql:String = "INSERT INTO watchmovies (title,rating,poster,plot,genre,year,runtime) VALUES " + 
					"(:title, :rating, :poster, :plot, :genre, :year, :runtime)";
				stm.text = sql;
				stm.parameters[":title"] = movie.title;
				stm.parameters[":rating"] = movie.rating;
				stm.parameters[":poster"] = movie.poster;
				stm.parameters[":plot"] = movie.plot;
				stm.parameters[":genre"] = movie.genre;
				stm.parameters[":year"] = movie.year;
				stm.parameters[":runtime"] = movie.runtime;
				try {
					stm.execute();
				} catch(error:Error) {
					trace(error.message);
				}
			}
			
		}
		
		public function editMovie(movie:Movie):void {
			var stm:SQLStatement = new SQLStatement();
			stm.sqlConnection = con;
			var sql:String = "UPDATE watchmovies SET title = :title, rating = :rating, poster = :poster, " +
				"plot = :plot, genre = :genre, year = :year, runtime = :runtime " +
				"WHERE id = " +movie.id;
			stm.text = sql;
			stm.parameters[":title"] = movie.title;
			stm.parameters[":rating"] = movie.rating;
			stm.parameters[":poster"] = movie.poster;
			stm.parameters[":plot"] = movie.plot;
			stm.parameters[":genre"] = movie.genre;
			stm.parameters[":year"] = movie.year;
			stm.parameters[":runtime"] = movie.runtime;
			stm.execute();
		}
		
		public function removeMovie(title:String):void {
			var stm:SQLStatement = new SQLStatement();
			stm.sqlConnection = con;
			var sql:String = "DELETE FROM watchmovies WHERE title=:title";
			stm.parameters[":title"] = title;
			stm.text = sql;
			stm.execute();
		}
		
		public function listMovies():ArrayList
		{
			var stm:SQLStatement = new SQLStatement();
			stm.sqlConnection = con;
			var sql:String = "SELECT * FROM watchmovies";
			stm.text = sql;
			stm.execute();
			
			var result:SQLResult = stm.getResult()
			var list:ArrayList = new ArrayList();
			
			if(result.data != null) {
				for (var i:int = 0; i < result.data.length; i++) 
				{
					var linha:Object = result.data[i];	
					list.addItem(linha);
				}
			}else{
				list.addItem("Nenhum filme encontrado");
			}
			
			return list; 
		}
		
	}
}