using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using System.Configuration;
using System.Data.SqlClient;

public partial class _Default : System.Web.UI.Page
{
    protected void SqlDataSource1_Inserted(object sender, SqlDataSourceStatusEventArgs e)
    {
        fileId = (int)e.Command.Parameters["@InsertedID"].Value;
        UpdateInsertFileData("INSERT INTO [FileData] ([ID], [BinaryData]) VALUES (@ID, @BinaryData)", fileId, fileData);
    }

    protected void SqlDataSource1_Updated(object sender, SqlDataSourceStatusEventArgs e)
    {
        UpdateInsertFileData("UPDATE [FileData] SET [BinaryData] = @BinaryData WHERE [ID] = @ID", fileId, fileData);
    }

    int fileId;
    byte[] fileData;

    protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridEditableItem && e.Item.IsInEditMode)
        {
            GridEditableItem item = e.Item as GridEditableItem;
            RadUpload upload = (item.EditManager.GetColumnEditor("AttachmentColumn") as GridAttachmentColumnEditor).RadUploadControl;
            upload.OnClientFileSelected = "uploadFileSelected";
        }
    }

    protected void RadGrid1_ItemCommand(object source, GridCommandEventArgs e)
    {
        if (e.CommandName == RadGrid.UpdateCommandName ||
            e.CommandName == RadGrid.PerformInsertCommandName)
        {
            GridEditableItem item = e.Item as GridEditableItem;

            if (!(item is GridEditFormInsertItem))
            {
                fileId = (int)item.GetDataKeyValue("ID");
            }

            string fileName = (item.EditManager.GetColumnEditor("FileName") as GridTextBoxColumnEditor).Text;
            fileData = (item.EditManager.GetColumnEditor("AttachmentColumn") as GridAttachmentColumnEditor).UploadedFileContent;

            if (fileData.Length == 0 || fileName.Trim() == string.Empty)
            {
                e.Canceled = true;
                RadGrid1.Controls.Add(new LiteralControl("<b style='color:red;'>No file uploaded. Action canceled.</b>"));
            }
        }
    }

    private int UpdateInsertFileData(string command, int fileId, byte[] data)
    {
        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["TelerikConnectionString"].ConnectionString))
        {
            using (SqlCommand comm = new SqlCommand(command, conn))
            {
                comm.Parameters.Add(new SqlParameter("ID", fileId));
                comm.Parameters.Add(new SqlParameter("BinaryData", fileData));

                conn.Open();
                return comm.ExecuteNonQuery();
            }
        }
    }
}

