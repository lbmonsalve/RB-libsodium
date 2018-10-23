#tag Module
Protected Module SKI
	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_aead_aes256gcm_decrypt Lib "libsodium" (Buffer As Ptr, ByRef BufferLength As UInt64, nsec As Ptr, Message As Ptr, MessageLength As UInt64, AddicionalData As Ptr, AdicionalDataLength As UInt64, Nonce As Ptr, SecretKey As Ptr) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_aead_aes256gcm_encrypt Lib "libsodium" (Buffer As Ptr, ByRef BufferLength As UInt64, Message As Ptr, MessageLength As UInt64, AddicionalData As Ptr, AdicionalDataLength As UInt64, nsec As Ptr, Nonce As Ptr, SecretKey As Ptr) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_aead_chacha20poly1305_decrypt Lib "libsodium" (Buffer As Ptr, ByRef BufferLength As UInt64, nsec As Ptr, Message As Ptr, MessageLength As UInt64, AddicionalData As Ptr, AdicionalDataLength As UInt64, Nonce As Ptr, SecretKey As Ptr) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_aead_chacha20poly1305_encrypt Lib "libsodium" (Buffer As Ptr, ByRef BufferLength As UInt64, Message As Ptr, MessageLength As UInt64, AddicionalData As Ptr, AdicionalDataLength As UInt64, nsec As Ptr, Nonce As Ptr, SecretKey As Ptr) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_aead_chacha20poly1305_ietf_decrypt Lib "libsodium" (Buffer As Ptr, ByRef BufferLength As UInt64, nsec As Ptr, Message As Ptr, MessageLength As UInt64, AddicionalData As Ptr, AdicionalDataLength As UInt64, Nonce As Ptr, SecretKey As Ptr) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_aead_chacha20poly1305_ietf_encrypt Lib "libsodium" (Buffer As Ptr, ByRef BufferLength As UInt64, Message As Ptr, MessageLength As UInt64, AddicionalData As Ptr, AdicionalDataLength As UInt64, nsec As Ptr, Nonce As Ptr, SecretKey As Ptr) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_aead_xchacha20poly1305_ietf_decrypt Lib "libsodium" (Buffer As Ptr, ByRef BufferLength As UInt64, nsec As Ptr, Message As Ptr, MessageLength As UInt64, AddicionalData As Ptr, AdicionalDataLength As UInt64, Nonce As Ptr, SecretKey As Ptr) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_aead_xchacha20poly1305_ietf_encrypt Lib "libsodium" (Buffer As Ptr, ByRef BufferLength As UInt64, Message As Ptr, MessageLength As UInt64, AddicionalData As Ptr, AdicionalDataLength As UInt64, nsec As Ptr, Nonce As Ptr, SecretKey As Ptr) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_auth Lib "libsodium" (Buffer As Ptr, Message As Ptr, MessageLength As UInt64, SecretKey As Ptr) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_auth_verify Lib "libsodium" (Signature As Ptr, Message As Ptr, MessageLength As UInt64, SecretKey As Ptr) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_secretbox_easy Lib "libsodium" (Buffer As Ptr, Message As Ptr, MessageLength As UInt64, Nonce As Ptr, SecretKey As Ptr) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function crypto_secretbox_open_easy Lib "libsodium" (Buffer As Ptr, Message As Ptr, MessageLength As UInt64, Nonce As Ptr, SecretKey As Ptr) As Int32
	#tag EndExternalMethod

	#tag Method, Flags = &h1
		Protected Function DecryptData(CipherText As MemoryBlock, Key As libsodium.SKI.SecretKey, Nonce As MemoryBlock) As MemoryBlock
		  ' Decrypts the CipherText using the XSalsa20 stream cipher with the specified Key and Nonce. A
		  ' Poly1305 message authentication code is prepended by the EncryptData method and will be
		  ' validated by this method. The decrypted data is returned on success. On error returns Nil.
		  '
		  ' See:
		  ' https://download.libsodium.org/doc/secret-key_cryptography/authenticated_encryption.html#combined-mode
		  ' https://github.com/charonn0/RB-libsodium/wiki/libsodium.SKI.DecryptData
		  
		  Return DecryptData(CipherText, Key.Value, Nonce)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function DecryptData(CipherText As MemoryBlock, AdditionalData As MemoryBlock, Key As libsodium.SKI.SecretKey, Nonce As MemoryBlock, constructionType As TypeConstruction= TypeConstruction.ChaCha20_Poly1305) As MemoryBlock
		  ' Decrypts the CipherText using the XSalsa20 stream cipher with the specified Key and Nonce. A
		  ' Poly1305 message authentication code is prepended by the EncryptData method and will be
		  ' validated by this method. The decrypted data is returned on success. On error returns Nil.
		  '
		  ' See:
		  ' https://download.libsodium.org/doc/secret-key_cryptography/authenticated_encryption.html#combined-mode
		  ' https://github.com/charonn0/RB-libsodium/wiki/libsodium.SKI.DecryptData
		  
		  Return DecryptData(CipherText, AdditionalData, Key.Value, Nonce, constructionType)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DecryptData(CipherText As MemoryBlock, Key As MemoryBlock, Nonce As MemoryBlock) As MemoryBlock
		  If Left(CipherText, 5) = "-----" Then
		    If Nonce = Nil Then
		      CipherText = libsodium.Exporting.DecodeMessage(CipherText, Nonce)
		    Else
		      CipherText = libsodium.Exporting.DecodeMessage(CipherText)
		    End If
		  End If
		  CheckSize(Nonce, crypto_secretbox_NONCEBYTES)
		  CheckSize(Key, crypto_secretbox_KEYBYTES)
		  
		  Dim buffer As New MemoryBlock(CipherText.Size - crypto_secretbox_MACBYTES)
		  If crypto_secretbox_open_easy(Buffer, CipherText, CipherText.Size, Nonce, Key) = 0 Then
		    Return buffer
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DecryptData(CipherText As MemoryBlock, AdditionalData As MemoryBlock, Key As MemoryBlock, Nonce As MemoryBlock, constructionType As TypeConstruction= TypeConstruction.ChaCha20_Poly1305) As MemoryBlock
		  If Left(CipherText, 5) = "-----" Then
		    If Nonce = Nil Then
		      CipherText = libsodium.Exporting.DecodeMessage(CipherText, Nonce)
		    Else
		      CipherText = libsodium.Exporting.DecodeMessage(CipherText)
		    End If
		  End If
		  If constructionType= TypeConstruction.ChaCha20_Poly1305 Then
		    CheckSize(Nonce, crypto_aead_chacha20poly1305_NPUBBYTES)
		    CheckSize(Key, crypto_aead_chacha20poly1305_KEYBYTES)
		    
		    Dim buffer As New MemoryBlock(CipherText.Size - crypto_aead_chacha20poly1305_ABYTES)
		    Dim bufferLength As UInt64= buffer.Size
		    
		    If crypto_aead_chacha20poly1305_decrypt(Buffer, bufferLength, Nil, CipherText, CipherText.Size, AdditionalData, AdditionalData.Size, Nonce, Key) = 0 Then
		      Return buffer
		    End If
		  ElseIf constructionType= TypeConstruction.ChaCha20_Poly1305_IETF Then
		    CheckSize(Nonce, crypto_aead_chacha20poly1305_ietf_NPUBBYTES)
		    CheckSize(Key, crypto_aead_chacha20poly1305_ietf_KEYBYTES)
		    
		    Dim buffer As New MemoryBlock(CipherText.Size - crypto_aead_chacha20poly1305_ietf_ABYTES)
		    Dim bufferLength As UInt64= buffer.Size
		    
		    If crypto_aead_chacha20poly1305_ietf_decrypt(Buffer, bufferLength, Nil, CipherText, CipherText.Size, AdditionalData, AdditionalData.Size, Nonce, Key) = 0 Then
		      Return buffer
		    End If
		  ElseIf constructionType= TypeConstruction.XChaCha20_Poly1305_IETF Then
		    CheckSize(Nonce, crypto_aead_xchacha20poly1305_ietf_NPUBBYTES)
		    CheckSize(Key, crypto_aead_xchacha20poly1305_ietf_KEYBYTES)
		    
		    Dim buffer As New MemoryBlock(CipherText.Size - crypto_aead_xchacha20poly1305_ietf_ABYTES)
		    Dim bufferLength As UInt64= buffer.Size
		    
		    If crypto_aead_xchacha20poly1305_ietf_decrypt(Buffer, bufferLength, Nil, CipherText, CipherText.Size, AdditionalData, AdditionalData.Size, Nonce, Key) = 0 Then
		      Return buffer
		    End If
		  ElseIf constructionType= TypeConstruction.AES256_GCM Then
		    CheckSize(Nonce, crypto_aead_aes256gcm_NPUBBYTES)
		    CheckSize(Key, crypto_aead_aes256gcm_KEYBYTES)
		    
		    Dim buffer As New MemoryBlock(CipherText.Size - crypto_aead_aes256gcm_ABYTES)
		    Dim bufferLength As UInt64= buffer.Size
		    
		    If crypto_aead_aes256gcm_decrypt(Buffer, bufferLength, Nil, CipherText, CipherText.Size, AdditionalData, AdditionalData.Size, Nonce, Key) = 0 Then
		      Return buffer
		    End If
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function EncryptData(ClearText As MemoryBlock, Key As libsodium.SKI.SecretKey, Nonce As MemoryBlock, Exportable As Boolean = False) As MemoryBlock
		  ' Encrypts the ClearText using the XSalsa20 stream cipher with the specified Key and Nonce. A
		  ' Poly1305 message authentication code is also generated and prepended to the returned encrypted
		  ' data. On error returns Nil.
		  '
		  ' See:
		  ' https://download.libsodium.org/doc/secret-key_cryptography/authenticated_encryption.html#combined-mode
		  ' https://github.com/charonn0/RB-libsodium/wiki/libsodium.SKI.EncryptData
		  
		  If Nonce = Nil And Exportable Then Nonce = Key.RandomNonce()
		  Return EncryptData(ClearText, Key.Value, Nonce, Exportable)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function EncryptData(ClearText As MemoryBlock, AdditionalData As MemoryBlock, Key As libsodium.SKI.SecretKey, Nonce As MemoryBlock, Exportable As Boolean = False, constructionType As TypeConstruction= TypeConstruction.ChaCha20_Poly1305) As MemoryBlock
		  ' Encrypts the ClearText using the XSalsa20 stream cipher with the specified Key and Nonce. A
		  ' Poly1305 message authentication code is also generated and prepended to the returned encrypted
		  ' data. On error returns Nil.
		  '
		  ' See:
		  ' https://download.libsodium.org/doc/secret-key_cryptography/authenticated_encryption.html#combined-mode
		  ' https://github.com/charonn0/RB-libsodium/wiki/libsodium.SKI.EncryptData
		  
		  If Nonce = Nil And Exportable Then Nonce = Key.RandomNonce(constructionType)
		  Return EncryptData(ClearText, AdditionalData, Key.Value, Nonce, Exportable, constructionType)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncryptData(ClearText As MemoryBlock, Key As MemoryBlock, Nonce As MemoryBlock, Exportable As Boolean = False) As MemoryBlock
		  CheckSize(Nonce, crypto_secretbox_NONCEBYTES)
		  CheckSize(Key, crypto_secretbox_KEYBYTES)
		  
		  Dim buffer As New MemoryBlock(ClearText.Size + crypto_secretbox_MACBYTES)
		  If crypto_secretbox_easy(buffer, ClearText, ClearText.Size, Nonce, Key) = 0 Then
		    If Exportable Then buffer = libsodium.Exporting.EncodeMessage(buffer, Nonce)
		    Return buffer
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncryptData(ClearText As MemoryBlock, AdditionalData As MemoryBlock, Key As MemoryBlock, Nonce As MemoryBlock, Exportable As Boolean = False, constructionType As TypeConstruction= TypeConstruction.ChaCha20_Poly1305) As MemoryBlock
		  If constructionType= TypeConstruction.ChaCha20_Poly1305 Then
		    CheckSize(Nonce, crypto_aead_chacha20poly1305_NPUBBYTES)
		    CheckSize(Key, crypto_aead_chacha20poly1305_KEYBYTES)
		    
		    Dim buffer As New MemoryBlock(ClearText.Size + crypto_aead_chacha20poly1305_ABYTES)
		    Dim bufferLength As UInt64= buffer.Size
		    
		    If crypto_aead_chacha20poly1305_encrypt(buffer, bufferLength, ClearText, ClearText.Size, AdditionalData, AdditionalData.Size, Nil, Nonce, Key) = 0 Then
		      If Exportable Then buffer = libsodium.Exporting.EncodeMessage(buffer, Nonce)
		      Return buffer
		    End If
		  ElseIf constructionType= TypeConstruction.ChaCha20_Poly1305_IETF Then
		    CheckSize(Nonce, crypto_aead_chacha20poly1305_ietf_NPUBBYTES)
		    CheckSize(Key, crypto_aead_chacha20poly1305_ietf_KEYBYTES)
		    
		    Dim buffer As New MemoryBlock(ClearText.Size + crypto_aead_chacha20poly1305_ietf_ABYTES)
		    Dim bufferLength As UInt64= buffer.Size
		    
		    If crypto_aead_chacha20poly1305_ietf_encrypt(buffer, bufferLength, ClearText, ClearText.Size, AdditionalData, AdditionalData.Size, Nil, Nonce, Key) = 0 Then
		      If Exportable Then buffer = libsodium.Exporting.EncodeMessage(buffer, Nonce)
		      Return buffer
		    End If
		  ElseIf constructionType= TypeConstruction.XChaCha20_Poly1305_IETF Then
		    CheckSize(Nonce, crypto_aead_xchacha20poly1305_ietf_NPUBBYTES)
		    CheckSize(Key, crypto_aead_xchacha20poly1305_ietf_KEYBYTES)
		    
		    Dim buffer As New MemoryBlock(ClearText.Size + crypto_aead_xchacha20poly1305_ietf_ABYTES)
		    Dim bufferLength As UInt64= buffer.Size
		    
		    If crypto_aead_xchacha20poly1305_ietf_encrypt(buffer, bufferLength, ClearText, ClearText.Size, AdditionalData, AdditionalData.Size, Nil, Nonce, Key) = 0 Then
		      If Exportable Then buffer = libsodium.Exporting.EncodeMessage(buffer, Nonce)
		      Return buffer
		    End If
		  ElseIf constructionType= TypeConstruction.AES256_GCM Then
		    'If Not System.IsFunctionAvailable("crypto_aead_aes256gcm_encrypt", "libsodium") Then Break
		    
		    CheckSize(Nonce, crypto_aead_aes256gcm_NPUBBYTES)
		    CheckSize(Key, crypto_aead_aes256gcm_KEYBYTES)
		    
		    Dim buffer As New MemoryBlock(ClearText.Size + crypto_aead_aes256gcm_ABYTES)
		    Dim bufferLength As UInt64= buffer.Size
		    
		    If crypto_aead_aes256gcm_encrypt(buffer, bufferLength, ClearText, ClearText.Size, AdditionalData, AdditionalData.Size, Nil, Nonce, Key) = 0 Then
		      If Exportable Then buffer = libsodium.Exporting.EncodeMessage(buffer, Nonce)
		      Return buffer
		    End If
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GenerateMAC(Message As MemoryBlock, Key As libsodium.SKI.SecretKey, Exportable As Boolean = False) As MemoryBlock
		  ' Generate a HMAC-SHA512256 authentication code for the Message using SecretKey.
		  ' See: https://download.libsodium.org/doc/secret-key_cryptography/secret-key_authentication.html
		  
		  CheckSize(Key.Value, crypto_auth_KEYBYTES)
		  
		  Dim signature As New MemoryBlock(crypto_auth_BYTES)
		  If crypto_auth(signature, Message, Message.Size, Key.Value) = 0 Then
		    If Exportable Then signature = libsodium.Exporting.Export(signature, libsodium.Exporting.ExportableType.HMAC)
		    Return signature
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function VerifyMAC(MAC As MemoryBlock, Message As MemoryBlock, Key As libsodium.SKI.SecretKey) As Boolean
		  ' Validate a HMAC-SHA512256 authentication code for the Message that was generated using SecretKey
		  ' See: https://download.libsodium.org/doc/secret-key_cryptography/secret-key_authentication.html
		  
		  CheckSize(Key.Value, crypto_auth_KEYBYTES)
		  If Left(MAC, 5) = "-----" Then MAC = libsodium.Exporting.Import(MAC)
		  If Left(Message, 5) = "-----" Then Message = libsodium.Exporting.Import(Message)
		  Return crypto_auth_verify(MAC, Message, Message.Size, Key.Value) = 0
		End Function
	#tag EndMethod


	#tag Constant, Name = crypto_aead_aes256gcm_ABYTES, Type = Double, Dynamic = False, Default = \"16", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_aead_aes256gcm_KEYBYTES, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_aead_aes256gcm_NPUBBYTES, Type = Double, Dynamic = False, Default = \"12", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_aead_chacha20poly1305_ABYTES, Type = Double, Dynamic = False, Default = \"16", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_aead_chacha20poly1305_ietf_ABYTES, Type = Double, Dynamic = False, Default = \"16", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_aead_chacha20poly1305_ietf_KEYBYTES, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_aead_chacha20poly1305_ietf_NPUBBYTES, Type = Double, Dynamic = False, Default = \"12", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_aead_chacha20poly1305_KEYBYTES, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_aead_chacha20poly1305_NPUBBYTES, Type = Double, Dynamic = False, Default = \"8", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_aead_xchacha20poly1305_ietf_ABYTES, Type = Double, Dynamic = False, Default = \"16", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_aead_xchacha20poly1305_ietf_KEYBYTES, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_aead_xchacha20poly1305_ietf_NPUBBYTES, Type = Double, Dynamic = False, Default = \"24", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_auth_BYTES, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_auth_KEYBYTES, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_secretbox_KEYBYTES, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_secretbox_MACBYTES, Type = Double, Dynamic = False, Default = \"16", Scope = Private
	#tag EndConstant

	#tag Constant, Name = crypto_secretbox_NONCEBYTES, Type = Double, Dynamic = False, Default = \"24", Scope = Private
	#tag EndConstant


	#tag Enum, Name = TypeConstruction, Type = Integer, Flags = &h1
		AES256_GCM
		  XSalsa20_Poly1305
		  ChaCha20_Poly1305
		  ChaCha20_Poly1305_IETF
		XChaCha20_Poly1305_IETF
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
