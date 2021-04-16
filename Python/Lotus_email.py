import os, uuid
import itertools as it

from win32com.client import DispatchEx
import pywintypes # for exception


def send_mail(subject, body_text, send_to,
    copyto=None, blindcopyto=None, attachments=None):

    # connect to Notes COM
    session = DispatchEx('Lotus.NotesSession')
    while True:
        try:
            session.Initialize(input("Notes Password: "))
            break
        except Exception as e:
            print(e)
            pass

    # connect to server & database
    server_name = 'NALLN242/40/LLN/IBM'
    db_name = 'data3\\126\\1000983376.nsf'
    """
    for server_name and db_name from Notes:
        File > Preferences > Locations > Online > Edit
            server_name = Servers > Home/mail server
            db_name = Mail > Mail file
    """
    db = session.getDatabase(server_name, db_name)
    if not db.IsOpen:
        try:
            db.Open()
        except pywintypes.com_error:
            print(f"could not open database: {db_name}")

    # build document
    doc = db.CreateDocument()
    doc.ReplaceItemValue("Form", "Memo")
    doc.ReplaceItemValue("Subject", subject)

    # assign random uid because sometimes Lotus Notes tries to reuse the same one
    uid = str(uuid.uuid4().hex)
    doc.ReplaceItemValue('UNIVERSALID',uid)

    # "SendTo" MUST be populated otherwise you get this error: 
    # 'No recipient list for Send operation'
    doc.ReplaceItemValue("SendTo", send_to)

    if copyto:
        doc.ReplaceItemValue("CopyTo", copyto)
    if blindcopyto:
        doc.ReplaceItemValue("BlindCopyTo", blindcopyto)

    # body
    body = doc.CreateRichTextItem("Body")
    body.AppendText(body_text)

    # attachments 
    if attachments:
        email_att_field = doc.CreateRichTextItem("Attachment")
        for attachment in attachments:
            email_att_field.EmbedObject(1454, "", attachment, "Attachment")

    doc.SaveMessageOnSend = True # show sent email in Notes "Sent" view
    doc.Send(False)  # not really sure what the arg is for, but makes file sizes massive if True


if __name__ == '__main__':

    send_to = ['John.Hupperts@ibm.com',]
    files = ["C:\\Users\\JohnHupperts\\Desktop\\email_poc.PNG",]
    attachments = it.takewhile(lambda x: os.path.exists(x), files)

    send_mail(subject="Python Test", body_text="test body", 
        send_to=send_to, attachments=attachments)
