<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Form1
    Inherits System.Windows.Forms.Form

    'Form 覆寫 Dispose 以清除元件清單。
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    '為 Windows Form 設計工具的必要項
    Private components As System.ComponentModel.IContainer

    '注意: 以下為 Windows Form 設計工具所需的程序
    '可以使用 Windows Form 設計工具進行修改。
    '請不要使用程式碼編輯器進行修改。
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Me.Button6 = New System.Windows.Forms.Button
        Me.Button5 = New System.Windows.Forms.Button
        Me.Button4 = New System.Windows.Forms.Button
        Me.Button3 = New System.Windows.Forms.Button
        Me.Button2 = New System.Windows.Forms.Button
        Me.Button1 = New System.Windows.Forms.Button
        Me.訂單ID = New System.Windows.Forms.Button
        Me.SerialPort1 = New System.IO.Ports.SerialPort(Me.components)
        Me.Timer1 = New System.Windows.Forms.Timer(Me.components)
        Me.Button7 = New System.Windows.Forms.Button
        Me.Button8 = New System.Windows.Forms.Button
        Me.Button9 = New System.Windows.Forms.Button
        Me.Button10 = New System.Windows.Forms.Button
        Me.清除 = New System.Windows.Forms.Button
        Me.訂單 = New System.Windows.Forms.Button
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.連線 = New System.Windows.Forms.Button
        Me.查詢 = New System.Windows.Forms.Button
        Me.備用4 = New System.Windows.Forms.Button
        Me.備用3 = New System.Windows.Forms.Button
        Me.Label2 = New System.Windows.Forms.Label
        Me.Panel2 = New System.Windows.Forms.Panel
        Me.Panel3 = New System.Windows.Forms.Panel
        Me.Label1 = New System.Windows.Forms.Label
        Me.訂購數量與出價金額 = New System.Windows.Forms.Button
        Me.Timer2 = New System.Windows.Forms.Timer(Me.components)
        Me.Panel4 = New System.Windows.Forms.Panel
        Me.Label3 = New System.Windows.Forms.Label
        Me.配額與付款總額 = New System.Windows.Forms.Button
        Me.Panel1.SuspendLayout()
        Me.Panel2.SuspendLayout()
        Me.Panel3.SuspendLayout()
        Me.Panel4.SuspendLayout()
        Me.SuspendLayout()
        '
        'Button6
        '
        Me.Button6.Font = New System.Drawing.Font("標楷體", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.Button6.Location = New System.Drawing.Point(200, 107)
        Me.Button6.Name = "Button6"
        Me.Button6.Size = New System.Drawing.Size(78, 78)
        Me.Button6.TabIndex = 34
        Me.Button6.Text = "1"
        Me.Button6.UseVisualStyleBackColor = True
        '
        'Button5
        '
        Me.Button5.Font = New System.Drawing.Font("標楷體", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.Button5.Location = New System.Drawing.Point(108, 107)
        Me.Button5.Name = "Button5"
        Me.Button5.Size = New System.Drawing.Size(78, 78)
        Me.Button5.TabIndex = 33
        Me.Button5.Text = "1"
        Me.Button5.UseVisualStyleBackColor = True
        '
        'Button4
        '
        Me.Button4.Font = New System.Drawing.Font("標楷體", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.Button4.Location = New System.Drawing.Point(16, 107)
        Me.Button4.Name = "Button4"
        Me.Button4.Size = New System.Drawing.Size(78, 78)
        Me.Button4.TabIndex = 32
        Me.Button4.Text = "1"
        Me.Button4.UseVisualStyleBackColor = True
        '
        'Button3
        '
        Me.Button3.Font = New System.Drawing.Font("標楷體", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.Button3.Location = New System.Drawing.Point(200, 17)
        Me.Button3.Name = "Button3"
        Me.Button3.Size = New System.Drawing.Size(78, 78)
        Me.Button3.TabIndex = 31
        Me.Button3.Text = "1"
        Me.Button3.UseVisualStyleBackColor = True
        '
        'Button2
        '
        Me.Button2.Font = New System.Drawing.Font("標楷體", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.Button2.Location = New System.Drawing.Point(108, 17)
        Me.Button2.Name = "Button2"
        Me.Button2.Size = New System.Drawing.Size(78, 78)
        Me.Button2.TabIndex = 30
        Me.Button2.Text = "1"
        Me.Button2.UseVisualStyleBackColor = True
        '
        'Button1
        '
        Me.Button1.Font = New System.Drawing.Font("標楷體", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.Button1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Button1.Location = New System.Drawing.Point(16, 17)
        Me.Button1.Name = "Button1"
        Me.Button1.Size = New System.Drawing.Size(78, 78)
        Me.Button1.TabIndex = 29
        Me.Button1.Text = "1"
        Me.Button1.UseVisualStyleBackColor = True
        '
        '訂單ID
        '
        Me.訂單ID.BackColor = System.Drawing.SystemColors.ControlLight
        Me.訂單ID.Font = New System.Drawing.Font("標楷體", 26.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.訂單ID.Location = New System.Drawing.Point(16, 52)
        Me.訂單ID.Name = "訂單ID"
        Me.訂單ID.Size = New System.Drawing.Size(346, 58)
        Me.訂單ID.TabIndex = 25
        Me.訂單ID.Text = "1234"
        Me.訂單ID.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.訂單ID.UseVisualStyleBackColor = False
        '
        'SerialPort1
        '
        Me.SerialPort1.BaudRate = 115200
        '
        'Timer1
        '
        '
        'Button7
        '
        Me.Button7.Font = New System.Drawing.Font("標楷體", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.Button7.Location = New System.Drawing.Point(16, 199)
        Me.Button7.Name = "Button7"
        Me.Button7.Size = New System.Drawing.Size(78, 78)
        Me.Button7.TabIndex = 34
        Me.Button7.Text = "1"
        Me.Button7.UseVisualStyleBackColor = True
        '
        'Button8
        '
        Me.Button8.Font = New System.Drawing.Font("標楷體", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.Button8.Location = New System.Drawing.Point(108, 199)
        Me.Button8.Name = "Button8"
        Me.Button8.Size = New System.Drawing.Size(78, 78)
        Me.Button8.TabIndex = 34
        Me.Button8.Text = "1"
        Me.Button8.UseVisualStyleBackColor = True
        '
        'Button9
        '
        Me.Button9.Font = New System.Drawing.Font("標楷體", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.Button9.Location = New System.Drawing.Point(200, 199)
        Me.Button9.Name = "Button9"
        Me.Button9.Size = New System.Drawing.Size(78, 78)
        Me.Button9.TabIndex = 29
        Me.Button9.Text = "1"
        Me.Button9.UseVisualStyleBackColor = True
        '
        'Button10
        '
        Me.Button10.Font = New System.Drawing.Font("標楷體", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.Button10.Location = New System.Drawing.Point(108, 287)
        Me.Button10.Name = "Button10"
        Me.Button10.Size = New System.Drawing.Size(78, 78)
        Me.Button10.TabIndex = 30
        Me.Button10.Text = "1"
        Me.Button10.UseVisualStyleBackColor = True
        '
        '清除
        '
        Me.清除.Font = New System.Drawing.Font("標楷體", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.清除.Location = New System.Drawing.Point(292, 17)
        Me.清除.Name = "清除"
        Me.清除.Size = New System.Drawing.Size(138, 78)
        Me.清除.TabIndex = 31
        Me.清除.Text = "清除"
        Me.清除.UseVisualStyleBackColor = True
        '
        '訂單
        '
        Me.訂單.Font = New System.Drawing.Font("標楷體", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.訂單.Location = New System.Drawing.Point(292, 287)
        Me.訂單.Name = "訂單"
        Me.訂單.Size = New System.Drawing.Size(138, 78)
        Me.訂單.TabIndex = 32
        Me.訂單.UseVisualStyleBackColor = True
        '
        'Panel1
        '
        Me.Panel1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.Panel1.Controls.Add(Me.Button8)
        Me.Panel1.Controls.Add(Me.Button6)
        Me.Panel1.Controls.Add(Me.Button7)
        Me.Panel1.Controls.Add(Me.Button5)
        Me.Panel1.Controls.Add(Me.Button2)
        Me.Panel1.Controls.Add(Me.Button1)
        Me.Panel1.Controls.Add(Me.Button9)
        Me.Panel1.Controls.Add(Me.連線)
        Me.Panel1.Controls.Add(Me.Button3)
        Me.Panel1.Controls.Add(Me.查詢)
        Me.Panel1.Controls.Add(Me.訂單)
        Me.Panel1.Controls.Add(Me.Button4)
        Me.Panel1.Controls.Add(Me.清除)
        Me.Panel1.Controls.Add(Me.備用4)
        Me.Panel1.Controls.Add(Me.備用3)
        Me.Panel1.Controls.Add(Me.Button10)
        Me.Panel1.Location = New System.Drawing.Point(424, 35)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(448, 381)
        Me.Panel1.TabIndex = 44
        '
        '連線
        '
        Me.連線.Font = New System.Drawing.Font("標楷體", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.連線.Location = New System.Drawing.Point(292, 197)
        Me.連線.Name = "連線"
        Me.連線.Size = New System.Drawing.Size(138, 78)
        Me.連線.TabIndex = 32
        Me.連線.Text = "連線"
        Me.連線.UseVisualStyleBackColor = True
        '
        '查詢
        '
        Me.查詢.Font = New System.Drawing.Font("標楷體", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.查詢.Location = New System.Drawing.Point(292, 107)
        Me.查詢.Name = "查詢"
        Me.查詢.Size = New System.Drawing.Size(138, 78)
        Me.查詢.TabIndex = 32
        Me.查詢.Text = "查詢"
        Me.查詢.UseVisualStyleBackColor = True
        '
        '備用4
        '
        Me.備用4.Font = New System.Drawing.Font("新細明體", 24.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.備用4.Location = New System.Drawing.Point(200, 287)
        Me.備用4.Name = "備用4"
        Me.備用4.Size = New System.Drawing.Size(78, 78)
        Me.備用4.TabIndex = 30
        Me.備用4.UseVisualStyleBackColor = True
        '
        '備用3
        '
        Me.備用3.Font = New System.Drawing.Font("新細明體", 24.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.備用3.Location = New System.Drawing.Point(16, 287)
        Me.備用3.Name = "備用3"
        Me.備用3.Size = New System.Drawing.Size(78, 78)
        Me.備用3.TabIndex = 30
        Me.備用3.UseVisualStyleBackColor = True
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Font = New System.Drawing.Font("標楷體", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.Label2.Location = New System.Drawing.Point(10, 17)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(115, 32)
        Me.Label2.TabIndex = 45
        Me.Label2.Text = "訂單ID"
        '
        'Panel2
        '
        Me.Panel2.BackColor = System.Drawing.Color.FromArgb(CType(CType(128, Byte), Integer), CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer))
        Me.Panel2.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.Panel2.Controls.Add(Me.Label2)
        Me.Panel2.Controls.Add(Me.訂單ID)
        Me.Panel2.Location = New System.Drawing.Point(39, 35)
        Me.Panel2.Name = "Panel2"
        Me.Panel2.Size = New System.Drawing.Size(379, 125)
        Me.Panel2.TabIndex = 46
        '
        'Panel3
        '
        Me.Panel3.BackColor = System.Drawing.Color.FromArgb(CType(CType(128, Byte), Integer), CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer))
        Me.Panel3.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.Panel3.Controls.Add(Me.Label1)
        Me.Panel3.Controls.Add(Me.訂購數量與出價金額)
        Me.Panel3.Location = New System.Drawing.Point(39, 166)
        Me.Panel3.Name = "Panel3"
        Me.Panel3.Size = New System.Drawing.Size(379, 120)
        Me.Panel3.TabIndex = 46
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Font = New System.Drawing.Font("標楷體", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.Label1.Location = New System.Drawing.Point(3, 12)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(378, 32)
        Me.Label1.TabIndex = 45
        Me.Label1.Text = "訂購數量與出價金額欄位"
        '
        '訂購數量與出價金額
        '
        Me.訂購數量與出價金額.BackColor = System.Drawing.SystemColors.ControlLight
        Me.訂購數量與出價金額.Font = New System.Drawing.Font("標楷體", 26.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.訂購數量與出價金額.Location = New System.Drawing.Point(16, 47)
        Me.訂購數量與出價金額.Name = "訂購數量與出價金額"
        Me.訂購數量與出價金額.Size = New System.Drawing.Size(346, 58)
        Me.訂購數量與出價金額.TabIndex = 25
        Me.訂購數量與出價金額.Text = "12345678"
        Me.訂購數量與出價金額.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.訂購數量與出價金額.UseVisualStyleBackColor = False
        '
        'Timer2
        '
        Me.Timer2.Interval = 400
        '
        'Panel4
        '
        Me.Panel4.BackColor = System.Drawing.Color.FromArgb(CType(CType(128, Byte), Integer), CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer))
        Me.Panel4.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.Panel4.Controls.Add(Me.Label3)
        Me.Panel4.Controls.Add(Me.配額與付款總額)
        Me.Panel4.Location = New System.Drawing.Point(39, 292)
        Me.Panel4.Name = "Panel4"
        Me.Panel4.Size = New System.Drawing.Size(379, 124)
        Me.Panel4.TabIndex = 46
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Font = New System.Drawing.Font("標楷體", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.Label3.Location = New System.Drawing.Point(3, 12)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(246, 32)
        Me.Label3.TabIndex = 45
        Me.Label3.Text = "配額與付款總額"
        '
        '配額與付款總額
        '
        Me.配額與付款總額.BackColor = System.Drawing.SystemColors.ControlLight
        Me.配額與付款總額.Font = New System.Drawing.Font("標楷體", 26.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(136, Byte))
        Me.配額與付款總額.Location = New System.Drawing.Point(16, 50)
        Me.配額與付款總額.Name = "配額與付款總額"
        Me.配額與付款總額.Size = New System.Drawing.Size(346, 58)
        Me.配額與付款總額.TabIndex = 25
        Me.配額與付款總額.Text = "#12$1234"
        Me.配額與付款總額.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.配額與付款總額.UseVisualStyleBackColor = False
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 12.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.Color.FromArgb(CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer), CType(CType(192, Byte), Integer))
        Me.ClientSize = New System.Drawing.Size(910, 446)
        Me.Controls.Add(Me.Panel4)
        Me.Controls.Add(Me.Panel3)
        Me.Controls.Add(Me.Panel2)
        Me.Controls.Add(Me.Panel1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Fixed3D
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "Form1"
        Me.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Show
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "限量商品產銷管理系統"
        Me.Panel1.ResumeLayout(False)
        Me.Panel2.ResumeLayout(False)
        Me.Panel2.PerformLayout()
        Me.Panel3.ResumeLayout(False)
        Me.Panel3.PerformLayout()
        Me.Panel4.ResumeLayout(False)
        Me.Panel4.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents Button6 As System.Windows.Forms.Button
    Friend WithEvents Button5 As System.Windows.Forms.Button
    Friend WithEvents Button4 As System.Windows.Forms.Button
    Friend WithEvents Button3 As System.Windows.Forms.Button
    Friend WithEvents Button2 As System.Windows.Forms.Button
    Friend WithEvents Button1 As System.Windows.Forms.Button
    Friend WithEvents 訂單ID As System.Windows.Forms.Button
    Friend WithEvents SerialPort1 As System.IO.Ports.SerialPort
    Friend WithEvents Timer1 As System.Windows.Forms.Timer
    Friend WithEvents Button7 As System.Windows.Forms.Button
    Friend WithEvents Button8 As System.Windows.Forms.Button
    Friend WithEvents Button9 As System.Windows.Forms.Button
    Friend WithEvents Button10 As System.Windows.Forms.Button
    Friend WithEvents 清除 As System.Windows.Forms.Button
    Friend WithEvents 訂單 As System.Windows.Forms.Button
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents 查詢 As System.Windows.Forms.Button
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents 連線 As System.Windows.Forms.Button
    Friend WithEvents 備用4 As System.Windows.Forms.Button
    Friend WithEvents 備用3 As System.Windows.Forms.Button
    Friend WithEvents Panel2 As System.Windows.Forms.Panel
    Friend WithEvents Panel3 As System.Windows.Forms.Panel
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents 訂購數量與出價金額 As System.Windows.Forms.Button
    Friend WithEvents Timer2 As System.Windows.Forms.Timer
    Friend WithEvents Panel4 As System.Windows.Forms.Panel
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents 配額與付款總額 As System.Windows.Forms.Button

End Class
