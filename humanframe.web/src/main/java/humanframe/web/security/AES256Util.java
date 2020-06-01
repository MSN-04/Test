package humanframe.web.security;

import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.AlgorithmParameterSpec;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;

import humanframe.core.util.HumanStringUtil;


public class AES256Util {

	public static byte[] ivBytes = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };

	public static String AESEncode(String str, String key)	throws java.io.UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,	IllegalBlockSizeException, BadPaddingException {
		if (!HumanStringUtil.nvl(str).equals("")) {
			byte[] textBytes = str.getBytes("UTF-8");
			AlgorithmParameterSpec ivSpec = new IvParameterSpec(ivBytes);
			     SecretKeySpec newKey = new SecretKeySpec(key.getBytes("UTF-8"), "AES");
			     Cipher cipher = null;
			cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
			cipher.init(Cipher.ENCRYPT_MODE, newKey, ivSpec);
			return Base64.encodeBase64String(cipher.doFinal(textBytes));
		}
		return "";
	}
	
	public static String AESDecode(String str, String key)	throws java.io.UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
		if (!HumanStringUtil.nvl(str).equals("")) {
			byte[] textBytes = Base64.decodeBase64(str.replaceAll(" ", "+"));
			AlgorithmParameterSpec ivSpec = new IvParameterSpec(ivBytes);
			SecretKeySpec newKey = new SecretKeySpec(key.getBytes("UTF-8"), "AES");
			Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
			cipher.init(Cipher.DECRYPT_MODE, newKey, ivSpec);
			return new String(cipher.doFinal(textBytes), "UTF-8");
		}
		return "";
	}
}