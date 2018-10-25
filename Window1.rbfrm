#tag Window
Begin Window Window1
   BackColor       =   &hFFFFFF
   Backdrop        =   ""
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   400
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   906309631
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   True
   Title           =   "libsodiumTest"
   Visible         =   True
   Width           =   600
   Begin BevelButton BevelButton1
      AcceptFocus     =   False
      AutoDeactivate  =   True
      BackColor       =   "&c00000000"
      Bevel           =   0
      Bold            =   False
      ButtonType      =   0
      Caption         =   "Test"
      CaptionAlign    =   3
      CaptionDelta    =   0
      CaptionPlacement=   1
      Enabled         =   True
      HasBackColor    =   False
      HasMenu         =   0
      Height          =   30
      HelpTag         =   ""
      Icon            =   ""
      IconAlign       =   0
      IconDX          =   0
      IconDY          =   0
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      MenuValue       =   0
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextColor       =   "&c00000000"
      TextFont        =   "System"
      TextSize        =   ""
      TextUnit        =   0
      Top             =   14
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   60
   End
   Begin TextArea TextArea1
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   True
      BackColor       =   &hFFFFFF
      Bold            =   ""
      Border          =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   324
      HelpTag         =   ""
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   ""
      Left            =   20
      LimitText       =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Mask            =   ""
      Multiline       =   True
      ReadOnly        =   ""
      Scope           =   0
      ScrollbarHorizontal=   ""
      ScrollbarVertical=   True
      Styled          =   True
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &h000000
      TextFont        =   "System"
      TextSize        =   16
      TextUnit        =   0
      Top             =   56
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   560
   End
End
#tag EndWindow

#tag WindowCode
#tag EndWindowCode

#tag Events BevelButton1
	#tag Event
		Sub Action()
		  TextArea1.AppendText "libsodium version: "+ libsodium.Version.VersionString+ EndOfLine+ EndOfLine
		  
		  TextArea1.AppendText "SKI Encryption AEAD:"+ EndOfLine
		  
		  If libsodium.Version.HasAESNI And libsodium.Version.HasPCLMul And libsodium.Version.HasAES256GCM Then
		    TextArea1.AppendText "AES256GCM:"+ EndOfLine
		    Dim key As libsodium.SKI.SecretKey
		    key = libsodium.SKI.AEAD.Generate(libsodium.SKI.AEAD.AEADType.AES256GCM) ' random key for example
		    Dim nonce As MemoryBlock = libsodium.SKI.AEAD.RandomNonce(libsodium.SKI.AEAD.AEADType.AES256GCM) ' must be stored/sent with the message
		    Dim ciphertext As MemoryBlock = libsodium.SKI.AEAD.EncryptData("test", key, nonce, "123456", libsodium.SKI.AEAD.AEADType.AES256GCM)
		    Dim cleartext As MemoryBlock = libsodium.SKI.AEAD.DecryptData(ciphertext, key, nonce, "123456", libsodium.SKI.AEAD.AEADType.AES256GCM)
		    Break
		  End If
		  
		  TextArea1.AppendText "ChaCha20Poly1305:"+ EndOfLine
		  Dim key As libsodium.SKI.SecretKey
		  key = libsodium.SKI.AEAD.Generate ' random key for example
		  Dim nonce As MemoryBlock = libsodium.SKI.AEAD.RandomNonce ' must be stored/sent with the message
		  Dim ciphertext As MemoryBlock = libsodium.SKI.AEAD.EncryptData("test", key, nonce, "123456")
		  Dim cleartext As MemoryBlock = libsodium.SKI.AEAD.DecryptData(ciphertext, key, nonce, "123456")
		  Break
		  
		  TextArea1.AppendText "ChaCha20Poly1305_IETF:"+ EndOfLine
		  key = libsodium.SKI.AEAD.Generate(libsodium.SKI.AEAD.AEADType.ChaCha20Poly1305_IETF) ' random key for example
		  nonce = libsodium.SKI.AEAD.RandomNonce(libsodium.SKI.AEAD.AEADType.ChaCha20Poly1305_IETF) ' must be stored/sent with the message
		  ciphertext = libsodium.SKI.AEAD.EncryptData("test", key, nonce, "123456", libsodium.SKI.AEAD.AEADType.ChaCha20Poly1305_IETF)
		  cleartext = libsodium.SKI.AEAD.DecryptData(ciphertext, key, nonce, "123456", libsodium.SKI.AEAD.AEADType.ChaCha20Poly1305_IETF)
		  Break
		  
		  TextArea1.AppendText "XChaCha20Poly1305_IETF:"+ EndOfLine
		  key = libsodium.SKI.AEAD.Generate(libsodium.SKI.AEAD.AEADType.XChaCha20Poly1305_IETF) ' random key for example
		  nonce = libsodium.SKI.AEAD.RandomNonce(libsodium.SKI.AEAD.AEADType.XChaCha20Poly1305_IETF) ' must be stored/sent with the message
		  ciphertext = libsodium.SKI.AEAD.EncryptData("test", key, nonce, "123456", libsodium.SKI.AEAD.AEADType.XChaCha20Poly1305_IETF)
		  cleartext = libsodium.SKI.AEAD.DecryptData(ciphertext, key, nonce, "123456", libsodium.SKI.AEAD.AEADType.XChaCha20Poly1305_IETF)
		  Break
		End Sub
	#tag EndEvent
#tag EndEvents
