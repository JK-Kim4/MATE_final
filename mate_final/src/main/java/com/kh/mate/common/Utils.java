package com.kh.mate.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Utils {

	
	public static String getRenamedFileName(String originalFilename) {
		String renamedFilename = null;

		int beginIndex = originalFilename.lastIndexOf('.');
		String ext = originalFilename.substring(beginIndex); // .png ....

		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS_");
		DecimalFormat df = new DecimalFormat("000");
		
		renamedFilename = sdf.format(new Date())
						+ df.format(Math.random() * 1000 )
						+ ext;
		
		return renamedFilename;
	}


}
