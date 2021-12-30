from apiclient.discovery import build
from oauth2client.service_account import ServiceAccountCredentials
from httplib2 import Http
from googleapiclient.http import MediaFileUpload
import os
import time
import datetime

scopes = ['https://www.googleapis.com/auth/drive']
credentials = ServiceAccountCredentials.from_json_keyfile_name('/home/pi/Desktop/drive_service_creds.json', scopes)

http_auth = credentials.authorize(Http())
drive = build('drive', 'v3', http=http_auth)
file_metadata = {
        'name': 'image.jpg',
        'parents': ['1ih_b8pfegwgBKZ_PEgWf3WL-hkXwZBtt']
}

file_id_list = []
while True:
        print('snapping pic')
        os.system("raspistill -vf -o /home/pi/Desktop/image.jpg")
        file_metadata = {
                'name': f"{datetime.datetime.fromtimestamp(time.time()).strftime('%H-%M-%S')}_image.jpg",
                'parents': ['1ih_b8pfegwgBKZ_PEgWf3WL-hkXwZBtt']
        }
        media = MediaFileUpload('/home/pi/Desktop/image.jpg', mimetype='image/jpeg')
        upload_response = drive.files().create(body=file_metadata, media_body=media, fields='id,name,mimeType,parents,properties,owners,driveId').execute()
        if len(file_id_list) > 10:
                delete_response = drive.files().delete(fileId=file_id_list[0]).execute()
                file_id_list.pop(0)
        latest_file_id = upload_response.get('id')
        file_id_list.append(latest_file_id)
        time.sleep(5)