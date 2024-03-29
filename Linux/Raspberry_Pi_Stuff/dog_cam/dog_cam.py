# https://stackoverflow.com/questions/38949318/google-sheets-api-returns-the-caller-does-not-have-permission-when-using-serve/49965912#49965912
from apiclient.discovery import build
from oauth2client.service_account import ServiceAccountCredentials
from httplib2 import Http
from googleapiclient.http import MediaFileUpload
import subprocess
import time
import datetime
from datetime import datetime as dt
import traceback


def now():
    return dt.now().strftime('%Y-%m-%d.%H:%M:%S')


def log_exception(exception_log_path, note=''):
    with open(exception_log_path, 'a') as log_file:
        log_file.writelines(now() + ' >> ' + note)
        log_file.writelines(traceback.format_exc() + "\n")


def log_Drive_request(request_log_path, Drive_upload_response, note=''):
    with open(request_log_path, 'a') as log_file:
        log_file.writelines(now() + ' >> ' + note)
        log_file.writelines(Drive_upload_response.__repr__() + "\n")


def log_cam_cmd(cam_log_path, cam_cmd_response, note=''):
    with open(cam_log_path, 'a') as log_file:
        log_file.writelines(now() + ' >> ' + note)
        log_file.writelines(str(cam_cmd_response.returncode))
        if cam_cmd_response.stderr:
            log_file.writelines(str(cam_cmd_response.stderr))
        if cam_cmd_response.stdout:
            log_file.writelines(str(cam_cmd_response.stdout))



if __name__ == "__main__":

    exception_log_path = "/home/john/dog_cam/sec_cam_tracebacks.log"
    request_log_path = "/home/john/dog_cam/sec_cam_requests.log"
    cam_log_path = "/home/john/dog_cam/cam.log"

    scopes = ['https://www.googleapis.com/auth/drive']
    credentials = ServiceAccountCredentials.from_json_keyfile_name('/home/john/dog_cam/docs_svc.json', scopes)

    http_auth = credentials.authorize(Http())
    drive = build('drive', 'v3', http=http_auth)
    file_metadata = {
            'name': 'image.jpg',
            'parents': ['1ih_b8pRyWZfBKZ_PEgWf3WL-hkXwZBtt']
    }

    file_id_list = []
    while True:
        try:
            name_time_stamp = datetime.datetime.fromtimestamp(time.time()).strftime('%H-%M-%S')
            print(f'snapping {name_time_stamp}')
            cam_cmd_response = subprocess.run(['fswebcam', '/home/john/dog_cam/image.jpg'])
            # cam_response = subprocess.run(['raspistill', '-vf', '-o', '/home/pi/Desktop/image.jpg'])
            if cam_cmd_response.returncode != 0:
                log_cam_cmd(cam_log_path, cam_cmd_response)
            file_metadata = {
                'name': f"{name_time_stamp}_image.jpg",
                'parents': ['1ih_b8pRyWZfBKZ_PEgWf3WL-hkXwZBtt']
            }
            media = MediaFileUpload('/home/john/dog_cam/image.jpg', mimetype='image/jpeg')
            Drive_upload_response = drive.files().create(body=file_metadata, media_body=media, fields='id,name,mimeType,parents,properties,owners,driveId').execute()
            log_Drive_request(request_log_path, Drive_upload_response)
            if len(file_id_list) > 10:
                delete_response = drive.files().delete(fileId=file_id_list[0]).execute()
                file_id_list.pop(0)
            latest_file_id = Drive_upload_response.get('id')
            file_id_list.append(latest_file_id)
            time.sleep(5)
        except Exception:
            traceback.print_exc()
            log_exception(exception_log_path=exception_log_path)
