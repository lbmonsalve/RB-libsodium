#tag Module
Protected Module libsodium
	#tag Method, Flags = &h0
		Sub AllowSwap(Extends m As MemoryBlock, Size As Int32 = -1, Assigns Allow As Boolean)
		  If Not libsodium.IsAvailable Then Raise New SodiumException(ERR_UNAVAILABLE)
		  
		  If Size = -1 Then Size = m.Size
		  If Size = -1 Then Raise New SodiumException(ERR_OUT_OF_RANGE)
		  If Allow Then
		    If sodium_munlock(m, Size) <> 0 Then Raise New SodiumException(ERR_LOCK_DENIED)
		  Else
		    If sodium_mlock(m, Size) <> 0 Then Raise New SodiumException(ERR_LOCK_DENIED)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Argon2(InputData As MemoryBlock) As String
		  ' Generates an Argon2 digest of the InputData
		  ' https://download.libsodium.org/doc/password_hashing/the_argon2i_function.html
		  
		  Dim p As New libsodium.Password(InputData)
		  Return p.GenerateHash(Password.ALG_ARGON2)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CheckSize(Data As MemoryBlock, Expected As Int64, Upperbound As Int64 = 0)
		  Dim err As SodiumException
		  Select Case True
		  Case Data = Nil
		    Return
		  Case Upperbound > 0
		    err = New SodiumException(ERR_OUT_OF_RANGE)
		    err.Message = err.Message + " (Needs: " + Format(Expected, "############0") + "-" + Format(Upperbound, "############0") + "; Got: " + Format(Data.Size, "############0") + ")"
		  Case Data.Size <> Expected
		    err = New SodiumException(ERR_SIZE_MISMATCH)
		    err.Message = err.Message + " (Needs: " + Format(Expected, "############0") + "; Got: " + Format(Data.Size, "############0") + ")"
		  End Select
		  
		  If err <> Nil Then Raise err
		End Sub
	#tag EndMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_generichash_final Lib "libsodium" (State As Ptr, OutputBuffer As Ptr, OutputSize As UInt64) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_generichash_init Lib "libsodium" (State As Ptr, Key As Ptr, KeySize As Int64, OutLength As Int64) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_generichash_statebytes Lib "libsodium" () As UInt64
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_generichash_update Lib "libsodium" (State As Ptr, InputBuffer As Ptr, InputSize As UInt64) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_hash_sha256_final Lib "libsodium" (State As Ptr, OutputBuffer As Ptr) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_hash_sha256_init Lib "libsodium" (State As Ptr) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_hash_sha256_statebytes Lib "libsodium" () As UInt64
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_hash_sha256_update Lib "libsodium" (State As Ptr, InputBuffer As Ptr, InputSize As UInt64) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_hash_sha512_final Lib "libsodium" (State As Ptr, OutputBuffer As Ptr) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_hash_sha512_init Lib "libsodium" (State As Ptr) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_hash_sha512_statebytes Lib "libsodium" () As UInt64
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_hash_sha512_update Lib "libsodium" (State As Ptr, InputBuffer As Ptr, InputSize As UInt64) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_pwhash Lib "libsodium" (OutBuffer As Ptr, OutSize As UInt64, Passwd As Ptr, PasswdSize As UInt64, SaltBuffer As Ptr, OpsLimit As UInt64, MemLimit As UInt64, Algorithm As Int32) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_pwhash_scryptsalsa208sha256 Lib "libsodium" (OutBuffer As Ptr, OutSize As UInt64, Passwd As Ptr, PasswdSize As UInt64, SaltBuffer As Ptr, OpsLimit As UInt64, MemLimit As UInt64) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_pwhash_scryptsalsa208sha256_str Lib "libsodium" (Buffer As Ptr, Passwd As Ptr, PasswdSize As UInt64, OpsLimit As UInt64, MemLimit As UInt64) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_pwhash_scryptsalsa208sha256_str_verify Lib "libsodium" (Hash As Ptr, Passwd As Ptr, PasswdSize As UInt64) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_pwhash_str Lib "libsodium" (Buffer As Ptr, Passwd As Ptr, PasswdSize As UInt64, OpsLimit As UInt64, MemLimit As UInt64) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_pwhash_str_verify Lib "libsodium" (Hash As Ptr, Passwd As Ptr, PasswdSize As UInt64) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_shorthash Lib "libsodium" (Buffer As Ptr, InputData As Ptr, InputDataSize As UInt64, Key As Ptr) As UInt32
	#tag EndExternalMethod

	#tag Method, Flags = &h1
		Protected Function DecodeHex(HexData As MemoryBlock, IgnoredChars As String = "") As MemoryBlock
		  ' decodes ASCII hexadecimal to Binary. On error, returns Nil. IgnoredChars
		  ' is an optional string of characters to skip when interpreting the HexData
		  ' https://download.libsodium.org/doc/helpers/#hexadecimal-encodingdecoding
		  
		  If Not libsodium.IsAvailable Then Raise New SodiumException(ERR_UNAVAILABLE)
		  Dim output As New MemoryBlock(HexData.Size * 2 + 1)
		  Dim endhex As Ptr
		  Dim ign As MemoryBlock = IgnoredChars + Chr(0)
		  Dim sz As UInt32 = output.Size
		  If sodium_hex2bin(output, output.Size, HexData, HexData.Size, ign, sz, endhex) = 0 Then
		    Return output.StringValue(0, sz)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function EncodeHex(BinaryData As MemoryBlock, ToUppercase As Boolean = True) As MemoryBlock
		  ' Encodes the BinaryData as ASCII hexadecimal
		  ' https://download.libsodium.org/doc/helpers/#hexadecimal-encodingdecoding
		  
		  If Not libsodium.IsAvailable Then Raise New SodiumException(ERR_UNAVAILABLE)
		  Dim output As New MemoryBlock(BinaryData.Size * 2 + 1)
		  If sodium_bin2hex(output, output.Size, BinaryData, BinaryData.Size) <> Nil Then
		    If ToUppercase Then
		      Return output.CString(0).Uppercase
		    Else
		      Return output.CString(0)
		    End If
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GenericHash(InputData As MemoryBlock, Key As MemoryBlock = Nil, HashSize As UInt32 = libsodium.crypto_generichash_BYTES_MAX) As String
		  ' Generates a 512-bit BLAKE2b digest of the InputData, optionally using the specified key.
		  ' https://download.libsodium.org/doc/hashing/generic_hashing.html
		  
		  Dim h As GenericHashDigest
		  If Key = Nil Then
		    h = New GenericHashDigest(Key, HashSize)
		  Else
		    h = New GenericHashDigest(HashType.Generic)
		  End If
		  h.Process(InputData)
		  Return h.Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsAvailable() As Boolean
		  ' Returns True if libsodium is available.
		  
		  Static available As Boolean
		  
		  If Not available Then available = System.IsFunctionAvailable("sodium_init", "libsodium")
		  If available Then 
		    If sodium_init() = -1 Then available = False
		  End If
		  Return available
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function RandomBytes(Count As UInt64) As MemoryBlock
		  ' Returns a MemoryBlock filled with Count bytes of cryptographically random data.
		  ' https://download.libsodium.org/doc/generating_random_data/
		  
		  If Not libsodium.IsAvailable Then Raise New SodiumException(ERR_UNAVAILABLE)
		  Dim mb As New MemoryBlock(Count)
		  randombytes_buf(mb, mb.Size)
		  Return mb
		End Function
	#tag EndMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Sub randombytes_buf Lib "libsodium" (Buffer As Ptr, BufferSize As UInt64)
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function randombytes_random Lib "libsodium" () As UInt32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function randombytes_uniform Lib "libsodium" (UpperBound As UInt32) As UInt32
	#tag EndExternalMethod

	#tag Method, Flags = &h1
		Protected Function RandomUInt32(Optional UpperBound As UInt32) As UInt32
		  ' Returns a random UInt32. If UpperBound is specified then the value will be 
		  ' less-than or equal-to UpperBound
		  ' https://download.libsodium.org/doc/generating_random_data/
		  
		  If Not libsodium.IsAvailable Then Raise New SodiumException(ERR_UNAVAILABLE)
		  If UpperBound = 0 Then
		    Return randombytes_random()
		  Else
		    Return randombytes_uniform(UpperBound)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function scrypt(InputData As MemoryBlock) As String
		  ' Generates a scrypt digest of the InputData
		  ' https://download.libsodium.org/doc/password_hashing/scrypt.html
		  
		  Dim p As New libsodium.Password(InputData)
		  Return p.GenerateHash(Password.ALG_SCRYPT)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SHA256(InputData As MemoryBlock) As String
		  ' Generates a SHA256 digest of the InputData
		  ' https://download.libsodium.org/doc/advanced/sha-2_hash_function.html
		  
		  Dim h As New GenericHashDigest(HashType.SHA256)
		  h.Process(InputData)
		  Return h.Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SHA512(InputData As MemoryBlock) As String
		  ' Generates a SHA256 digest of the InputData
		  ' https://download.libsodium.org/doc/advanced/sha-2_hash_function.html
		  
		  Dim h As New GenericHashDigest(HashType.SHA512)
		  h.Process(InputData)
		  Return h.Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ShortHash(InputData As MemoryBlock, Key As MemoryBlock) As UInt64
		  ' Generates a 64-bit hawsh of the InputData using the specified key. This method
		  ' outputs short but unpredictable (without knowing the secret key) values suitable 
		  ' for picking a list in a hash table for a given key.
		  ' https://download.libsodium.org/doc/hashing/short-input_hashing.html
		  
		  If Not libsodium.IsAvailable Then Raise New SodiumException(ERR_UNAVAILABLE)
		  CheckSize(Key, crypto_shorthash_KEYBYTES)
		  
		  Dim buffer As New MemoryBlock(crypto_shorthash_BYTES)
		  If crypto_shorthash(buffer, InputData, InputData.Size, Key) = 0 Then
		    Return buffer.UInt64Value(0)
		  End If
		End Function
	#tag EndMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Sub sodium_add Lib "libsodium" (BufferA As Ptr, BufferB As Ptr, Length As UInt64)
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function sodium_allocarray Lib "libsodium" (Count As UInt64, FieldSize As UInt64) As Ptr
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function sodium_bin2hex Lib "libsodium" (HexBuffer As Ptr, HexBufferLength As UInt32, BinBuffer As Ptr, BinBufferLength As UInt32) As Ptr
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function sodium_compare Lib "libsodium" (Buffer1 As Ptr, Buffer2 As Ptr, Lenfth As UInt64) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Sub sodium_free Lib "libsodium" (DataPtr As Ptr)
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function sodium_hex2bin Lib "libsodium" (BinBuffer As Ptr, BinBufferMaxLength As UInt32, HexBuffer As Ptr, HexBufferLength As UInt32, IgnoreChars As Ptr, ByRef BinBufferLength As UInt32, ByRef HexEnd As Ptr) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Sub sodium_increment Lib "libsodium" (Number As Ptr, Length As UInt64)
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function sodium_init Lib "libsodium" () As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function sodium_malloc Lib "libsodium" (Length As UInt64) As Ptr
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function sodium_memcmp Lib "libsodium" (Buffer1 As Ptr, Buffer2 As Ptr, Length As UInt64) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Sub sodium_memzero Lib "libsodium" (DataPtr As Ptr, Length As UInt64)
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function sodium_mlock Lib "libsodium" (Address As Ptr, Length As UInt64) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function sodium_mprotect_noaccess Lib "libsodium" (DataPtr As Ptr) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function sodium_mprotect_readonly Lib "libsodium" (DataPtr As Ptr) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function sodium_mprotect_readwrite Lib "libsodium" (DataPtr As Ptr) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function sodium_munlock Lib "libsodium" (Address As Ptr, Length As UInt64) As Int32
	#tag EndExternalMethod

	#tag Method, Flags = &h1
		Protected Function StrComp(String1 As String, String2 As String) As Boolean
		  ' Performs a constant-time binary comparison of the strings, and returns True if they are identical.
		  ' https://download.libsodium.org/doc/helpers/#constant-time-test-for-equality
		  
		  If Not libsodium.IsAvailable Then Raise New SodiumException(ERR_UNAVAILABLE)
		  
		  Dim mb1 As MemoryBlock = String1
		  Dim mb2 As MemoryBlock = String2
		  Return sodium_memcmp(mb1, mb2, Max(mb1.Size, mb2.Size)) = 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ZeroFill(Extends m As MemoryBlock, Size As Int32 = -1)
		  ' Zero-fill the MemoryBlock
		  
		  If Not libsodium.IsAvailable Then Raise New SodiumException(ERR_UNAVAILABLE)
		  
		  If m <> Nil Then
		    If Size = -1 Then Size = m.Size
		    sodium_memzero(m, Size)
		  End If
		End Sub
	#tag EndMethod


	#tag Constant, Name = crypto_auth_BYTES, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_auth_KEYBYTES, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_box_BEFORENMBYTES, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_box_BOXZEROBYTES, Type = Double, Dynamic = False, Default = \"16", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_box_MACBYTES, Type = Double, Dynamic = False, Default = \"16", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_box_NONCEBYTES, Type = Double, Dynamic = False, Default = \"24", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_box_PUBLICKEYBYTES, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_box_SECRETKEYBYTES, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_box_SEEDBYTES, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_box_ZEROBYTES, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_generichash_BYTES, Type = Double, Dynamic = False, Default = \"32", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = crypto_generichash_BYTES_MAX, Type = Double, Dynamic = False, Default = \"64", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = crypto_generichash_BYTES_MIN, Type = Double, Dynamic = False, Default = \"16", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = crypto_generichash_KEYBYTES, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_generichash_KEYBYTES_MAX, Type = Double, Dynamic = False, Default = \"64", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_generichash_KEYBYTES_MIN, Type = Double, Dynamic = False, Default = \"16", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_pwhash_SALTBYTES, Type = Double, Dynamic = False, Default = \"16", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_pwhash_STRBYTES, Type = Double, Dynamic = False, Default = \"128", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_scalarmult_BYTES, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_shorthash_BYTES, Type = Double, Dynamic = False, Default = \"8", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_shorthash_KEYBYTES, Type = Double, Dynamic = False, Default = \"16", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = crypto_sign_BYTES, Type = Double, Dynamic = False, Default = \"64", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_sign_PUBLICKEYBYTES, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_sign_SECRETKEYBYTES, Type = Double, Dynamic = False, Default = \"64", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_sign_SEEDBYTES, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = ERR_CANT_ALLOC, Type = Double, Dynamic = False, Default = \"-5", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ERR_COMPUTATION_FAILED, Type = Double, Dynamic = False, Default = \"-12", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ERR_CONVERSION_FAILED, Type = Double, Dynamic = False, Default = \"-18", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ERR_INIT_FAILED, Type = Double, Dynamic = False, Default = \"-2", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ERR_INVALID_STATE, Type = Double, Dynamic = False, Default = \"-11", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ERR_KEYDERIVE_FAILED, Type = Double, Dynamic = False, Default = \"-15", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ERR_KEYGEN_FAILED, Type = Double, Dynamic = False, Default = \"-14", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ERR_LOCK_DENIED, Type = Double, Dynamic = False, Default = \"-9", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ERR_OPSLIMIT, Type = Double, Dynamic = False, Default = \"-16", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ERR_OUT_OF_BOUNDS, Type = Double, Dynamic = False, Default = \"-10", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ERR_OUT_OF_RANGE, Type = Double, Dynamic = False, Default = \"-17", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ERR_PROTECT_FAILED, Type = Double, Dynamic = False, Default = \"-4", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ERR_READ_DENIED, Type = Double, Dynamic = False, Default = \"-7", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ERR_SIZE_MISMATCH, Type = Double, Dynamic = False, Default = \"-13", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ERR_TOO_LARGE, Type = Double, Dynamic = False, Default = \"-6", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ERR_UNAVAILABLE, Type = Double, Dynamic = False, Default = \"-3", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ERR_WRITE_DENIED, Type = Double, Dynamic = False, Default = \"-8", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = STRICT_CONVERT, Type = Boolean, Dynamic = False, Default = \"False", Scope = Private
	#tag EndConstant


	#tag Enum, Name = HashType, Type = Integer, Flags = &h1
		Generic
		  SHA256
		SHA512
	#tag EndEnum

	#tag Enum, Name = ProtectionLevel, Flags = &h1
		ReadWrite
		  ReadOnly
		NoAccess
	#tag EndEnum

	#tag Enum, Name = ResourceLimits, Type = Integer, Flags = &h1
		Sensitive
		  Moderate
		Interactive
	#tag EndEnum


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
			InitialValue="0"
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
End Module
#tag EndModule
