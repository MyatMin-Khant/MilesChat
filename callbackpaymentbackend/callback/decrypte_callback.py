from Crypto.Util.Padding import pad
from Crypto.Cipher import AES
import base64
 
class DecrypteCallBack(object):
 
    def __init__(self):
        self.unpad = lambda date: date[0:-ord(date[-1])]
 
    def aes_cipher(self, key, aes_str):
        aes = AES.new(key.encode('utf-8'), AES.MODE_ECB)
        pad_pkcs7 = pad(aes_str.encode('utf-8'), AES.block_size, style='pkcs7') 
        encrypt_aes = aes.encrypt(pad_pkcs7)
        encrypted_text = str(base64.encodebytes(encrypt_aes), encoding='utf-8') 
        encrypted_text_str = encrypted_text.replace("\n", "")
 
        return encrypted_text_str
 
    def decrypt(self, key, decrData):
        res = base64.decodebytes(decrData.encode("utf8"))
        aes = AES.new(key.encode('utf-8'), AES.MODE_ECB)
        msg = aes.decrypt(res).decode("utf8")
        return self.unpad(msg)