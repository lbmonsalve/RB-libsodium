#tag Class
Class SecureMemoryBlock
	#tag Method, Flags = &h0
		Function BooleanValue(Offset As UInt64) As Boolean
		  If mProtectionLevel = libsodium.ProtectionLevel.NoAccess Then Raise New SodiumException(ERR_READ_DENIED)
		  Dim mb As MemoryBlock = mPtr
		  Return mb.BooleanValue(Offset)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BooleanValue(Offset As UInt64, Assigns NewBool As Boolean)
		  If mProtectionLevel <> libsodium.ProtectionLevel.ReadWrite Then Raise New SodiumException(ERR_WRITE_DENIED)
		  If Offset + 1 > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  Dim mb As MemoryBlock = mPtr
		  mb.BooleanValue(Offset) = NewBool
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ByteValue(Offset As UInt64) As Byte
		  If mProtectionLevel = libsodium.ProtectionLevel.NoAccess Then Raise New SodiumException(ERR_READ_DENIED)
		  If Offset + 1 > mSize Then Raise New SodiumException(ERR_OUT_OF_BOUNDS)
		  Dim mb As MemoryBlock = mPtr
		  Return mb.Byte(Offset)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ByteValue(Offset As UInt64, Assigns NewByte As Byte)
		  If mProtectionLevel <> libsodium.ProtectionLevel.ReadWrite Then Raise New SodiumException(ERR_WRITE_DENIED)
		  If Offset + 1 > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  Dim mb As MemoryBlock = mPtr
		  mb.Byte(Offset) = NewByte
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ColorValue(Offset As UInt64, Bits As Int32) As Color
		  If mProtectionLevel = libsodium.ProtectionLevel.NoAccess Then Raise New SodiumException(ERR_READ_DENIED)
		  If Offset + 4 > mSize Then Raise New SodiumException(ERR_OUT_OF_BOUNDS)
		  Dim mb As MemoryBlock = mPtr
		  Return mb.ColorValue(Offset, Bits)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ColorValue(Offset As UInt64, Bits As Int32, Assigns NewColor As Color)
		  If mProtectionLevel <> libsodium.ProtectionLevel.ReadWrite Then Raise New SodiumException(ERR_WRITE_DENIED)
		  If Offset + 4 > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  Dim mb As MemoryBlock = mPtr
		  mb.ColorValue(Offset, Bits) = NewColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(RealMB As Ptr, RealSize As UInt64)
		  If Not libsodium.IsAvailable Then Raise New SodiumException(ERR_UNAVAILABLE)
		  If RealMB = Nil Then Raise New NilObjectException
		  mPtr = RealMB
		  mFreeable = False
		  mSize = RealSize
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Size As UInt32)
		  If Not libsodium.IsAvailable Then Raise New SodiumException(ERR_UNAVAILABLE)
		  mPtr = sodium_malloc(Size)
		  If mPtr = Nil Then Raise New SodiumException(ERR_CANT_ALLOC)
		  mSize = Size
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CString(Offset As UInt64) As CString
		  If mProtectionLevel = libsodium.ProtectionLevel.NoAccess Then Raise New SodiumException(ERR_READ_DENIED)
		  Dim mb As MemoryBlock = mPtr
		  Return mb.CString(Offset)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CString(Offset As UInt64, Assigns NewString As CString)
		  If mProtectionLevel <> libsodium.ProtectionLevel.ReadWrite Then Raise New SodiumException(ERR_WRITE_DENIED)
		  #If RBVersion > 2014.021 Then
		    If Offset + CType(NewString, String).LenB > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  #else
		    If Offset + NewString.LenB > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  #Endif
		  Dim mb As MemoryBlock = mPtr
		  mb.CString(Offset) = NewString
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CurrencyValue(Offset As UInt64) As Currency
		  If mProtectionLevel = libsodium.ProtectionLevel.NoAccess Then Raise New SodiumException(ERR_READ_DENIED)
		  If Offset + 8 > mSize Then Raise New SodiumException(ERR_OUT_OF_BOUNDS)
		  Dim mb As MemoryBlock = mPtr
		  Return mb.CurrencyValue(Offset)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CurrencyValue(Offset As UInt64, Assigns NewCurrency As Currency)
		  If mProtectionLevel <> libsodium.ProtectionLevel.ReadWrite Then Raise New SodiumException(ERR_WRITE_DENIED)
		  If Offset + 8 > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  Dim mb As MemoryBlock = mPtr
		  mb.CurrencyValue(Offset) = NewCurrency
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  If mPtr <> Nil Then
		    If mFreeable Then
		      sodium_free(mPtr)
		    Else
		      Me.ZeroFill()
		    End If
		  End If
		  
		Finally
		  mPtr = Nil
		  mSize = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DoubleValue(Offset As UInt64) As Double
		  If mProtectionLevel = libsodium.ProtectionLevel.NoAccess Then Raise New SodiumException(ERR_READ_DENIED)
		  If Offset + 8 > mSize Then Raise New SodiumException(ERR_OUT_OF_BOUNDS)
		  Dim mb As MemoryBlock = mPtr
		  Return mb.DoubleValue(Offset)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoubleValue(Offset As UInt64, Assigns NewDouble As Double)
		  If mProtectionLevel <> libsodium.ProtectionLevel.ReadWrite Then Raise New SodiumException(ERR_WRITE_DENIED)
		  If Offset + 8 > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  Dim mb As MemoryBlock = mPtr
		  mb.DoubleValue(Offset) = NewDouble
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Int16Value(Offset As UInt64) As Int16
		  If mProtectionLevel = libsodium.ProtectionLevel.NoAccess Then Raise New SodiumException(ERR_READ_DENIED)
		  If Offset + 2 > mSize Then Raise New SodiumException(ERR_OUT_OF_BOUNDS)
		  Dim mb As MemoryBlock = mPtr
		  Return mb.Int16Value(Offset)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Int16Value(Offset As UInt64, Assigns NewInt As Int16)
		  If mProtectionLevel <> libsodium.ProtectionLevel.ReadWrite Then Raise New SodiumException(ERR_WRITE_DENIED)
		  If Offset + 2 > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  Dim mb As MemoryBlock = mPtr
		  mb.Int16Value(Offset) = NewInt
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Int32Value(Offset As UInt64) As Int32
		  If mProtectionLevel = libsodium.ProtectionLevel.NoAccess Then Raise New SodiumException(ERR_READ_DENIED)
		  If Offset + 4 > mSize Then Raise New SodiumException(ERR_OUT_OF_BOUNDS)
		  Dim mb As MemoryBlock = mPtr
		  Return mb.Int32Value(Offset)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Int32Value(Offset As UInt64, Assigns NewInt As Int32)
		  If mProtectionLevel <> libsodium.ProtectionLevel.ReadWrite Then Raise New SodiumException(ERR_WRITE_DENIED)
		  If Offset + 4 > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  Dim mb As MemoryBlock = mPtr
		  mb.Int32Value(Offset) = NewInt
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Int64Value(Offset As UInt64) As Int64
		  If mProtectionLevel = libsodium.ProtectionLevel.NoAccess Then Raise New SodiumException(ERR_READ_DENIED)
		  If Offset + 8 > mSize Then Raise New SodiumException(ERR_OUT_OF_BOUNDS)
		  Dim mb As MemoryBlock = mPtr
		  Return mb.Int64Value(Offset)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Int64Value(Offset As UInt64, Assigns NewInt As Int64)
		  If mProtectionLevel <> libsodium.ProtectionLevel.ReadWrite Then Raise New SodiumException(ERR_WRITE_DENIED)
		  If Offset + 8 > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  Dim mb As MemoryBlock = mPtr
		  mb.Int64Value(Offset) = NewInt
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsZero(Offset As Int32 = 0, Length As Int32 = - 1) As Boolean
		  ' This method returns True if the SecureMemoryBlock contains only zeros. It returns False
		  ' if non-zero bits are found. Execution time is constant for a given length.
		  
		  If mPtr = Nil Then Return True
		  If Offset < 0 Then Raise New SodiumException(ERR_OUT_OF_RANGE)
		  Dim p As Ptr
		  If Length < 0 Then Length = mSize
		  If Offset + Length > mSize Then Raise New SodiumException(ERR_OUT_OF_RANGE)
		  If Offset > 0 Then
		    p = Ptr(Integer(mPtr) + Offset)
		  Else
		    p = mPtr
		  End If
		  
		  Return sodium_is_zero(p, Length) = 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Long(Offset As UInt64) As Int32
		  Return Me.Int32Value(Offset)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Long(Offset As UInt64, Assigns NewInt As Int32)
		  Me.Int32Value(Offset) = NewInt
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(OtherMB As libsodium.SecureMemoryBlock) As Int32
		  Select Case True
		  Case OtherMB Is Nil
		    Return 1
		  Case libsodium.StrComp(Me.StringValue(0, Me.Size), OtherMB.StringValue(0, OtherMB.Size))
		    Return 0
		  Case OtherMB.Size = mSize
		    Return Sign(Int32(mPtr) - Int32(OtherMB.mPtr))
		  Else
		    Return Sign(mSize - UInt64(OtherMB.Size))
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(OtherMB As String) As Int32
		  If libsodium.StrComp(Me.StringValue(0, Me.Size), OtherMB) Then Return 0
		  If OtherMB.LenB < Me.Size Then Return 1
		  Return -1
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Convert() As String
		  Return Me.StringValue(0, mSize)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Operator_Convert(FromString As String)
		  If mPtr <> Nil Then Me.Destructor
		  Me.Constructor(FromString.LenB)
		  Me.StringValue(0, FromString.LenB) = FromString
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PString(Offset As UInt64) As PString
		  If mProtectionLevel = libsodium.ProtectionLevel.NoAccess Then Raise New SodiumException(ERR_READ_DENIED)
		  Dim mb As MemoryBlock = mPtr
		  Return mb.PString(Offset)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PString(Offset As UInt64, Assigns NewString As PString)
		  If mProtectionLevel <> libsodium.ProtectionLevel.ReadWrite Then Raise New SodiumException(ERR_WRITE_DENIED)
		  #If RBVersion > 2014.021 Then
		    If Offset + CType(NewString, String).LenB > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  #else
		    If Offset + NewString.LenB > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  #Endif
		  Dim mb As MemoryBlock = mPtr
		  mb.PString(Offset) = NewString
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SingleValue(Offset As UInt64) As Single
		  If mProtectionLevel = libsodium.ProtectionLevel.NoAccess Then Raise New SodiumException(ERR_READ_DENIED)
		  If Offset + 4 > mSize Then Raise New SodiumException(ERR_OUT_OF_BOUNDS)
		  Dim mb As MemoryBlock = mPtr
		  Return mb.SingleValue(Offset)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SingleValue(Offset As UInt64, Assigns NewInt As Single)
		  If mProtectionLevel <> libsodium.ProtectionLevel.ReadWrite Then Raise New SodiumException(ERR_WRITE_DENIED)
		  If Offset + 4 > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  Dim mb As MemoryBlock = mPtr
		  mb.SingleValue(Offset) = NewInt
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Size() As UInt64
		  Return mSize
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StringValue(Offset As UInt64, Length As UInt64) As MemoryBlock
		  If mProtectionLevel = libsodium.ProtectionLevel.NoAccess Then Raise New SodiumException(ERR_READ_DENIED)
		  Dim mb As MemoryBlock = mPtr
		  Return mb.StringValue(Offset, Length)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StringValue(Offset As UInt64, Length As UInt64, Assigns NewData As MemoryBlock)
		  If mProtectionLevel <> libsodium.ProtectionLevel.ReadWrite Then Raise New SodiumException(ERR_WRITE_DENIED)
		  If Offset + Length > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  Dim mb As MemoryBlock = mPtr
		  mb.StringValue(Offset, Length) = NewData
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UInt16Value(Offset As UInt64) As UInt16
		  If mProtectionLevel = libsodium.ProtectionLevel.NoAccess Then Raise New SodiumException(ERR_READ_DENIED)
		  If Offset + 2 > mSize Then Raise New SodiumException(ERR_OUT_OF_BOUNDS)
		  Dim mb As MemoryBlock = mPtr
		  Return mb.UInt16Value(Offset)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UInt16Value(Offset As UInt64, Assigns NewInt As UInt16)
		  If mProtectionLevel <> libsodium.ProtectionLevel.ReadWrite Then Raise New SodiumException(ERR_WRITE_DENIED)
		  If Offset + 2 > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  Dim mb As MemoryBlock = mPtr
		  mb.UInt16Value(Offset) = NewInt
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UInt32Value(Offset As UInt64) As UInt32
		  If mProtectionLevel = libsodium.ProtectionLevel.NoAccess Then Raise New SodiumException(ERR_READ_DENIED)
		  If Offset + 4 > mSize Then Raise New SodiumException(ERR_OUT_OF_BOUNDS)
		  Dim mb As MemoryBlock = mPtr
		  Return mb.UInt32Value(Offset)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UInt32Value(Offset As UInt64, Assigns NewInt As UInt32)
		  If mProtectionLevel <> libsodium.ProtectionLevel.ReadWrite Then Raise New SodiumException(ERR_WRITE_DENIED)
		  If Offset + 4 > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  Dim mb As MemoryBlock = mPtr
		  mb.UInt32Value(Offset) = NewInt
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UInt64Value(Offset As UInt64) As UInt64
		  If mProtectionLevel = libsodium.ProtectionLevel.NoAccess Then Raise New SodiumException(ERR_READ_DENIED)
		  If Offset + 8 > mSize Then Raise New SodiumException(ERR_OUT_OF_BOUNDS)
		  Dim mb As MemoryBlock = mPtr
		  Return mb.UInt64Value(Offset)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UInt64Value(Offset As UInt64, Assigns NewInt As UInt64)
		  If mProtectionLevel <> libsodium.ProtectionLevel.ReadWrite Then Raise New SodiumException(ERR_WRITE_DENIED)
		  If Offset + 8 > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  Dim mb As MemoryBlock = mPtr
		  mb.UInt64Value(Offset) = NewInt
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UInt8Value(Offset As UInt64) As UInt8
		  If mProtectionLevel = libsodium.ProtectionLevel.NoAccess Then Raise New SodiumException(ERR_READ_DENIED)
		  If Offset + 1 > mSize Then Raise New SodiumException(ERR_OUT_OF_BOUNDS)
		  Dim mb As MemoryBlock = mPtr
		  Return mb.UInt8Value(Offset)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UInt8Value(Offset As UInt64, Assigns NewInt As UInt8)
		  If mProtectionLevel <> libsodium.ProtectionLevel.ReadWrite Then Raise New SodiumException(ERR_WRITE_DENIED)
		  If Offset + 1 > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  Dim mb As MemoryBlock = mPtr
		  mb.UInt8Value(Offset) = NewInt
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UShortValue(Offset As UInt64) As UInt16
		  Return Me.UInt16Value(Offset)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UShortValue(Offset As UInt64, Assigns NewInt As UInt16)
		  Me.UInt16Value(Offset) = NewInt
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function WString(Offset As UInt64) As WString
		  If mProtectionLevel = libsodium.ProtectionLevel.NoAccess Then Raise New SodiumException(ERR_READ_DENIED)
		  Dim mb As MemoryBlock = mPtr
		  Return mb.WString(Offset)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WString(Offset As UInt64, Assigns NewString As WString)
		  If mProtectionLevel <> libsodium.ProtectionLevel.ReadWrite Then Raise New SodiumException(ERR_WRITE_DENIED)
		  #If RBVersion > 2014.021 Then
		    If Offset + CType(NewString, String).LenB > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  #else
		    If Offset + NewString.LenB > mSize Then Raise New SodiumException(ERR_TOO_LARGE)
		  #Endif
		  Dim mb As MemoryBlock = mPtr
		  mb.WString(Offset) = NewString
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ZeroFill(Offset As Int32 = 0, Length As Int32 = - 1)
		  ' This method fills the SecureMemoryBlock with zeroes, overwriting any previous data.
		  
		  If mPtr = Nil Then Return
		  If Offset < 0 Then Raise New SodiumException(ERR_OUT_OF_RANGE)
		  Dim p As Ptr
		  If Length < 0 Then Length = mSize
		  If Offset + Length > mSize Then Raise New SodiumException(ERR_OUT_OF_RANGE)
		  If Offset > 0 Then
		    p = Ptr(Integer(mPtr) + Offset)
		  Else
		    p = mPtr
		  End If
		  
		  sodium_memzero(p, Length)
		End Sub
	#tag EndMethod


	#tag Note, Name = About this class
		libsodium provides heap allocation features for storing sensitive data. These features are wrapped by this class in 
		a MemoryBlock-like interface. Memory allocations using this class are slower and require 3 or 4 extra pages of virtual memory.
		
		##Guard features
		The allocated region is placed at the end of a page boundary, immediately followed by a guard page. As a result, accessing 
		memory past the end of the region will immediately terminate the application.
		
		A canary is also placed right before the returned pointer. Modification of this canary is detected when trying to free the 
		allocated region in the Destructor, and will cause the application to immediately terminate.
		
		An additional guard page is placed before this canary to make it less likely for sensitive data to be accessible when reading 
		past the end of an unrelated region.
		
		The allocated region is filled with 0xd0 bytes in order to help catch bugs due to initialized data.
		
		Set the AllowSwap property to False to tell the OS not to swap the underlying memory pages to disk. On operating systems supporting 
		MAP_NOCORE or MADV_DONTDUMP, memory allocated this way will also not be part of core dumps. The OS limits the number of pages that 
		can be excluded from swap, so don't over-do it.
		
		The memory address will not be aligned if the allocation size is not a multiple of the required alignment. For this reason, 
		this class should not be used with packed or variable-length structures, unless the size given to the Constructor is rounded 
		up in order to ensure proper alignment.
		
		Allocating 0 bytes is a valid operation, and returns a pointer that can be successfully destroyed.
		
		Setting the ProtectionLevel property to ReadOnly or NoAccess will disallow any attempt to modify the memory. Setting it to
		NoAccess will also disallow any attempt to read its contents. If the attempt is made by calling one of this class's methods 
		then an exception will be raised. Access attempts that do not go through a class method will cause the the application to 
		terminate immediately.
		
		Call the ZeroFill method to fill the memory with null bytes. This will be done automatically by the Destructor.
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mAllowSwap
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Dim i As Int32
			  If value Then
			    i = sodium_munlock(mPtr, mSize)
			  Else
			    i = sodium_mlock(mPtr, mSize)
			  End If
			  If i = -1 Then Raise New SodiumException(ERR_LOCK_DENIED)
			  mAllowSwap = value
			End Set
		#tag EndSetter
		AllowSwap As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  #If DebugBuild Then
			    If mProtectionLevel = libsodium.ProtectionLevel.NoAccess Then Return New MemoryBlock(mSize)
			    Return Me.StringValue(0, Me.Size)
			  #endif
			End Get
		#tag EndGetter
		Private Contents As MemoryBlock
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mAllowSwap As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFreeable As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mProtectionLevel As libsodium.ProtectionLevel = libsodium.ProtectionLevel.ReadWrite
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mPtr As Ptr
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSize As UInt64
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mProtectionLevel
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Dim i As Int32
			  Select Case value
			  Case libsodium.ProtectionLevel.ReadWrite
			    i = sodium_mprotect_readwrite(mPtr)
			  Case libsodium.ProtectionLevel.ReadOnly
			    i = sodium_mprotect_readonly(mPtr)
			  Case libsodium.ProtectionLevel.NoAccess
			    i = sodium_mprotect_noaccess(mPtr)
			  End Select
			  If i = -1 Then Raise New SodiumException(ERR_PROTECT_FAILED)
			  mProtectionLevel = value
			End Set
		#tag EndSetter
		ProtectionLevel As libsodium.ProtectionLevel
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="AllowSwap"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
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
End Class
#tag EndClass
