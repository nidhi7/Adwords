import java.util.Scanner;
import java.io.*;
import java.sql.*;

import oracle.jdbc.*;

public class adwords {

	public static void main(String[] args) {
		// TODO Auto-generated method stub

		File f = new File("System.in.dat");
		Scanner sc = null;
		try {
			sc = new Scanner(f);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		sc.next();
		sc.next();
		String usr = sc.next();
		sc.next();
		sc.next();
		String pwd = sc.next();
		//System.out.println("Username and passwords are "+usr + " " + pwd);
		//System.out.print(sc.nextLine());
		
		sc.next();
		sc.next();
		sc.next();
		int kTask1 = sc.nextInt();
		//System.out.println("K value for TASK1: "+kTask1);
		sc.next();
		sc.next();
		sc.next();
		int kTask2 = sc.nextInt();
		//System.out.println("K value for TASK2: "+kTask2);
		sc.next();
		sc.next();
		sc.next();
		int kTask3 = sc.nextInt();
		//System.out.println("K value for TASK3: "+kTask3);
		sc.next();
		sc.next();
		sc.next();
		int kTask4 = sc.nextInt();
		//System.out.println("K value for TASK4: "+kTask4);
		sc.next();
		sc.next();
		sc.next();
		int kTask5 = sc.nextInt();
		//System.out.println("K value for TASK5: "+kTask5);
		sc.next();
		sc.next();
		sc.next();
		int kTask6 = sc.nextInt();
		//System.out.println("K value for TASK6: "+kTask6);
		try {
			DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());

			Connection conn = DriverManager.getConnection(
					"jdbc:oracle:thin:@oracle.cise.ufl.edu:1521:orcl",usr,pwd);
			//System.out.println();			
			//System.out.println("Connected successfully");
			
			Process dropAndCreate=Runtime.getRuntime().exec("sqlplus "+usr+"@orcl/"+pwd+" "+"@dropAndCreate.sql");
			dropAndCreate.waitFor();
			//System.out.println("Tables dropped and created successfuly");
			
			Process plq = Runtime.getRuntime().exec(
					"sqlldr " + usr + "@orcl/" + pwd
							+ " control='loadQueries.ctl'");
			plq.waitFor();
			//System.out.println("queries loaded successfully");
			
			Process pla = Runtime.getRuntime().exec(
					"sqlldr " + usr + "@orcl/" + pwd
							+ " control='loadAdvertisers.ctl'");
			pla.waitFor();
			//System.out.println("advertisers loaded successfully");
			
			Process plk = Runtime.getRuntime().exec(
					"sqlldr " + usr + "@orcl/" + pwd
							+ " control='loadKeywords.ctl'");
			plk.waitFor();
			//System.out.println("keywords loaded successfully");
			
			Process p1 = Runtime.getRuntime().exec("sqlplus "+usr+"@orcl/"+pwd+" "+"@adwords.sql");
					p1.waitFor();
			
					//System.out.println("Proc created");
			CallableStatement stmt = conn
					.prepareCall("CALL ADWORDS(?,?,?,?,?,?,?,?,?,?,?,?)");
			
			//System.out.println("Called Proc");
			// Bind IN parameters first, then bind OUT parameters
			stmt.setInt(1, kTask1); 
			stmt.setInt(2, kTask2);
			stmt.setInt(3, kTask3);
			stmt.setInt(4, kTask4);
			stmt.setInt(5, kTask5);
			stmt.setInt(6, kTask6);
			
			// 7th to 12th parameters are OUT so register them

			stmt.registerOutParameter(7, OracleTypes.CURSOR);
			stmt.registerOutParameter(8, OracleTypes.CURSOR);
			stmt.registerOutParameter(9, OracleTypes.CURSOR);
			stmt.registerOutParameter(10, OracleTypes.CURSOR);
			stmt.registerOutParameter(11, OracleTypes.CURSOR);
			stmt.registerOutParameter(12, OracleTypes.CURSOR);

			
		//	System.out.println("Executing proc");
			stmt.execute();
		//	System.out.println("Executed proc");
			// First ReulstSet object
			/*
			 * if (!isResultSet) {
			 * System.out.println("The first result is not a ResultSet.");
			 * return; }
			 */
			// First ReulstSet object
			// First ReulstSet object
			//System.out.println("Generating System.out.1 for GREEDY 1ST AUCTION");
			// ResultSet res = stmt.getResultSet();
			ResultSet res = (ResultSet) stmt.getObject(7);
			PrintWriter writer = null;

			writer = new PrintWriter(new OutputStreamWriter(
					new BufferedOutputStream(new FileOutputStream(
							"System.out.1.dat")), "UTF-8"));

			while (res.next()) {
				/*
				 * System.out.println("  "+res.getFloat("QID")
				 * +", "+res.getFloat("RANK") +", "+res.getFloat("ADVERTISERID")
				 * +", "+res.getFloat("BALANCE") +", "+res.getFloat("BUDGET"));
				 */
				writer.append(
						res.getInt("QID") + ", " + res.getInt("RANK")
								+ ", " + res.getInt("ADVERTISERID") + ", "
								+ res.getFloat("BALANCE") + ", "
								+ res.getFloat("BUDGET")).println();

			}
			res.close();
			writer.close();

			// Move to the next result
			//System.out.println();
			//System.out.println("Generating System.out.3 for BALANCED 1ST AUCTION");
			ResultSet res2 = (ResultSet) stmt.getObject(8);
			writer = new PrintWriter(new OutputStreamWriter(
					new BufferedOutputStream(new FileOutputStream(
							"System.out.3.dat")), "UTF-8"));
			while (res2.next()) {

				writer.append(
						res2.getInt("QID") + ", " + res2.getInt("RANK")
								+ ", " + res2.getInt("ADVERTISERID") + ", "
								+ res2.getFloat("BALANCE") + ", "
								+ res2.getFloat("BUDGET")).println();

			}
			res2.close();
			writer.close();
			
			// Move to the next result
						//System.out.println();
						//System.out.println("Generating System.out.5 for GENERALIZED BALANCED 1ST AUCTION");
						ResultSet res3 = (ResultSet) stmt.getObject(9);
						writer = new PrintWriter(new OutputStreamWriter(
								new BufferedOutputStream(new FileOutputStream(
										"System.out.5.dat")), "UTF-8"));
						while (res3.next()) {

							writer.append(
									res3.getInt("QID") + ", " + res3.getInt("RANK")
											+ ", " + res3.getInt("ADVERTISERID") + ", "
											+ res3.getFloat("BALANCE") + ", "
											+ res3.getFloat("BUDGET")).println();

						}
						res3.close();
						writer.close();
						
						// Move to the next result
						//System.out.println();
						//System.out.println("Generating System.out.2 for GREEDY 2ND AUCTION");
						ResultSet res4 = (ResultSet) stmt.getObject(10);
						writer = new PrintWriter(new OutputStreamWriter(
								new BufferedOutputStream(new FileOutputStream(
										"System.out.2.dat")), "UTF-8"));
						while (res4.next()) {

							writer.append(
									res4.getInt("QID") + ", " + res4.getInt("RANK")
											+ ", " + res4.getInt("ADVERTISERID") + ", "
											+ res4.getFloat("BALANCE") + ", "
											+ res4.getFloat("BUDGET")).println();

						}
						res4.close();
						writer.close();
						
						// Move to the next result
						//System.out.println();
						//System.out.println("Generating System.out.4 for BALANCED 2ND AUCTION");
						ResultSet res5 = (ResultSet) stmt.getObject(11);
						writer = new PrintWriter(new OutputStreamWriter(
								new BufferedOutputStream(new FileOutputStream(
										"System.out.4.dat")), "UTF-8"));
						while (res5.next()) {

							writer.append(
									res5.getInt("QID") + ", " + res5.getInt("RANK")
											+ ", " + res5.getInt("ADVERTISERID") + ", "
											+ res5.getFloat("BALANCE") + ", "
											+ res5.getFloat("BUDGET")).println();

						}
						res5.close();
						writer.close();
						
						// Move to the next result
						//System.out.println();
						//System.out.println("Generating System.out.6 for GENERALIZED BALANCED 2ND AUCTION");
						ResultSet res6 = (ResultSet) stmt.getObject(12);
						writer = new PrintWriter(new OutputStreamWriter(
								new BufferedOutputStream(new FileOutputStream(
										"System.out.6.dat")), "UTF-8"));
						while (res6.next()) {

							writer.append(
									res6.getInt("QID") + ", " + res6.getInt("RANK")
											+ ", " + res6.getInt("ADVERTISERID") + ", "
											+ res6.getFloat("BALANCE") + ", "
											+ res6.getFloat("BUDGET")).println();

						}
						res6.close();
						writer.close();
			stmt.close();

			Process drop=Runtime.getRuntime().exec("sqlplus "+usr+"@orcl/"+pwd+" "+"@drop.sql");
			drop.waitFor();
			//System.out.println("Tables dropped successfuly");

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}
