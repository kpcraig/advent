using System;
using System.Security.Cryptography;
using System.Text;

class Program
{
	static void Main() {
		string key = "iwrupvqb";
		int val = 0;
		MD5 md5 = MD5.Create();
		string hexHash;
		do {
			string fullKey = key + val;
			byte[] hash = md5.ComputeHash( System.Text.Encoding.ASCII.GetBytes(fullKey) );
			StringBuilder sb = new StringBuilder();
			for(int i = 0;i < hash.Length;i++) {
				sb.Append(hash[i].ToString("X2"));
			}
			hexHash = sb.ToString();
			val++;
		}while(!hexHash.StartsWith("00000"));
		Console.WriteLine((val - 1));
	}
}
