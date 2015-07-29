<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <telerik:RadCodeBlock ID="RadCodeBlock2" runat="server">
        <script type="text/javascript">
            <!--
            function gridCommand(sender, args) {
                if (args.get_commandName() == "DownloadAttachment") {
                    var manager = $find('<%= RadAjaxManager.GetCurrent(Page).ClientID %>');
                    manager.set_enableAJAX(false);

                    setTimeout(function () {
                        manager.set_enableAJAX(true);
                    }, 0);
                }
            }

            function conditionalPostback(sender, eventArgs) {
                var eventArgument = eventArgs.get_eventArgument();

                if (eventArgument.indexOf("Update") > -1 || eventArgument.indexOf("PerformInsert") > -1) {
                    if (upload && upload.getFileInputs()[0].value != "") {
                        eventArgs.set_enableAjax(false);
                    }
                }
            }

            var upload = null;

            function uploadFileSelected(sender, args) {
                upload = sender;
                var uploadContainer = sender.get_element();
                var editTable = uploadContainer.parentNode.parentNode.parentNode.parentNode;
                var fileNameTextBox = editTable.rows[0].cells[1].getElementsByTagName('input')[0];

                fileNameTextBox.value = args.get_fileInputField().title;
            }
                -->
        </script>
    </telerik:RadCodeBlock>
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" EnableAJAX="true" DefaultLoadingPanelID="RadAjaxLoadingPanel1">
        <ClientEvents OnRequestStart="conditionalPostback" />
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGrid1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server">
    </telerik:RadAjaxLoadingPanel>
    <telerik:RadGrid ID="RadGrid1" runat="server" DataSourceID="SqlDataSource1" AutoGenerateColumns="false"
        AllowSorting="true" AllowAutomaticUpdates="true" AllowAutomaticInserts="true"
        OnItemCommand="RadGrid1_ItemCommand" OnItemCreated="RadGrid1_ItemCreated">
        <MasterTableView DataKeyNames="ID" CommandItemDisplay="Top" Width="100%">
            <Columns>
                <telerik:GridEditCommandColumn HeaderStyle-Width="30px">
                </telerik:GridEditCommandColumn>
                <telerik:GridBoundColumn DataField="ID" HeaderText="ID" ReadOnly="true">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="FileName" HeaderText="FileName">
                </telerik:GridBoundColumn>
                <telerik:GridDateTimeColumn DataField="UploadDate" HeaderText="UploadDate" PickerType="DatePicker">
                </telerik:GridDateTimeColumn>
                <telerik:GridBoundColumn DataField="UploadedBy" HeaderText="UploadedBy">
                </telerik:GridBoundColumn>
                <telerik:GridAttachmentColumn DataSourceID="SqlDataSource2" MaxFileSize="1048576"
                    EditFormHeaderTextFormat="Upload File:" HeaderText="Download" AttachmentDataField="BinaryData"
                    AttachmentKeyFields="ID" FileNameTextField="FileName" DataTextField="FileName"
                    UniqueName="AttachmentColumn">
                </telerik:GridAttachmentColumn>
            </Columns>
        </MasterTableView>
        <ClientSettings>
            <ClientEvents OnCommand="gridCommand" />
        </ClientSettings>
    </telerik:RadGrid>
    <div class="module" style="margin-top: 10px;">
        <b>Note:</b> Maximum file size allowed: 1MB
    </div>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:TelerikConnectionString %>"
        InsertCommand="INSERT INTO [Files] ([FileName], [UploadDate], [UploadedBy]) VALUES (@FileName, @UploadDate, @UploadedBy) SET @InsertedID = SCOPE_IDENTITY()"
        SelectCommand="SELECT [ID], [FileName], [UploadDate], [UploadedBy] FROM [Files]"
        UpdateCommand="UPDATE [Files] SET [FileName] = @FileName, [UploadDate] = @UploadDate, [UploadedBy] = @UploadedBy WHERE [ID] = @ID"
        OnInserted="SqlDataSource1_Inserted" OnUpdated="SqlDataSource1_Updated">
        <UpdateParameters>
            <asp:Parameter Name="FileName" Type="String" />
            <asp:Parameter Name="UploadDate" Type="DateTime" />
            <asp:Parameter Name="UploadedBy" Type="String" />
            <asp:Parameter Name="ID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="FileName" Type="String" />
            <asp:Parameter Name="UploadDate" Type="DateTime" />
            <asp:Parameter Name="UploadedBy" Type="String" />
            <asp:Parameter Name="InsertedID" Type="Int32" Direction="Output" />
        </InsertParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:TelerikConnectionString %>"
        SelectCommand="SELECT [ID], [BinaryData] FROM [FileData] WHERE [ID] = @ID">
        <SelectParameters>
            <asp:Parameter Name="ID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
