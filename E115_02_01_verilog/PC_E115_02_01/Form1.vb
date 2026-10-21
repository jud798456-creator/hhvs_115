'creator by HGL,2026.07.xx

'全國高級中等學校 115 學年度工業類科學生技藝競賽
'數位電子術科參考試題二
'試題名稱： 限量商品產銷管理系統

'電腦端軟體:E112術科比賽題目\E112_02_END\PC_E112_02_01
'配合硬體:E112術科比賽題目\E112_02_END\E112_02_01

'請使用秉華科技有限公司 TEL:04-26528352 www.be-friend.com.tw
'產品編號:BF-CYC3-S40APVC (EP3C40Q240C8N 50MHz LEs:39,600 Mbit:1,161,216 PINs:129)

Imports System.Threading
Imports System.IO.Ports

Public Class Form1
    Dim 灰色 As Color = Color.DarkGray
    Dim 深灰色 As Color = Color.Gray
    Dim 淺灰色 As Color
    Dim 黃色 As Color = Color.Yellow
    Dim keydownok As Boolean = False
    Dim 密碼長度 As Int16 = 4
    Dim 連線測試次數 As Int16
    Public aaa As String
    'Dim 深灰色2 As Color 
    '
    Dim 上鎖 As Byte '0:全上鎖, 1:解鎖
    'Dim button1_12(12) As Object ' Object 'or Control:物件收集

    'Form1_Load 初始化
    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim rs232ok As Boolean = False
        Dim i As Integer = 1

        AddHandler SerialPort1.DataReceived, AddressOf SerialPort1_read

        '搜尋RS232介面
        While Not rs232ok
            Try
                SerialPort1.PortName = "COM" & i
                SerialPort1.Open()
                If MessageBox.Show("已找到可用的" & "COM" & i & " RS232介面" & vbNewLine & "是否要使用?", "搜尋RS232介面", MessageBoxButtons.OKCancel) = Windows.Forms.DialogResult.OK Then
                    rs232ok = True
                    Me.Text &= "(使用COM" & i & ")"
                Else
                    SerialPort1.Close()
                End If
            Catch ex As Exception
                If i > 50 Then
                    MessageBox.Show("已找不到可用的RS232介面", "搜尋RS232介面", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    End '程式結束
                End If
            End Try
            i += 1
        End While

        淺灰色 = 訂單ID.BackColor
        '密碼.Text = ""

        For Each B As Object In Me.Panel1.Controls ' or  For Each B As Control In Me.Panel1.Controls
            If Mid(B.Name, 7) <> "" Then
                B.Text = Mid(B.Name, 7) Mod 10
            End If
            B.backcolor = 淺灰色
        Next

        ' Timer1.Enabled = True '啟動監測
        Label2.Select() '失焦
        上鎖 = 1 '上鎖

    End Sub

    '0~9、清除鍵 按下按鈕
    Private Sub Button1_12_MouseDown(ByVal sender As System.Object, ByVal e As System.EventArgs) _
    Handles Button1.MouseDown, Button2.MouseDown, Button3.MouseDown, Button4.MouseDown, Button5.MouseDown, Button6.MouseDown, _
            Button7.MouseDown, Button8.MouseDown, Button9.MouseDown, Button10.MouseDown, 清除.MouseDown ', 返回.MouseDown

        If Not keydownok Then
            If 上鎖 = 1 And MouseButtons = Windows.Forms.MouseButtons.Left Then
                If sender.Equals(清除) Then
                    訂單ID.Text = ""
                    訂購數量與出價金額.Text = ""
                    配額與付款總額.Text = ""
                    For Each B As Object In Me.Panel1.Controls ' or  For Each B As Control In Me.Panel1.Controls
                        B.backcolor = 淺灰色
                    Next
                Else

                    '不捲動寫法
                    訂單ID.Text = Microsoft.VisualBasic.Left(訂單ID.Text & sender.text, 密碼長度)

                    '捲動寫法
                    '密碼.Text = Microsoft.VisualBasic.Right(密碼.Text & sender.text, 密碼長度)

                End If
                sender.backcolor = 黃色
                keydownok = True
            End If
        End If
        Label2.Select() '失焦

    End Sub

    '放開按鈕
    Private Sub Button1_12_MouseUp(ByVal sender As System.Object, ByVal e As System.EventArgs) _
    Handles Button1.MouseUp, Button2.MouseUp, Button3.MouseUp, Button4.MouseUp, Button5.MouseUp, Button6.MouseUp, _
           Button7.MouseUp, Button8.MouseUp, Button9.MouseUp, Button10.MouseUp, 清除.MouseUp, 訂單.MouseUp, 連線.MouseUp

        If sender.backcolor = 黃色 And MouseButtons <> Windows.Forms.MouseButtons.Left Then
            sender.backcolor = 淺灰色
            keydownok = False
        End If
        Label2.Select() '失焦

    End Sub

    '沒有啟動了
    'FPGA->ESP8266 to PC
    Private Sub Timer1_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Timer1.Tick
        '--命令FPGA->ESP8266->PC:(1byte)指揮PC辦事
        '--固定長度1byte命令
        Dim 接收(0) As Byte '接收1byte
        訂購數量與出價金額.Text = ""
        Do While (SerialPort1.BytesToRead >= 1)
            SerialPort1.Read(接收, 0, 1) '接收1byte
            Select Case 接收(0)
                Case 0 'FPGA reset or 待機 命令
                    訂單ID.Text = ""
                    訂購數量與出價金額.Text = ""
                    配額與付款總額.Text = ""

                    For Each B As Object In Me.Panel1.Controls ' or  For Each B As Control In Me.Panel1.Controls
                        B.backcolor = 淺灰色
                    Next
                    上鎖 = 1 '上鎖

                Case 9 'FPGA 命令-->查詢碼

                    上鎖 = 1 '解鎖

                Case 17 'FPGA 命令-->連線碼

                    上鎖 = 1 '解鎖

                Case Else 'FPGA->ESP8266->PC


                    上鎖 = 1 '不允許操作

            End Select

        Loop

        Label2.Select() '失焦

    End Sub

    '------------------------------------------------------------------------------------------------------
    'PC to FPGA
    Private Sub PCtoFPGA(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles 查詢.MouseDown
        '傳出命令:
        Dim 傳送訂單(10) As Byte '共11個byte
        Dim i As Int16
        If 上鎖 = 1 And keydownok = False Then

            '密碼編碼包裝-二進位包裝
            '傳送訂單(0) = 密碼.Text Mod 256
            '傳送訂單(1) = 密碼.Text \ 256

            '密碼編碼4bit包裝:BCD包裝
            'i = 傳送資訊.Text
            '傳送資訊.Text = Format(i, "0000")
            '傳送訂單(0) = Mid(傳送資訊.Text, 3, 1) * 16 + Mid(傳送資訊.Text, 4, 1)
            '傳送訂單(1) = Mid(傳送資訊.Text, 1, 1) * 16 + Mid(傳送資訊.Text, 2, 1)

            If sender.Equals(查詢) Then
                If 訂單ID.Text.Length = 4 Then
                    If Microsoft.VisualBasic.Left(訂單ID.Text, 2) = "99" Then
                        查詢.BackColor = 黃色
                        傳送訂單(0) = 18 '查詢碼
                        傳送訂單(1) = Microsoft.VisualBasic.Left(訂單ID.Text, 2) '1byte(二進位包裝) :99
                        傳送訂單(2) = Microsoft.VisualBasic.Right(訂單ID.Text, 2) '1byte(二進位包裝):ID
                        SerialPort1.Write(傳送訂單, 0, 3)
                    End If
                End If
            End If

            If sender.Equals(連線) Or sender.Equals(Timer2) Then
                連線.BackColor = 黃色
                傳送訂單(0) = 17 '連線碼
                SerialPort1.Write(傳送訂單, 0, 1)
            End If

            '密碼編碼
            'If (sender.Equals(查詢) And 訂單ID.Text.Length = 4) Or sender.Equals(連線) Or sender.Equals(Timer2) Then '1~4碼

            'If sender.Equals(查詢) Or sender.Equals(連線) Then sender.BackColor = 黃色

            '密碼編碼包裝-二進位包裝
            '傳送訂單(0) = 密碼.Text Mod 256
            '傳送訂單(1) = 密碼.Text \ 256

            '密碼編碼4bit包裝:BCD包裝
            'i = 傳送資訊.Text
            '傳送資訊.Text = Format(i, "0000")
            '傳送訂單(0) = Mid(傳送資訊.Text, 3, 1) * 16 + Mid(傳送資訊.Text, 4, 1)
            '傳送訂單(1) = Mid(傳送資訊.Text, 1, 1) * 16 + Mid(傳送資訊.Text, 2, 1)

            'If sender.Equals(查詢) Then
            'For i = 1 To 訂單ID.Text.Length
            '傳送訂單(i - 1) = Asc(Mid(訂單ID.Text, i, 1))
            'Next
            'SerialPort1.Write(傳送訂單, 0, 訂單ID.Text.Length)
            '訂單ID.Text = ""
            'Else
            '傳送訂單(0) = 17 '連線
            ' SerialPort1.Write(傳送訂單, 0, 1)
            'End If


            '傳送到ESP8266->FPGA
            'For j = 0 To 傳送資訊.Text.Length - 1
            'SerialPort1.Write(傳送訂單, j, 1)
            'Thread.Sleep(20)
            ' Next
            '傳送資訊.Text = ""
            '上鎖 = 0 '上鎖
            'End If

        End If
        Label2.Select() '失焦

    End Sub

    Private Sub 查詢_MouseUp(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles 查詢.MouseUp

        If 查詢.BackColor = 黃色 And MouseButtons <> Windows.Forms.MouseButtons.Left Then
            查詢.BackColor = 淺灰色
        End If

    End Sub

    'RS232 接收資料 執行緒
    Private Sub SerialPort1_read(ByVal sender As Object, ByVal e As SerialDataReceivedEventArgs)
        Dim 接收(0) As Byte '接收1byte
        aaa = ""
        Do While (SerialPort1.BytesToRead >= 1)
            SerialPort1.Read(接收, 0, 1) '接收1byte
            aaa &= Chr(接收(0))
            Thread.Sleep(1)
        Loop
        Me.Invoke(New MethodInvoker(AddressOf Serial1aReceivedData)) 'call back 呼叫主程緒
    End Sub

    'RS232 主程緒處理程式
    Private Sub Serial1aReceivedData()
        Dim i As Int16
        Select Case Asc(Mid(aaa, 1, 1))

            Case 1 'FPGA reset or 待機 命令
                訂單ID.Text = ""
                訂購數量與出價金額.Text = ""
                配額與付款總額.Text = ""
                For Each B As Object In Me.Panel1.Controls ' or  For Each B As Control In Me.Panel1.Controls
                    B.backcolor = 淺灰色
                    B.ForeColor = Color.Black
                Next
                上鎖 = 1 '上鎖

            Case 17 '連線成功
                i = Asc(Mid(aaa, 2, 1))
                訂單ID.Text = Format(i, "00") 'xx
                i = Asc(Mid(aaa, 3, 1))
                訂單ID.Text &= Format(i, "00") 'xx
                i = Asc(Mid(aaa, 4, 1))
                訂購數量與出價金額.Text = Format(i, "0000") 'xxxx
                i = Asc(Mid(aaa, 5, 1))
                訂購數量與出價金額.Text &= Format(i, "0000") 'xxxx
                配額與付款總額.Text = Mid(aaa, 6) '0000


                '連線.ForeColor = Color.Red
                '訂購數量與出價金額.ForeColor = Color.Green

                Timer2.Enabled = False
                上鎖 = 1 '解鎖

            Case 18 '查詢回傳給PC端
                i = Asc(Mid(aaa, 2, 1))
                訂單ID.Text = Format(i, "00") '訂單
                i = Asc(Mid(aaa, 3, 1))
                訂單ID.Text &= Format(i, "00") 'ID
                i = Asc(Mid(aaa, 4, 1))
                訂購數量與出價金額.Text = Format(i, "0000") '「訂購數量」
                i = Asc(Mid(aaa, 5, 1))
                訂購數量與出價金額.Text &= Format(i, "0000") '「出價金額」
                配額與付款總額.Text = Mid(aaa, 6) '#XX$YYYY:「商品配額」與「付款總額」
                上鎖 = 1 '解鎖

            Case 19 '

                上鎖 = 1 '解鎖

            Case Else 'FPGA->ESP8266->PC

                訂購數量與出價金額.Text = aaa
                '訂購數量與出價金額.ForeColor = Color.Black

                上鎖 = 1 '不允許操作

        End Select

        keydownok = False

    End Sub

    '連線測試
    Private Sub 連線_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles 連線.MouseDown
        連線測試次數 = 3
        Timer2.Enabled = True
        PCtoFPGA(sender, e)
    End Sub
    '連線超時
    Private Sub Timer2_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Timer2.Tick
        Timer2.Enabled = False
        If 連線測試次數 = 1 Then
            '連線.ForeColor = Color.Black
            '連線失敗

            訂單ID.Text = ""
            訂購數量與出價金額.Text = ""
            配額與付款總額.Text = "9999" '錯誤警示碼 "9999"
        Else
            連線測試次數 = 連線測試次數 - 1
            Thread.Sleep(100)
            Timer2.Enabled = True
            PCtoFPGA(sender, e)
        End If
    End Sub

End Class
