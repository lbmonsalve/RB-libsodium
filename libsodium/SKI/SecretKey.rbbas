#tag Class
Protected Class SecretKey
Inherits libsodium.SKI.KeyContainer
	#tag Method, Flags = &h0
		Sub Constructor(FromPassword As libsodium.Password, Optional Salt As MemoryBlock, Limits As libsodium.ResourceLimits = libsodium.ResourceLimits.Interactive, HashAlgorithm As Int32 = libsodium.Password.ALG_ARGON2)
		  ' Generates a secret key by deriving it from a salted hash of the password. The operation is
		  ' deterministic, such that calling this method twice with the same Password, Salt, and Limits
		  ' parameters will produce the same output both times.
		  
		  If Salt <> Nil Then CheckSize(Salt, crypto_pwhash_SALTBYTES) Else Salt = FromPassword.RandomSalt
		  Dim key As MemoryBlock = FromPassword.DeriveKey(crypto_secretbox_KEYBYTES, Salt, Limits, HashAlgorithm)
		  Me.Constructor(key)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1001
		Protected Sub Constructor(KeyData As MemoryBlock)
		  // Calling the overridden superclass constructor.
		  CheckSize(KeyData, crypto_secretbox_KEYBYTES)
		  Super.Constructor(KeyData)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Export(SaveTo As FolderItem, Optional Passwd As libsodium.Password, OverWrite As Boolean = False) As Boolean
		  ' Exports the SecretKey in a format that is understood by SecretKey.Import(FolderItem)
		  '
		  ' See:
		  ' https://github.com/charonn0/RB-libsodium/wiki/libsodium.SKI.SecretKey.Export
		  
		  Try
		    Dim bs As BinaryStream = BinaryStream.Create(SaveTo, OverWrite)
		    bs.Write(Me.Export(Passwd))
		    bs.Close
		  Catch Err As IOException
		    Return False
		  End Try
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Export(Optional Passwd As libsodium.Password) As MemoryBlock
		  ' Exports the SecretKey in a format that is understood by SecretKey.Import
		  '
		  ' See:
		  ' https://github.com/charonn0/RB-libsodium/wiki/libsodium.SKI.SecretKey.Export
		  
		  Return PackKey(Me.Value, ExportPrefix, ExportSuffix, Passwd)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		 Shared Function Generate() As libsodium.SKI.SecretKey
		  ' Returns random bytes that are suitable to be used as a secret key.
		  
		  Return New libsodium.SKI.SecretKey(RandomBytes(crypto_secretbox_KEYBYTES))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Import(ExportedKey As FolderItem, Optional Passwd As libsodium.Password) As libsodium.SKI.SecretKey
		  ' Import an SecretKey that was exported using SecretKey.Export(FolderItem)
		  '
		  ' See:
		  ' https://github.com/charonn0/RB-libsodium/wiki/libsodium.SKI.SecretKey.Import
		  
		  Dim bs As BinaryStream = BinaryStream.Open(ExportedKey)
		  Dim keydata As MemoryBlock = bs.Read(bs.Length)
		  bs.Close
		  Return Import(keydata, Passwd)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Import(ExportedKey As MemoryBlock, Optional Passwd As libsodium.Password) As libsodium.SKI.SecretKey
		  ' Import an SecretKey that was exported using SecretKey.Export
		  '
		  ' See:
		  ' https://github.com/charonn0/RB-libsodium/wiki/libsodium.SKI.SecretKey.Import
		  
		  Dim sk As MemoryBlock = ExtractKey(ExportedKey, ExportPrefix, ExportSuffix, Passwd)
		  If sk <> Nil Then Return New SecretKey(sk)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(OtherKey As libsodium.SKI.SecretKey) As Integer
		  If OtherKey Is Nil Then Return 1
		  Return Super.Operator_Compare(OtherKey.Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function RandomNonce() As MemoryBlock
		  ' Returns random bytes that are suitable to be used as a Nonce.
		  
		  Return RandomBytes(crypto_secretbox_NONCEBYTES)
		End Function
	#tag EndMethod


	#tag Note, Name = Usage
		This class contains a symmetric key for use with secret key encryption and message authentication. Encryption, 
		decryption, and MAC generation/validation use the same key, so it must be kept secret at all times.
		
		You may use a SecretKey with these utility methods:
		
		  * libsodium.SKI.EncryptData: Encrypt a message and generate its MAC; the MAC is prepended to the 
		    encrypted message and returned.
		  * libsodium.SKI.DecryptData: Authenticate the MAC and return the decrypted the message.
		  * libsodium.SKI.GenerateMAC: Generate a MAC for an unencrypted message.
		  * libsodium.SKI.VerifyMAC: Authenticate a MAC for an unencrypted message.
		
		Encryption is done using the XSalsa20 stream cipher. Message authentication uses Poly1305 authentication codes.
		
		
		To generate a brand new secret key use the SecretKey.Generate() shared method:
		
		     Dim sk As libsodium.SKI.SecretKey
		     sk = sk.Generate()
		
		To derive a secret key from a password use the Constructor method. Derivation requires a random salt, which you 
		should get from the Password.RandomSalt() shared method:
		
		     Dim pw As libsodium.Password = "seekrit"
		     Dim salt As MemoryBlock = pw.RandomSalt()
		     Dim sk As New libsodium.SKI.SecretKey(pw, salt)
		
		
		Encryption/decryption needs a Nonce value to work. Use the SecretKey.RandomNonce shared method to generate
		securely random nonces (continuing from the above code): 
		
		    Dim n As MemoryBlock = sk.RandomNonce()
		    Dim msg As MemoryBlock = libsodium.SKI.EncryptData("Hello, world!", sk, n)
		    MsgBox(libsodium.SKI.DecryptData(msg, sk, n))
	#tag EndNote


	#tag Constant, Name = ExportPrefix, Type = String, Dynamic = False, Default = \"-----BEGIN XSALSA20 KEY BLOCK-----", Scope = Private
	#tag EndConstant

	#tag Constant, Name = ExportSuffix, Type = String, Dynamic = False, Default = \"-----END XSALSA20 KEY BLOCK-----", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
